package dao;

import model.User;
import context.DBContext;
import java.sql.*;
import java.util.List;
import java.util.Map;

public class OrderDAO {

    public int insertOrder(int userId, String fullname, String phone, String address, double totalMoney, String paymentMethod) {
        String sql = "INSERT INTO orders (user_id, fullname, phone, address, total_money, payment_method, status, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            if (userId > 0) ps.setInt(1, userId);
            else ps.setNull(1, Types.INTEGER);

            ps.setString(2, fullname);
            ps.setString(3, phone);
            ps.setString(4, address);
            ps.setDouble(5, totalMoney);
            ps.setString(6, paymentMethod);
            ps.setInt(7, 1);

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public void insertOrderDetail(int orderId, int productId, String productName, double price, int quantity) {
        String sql = "INSERT INTO order_details (order_id, product_id, product_name, price, quantity) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ps.setInt(2, productId);
            ps.setString(3, productName);
            ps.setDouble(4, price);
            ps.setInt(5, quantity);

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}