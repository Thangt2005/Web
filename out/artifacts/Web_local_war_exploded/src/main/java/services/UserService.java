package services;

import model.User;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserService {
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
        } catch (Exception e) {
            System.out.println("LỖI CHECK EMAIL: " + e.getMessage()); // Thêm dòng này để kiểm tra
            e.printStackTrace();
        }
        return false;
    }

    // --- 2. HÀM CHECK LOGIN ĐÃ SỬA ---
    // Hàm này sẽ trả về đối tượng User (chứa role) thay vì gọi userDAO
    public User checkLogin(String username, String password) {
        User userResult = null;
        String sql = "SELECT * FROM login WHERE username = ? AND password = ?";

        // Nhớ mã hóa mật khẩu nhập vào sang MD5 để so sánh với DB
        String md5Pass = toMD5(password);

        try (Connection conn = DriverManager.getConnection(url, this.user, this.pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, md5Pass);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Nếu tìm thấy, tạo đối tượng User mới
                    // LƯU Ý: Anh phải đảm bảo Constructor của class User khớp với thứ tự này
                    // Hoặc dùng setter như bên dưới cho an toàn
                    userResult = new User();
                    userResult.setId(rs.getInt("id"));
                    userResult.setUsername(rs.getString("username"));
                    userResult.setFullname(rs.getString("fullname"));
                    userResult.setEmail(rs.getString("email"));

                    // QUAN TRỌNG: Lấy cột role từ database
                    // Nếu trong DB cột role tên là "role" thì để nguyên, nếu tên khác thì sửa lại
                    userResult.setRole(rs.getInt("role"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return userResult; // Trả về User (nếu sai pass sẽ trả về null)
    }

    // 3. Đăng ký tài khoản mới
    public int registerUser(String email, String username, String password) {
        // Sắp xếp lại thứ tự cột cho rõ ràng và dễ kiểm soát
        String sql = "INSERT INTO login (username, password, fullname, email, role) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // 1. username -> ứng với cột username
            ps.setString(1, username);

            // 2. password -> ứng với cột password (đã mã hóa MD5)
            ps.setString(2, toMD5(password));

            // 3. fullname -> ứng với cột fullname
            ps.setString(3, "Khách hàng");

            // 4. email -> ứng với cột email
            ps.setString(4, email);

            // 5. role -> ứng với cột role (mặc định 0 là User)
            ps.setInt(5, 0);

            return ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("LỖI SQL TẠI REGISTER: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    // 4. Lấy danh sách khách hàng (Dành cho Admin)
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM login";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                // Cách tạo đối tượng User an toàn nhất là dùng Constructor rỗng rồi set từng cái
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setFullname(rs.getString("fullname"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getInt("role")); // Lấy thêm role
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