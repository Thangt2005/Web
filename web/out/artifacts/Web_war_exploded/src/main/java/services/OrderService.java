package services;

import model.Order;
import model.OrderDetail;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class OrderService {
    private String url = "jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8";
    private String user = "root";
    private String pass = "";

    // 1. Lấy tất cả đơn hàng (Cho Admin) - Sắp xếp đơn mới nhất lên đầu
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY created_at DESC";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("id"));
                o.setUserId(rs.getInt("user_id"));
                o.setFullname(rs.getString("fullname"));
                o.setPhone(rs.getString("phone"));
                o.setAddress(rs.getString("address"));
                o.setTotalMoney(rs.getDouble("total_money"));
                o.setStatus(rs.getInt("status"));
                o.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(o);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 2. Lấy chi tiết đơn hàng (Khi bấm nút "Xem chi tiết")
    public List<OrderDetail> getOrderDetails(int orderId) {
        List<OrderDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM order_details WHERE order_id = ?";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderDetail d = new OrderDetail();
                    d.setId(rs.getInt("id"));
                    d.setOrderId(rs.getInt("order_id"));
                    d.setProductId(rs.getInt("product_id"));
                    d.setProductName(rs.getString("product_name"));
                    d.setPrice(rs.getDouble("price"));
                    d.setQuantity(rs.getInt("quantity"));
                    list.add(d);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 3. Cập nhật trạng thái đơn hàng (Admin bấm nút duyệt/hủy)
    public void updateStatus(int orderId, int status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
    public int createOrder(int userId, String fullname, String phone, String address, List<Map<String, Object>> cartItems) {
        int orderId = -1;
        String sqlOrder = "INSERT INTO orders (user_id, fullname, phone, address, total_money, status, created_at) VALUES (?, ?, ?, ?, ?, ?, NOW())";
        String sqlDetail = "INSERT INTO order_details (order_id, product_id, product_name, price, quantity) VALUES (?, ?, ?, ?, ?)";

        // Tính tổng tiền
        double totalMoney = 0;
        for (Map<String, Object> item : cartItems) {
            double price = (double) item.get("price"); // Hoặc logic giá của anh
            int quantity = (int) item.get("quantity");
            totalMoney += price * quantity;
        }

        Connection conn = null;
        try {
            conn = DriverManager.getConnection(url, user, pass);
            // Tắt tự động commit để xử lý Transaction (quan trọng)
            conn.setAutoCommit(false);

            // 1. INSERT ORDERS
            // RETURN_GENERATED_KEYS để lấy ID đơn hàng vừa tạo (số 7, 8, 9...)
            PreparedStatement psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, userId);
            psOrder.setString(2, fullname);
            psOrder.setString(3, phone);
            psOrder.setString(4, address);
            psOrder.setDouble(5, totalMoney);
            psOrder.setInt(6, 1); // Status = 1 (Chờ thanh toán/xác nhận)

            int rowAffected = psOrder.executeUpdate();
            if (rowAffected > 0) {
                ResultSet rs = psOrder.getGeneratedKeys();
                if (rs.next()) {
                    orderId = rs.getInt(1); // LẤY ĐƯỢC ID ĐƠN HÀNG (Ví dụ: 7)
                }
            }

            // 2. INSERT ORDER DETAILS (Lặp qua giỏ hàng để lưu từng món)
            if (orderId != -1) {
                PreparedStatement psDetail = conn.prepareStatement(sqlDetail);
                for (Map<String, Object> item : cartItems) {
                    psDetail.setInt(1, orderId);

                    // --- SỬA DÒNG NÀY ---
                    // Cũ (Sai): psDetail.setInt(2, (int) item.get("productId"));
                    // Mới (Đúng): Phải dùng key là "id" giống bên CartServices
                    psDetail.setInt(2, (int) item.get("id"));

                    psDetail.setString(3, (String) item.get("ten_sp")); // Key bên Cart là "ten_sp"
                    psDetail.setDouble(4, (double) item.get("gia"));    // Key bên Cart là "gia" (không phải "price")
                    psDetail.setInt(5, (int) item.get("so_luong"));     // Key bên Cart là "so_luong" (không phải "quantity")

                    psDetail.addBatch();
                }
                psDetail.executeBatch();
            }

            conn.commit(); // Lưu thành công

        } catch (Exception e) {
            e.printStackTrace(); // Anh xem log sẽ thấy lỗi NullPointerException ở đây
            try {
                if (conn != null) conn.rollback(); // Xóa sạch dữ liệu nếu lỗi
            } catch (SQLException ex) { ex.printStackTrace(); }

            orderId = -1; // <--- THÊM DÒNG NÀY: Để báo cho Controller biết là thất bại
        } finally {
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }

        return orderId;
    }
}