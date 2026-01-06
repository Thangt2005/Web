package services;

import java.sql.*;
import java.util.List;
import java.util.Map;

public class OrderService {
    private final String url = "jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8";
    private final String user = "root";
    private final String pass = "";

    public boolean saveOrder(String sessionId, String name, String phone, String address, String note, double total, List<Map<String, Object>> items) {
        String sqlOrder = "INSERT INTO donhang (session_id, ho_ten, sdt, dia_chi, ghi_chu, tong_tien) VALUES (?, ?, ?, ?, ?, ?)";
        String sqlDetail = "INSERT INTO donhang_chitiet (donhang_id, ten_sp, so_luong, gia) VALUES (?, ?, ?, ?)";

        try (Connection conn = DriverManager.getConnection(url, user, pass)) {
            conn.setAutoCommit(false); // Bắt đầu Transaction

            try (PreparedStatement psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS)) {
                psOrder.setString(1, sessionId);
                psOrder.setString(2, name);
                psOrder.setString(3, phone);
                psOrder.setString(4, address);
                psOrder.setString(5, note);
                psOrder.setDouble(6, total);
                psOrder.executeUpdate();

                ResultSet rs = psOrder.getGeneratedKeys();
                if (rs.next()) {
                    int orderId = rs.getInt(1);
                    try (PreparedStatement psDetail = conn.prepareStatement(sqlDetail)) {
                        for (Map<String, Object> item : items) {
                            psDetail.setInt(1, orderId);
                            psDetail.setString(2, (String) item.get("ten_sp"));
                            psDetail.setInt(3, (int) item.get("so_luong"));
                            psDetail.setDouble(4, (double) item.get("gia"));
                            psDetail.addBatch();
                        }
                        psDetail.executeBatch();
                    }
                }
                conn.commit(); // Hoàn tất lưu
                return true;
            } catch (Exception e) {
                conn.rollback(); // Lỗi thì hoàn tác
                e.printStackTrace();
            }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
}