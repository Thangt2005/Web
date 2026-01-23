package services;

import model.User;
import context.DBContext;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserService {

    // 1. Kiểm tra Email tồn tại
    public boolean checkEmailExists(String email) {
        String sql = "SELECT email FROM login WHERE email = ?";
        try (Connection conn = new DBContext().getConnection();
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

    // 2. Cập nhật mật khẩu mới
    public void updatePassword(String email, String newPassword) {
        String sql = "UPDATE login SET password = ? WHERE email = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, toMD5(newPassword)); // Mã hóa MD5 để đồng bộ với Login
            ps.setString(2, email);
            ps.executeUpdate();
            System.out.println("Đã cập nhật mật khẩu mới (MD5) cho: " + email);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 3. Kiểm tra Đăng nhập
    public User checkLogin(String username, String password) {
        User userResult = null;
        String sql = "SELECT * FROM login WHERE username = ? AND password = ? AND status = 1";
        String md5Pass = toMD5(password);

        try (Connection conn = new DBContext().getConnection();
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

    // 4. Đăng ký tài khoản mới
    public int registerUser(String email, String username, String password) {
        if (checkEmailExists(email)) return -1;

        String sql = "INSERT INTO login (email, username, password, fullname, role, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, username);
            ps.setString(3, toMD5(password));
            ps.setString(4, "Khách hàng");
            ps.setInt(5, 0);
            ps.setInt(6, 1);

            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 5. Lấy danh sách khách hàng (Admin)
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM login";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setFullname(rs.getString("fullname"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getInt("role"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 6. Xóa tài khoản
    public boolean deleteUser(int id) {
        String sql = "DELETE FROM login WHERE id = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
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
            return password; // Trả về pass gốc nếu lỗi mã hóa
        }
    }
}