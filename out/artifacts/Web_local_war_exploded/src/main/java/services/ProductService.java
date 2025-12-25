package services;

import model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductService {
    // Database configuration
    private String url = "jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8";
    private String user = "root";
    private String pass = "";

    // 1. HÀM PHỤ: Chuyển dữ liệu từ Database thành đối tượng Java (Dùng chung để tránh dư thừa)
    private Product mapProduct(ResultSet rs, String tableName) throws SQLException {
        Product p = new Product(
                rs.getInt("id"),
                rs.getString("ten_sp"),
                rs.getString("hinh_anh"),
                rs.getDouble("gia"),
                rs.getInt("giam_gia")
        );
        p.setCategory(tableName); // Lưu lại tên bảng để làm link chi tiết
        return p;
    }

    // 2. HÀM LẤY SẢN PHẨM THEO BẢNG: Thay thế cho 12 hàm riêng lẻ trước đây
    public List<Product> getProductsByTable(String tableName, String search) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM " + tableName;
        if (search != null && !search.trim().isEmpty()) {
            sql += " WHERE ten_sp LIKE ?";
        }

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (search != null && !search.trim().isEmpty()) {
                ps.setString(1, "%" + search.trim() + "%");
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapProduct(rs, tableName));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 3. HÀM TÌM KIẾM TOÀN TRANG: Quét qua 12 bảng không dùng UNION ALL
    public List<Product> searchEverywhere(String keyword) {
        List<Product> allResults = new ArrayList<>();
        String[] tables = {
                "home_sanpham", "combo_sanpham", "toilet_sanpham", "lavabo_sanpham",
                "voirua_sanpham", "bontam_sanpham", "phukien_sanpham", "chauruachen_sanpham",
                "voisentam_sanpham", "voisen_sanpham", "bontieunam_sanpham", "tulavabo_sanpham"
        };

        try (Connection conn = DriverManager.getConnection(url, user, pass)) {
            String p = "%" + (keyword == null ? "" : keyword.trim()) + "%";

            for (String tableName : tables) {
                String sql = "SELECT * FROM " + tableName + " WHERE ten_sp LIKE ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, p);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            allResults.add(mapProduct(rs, tableName));
                        }
                    }
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return allResults;
    }

    // 4. CÁC HÀM THỐNG KÊ (Cho trang Admin Dashboard)
    public int getTotalProducts() {
        int total = 0;
        String sql = "SELECT (SELECT COUNT(*) FROM bontam_sanpham) + (SELECT COUNT(*) FROM bontieunam_sanpham) + " +
                "(SELECT COUNT(*) FROM chauruachen_sanpham) + (SELECT COUNT(*) FROM combo_sanpham) + " +
                "(SELECT COUNT(*) FROM home_sanpham) + (SELECT COUNT(*) FROM lavabo_sanpham) + " +
                "(SELECT COUNT(*) FROM phukien_sanpham) + (SELECT COUNT(*) FROM toilet_sanpham) + " +
                "(SELECT COUNT(*) FROM tulavabo_sanpham) + (SELECT COUNT(*) FROM voirua_sanpham) + " +
                "(SELECT COUNT(*) FROM voisentam_sanpham) + (SELECT COUNT(*) FROM voisen_sanpham) as total";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) total = rs.getInt("total");
        } catch (Exception e) { e.printStackTrace(); }
        return total;
    }

    public double getTotalRevenue() {
        double total = 0;
        String sql = "SELECT SUM(tong_tien) as revenue FROM orders WHERE trang_thai = 'Completed'";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) total = rs.getDouble("revenue");
        } catch (Exception e) { e.printStackTrace(); }
        return total;
    }

    // 5. CÁC HÀM QUẢN LÝ (CRUD)
    public boolean addProduct(String tableName, String name, String img, String price, String discount) {
        String sql = "INSERT INTO " + tableName + " (ten_sp, hinh_anh, gia, giam_gia) VALUES (?, ?, ?, ?)";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, img);
            ps.setDouble(3, Double.parseDouble(price));
            ps.setInt(4, Integer.parseInt(discount));
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean deleteProduct(String tableName, int id) {
        String sql = "DELETE FROM " + tableName + " WHERE id = ?";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean updateProduct(String tableName, int id, String name, String img, double price, int discount) {
        String sql = "UPDATE " + tableName + " SET ten_sp = ?, hinh_anh = ?, gia = ?, giam_gia = ? WHERE id = ?";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, img);
            ps.setDouble(3, price);
            ps.setInt(4, discount);
            ps.setInt(5, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public Product getProductById(String tableName, int id) {
        String sql = "SELECT * FROM " + tableName + " WHERE id = ?";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapProduct(rs, tableName);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }
    //hàm lấy gợi ý cho thanh tìm kiếm
    public List<Product> getSearchSuggestions(String keyword) {
        List<Product> suggestions = new ArrayList<>();
        String[] tables = {
                "home_sanpham", "combo_sanpham", "toilet_sanpham", "lavabo_sanpham",
                "voirua_sanpham", "bontam_sanpham", "phukien_sanpham", "chauruachen_sanpham",
                "voisentam_sanpham", "voisen_sanpham", "bontieunam_sanpham", "tulavabo_sanpham"
        };

        try (Connection conn = DriverManager.getConnection(url, user, pass)) {
            String p = "%" + (keyword == null ? "" : keyword.trim()) + "%";
            for (String tableName : tables) {
                // Chỉ lấy 3 sản phẩm mỗi bảng để gợi ý cho nhanh, tránh lag
                String sql = "SELECT * FROM " + tableName + " WHERE ten_sp LIKE ? LIMIT 3";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, p);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            suggestions.add(mapProduct(rs, tableName));
                        }
                    }
                }
                // Nếu đã đủ 10 gợi ý thì dừng lại cho nhanh
                if (suggestions.size() >= 10) break;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return suggestions;
    }
}