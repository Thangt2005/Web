package services;

import java.sql.*;
import java.util.*;

public class CartServices {
    private final String url = "jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8";
    private final String user = "root";
    private final String pass = "";

    public void addToCart(String sessionId, int sanPhamId, String category) {
        try (Connection conn = DriverManager.getConnection(url, user, pass)) {

            // 1. LẤY THÔNG TIN TỪ ĐÚNG BẢNG (Category)
            String tableName = (category == null || category.isEmpty()) ? "home_sanpham" : category;
            String sqlGetProduct = "SELECT ten_sp, hinh_anh, gia FROM " + tableName + " WHERE id = ?";

            PreparedStatement psProduct = conn.prepareStatement(sqlGetProduct);
            psProduct.setInt(1, sanPhamId);
            ResultSet rsProduct = psProduct.executeQuery();

            String tenSp = "";
            String hinhAnh = "";
            double gia = 0;

            if (rsProduct.next()) {
                tenSp = rsProduct.getString("ten_sp");
                hinhAnh = rsProduct.getString("hinh_anh");
                gia = rsProduct.getDouble("gia");
            } else { return; }

            // 2. LẤY HOẶC TẠO GIỎ HÀNG CHO SESSION
            int gioHangId = -1;
            String sqlCheckCart = "SELECT id FROM giohang WHERE session_id = ?";
            PreparedStatement psCheck = conn.prepareStatement(sqlCheckCart);
            psCheck.setString(1, sessionId);
            ResultSet rsCart = psCheck.executeQuery();

            if (rsCart.next()) {
                gioHangId = rsCart.getInt("id");
            } else {
                String sqlCreateCart = "INSERT INTO giohang(session_id, ngay_tao) VALUES(?, NOW())";
                PreparedStatement psCreate = conn.prepareStatement(sqlCreateCart, Statement.RETURN_GENERATED_KEYS);
                psCreate.setString(1, sessionId);
                psCreate.executeUpdate();
                ResultSet rsKey = psCreate.getGeneratedKeys();
                if (rsKey.next()) gioHangId = rsKey.getInt(1);
            }

            // 3. KIỂM TRA SẢN PHẨM CỤ THỂ TRONG GIỎ (QUAN TRỌNG NHẤT)
            // Phải kiểm tra đúng giohang_id VÀ sanpham_id
            String sqlCheckItem = "SELECT id FROM giohang_chitiet WHERE giohang_id = ? AND sanpham_id = ?";
            PreparedStatement psItem = conn.prepareStatement(sqlCheckItem);
            psItem.setInt(1, gioHangId);
            psItem.setInt(2, sanPhamId);
            ResultSet rsItem = psItem.executeQuery();

            if (rsItem.next()) {
                // Nếu đúng sản phẩm này đã có -> Chỉ tăng số lượng của CHÍNH NÓ
                String sqlUpdate = "UPDATE giohang_chitiet SET so_luong = so_luong + 1 WHERE id = ?";
                PreparedStatement psUpdate = conn.prepareStatement(sqlUpdate);
                psUpdate.setInt(1, rsItem.getInt("id"));
                psUpdate.executeUpdate();
            } else {
                // Nếu là sản phẩm mới (ID khác) -> Thêm dòng mới vào Database
                String sqlInsert = "INSERT INTO giohang_chitiet(giohang_id, sanpham_id, ten_sp, hinh_anh, gia, so_luong) VALUES(?,?,?,?,?,1)";
                PreparedStatement psInsert = conn.prepareStatement(sqlInsert);
                psInsert.setInt(1, gioHangId);
                psInsert.setInt(2, sanPhamId);
                psInsert.setString(3, tenSp);
                psInsert.setString(4, hinhAnh);
                psInsert.setDouble(5, gia);
                psInsert.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public List<Map<String, Object>> getCartDetails(String sessionId) {
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DriverManager.getConnection(url, user, pass)) {

            String sql = "SELECT gc.* FROM giohang_chitiet gc " +
                    "JOIN giohang g ON gc.giohang_id = g.id " +
                    "WHERE g.session_id = ?";

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
                item.put("tam_tinh", rs.getDouble("gia") * rs.getInt("so_luong"));
                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ================== 4. XÓA SẢN PHẨM KHỎI GIỎ ==================
    public void removeProduct(String sessionId, int sanPhamId) {
        try (Connection conn = DriverManager.getConnection(url, user, pass)) {
            String sql = "DELETE gc FROM giohang_chitiet gc " +
                    "JOIN giohang g ON gc.giohang_id = g.id " +
                    "WHERE g.session_id = ? AND gc.sanpham_id = ?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, sessionId);
            ps.setInt(2, sanPhamId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public void decreaseQuantity(String sessionId, int id) {
        try (Connection conn = DriverManager.getConnection(url, user, pass)) {
            String sql = "UPDATE giohang_chitiet gc " +
                    "JOIN giohang g ON gc.giohang_id = g.id " +
                    "SET gc.so_luong = gc.so_luong - 1 " +
                    "WHERE g.session_id = ? AND gc.sanpham_id = ? AND gc.so_luong > 1";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, sessionId);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}