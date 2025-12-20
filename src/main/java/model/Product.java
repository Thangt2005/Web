package model;

public class Product {
    private int id;
    private String tenSp;
    private String hinhAnh;
    private double gia;
    private int giamGia;

    public Product() {}

    public Product(int id, String tenSp, String hinhAnh, double gia, int giamGia) {
        this.id = id;
        this.tenSp = tenSp;
        this.hinhAnh = hinhAnh;
        this.gia = gia;
        this.giamGia = giamGia;
    }

    // Getter & Setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTenSp() { return tenSp; }
    public void setTenSp(String tenSp) { this.tenSp = tenSp; }
    public String getHinhAnh() { return hinhAnh; }
    public void setHinhAnh(String hinhAnh) { this.hinhAnh = hinhAnh; }
    public double getGia() { return gia; }
    public void setGia(double gia) { this.gia = gia; }
    public int getGiamGia() { return giamGia; }
    public void setGiamGia(int giamGia) { this.giamGia = giamGia; }
}