package services;

import java.sql.*;
import java.util.*;

public class CartServices {
    private String url = "jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8";
    private String user = "root";
    private String pass = "";

    // Hàm thêm sản phẩm vào giỏ
    public void addToCart(String sessionId, int spId) {
        try (Connection conn = DriverManager.getConnection(url, user, pass)) {
            // Logic lấy/tạo giỏ hàng và thêm chi tiết (như đã hướng dẫn ở các bước trước)
            // ... (Phần logic này anh giữ nguyên từ bản cũ của anh)
        } catch (Exception e) { e.printStackTrace(); }
    }

    // Hàm lấy danh sách hiển thị giỏ hàng
    public List<Map<String, Object>> getCartDetails(String sessionId) {
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DriverManager.getConnection(url, user, pass)) {
            String sql = "SELECT gc.* FROM giohang_chitiet gc JOIN giohang g ON gc.giohang_id = g.id WHERE g.session_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, sessionId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("ten_sp", rs.getString("ten_sp"));
                item.put("hinh_anh", rs.getString("hinh_anh"));
                item.put("gia", rs.getDouble("gia"));
                item.put("so_luong", rs.getInt("so_luong"));
                item.put("tam_tinh", rs.getDouble("gia") * rs.getInt("so_luong"));
                list.add(item);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}