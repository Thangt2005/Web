package services;

import model.User;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserService {
    // FIX 1: Thống nhất tên database là 'db' cho toàn bộ class
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

        // Mã hóa mật khẩu người dùng vừa gõ để so sánh với mã MD5 trong DB
        String md5Pass = toMD5(password);

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, md5Pass); // So sánh 2 chuỗi MD5 với nhau
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

        // MÃ HÓA TẠI ĐÂY: Biến mật khẩu thường thành chuỗi MD5 32 ký tự
        String md5Pass = toMD5(password);

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, username);
            ps.setString(3, md5Pass); // Lưu mật khẩu đã mã hóa vào DB
            ps.setString(4, "Khách hàng");
            result = ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
        return result;
    }
    // 4. Lấy danh sách khách hàng cho trang Admin
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM db";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                // Đảm bảo khớp với Constructor: id, username, password, fullname, email
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

    // 5. Xóa tài khoản khách hàng
    public boolean deleteUser(int id) {
        String sql = "DELETE FROM login WHERE id = ?";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
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