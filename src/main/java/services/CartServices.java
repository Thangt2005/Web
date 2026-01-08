package services;

import java.sql.*;
import java.util.*;

public class CartServices {
    private final String url = "jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8";
    private final String user = "root";
    private final String pass = "";

    // --- HÀM HỖ TRỢ: Lấy hoặc tạo mới Giỏ hàng ID ---
    private int getOrCreateCartId(Connection conn, String sessionId) throws SQLException {
        String sqlCheck = "SELECT id FROM giohang WHERE session_id = ?";
        PreparedStatement ps = conn.prepareStatement(sqlCheck);
        ps.setString(1, sessionId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) return rs.getInt("id");

        String sqlCreate = "INSERT INTO giohang(session_id, ngay_tao) VALUES(?, NOW())";
        PreparedStatement psC = conn.prepareStatement(sqlCreate, Statement.RETURN_GENERATED_KEYS);
        psC.setString(1, sessionId);
        psC.executeUpdate();
        ResultSet rsK = psC.getGeneratedKeys();
        return rsK.next() ? rsK.getInt(1) : -1;
    }

    // 1. THÊM VÀO GIỎ (Phân biệt theo category)
    public void addToCart(String sessionId, int sanPhamId, String category) {
        String type = (category == null || category.isEmpty()) ? "home_sanpham" : category;
        try (Connection conn = DriverManager.getConnection(url, user, pass)) {
            // Lấy thông tin sản phẩm từ bảng tương ứng
            String sqlGetProduct = "SELECT ten_sp, hinh_anh, gia FROM " + type + " WHERE id = ?";
            PreparedStatement psProduct = conn.prepareStatement(sqlGetProduct);
            psProduct.setInt(1, sanPhamId);
            ResultSet rsProduct = psProduct.executeQuery();

            if (!rsProduct.next()) return;
            String tenSp = rsProduct.getString("ten_sp");
            String hinhAnh = rsProduct.getString("hinh_anh");
            double gia = rsProduct.getDouble("gia");

            int gioHangId = getOrCreateCartId(conn, sessionId);

            // Kiểm tra: Phải trùng cả ID và Category mới cộng dồn số lượng
            String sqlCheckItem = "SELECT id FROM giohang_chitiet WHERE giohang_id = ? AND sanpham_id = ? AND category = ?";
            PreparedStatement psItem = conn.prepareStatement(sqlCheckItem);
            psItem.setInt(1, gioHangId);
            psItem.setInt(2, sanPhamId);
            psItem.setString(3, type);
            ResultSet rsItem = psItem.executeQuery();

            if (rsItem.next()) {
                String sqlUpdate = "UPDATE giohang_chitiet SET so_luong = so_luong + 1 WHERE id = ?";
                PreparedStatement psUpdate = conn.prepareStatement(sqlUpdate);
                psUpdate.setInt(1, rsItem.getInt("id"));
                psUpdate.executeUpdate();
            } else {
                String sqlInsert = "INSERT INTO giohang_chitiet(giohang_id, sanpham_id, ten_sp, hinh_anh, gia, so_luong, category) VALUES(?,?,?,?,?,1,?)";
                PreparedStatement psInsert = conn.prepareStatement(sqlInsert);
                psInsert.setInt(1, gioHangId);
                psInsert.setInt(2, sanPhamId);
                psInsert.setString(3, tenSp);
                psInsert.setString(4, hinhAnh);
                psInsert.setDouble(5, gia);
                psInsert.setString(6, type);
                psInsert.executeUpdate();
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 2. LẤY CHI TIẾT GIỎ HÀNG
    public List<Map<String, Object>> getCartDetails(String sessionId) {
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DriverManager.getConnection(url, user, pass)) {
            String sql = "SELECT gc.* FROM giohang_chitiet gc JOIN giohang g ON gc.giohang_id = g.id WHERE g.session_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, sessionId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("id", rs.getInt("sanpham_id"));
                item.put("ten_sp", rs.getString("ten_sp"));
                item.put("hinh_anh", rs.getString("hinh_anh"));
                item.put("gia", rs.getDouble("gia"));
                item.put("so_luong", rs.getInt("so_luong"));
                item.put("category", rs.getString("category")); // Trả về category để JSP xử lý nút xóa/giảm
                item.put("tam_tinh", rs.getDouble("gia") * rs.getInt("so_luong"));
                list.add(item);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 3. XÓA SẢN PHẨM (Phải kèm category)
    public void removeProduct(String sessionId, int sanPhamId, String category) {
        try (Connection conn = DriverManager.getConnection(url, user, pass)) {
            String sql = "DELETE gc FROM giohang_chitiet gc " +
                    "JOIN giohang g ON gc.giohang_id = g.id " +
                    "WHERE g.session_id = ? AND gc.sanpham_id = ? AND gc.category = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, sessionId);
            ps.setInt(2, sanPhamId);
            ps.setString(3, category);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 4. GIẢM SỐ LƯỢNG (Phải kèm category)
    public void decreaseQuantity(String sessionId, int id, String category) {
        try (Connection conn = DriverManager.getConnection(url, user, pass)) {
            String sql = "UPDATE giohang_chitiet gc " +
                    "JOIN giohang g ON gc.giohang_id = g.id " +
                    "SET gc.so_luong = gc.so_luong - 1 " +
                    "WHERE g.session_id = ? AND gc.sanpham_id = ? AND gc.category = ? AND gc.so_luong > 1";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, sessionId);
            ps.setInt(2, id);
            ps.setString(3, category);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
}