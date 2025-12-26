package services;

import java.sql.*;
import java.util.*;

public class CartServices {

    private final String DB_URL = "jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8";
    private final String DB_USER = "root";
    private final String DB_PASS = "";

    private Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }

    // ================== THÊM SẢN PHẨM ==================
    public void addToCart(String sessionId, int sanPhamId) {
        try (Connection conn = getConnection()) {

            // 1. LẤY HOẶC TẠO GIỎ HÀNG (Session)
            int gioHangId = getOrCreateCartId(conn, sessionId);
            if (gioHangId == -1) return;

            // 2. KIỂM TRA SẢN PHẨM ĐÃ CÓ TRONG GIỎ CHƯA
            String sqlCheck = "SELECT id FROM giohang_chitiet WHERE giohang_id = ? AND sanpham_id = ?";
            boolean exists = false;
            try (PreparedStatement ps = conn.prepareStatement(sqlCheck)) {
                ps.setInt(1, gioHangId);
                ps.setInt(2, sanPhamId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) exists = true;
                }
            }

            if (exists) {
                // 3a. NẾU CÓ RỒI -> TĂNG SỐ LƯỢNG
                String sqlUpdate = "UPDATE giohang_chitiet SET so_luong = so_luong + 1 WHERE giohang_id = ? AND sanpham_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sqlUpdate)) {
                    ps.setInt(1, gioHangId);
                    ps.setInt(2, sanPhamId);
                    ps.executeUpdate();
                }
            } else {
                // 3b. NẾU CHƯA CÓ -> PHẢI LẤY THÔNG TIN SP TỪ KHO TRƯỚC
                // (Bước này quan trọng để điền vào các cột ten_sp, hinh_anh, gia trong bảng giohang_chitiet của bạn)

                String sqlGetProduct = "SELECT ten_sp, hinh_anh, gia FROM home_sanpham WHERE id = ?";
                String tenSp = "Sản phẩm lỗi";
                String hinhAnh = "";
                double gia = 0;

                try (PreparedStatement psProd = conn.prepareStatement(sqlGetProduct)) {
                    psProd.setInt(1, sanPhamId);
                    try (ResultSet rsProd = psProd.executeQuery()) {
                        if (rsProd.next()) {
                            tenSp = rsProd.getString("ten_sp");
                            hinhAnh = rsProd.getString("hinh_anh");
                            gia = rsProd.getDouble("gia");
                        }
                    }
                }

                // Câu lệnh INSERT đầy đủ các cột (Khắc phục lỗi của bạn tại đây)
                String sqlInsert = "INSERT INTO giohang_chitiet(giohang_id, sanpham_id, ten_sp, hinh_anh, gia, so_luong) VALUES(?,?,?,?,?,1)";
                try (PreparedStatement ps = conn.prepareStatement(sqlInsert)) {
                    ps.setInt(1, gioHangId);
                    ps.setInt(2, sanPhamId);
                    ps.setString(3, tenSp);
                    ps.setString(4, hinhAnh);
                    ps.setDouble(5, gia);
                    ps.executeUpdate();
                }
            }
            System.out.println("✅ Đã thêm thành công SP ID: " + sanPhamId);

        } catch (Exception e) {
            System.err.println("❌ LỖI SQL: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Helper: Lấy ID giỏ hàng
    private int getOrCreateCartId(Connection conn, String sessionId) throws SQLException {
        String sqlCheck = "SELECT id FROM giohang WHERE session_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sqlCheck)) {
            ps.setString(1, sessionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("id");
            }
        }

        // Tạo mới nếu chưa có
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

    // ================== LẤY DANH SÁCH GIỎ HÀNG ==================
    public List<Map<String, Object>> getCartDetails(String sessionId) {
        List<Map<String, Object>> list = new ArrayList<>();

        // Lấy trực tiếp từ bảng giohang_chitiet (vì bạn đã lưu tên, ảnh, giá vào đó rồi)
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
                    item.put("id", rs.getInt("id"));
                    item.put("ten_sp", rs.getString("ten_sp"));
                    item.put("hinh_anh", rs.getString("hinh_anh"));
                    item.put("gia", rs.getDouble("gia"));
                    item.put("so_luong", rs.getInt("so_luong"));
                    item.put("tam_tinh", rs.getDouble("gia") * rs.getInt("so_luong"));
                    list.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ================== XÓA KHỎI GIỎ ==================
    public void removeFromCart(int idChiTiet) {
        String sql = "DELETE FROM giohang_chitiet WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idChiTiet);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}