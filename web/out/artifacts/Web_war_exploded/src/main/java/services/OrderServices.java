package services;

import java.sql.*;
import java.util.*;

public class OrderServices {
    private final String url = "jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8";
    private final String user = "root";
    private final String pass = "";

    public int createOrder(int userId, String hoTen, String sdt, String diaChi, String ghiChu, double tongTien, List<Map<String, Object>> cartItems) {
        int orderId = -1;
        try (Connection conn = DriverManager.getConnection(url, user, pass)) {
            // 1. Lưu vào bảng donhang
            String sqlOrder = "INSERT INTO donhang (user_id, ho_ten, so_dien_thoai, dia_chi, ghi_chu, tong_tien, trang_thai, ngay_tao) VALUES (?, ?, ?, ?, ?, ?, 'Chờ thanh toán', NOW())";
            PreparedStatement psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            psOrder.setObject(1, (userId > 0) ? userId : null);
            psOrder.setString(2, hoTen);
            psOrder.setString(3, sdt);
            psOrder.setString(4, diaChi);
            psOrder.setString(5, ghiChu);
            psOrder.setDouble(6, tongTien);
            psOrder.executeUpdate();

            // Lấy ID đơn hàng vừa tạo
            ResultSet rs = psOrder.getGeneratedKeys();
            if (rs.next()) {
                orderId = rs.getInt(1);
            }

            // 2. Lưu chi tiết sản phẩm vào bảng donhang_chitiet
            if (orderId > 0 && cartItems != null) {
                String sqlDetail = "INSERT INTO donhang_chitiet (donhang_id, ten_sp, gia, so_luong) VALUES (?, ?, ?, ?)";
                PreparedStatement psDetail = conn.prepareStatement(sqlDetail);
                for (Map<String, Object> item : cartItems) {
                    psDetail.setInt(1, orderId);
                    psDetail.setString(2, (String) item.get("ten_sp"));
                    psDetail.setDouble(3, (Double) item.get("gia"));
                    psDetail.setInt(4, (Integer) item.get("so_luong"));
                    psDetail.addBatch(); // Gom lại chạy 1 lần cho nhanh
                }
                psDetail.executeBatch();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return orderId;
    }
    public void updateOrderStatus(int orderId, String status) {
        try (Connection conn = DriverManager.getConnection(url, user, pass)) {
            String sql = "UPDATE donhang SET trang_thai = ? WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}