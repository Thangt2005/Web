package services;

import java.sql.*;

public class UserServices {
    private String url = "jdbc:mysql://localhost:3306/login?useUnicode=true&characterEncoding=UTF-8";
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
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 2. Kiểm tra Đăng nhập (Phải dùng chung Database với hàm Register)
    public boolean checkLogin(String username, String password) {
        String sql = "SELECT username FROM login WHERE username = ? AND password = ?";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 3. Đăng ký tài khoản mới
    public int registerUser(String email, String username, String password) {
        int result = 0;
        // 1. ĐỔI TÊN DATABASE THÀNH 'db'
        String url = "jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8";
        String user = "root";
        String pass = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, user, pass)) {
                // 2. NẾU CỘT FULLNAME LÀ BẮT BUỘC, ANH NÊN THÊM VÀO SQL
                String sql = "INSERT INTO login (email, username, password, fullname) VALUES (?, ?, ?, ?)";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, email);
                ps.setString(2, username);
                ps.setString(3, password);
                ps.setString(4, "Khách hàng"); // Truyền tạm giá trị cho fullname

                result = ps.executeUpdate();
            }
        } catch (SQLException e) {
            if (e.getErrorCode() == 1062) return -1; // Trùng Email/Username
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }}