package services;

import model.User;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserService {
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("Không tìm thấy MySQL Driver! Hãy kiểm tra file .jar trong thư mục lib.");
            e.printStackTrace();
        }
    }
    // Cấu hình Database chung
    private String url = "jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8";
    private String user = "root";
    private String pass = "";

    // 1. Kiểm tra Email tồn tại
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

    // --- 2. HÀM CHECK LOGIN ---
    // Vẫn giữ kiểm tra status = 1 (Tài khoản đang hoạt động)
    public User checkLogin(String username, String password) {
        User userResult = null;
        String sql = "SELECT * FROM login WHERE username = ? AND password = ? AND status = 1";

        String md5Pass = toMD5(password);

        try (Connection conn = DriverManager.getConnection(url, this.user, this.pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, md5Pass);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    userResult = new User();
                    userResult.setId(rs.getInt("id"));
                    userResult.setUsername(rs.getString("username"));
                    userResult.setFullname(rs.getString("fullname"));
                    userResult.setEmail(rs.getString("email"));
                    userResult.setRole(rs.getInt("role"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return userResult;
    }

    // --- 3. ĐĂNG KÝ TÀI KHOẢN MỚI (Đã sửa: Active luôn) ---
    public int registerUser(String email, String username, String password) {
        int result = 0;

        // Kiểm tra trùng email
        if (checkEmailExists(email)) {
            return -1; // Báo lỗi đã tồn tại
        }

        // Câu lệnh SQL: Không lưu token, set status = 1 (Kích hoạt ngay lập tức)
        String sql = "INSERT INTO login (email, username, password, fullname, role, status) VALUES (?, ?, ?, ?, ?, ?)";

        String md5Pass = toMD5(password);try (Connection conn = DriverManager.getConnection(url, user, pass);
                                              PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, username);
            ps.setString(3, md5Pass);
            ps.setString(4, "Khách hàng"); // Tên mặc định
            ps.setInt(5, 0); // Role: 0 (User thường)
            ps.setInt(6, 1); // Status: 1 (Đã kích hoạt -> Đăng nhập được ngay)

            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    // 4. Lấy danh sách khách hàng (Dành cho Admin)
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM login";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setFullname(rs.getString("fullname"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getInt("role"));
                // Có thể lấy thêm status nếu cần hiển thị bên Admin
                // u.setStatus(rs.getInt("status"));
                list.add(u);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 5. Xóa tài khoản
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