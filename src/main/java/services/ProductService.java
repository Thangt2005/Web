package services;

import model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductService {
    private String url = "jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8";
    private String user = "root";
    private String pass = "";

    // --- HÀM TRỢ GIÚP DÙNG NỘI BỘ ---
    private List<Product> getDataByTable(String tableName, String search) {
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
                    Product p = new Product(rs.getInt("id"), rs.getString("ten_sp"),
                            rs.getString("hinh_anh"), rs.getDouble("gia"),
                            rs.getInt("giam_gia"));
                    p.setCategory(tableName);
                    list.add(p);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // --- CÁC HÀM RIÊNG BIỆT CHO TỪNG CONTROLLER (Fix lỗi image_056272.jpg) ---
    // Anh gọi hàm nào ở Controller thì em đã tạo đúng tên hàm đó ở đây ạ

    public List<Product> getAllProducts(String s) { return getDataByTable("home_sanpham", s); }
    public List<Product> getComboProducts(String s) { return getDataByTable("combo_sanpham", s); }
    public List<Product> getToiletProducts(String s) { return getDataByTable("toilet_sanpham", s); }
    public List<Product> getLavaboProducts(String s) { return getDataByTable("lavabo_sanpham", s); }
    public List<Product> getVoiRuaProducts(String s) { return getDataByTable("voirua_sanpham", s); }
    public List<Product> getBonTamProducts(String s) { return getDataByTable("bontam_sanpham", s); }
    public List<Product> getTuLavaboProducts(String s) { return getDataByTable("tulavabo_sanpham", s); }
    public List<Product> getVoiSenTamProducts(String s) { return getDataByTable("voisentam_sanpham", s); }
    public List<Product> getVoiSenProducts(String s) { return getDataByTable("voisen_sanpham", s); }
    public List<Product> getChauRuaChenProducts(String s) { return getDataByTable("chauruachen_sanpham", s); }
    public List<Product> getBonTieuNamProducts(String s) { return getDataByTable("bontieunam_sanpham", s); }
    public List<Product> getPhuKienProducts(String s) { return getDataByTable("phukien_sanpham", s); }

    // --- HÀM CHO ADMIN (Fix lỗi image_055df0.jpg - chỉ cần 1 tham số) ---
    public List<Product> getProductsByTable(String tableName) {
        return getDataByTable(tableName, null);
    }

    // --- HÀM TÌM KIẾM TOÀN HỆ THỐNG (Fix lỗi image_056d8e.jpg) ---
    public List<Product> searchAllProducts(String search) {
        List<Product> list = new ArrayList<>();
        String[] tables = {"bontam_sanpham", "bontieunam_sanpham", "chauruachen_sanpham", "combo_sanpham", "home_sanpham", "lavabo_sanpham", "phukien_sanpham", "toilet_sanpham", "tulavabo_sanpham", "voirua_sanpham", "voisentam_sanpham", "voisen_sanpham"};
        StringBuilder sql = new StringBuilder();

        for (int i = 0; i < tables.length; i++) {
            sql.append("SELECT id, ten_sp, hinh_anh, gia, giam_gia, '").append(tables[i]).append("' as table_source FROM ").append(tables[i]);
            if (search != null && !search.trim().isEmpty()) sql.append(" WHERE ten_sp LIKE ?");
            if (i < tables.length - 1) sql.append(" UNION ALL ");
        }

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (search != null && !search.trim().isEmpty()) {
                for (int j = 1; j <= tables.length; j++) ps.setString(j, "%" + search.trim() + "%");
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product(rs.getInt("id"), rs.getString("ten_sp"), rs.getString("hinh_anh"), rs.getDouble("gia"), rs.getInt("giam_gia"));
                    p.setCategory(rs.getString("table_source"));
                    list.add(p);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // --- CÁC HÀM THỐNG KÊ & CRUD KHÁC ---

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

    public boolean addProduct(String t, String n, String a, String g, String gg) {
        String sql = "INSERT INTO " + t + " (ten_sp, hinh_anh, gia, giam_gia) VALUES (?, ?, ?, ?)";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, n); ps.setString(2, a);
            ps.setDouble(3, Double.parseDouble(g)); ps.setInt(4, Integer.parseInt(gg));
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean deleteProduct(String t, int id) {
        String sql = "DELETE FROM " + t + " WHERE id = ?";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id); return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean updateProduct(String t, int id, String n, String a, double g, int gg) {
        String sql = "UPDATE " + t + " SET ten_sp = ?, hinh_anh = ?, gia = ?, giam_gia = ? WHERE id = ?";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, n); ps.setString(2, a); ps.setDouble(3, g); ps.setInt(4, gg); ps.setInt(5, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public Product getProductById(String t, int id) {
        String sql = "SELECT * FROM " + t + " WHERE id = ?";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return new Product(rs.getInt("id"), rs.getString("ten_sp"),
                        rs.getString("hinh_anh"), rs.getDouble("gia"),
                        rs.getInt("giam_gia"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }
}