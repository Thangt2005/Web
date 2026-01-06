package services;

import model.User;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class UserService {
    // CẤU HÌNH DATABASE
    private final String url = "jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8";
    private final String user = "root";
    private final String pass = "";

    // 1. Kiểm tra Email đã tồn tại chưa
    public boolean checkEmailExists(String email) {
        String sql = "SELECT email FROM login WHERE email = ?";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 2. Kiểm tra Username tồn tại
    public boolean checkUserExists(String username) {
        String sql = "SELECT username FROM login WHERE username = ?";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 3. Kiểm tra Đăng nhập (Yêu cầu tài khoản đã kích hoạt is_verified = 1)
    public boolean checkLogin(String username, String password) {
        String sql = "SELECT username FROM login WHERE username = ? AND password = ? AND is_verified = 1";
        String md5Pass = toMD5(password);

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, md5Pass);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 4. Đăng ký tài khoản mới (Trả về Token nếu thành công, hoặc thông báo lỗi)
    public String registerUser(String username, String password, String email) {
        // Kiểm tra trùng lặp trước khi insert
        if (checkEmailExists(email)) return "Email này đã được sử dụng!";
        if (checkUserExists(username)) return "Tên đăng nhập đã tồn tại!";

        String sql = "INSERT INTO login (email, username, password, fullname, verification_code, is_verified) VALUES (?, ?, ?, ?, ?, ?)";
        String md5Pass = toMD5(password);
        String token = UUID.randomUUID().toString();

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, username);
            ps.setString(3, md5Pass);
            ps.setString(4, "Khách hàng"); // Fullname mặc định
            ps.setString(5, token);
            ps.setInt(6, 0); // 0 = Chưa kích hoạt

            int result = ps.executeUpdate();
            return result > 0 ? token : "Đăng ký thất bại (Lỗi Database)";

        } catch (SQLException e) {
            e.printStackTrace();
            return "Đã xảy ra lỗi hệ thống: " + e.getMessage();
        }
    }

    // 5. Xác thực tài khoản qua Token
    public boolean verifyAccount(String token) {
        String sqlCheck = "SELECT id FROM login WHERE verification_code = ?";
        String sqlUpdate = "UPDATE login SET is_verified = 1, verification_code = NULL WHERE verification_code = ?";

        try (Connection conn = DriverManager.getConnection(url, user, pass)) {
            // Bước 1: Kiểm tra token có khớp tài khoản nào không
            try (PreparedStatement psCheck = conn.prepareStatement(sqlCheck)) {
                psCheck.setString(1, token);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next()) {
                        // Bước 2: Kích hoạt tài khoản
                        try (PreparedStatement psUpdate = conn.prepareStatement(sqlUpdate)) {
                            psUpdate.setString(1, token);
                            psUpdate.executeUpdate();
                            return true;
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 6. Lấy danh sách thành viên (Dành cho Admin)
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT id, username, password, fullname, email FROM login";

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new User(
                        rs.getInt("id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("fullname"),
                        rs.getString("email")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 7. Xóa tài khoản
    public boolean deleteUser(int id) {
        String sql = "DELETE FROM login WHERE id = ?";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Hàm tiện ích: Mã hóa MD5
    private String toMD5(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            md.update(password.getBytes());
            byte[] digest = md.digest();
            StringBuilder sb = new StringBuilder();
            for (byte b : digest) {
                sb.append(String.format("%02x", b & 0xff));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
    }
}