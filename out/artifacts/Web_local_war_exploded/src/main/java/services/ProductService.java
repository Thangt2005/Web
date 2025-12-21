package services;

import model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductService {
    // Khai báo thông số kết nối Database dùng chung
    private String url = "jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8";
    private String user = "root";
    private String pass = "";

    // --- HÀM 1: LẤY TỔNG SỐ LƯỢNG (Dùng cho Dashboard Admin) ---
    public int getTotalProducts() {
        int total = 0;
        String sql = "SELECT (SELECT COUNT(*) FROM chauruachen_sanpham) + (SELECT COUNT(*) FROM lavabo_sanpham) + " +
                "(SELECT COUNT(*) FROM tulavabo_sanpham) + (SELECT COUNT(*) FROM toilet_sanpham) + " +
                "(SELECT COUNT(*) FROM voisentam_sanpham) + (SELECT COUNT(*) FROM voisen_sanpham) + " +
                "(SELECT COUNT(*) FROM voirua_sanpham) + (SELECT COUNT(*) FROM bontam_sanpham) + " +
                "(SELECT COUNT(*) FROM bontieunam_sanpham) + (SELECT COUNT(*) FROM phukien_sanpham) + " +
                "(SELECT COUNT(*) FROM combo_sanpham) + (SELECT COUNT(*) FROM home_sanpham) as total";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) total = rs.getInt("total");
        } catch (Exception e) { e.printStackTrace(); }
        return total;
    }

    // --- HÀM 2: THÊM SẢN PHẨM MỚI (Sửa lỗi dòng 37 của anh Thắng) ---
    public boolean addProduct(String table, String ten, String anh, String gia, String giamGia) {
        // Câu lệnh SQL động để chèn vào bảng tương ứng
        String sql = "INSERT INTO " + table + " (ten_sp, hinh_anh, gia, giam_gia) VALUES (?, ?, ?, ?)";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, ten);
            ps.setString(2, anh);
            ps.setString(3, gia);
            ps.setString(4, giamGia);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // --- HÀM TRỢ GIÚP LẤY DANH SÁCH (HELPER) ---
    private List<Product> getProductsFromTable(String tableName, String search) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM " + tableName;
        if (search != null && !search.trim().isEmpty()) {
            sql += " WHERE ten_sp LIKE ?";
        }
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, user, pass);
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                if (search != null && !search.trim().isEmpty()) {
                    ps.setString(1, "%" + search.trim() + "%");
                }
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        list.add(new Product(
                                rs.getInt("id"), rs.getString("ten_sp"),
                                rs.getString("hinh_anh"), rs.getDouble("gia"),
                                rs.getInt("giam_gia")
                        ));
                    }
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // --- CÁC HÀM LẤY DANH SÁCH CHO CÁC CONTROLLER KHÁC ---
    public List<Product> getAllProducts(String s) { return getProductsFromTable("home_sanpham", s); }
    public List<Product> getComboProducts(String s) { return getProductsFromTable("combo_sanpham", s); }
    public List<Product> getToiletProducts(String s) { return getProductsFromTable("toilet_sanpham", s); }
    public List<Product> getLavaboProducts(String s) { return getProductsFromTable("lavabo_sanpham", s); }
    public List<Product> getTuLavaboProducts(String s) { return getProductsFromTable("tulavabo_sanpham", s); }
    public List<Product> getVoiSenTamProducts(String s) { return getProductsFromTable("voisentam_sanpham", s); }
    public List<Product> getChauRuaChenProducts(String s) { return getProductsFromTable("chauruachen_sanpham", s); }
    public List<Product> getBonTamProducts(String s) { return getProductsFromTable("bontam_sanpham", s); }
    public List<Product> getVoiRuaProducts(String s) { return getProductsFromTable("voirua_sanpham", s); }
    public List<Product> getBonTieuNamProducts(String s) { return getProductsFromTable("bontieunam_sanpham", s); }
    public List<Product> getPhuKienProducts(String s) { return getProductsFromTable("phukien_sanpham", s); }

    // --- HÀM LẤY CHI TIẾT SẢN PHẨM ---
    public Product getProductById(String table, int id) {
        Product p = null;
        // Sử dụng biến 'table' để câu lệnh SQL tìm đúng bảng
        String sql = "SELECT * FROM " + table + " WHERE id = ?";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    p = new Product(
                            rs.getInt("id"), rs.getString("ten_sp"),
                            rs.getString("hinh_anh"), rs.getDouble("gia"),
                            rs.getInt("giam_gia")
                    );
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return p;
    }
}