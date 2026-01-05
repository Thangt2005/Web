package services;

import model.User;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserService {
    // Cấu hình Database chung (Tên DB là 'db', bảng là 'login')
    private String url = "jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8";
    private String user = "root";
    private String pass = "";

    // 1. Kiểm tra Email tồn tại (Dùng cho Register)
    public boolean checkEmailExists(String email) {
        String sql = "SELECT email FROM login WHERE email = ?";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // 2. Kiểm tra Đăng nhập (So sánh Username và Password MD5)
    public boolean checkLogin(String username, String password) {
        String sql = "SELECT username FROM login WHERE username = ? AND password = ?";

        // Mã hóa mật khẩu người dùng nhập vào để so sánh với trong DB
        String md5Pass = toMD5(password);

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, md5Pass);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // 3. Đăng ký tài khoản mới
    public int registerUser(String email, String username, String password) {
        int result = 0;
        String sql = "INSERT INTO login (email, username, password, fullname) VALUES (?, ?, ?, ?)";

        // Mã hóa mật khẩu trước khi lưu
        String md5Pass = toMD5(password);

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, username);
            ps.setString(3, md5Pass);
            ps.setString(4, "Khách hàng"); // Mặc định tên hiển thị
            result = ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
        return result;
    }

    // 4. Lấy danh sách khách hàng (Dành cho Admin)
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        // LƯU Ý: Phải select từ bảng 'login', không phải từ 'db'
        String sql = "SELECT * FROM login";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                // Đảm bảo khớp với Constructor của Model User
                list.add(new User(
                        rs.getInt("id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("fullname"),
                        rs.getString("email")
                ));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 5. Xóa tài khoản (Dành cho Admin)
    public boolean deleteUser(int id) {
        String sql = "DELETE FROM login WHERE id = ?";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
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