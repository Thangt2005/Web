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

    public void addToCart(String sessionId, int sanPhamId, String loai) {
        try (Connection conn = getConnection()) {

            // 1. XÁC ĐỊNH TÊN BẢNG
            String tableName = getTableName(loai);

            // 2. LẤY HOẶC TẠO GIỎ HÀNG
            int gioHangId = getOrCreateCartId(conn, sessionId);
            if (gioHangId == -1) return;

            // 3. KIỂM TRA: PHẢI CHECK CẢ 'ID' VÀ 'LOẠI'
            // (Sửa: Thêm điều kiện AND loai_sp = ?)
            String sqlCheck = "SELECT id FROM giohang_chitiet WHERE giohang_id = ? AND sanpham_id = ? AND loai_sp = ?";
            boolean exists = false;

            try (PreparedStatement ps = conn.prepareStatement(sqlCheck)) {
                ps.setInt(1, gioHangId);
                ps.setInt(2, sanPhamId);
                ps.setString(3, loai); // Quan trọng: Phân biệt loại combo, home, bontam...
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) exists = true;
                }
            }

            if (exists) {
                // 4a. NẾU CÓ RỒI -> TĂNG SỐ LƯỢNG (Chỉ tăng đúng loại đó)
                String sqlUpdate = "UPDATE giohang_chitiet SET so_luong = so_luong + 1 WHERE giohang_id = ? AND sanpham_id = ? AND loai_sp = ?";
                try (PreparedStatement ps = conn.prepareStatement(sqlUpdate)) {
                    ps.setInt(1, gioHangId);
                    ps.setInt(2, sanPhamId);
                    ps.setString(3, loai);
                    ps.executeUpdate();
                }
            } else {
                // 4b. NẾU CHƯA CÓ -> LẤY THÔNG TIN TỪ BẢNG TƯƠNG ỨNG
                String sqlGetProduct = "SELECT ten_sp, hinh_anh, gia FROM " + tableName + " WHERE id = ?";

                String tenSp = "Sản phẩm lỗi";
                String hinhAnh = "";
                double gia = 0;
                boolean foundProduct = false;

                try (PreparedStatement psProd = conn.prepareStatement(sqlGetProduct)) {
                    psProd.setInt(1, sanPhamId);
                    try (ResultSet rsProd = psProd.executeQuery()) {
                        if (rsProd.next()) {
                            tenSp = rsProd.getString("ten_sp");
                            hinhAnh = rsProd.getString("hinh_anh");
                            gia = rsProd.getDouble("gia");
                            foundProduct = true;
                        }
                    }
                }

                if (foundProduct) {
                    // Insert vào giỏ hàng (THÊM CỘT loai_sp)
                    String sqlInsert = "INSERT INTO giohang_chitiet(giohang_id, sanpham_id, ten_sp, hinh_anh, gia, so_luong, loai_sp) VALUES(?,?,?,?,?,?,?)";
                    try (PreparedStatement ps = conn.prepareStatement(sqlInsert)) {
                        ps.setInt(1, gioHangId);
                        ps.setInt(2, sanPhamId);
                        ps.setString(3, tenSp);
                        ps.setString(4, hinhAnh);
                        ps.setDouble(5, gia);
                        ps.setInt(6, 1);
                        ps.setString(7, loai); // Lưu loại vào DB để lần sau check không bị trùng
                        ps.executeUpdate();
                    }
                } else {
                    System.out.println("❌ Không tìm thấy sản phẩm ID " + sanPhamId + " trong bảng " + tableName);
                }
            }

        } catch (Exception e) {
            System.err.println("❌ LỖI SQL: " + e.getMessage());
            e.printStackTrace();
        }
    }
    // --- HÀM PHỤ TRỢ: CHỌN TÊN BẢNG ---
    private String getTableName(String loai) {
        if (loai == null) return "home_sanpham"; // Mặc định
        switch (loai.toLowerCase()) {
            case "combo":   return "combo_sanpham";
            case "lavabo":  return "lavabo_sanpham";
            case "bontam":  return "bontam_sanpham";
            case "toilet":  return "toilet_sanpham";
            case "tulavabo":  return "tulavabo_sanpham";
            case "bontieunam":  return "bontieunam_sanpham";
            case "chauruachen":  return "chauruachen_sanpham";
            case "phukien":  return "phukien_sanpham";
            case "voirua":  return "voirua_sanpham";
            case "voisentam":  return "voisentam_sanpham";

            default:        return "home_sanpham";
        }
    }

    // Helper: Lấy ID giỏ hàng (GIỮ NGUYÊN)
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

    // ================== LẤY DANH SÁCH GIỎ HÀNG (GIỮ NGUYÊN) ==================
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

    // ================== XÓA KHỎI GIỎ (GIỮ NGUYÊN) ==================
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