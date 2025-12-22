package model;

public class Product {
    private int id;
    private String tenSp;
    private String hinhAnh;
    private double gia;
    private int giamGia;
    private String category; // Dùng để lưu tên bảng (source table) từ SQL UNION ALL

    public Product() {
    }

    public Product(int id, String tenSp, String hinhAnh, double gia, int giamGia) {
        this.id = id;
        this.tenSp = tenSp;
        this.hinhAnh = hinhAnh;
        this.gia = gia;
        this.giamGia = giamGia;
    }

    public Product(int id, String tenSp, String hinhAnh, double gia, int giamGia, String category) {
        this.id = id;
        this.tenSp = tenSp;
        this.hinhAnh = hinhAnh;
        this.gia = gia;
        this.giamGia = giamGia;
        this.category = category;
    }

    // --- 4. CÁC HÀM GETTER VÀ SETTER (Cực kỳ quan trọng) ---

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTenSp() {
        return tenSp;
    }

    public void setTenSp(String tenSp) {
        this.tenSp = tenSp;
    }

    public String getHinhAnh() {
        return hinhAnh;
    }

    public void setHinhAnh(String hinhAnh) {
        this.hinhAnh = hinhAnh;
    }

    public double getGia() {
        return gia;
    }

    public void setGia(double gia) {
        this.gia = gia;
    }

    public int getGiamGia() {
        return giamGia;
    }

    public void setGiamGia(int giamGia) {
        this.giamGia = giamGia;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }
}