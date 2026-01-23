package services;

import model.Order;
import model.OrderDetail;
import dao.OrderDAO;  // Đảm bảo anh đã có file OrderDAO trong gói dao
import context.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class OrderService {

    // Khởi tạo DAO để xử lý các lệnh SQL (Insert/Select)
    private OrderDAO orderDAO = new OrderDAO();

    // ============================================================
    // PHẦN 1: XỬ LÝ ĐẶT HÀNG (CHO KHÁCH HÀNG)
    // ============================================================

    /**
     * Hàm tạo đơn hàng mới
     * @param paymentMethod: Phương thức thanh toán (COD, PAYPAL...)
     * @return orderId: Mã đơn hàng vừa tạo (hoặc -1 nếu lỗi)
     */
    public int createOrder(int userId, String fullname, String phone, String address, List<Map<String, Object>> cartItems, String paymentMethod) {

        // 1. Tính tổng tiền đơn hàng
        double totalMoney = 0;
        if (cartItems != null) {
            for (Map<String, Object> item : cartItems) {
                try {
                    // Xử lý ép kiểu an toàn (tránh lỗi nếu Map trả về String hoặc Integer)
                    double gia = Double.parseDouble(item.get("gia").toString());
                    int soLuong = Integer.parseInt(item.get("so_luong").toString());
                    totalMoney += (gia * soLuong);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }

        // 2. Lưu thông tin chính của Đơn hàng vào bảng `orders`
        // Gọi sang DAO để thực hiện lệnh SQL INSERT
        int orderId = orderDAO.insertOrder(userId, fullname, phone, address, totalMoney, paymentMethod);

        // 3. Nếu tạo đơn hàng thành công (có ID > 0), tiếp tục lưu chi tiết sản phẩm
        if (orderId > 0 && cartItems != null) {
            for (Map<String, Object> item : cartItems) {
                try {
                    int productId = Integer.parseInt(item.get("id").toString());
                    String productName = item.get("ten_sp").toString();
                    double price = Double.parseDouble(item.get("gia").toString());
                    int quantity = Integer.parseInt(item.get("so_luong").toString());

                    // Gọi DAO để lưu từng dòng vào bảng `order_details`
                    orderDAO.insertOrderDetail(orderId, productId, productName, price, quantity);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }

        return orderId; // Trả về mã đơn hàng (để Controller chuyển hướng hoặc báo thành công)
    }

    // ============================================================
    // PHẦN 2: CÁC HÀM QUẢN LÝ (CHO ADMIN)
    // ============================================================

    // 1. Lấy danh sách tất cả đơn hàng (Sắp xếp mới nhất lên đầu)
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY created_at DESC";

        try (Connection conn = new DBContext().getConnection();
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

                // Lấy thông tin thanh toán (COD/Online)
                o.setPaymentMethod(rs.getString("payment_method"));

                o.setStatus(rs.getInt("status"));
                o.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Lấy chi tiết các sản phẩm trong một đơn hàng cụ thể
    public List<OrderDetail> getOrderDetails(int orderId) {
        List<OrderDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM order_details WHERE order_id = ?";

        try (Connection conn = new DBContext().getConnection();
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
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. Cập nhật trạng thái đơn hàng (Duyệt đơn, Hủy đơn, Giao hàng)
    public void updateStatus(int orderId, int status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, status);
            ps.setInt(2, orderId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}