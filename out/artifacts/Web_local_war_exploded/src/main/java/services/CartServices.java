package services;

import java.sql.*;
import java.util.*;

public class CartServices {

    private final String DB_URL = "jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8";
    private final String DB_USER = "root";
    private final String DB_PASS = "";

    // Hàm kết nối Database
    private Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }

    // 1. Thêm sản phẩm vào giỏ
    public void addToCart(String sessionId, int sanPhamId, String loai) {
        try (Connection conn = getConnection()) {
            String tableName = getTableName(loai);
            int gioHangId = getOrCreateCartId(conn, sessionId);
            if (gioHangId == -1) return;

            String sqlCheck = "SELECT id, so_luong FROM giohang_chitiet WHERE giohang_id = ? AND sanpham_id = ? AND loai_sp = ?";
            try (PreparedStatement ps = conn.prepareStatement(sqlCheck)) {
                ps.setInt(1, gioHangId);
                ps.setInt(2, sanPhamId);
                ps.setString(3, loai);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        updateQuantity(rs.getInt("id"), rs.getInt("so_luong") + 1);
                    } else {
                        insertNewItem(conn, gioHangId, sanPhamId, tableName, loai);
                    }
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 2. Chèn sản phẩm mới vào bảng chi tiết
    private void insertNewItem(Connection conn, int gioHangId, int sanPhamId, String tableName, String loai) throws SQLException {
        String sqlGetProduct = "SELECT ten_sp, hinh_anh, gia FROM " + tableName + " WHERE id = ?";
        try (PreparedStatement psProd = conn.prepareStatement(sqlGetProduct)) {
            psProd.setInt(1, sanPhamId);
            try (ResultSet rsProd = psProd.executeQuery()) {
                if (rsProd.next()) {
                    String sqlInsert = "INSERT INTO giohang_chitiet(giohang_id, sanpham_id, ten_sp, hinh_anh, gia, so_luong, loai_sp) VALUES(?,?,?,?,?,?,?)";
                    try (PreparedStatement psIns = conn.prepareStatement(sqlInsert)) {
                        psIns.setInt(1, gioHangId);
                        psIns.setInt(2, sanPhamId);
                        psIns.setString(3, rsProd.getString("ten_sp"));
                        psIns.setString(4, rsProd.getString("hinh_anh"));
                        psIns.setDouble(5, rsProd.getDouble("gia"));
                        psIns.setInt(6, 1);
                        psIns.setString(7, loai);
                        psIns.executeUpdate();
                    }
                }
            }
        }
    }

    // 3. Lấy danh sách chi tiết giỏ hàng để hiển thị
    public List<Map<String, Object>> getCartDetails(String sessionId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT gc.id, gc.ten_sp, gc.hinh_anh, gc.gia, gc.so_luong " +
                "FROM giohang_chitiet gc " +
                "JOIN giohang g ON gc.giohang_id = g.id " +
                "WHERE g.session_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, sessionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new HashMap<>();
                    double gia = rs.getDouble("gia");
                    int soLuong = rs.getInt("so_luong");

                    item.put("id", rs.getInt("id"));
                    item.put("ten_sp", rs.getString("ten_sp"));
                    item.put("hinh_anh", rs.getString("hinh_anh"));
                    item.put("gia", gia);
                    item.put("so_luong", soLuong);
                    item.put("tam_tinh", gia * soLuong);
                    list.add(item);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 4. Cập nhật số lượng sản phẩm (Tăng/Giảm)
    public void updateQuantity(int detailId, int quantity) {
        if (quantity <= 0) {
            removeFromCart(detailId);
            return;
        }
        String sql = "UPDATE giohang_chitiet SET so_luong = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, detailId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 5. Xóa một sản phẩm khỏi giỏ
    public void removeFromCart(int detailId) {
        String sql = "DELETE FROM giohang_chitiet WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, detailId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 6. Xóa sạch giỏ hàng theo Session
    public void clearCart(String sessionId) {
        String sql = "DELETE gc FROM giohang_chitiet gc " +
                "JOIN giohang g ON gc.giohang_id = g.id " +
                "WHERE g.session_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, sessionId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 7. Tính tổng tiền cả giỏ hàng
    public double getTotalCartPrice(String sessionId) {
        String sql = "SELECT SUM(gc.gia * gc.so_luong) AS tong_tien " +
                "FROM giohang_chitiet gc " +
                "JOIN giohang g ON gc.giohang_id = g.id " +
                "WHERE g.session_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, sessionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble("tong_tien");
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // --- Helper Methods ---

    private String getTableName(String loai) {
        if (loai == null) return "home_sanpham";
        return loai.toLowerCase() + "_sanpham";
    }

    private int getOrCreateCartId(Connection conn, String sessionId) throws SQLException {
        String sqlCheck = "SELECT id FROM giohang WHERE session_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sqlCheck)) {
            ps.setString(1, sessionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("id");
            }
        }
        String sqlInsert = "INSERT INTO giohang(session_id) VALUES(?)";
        try (PreparedStatement ps = conn.prepareStatement(sqlInsert, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, sessionId);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return -1;
    }
}