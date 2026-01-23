package model;
import java.sql.Timestamp;

public class Order {
    private int id;
    private int userId;
    private String fullname;
    private String phone;
    private String address;
    private double totalMoney;

    // THÊM BIẾN NÀY ĐỂ LƯU "COD" HOẶC "PAYPAL"
    private String paymentMethod;

    private int status; // 1: Chờ xử lý, 2: Đang giao, 3: Hoàn thành, 4: Hủy
    private Timestamp createdAt;

    public Order() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public double getTotalMoney() {
        return totalMoney;
    }

    public void setTotalMoney(double totalMoney) {
        this.totalMoney = totalMoney;
    }

    // --- MỚI THÊM: GETTER & SETTER CHO PAYMENT METHOD ---
    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
    // ----------------------------------------------------

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    // Hàm hỗ trợ hiển thị tên trạng thái cho đẹp
    public String getStatusName() {
        switch (status) {
            case 1: return "Chờ xác nhận";
            case 2: return "Đang giao hàng";
            case 3: return "Thành công";
            case 4: return "Đã hủy";
            default: return "Không xác định";
        }
    }
}