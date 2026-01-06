package services;

import model.User;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class UserService {
<<<<<<< HEAD
    // CẤU HÌNH DATABASE
    // Lưu ý: "db" là tên database. Nếu tên khác, hãy sửa lại chỗ này.
=======
    // Cấu hình Database chung (Tên DB là 'db', bảng là 'login')
>>>>>>> 1a171a12066a4dd3501f2532db6e181961fce088
    private String url = "jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8";
    private String user = "root";
    private String pass = "";

    // 1. Kiểm tra Email đã tồn tại chưa
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

<<<<<<< HEAD
    // Kiểm tra Username tồn tại
    public boolean checkUserExists(String username) {
        String sql = "SELECT username FROM login WHERE username = ?";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
=======
    // 2. Kiểm tra Đăng nhập (So sánh Username và Password MD5)
    public boolean checkLogin(String username, String password) {
        String sql = "SELECT username FROM login WHERE username = ? AND password = ?";

        // Mã hóa mật khẩu người dùng nhập vào để so sánh với trong DB
        String md5Pass = toMD5(password);

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, md5Pass);
>>>>>>> 1a171a12066a4dd3501f2532db6e181961fce088
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

<<<<<<< HEAD
    // 2. Kiểm tra Đăng nhập (Chỉ cho phép nếu is_verified = 1)
    public boolean checkLogin(String username, String password) {
        String sql = "SELECT username FROM login WHERE username = ? AND password = ? AND is_verified = 1";
=======
    // 3. Đăng ký tài khoản mới
    public int registerUser(String email, String username, String password) {
        int result = 0;
        String sql = "INSERT INTO login (email, username, password, fullname) VALUES (?, ?, ?, ?)";

        // Mã hóa mật khẩu trước khi lưu
>>>>>>> 1a171a12066a4dd3501f2532db6e181961fce088
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

    public String registerUser(String username, String password, String email) {

        // Kiểm tra tồn tại
        if (checkEmailExists(email)) {
            return "Email này đã được sử dụng!";
        }
        if (checkUserExists(username)) {
            return "Tên đăng nhập đã tồn tại!";
        }

        String sql = "INSERT INTO login (email, username, password, fullname, verification_code, is_verified) VALUES (?, ?, ?, ?, ?, ?)";
        String md5Pass = toMD5(password);
        String token = UUID.randomUUID().toString(); // Tạo mã token

        //  Thực thi Insert
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, username);
            ps.setString(3, md5Pass);
<<<<<<< HEAD
            ps.setString(4, "Khách hàng");
            ps.setString(5, token);
            ps.setInt(6, 0); // 0 = Chưa kích hoạt

            int result = ps.executeUpdate();

            // Nếu thành công trả về Token (hoặc null/chuỗi rỗng tùy logic controller cũ của bạn)
            // Theo code gốc của bạn thì đoạn này nên trả về Token.
            return result > 0 ? token : "Đăng ký thất bại (Lỗi Database)";

        } catch (Exception e) {
            e.printStackTrace();
            return "Đã xảy ra lỗi hệ thống: " + e.getMessage();
        }
    }

    // 4. Xác thực tài khoản (Khi bấm link mail)
    public boolean verifyAccount(String token) {
        String sqlCheck = "SELECT id FROM login WHERE verification_code = ?";
        // Sau khi xác thực: Đổi is_verified thành 1, và Xóa token đi (để link chỉ dùng 1 lần)
        String sqlUpdate = "UPDATE login SET is_verified = 1, verification_code = NULL WHERE verification_code = ?";

        try (Connection conn = DriverManager.getConnection(url, user, pass)) {
            PreparedStatement psCheck = conn.prepareStatement(sqlCheck);
            psCheck.setString(1, token);
            ResultSet rs = psCheck.executeQuery();

            if (rs.next()) {
                PreparedStatement psUpdate = conn.prepareStatement(sqlUpdate);
                psUpdate.setString(1, token);
                psUpdate.executeUpdate();
                return true;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // 5. Lấy danh sách (Admin) - Đã sửa đúng tên bảng 'login'
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM db";

=======
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
>>>>>>> 1a171a12066a4dd3501f2532db6e181961fce088
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
<<<<<<< HEAD
=======
                // Đảm bảo khớp với Constructor của Model User
>>>>>>> 1a171a12066a4dd3501f2532db6e181961fce088
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

<<<<<<< HEAD
    // 6. Xóa tài khoản khách hàng
=======
    // 5. Xóa tài khoản (Dành cho Admin)
>>>>>>> 1a171a12066a4dd3501f2532db6e181961fce088
    public boolean deleteUser(int id) {
        String sql = "DELETE FROM login WHERE id = ?";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

<<<<<<< HEAD
    // Tiện ích: Mã hóa MD5
=======
    // Hàm tiện ích: Mã hóa MD5
>>>>>>> 1a171a12066a4dd3501f2532db6e181961fce088
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
            e.printStackTrace(); return null;
        }
    }
}