package services;

import java.sql.*;

public class UserServices {
    // Thông số kết nối Database login
    private String url = "jdbc:mysql://localhost:3306/login?useUnicode=true&characterEncoding=UTF-8";
    private String user = "root";
    private String pass = "";

    public boolean checkEmailExists(String email) {
        boolean exists = false;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, user, pass);

            String sql = "SELECT * FROM login WHERE email = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                exists = true;
            }
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return exists;
    }
    // Hàm kiểm tra thông tin đăng nhập
    public boolean checkLogin(String username, String password) {
        boolean isValid = false;
        // Database 'db' theo code gốc của anh
        String url = "jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8";
        String user = "root";
        String pass = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, user, pass);

            // SQL chống Injection
            String sql = "SELECT * FROM login WHERE username = ? AND password = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                isValid = true;
            }
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isValid;
    }
    // Hàm thêm tài khoản mới vào database 'login'
    public int registerUser(String email, String username, String password) {
        int result = 0;
        // Database 'login' theo code gốc của anh
        String url = "jdbc:mysql://localhost:3306/login?useUnicode=true&characterEncoding=UTF-8";
        String user = "root";
        String pass = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, user, pass);

            String sql = "INSERT INTO login (email, username, password) VALUES (?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, username);
            ps.setString(3, password);

            result = ps.executeUpdate();
            conn.close();
        } catch (SQLException e) {
            // Trả về mã lỗi 1062 nếu trùng Email/Username
            if (e.getErrorCode() == 1062) return -1;
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}