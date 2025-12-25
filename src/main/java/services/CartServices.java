package services;

import java.sql.*;
import java.util.*;

public class CartServices {

    private final String url = "jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8";
    private final String user = "root";
    private final String pass = "";

    // ================== THÊM SẢN PHẨM VÀO GIỎ ==================
    public void addToCart(String sessionId, int sanPhamId) {

        try (Connection conn = DriverManager.getConnection(url, user, pass)) {

            int gioHangId = -1;

            // 1. Kiểm tra giỏ hàng theo session
            String sqlCheckCart = "SELECT id FROM giohang WHERE session_id = ?";
            PreparedStatement psCheck = conn.prepareStatement(sqlCheckCart);
            psCheck.setString(1, sessionId);
            ResultSet rsCart = psCheck.executeQuery();

            if (rsCart.next()) {
                gioHangId = rsCart.getInt("id");
            } else {
                // 2. Chưa có → tạo giỏ mới
                String sqlCreateCart = "INSERT INTO giohang(session_id) VALUES(?)";
                PreparedStatement psCreate =
                        conn.prepareStatement(sqlCreateCart, Statement.RETURN_GENERATED_KEYS);
                psCreate.setString(1, sessionId);
                psCreate.executeUpdate();

                ResultSet rsKey = psCreate.getGeneratedKeys();
                if (rsKey.next()) {
                    gioHangId = rsKey.getInt(1);
                }
            }

            // 3. Kiểm tra sản phẩm đã có trong giỏ chưa
            String sqlCheckItem =
                    "SELECT so_luong FROM giohang_chitiet WHERE giohang_id = ? AND sanpham_id = ?";
            PreparedStatement psItem = conn.prepareStatement(sqlCheckItem);
            psItem.setInt(1, gioHangId);
            psItem.setInt(2, sanPhamId);
            ResultSet rsItem = psItem.executeQuery();

            if (rsItem.next()) {
                // 4. Có rồi → tăng số lượng
                String sqlUpdate =
                        "UPDATE giohang_chitiet SET so_luong = so_luong + 1 " +
                                "WHERE giohang_id = ? AND sanpham_id = ?";
                PreparedStatement psUpdate = conn.prepareStatement(sqlUpdate);
                psUpdate.setInt(1, gioHangId);
                psUpdate.setInt(2, sanPhamId);
                psUpdate.executeUpdate();
            } else {
                // 5. Chưa có → thêm mới
                String sqlInsert =
                        "INSERT INTO giohang_chitiet(giohang_id, sanpham_id, so_luong) VALUES(?,?,1)";
                PreparedStatement psInsert = conn.prepareStatement(sqlInsert);
                psInsert.setInt(1, gioHangId);
                psInsert.setInt(2, sanPhamId);
                psInsert.executeUpdate();
            }

            System.out.println("✅ Đã thêm SP ID = " + sanPhamId + " | session = " + sessionId);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ================== LẤY DANH SÁCH GIỎ HÀNG ==================
    public List<Map<String, Object>> getCartDetails(String sessionId) {

        List<Map<String, Object>> list = new ArrayList<>();

        try (Connection conn = DriverManager.getConnection(url, user, pass)) {

            String sql =
                    "SELECT gc.id AS cart_detail_id, sp.ten_sp, sp.gia, sp.hinh_anh, gc.so_luong " +
                            "FROM giohang_chitiet gc " +
                            "JOIN giohang g ON gc.giohang_id = g.id " +
                            "JOIN home_sanpham sp ON gc.sanpham_id = sp.id " +
                            "WHERE g.session_id = ?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, sessionId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("id", rs.getInt("cart_detail_id"));
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
}
