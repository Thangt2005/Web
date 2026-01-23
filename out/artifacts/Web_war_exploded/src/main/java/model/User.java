package model;

import java.io.Serializable;

public class User implements Serializable {
    private int id;
    private String username;
    private String password;
    private String fullname;
    private String email;

    // --- BỔ SUNG 2 TRƯỜNG NÀY ĐỂ TRANG THANH TOÁN KHÔNG LỖI ---
    private String phone;
    private String address;
    // -----------------------------------------------------------

    private int role; // 0: User, 1: Admin

    // 1. Constructor rỗng
    public User() {
    }

    // 2. Constructor đầy đủ (Cập nhật thêm phone, address)
    public User(int id, String username, String password, String fullname, String email, String phone, String address, int role) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.fullname = fullname;
        this.email = email;
        this.phone = phone;
        this.address = address;
        this.role = role;
    }

    // Constructor rút gọn (Giữ lại để tương thích code cũ nếu cần)
    public User(int id, String username, String password, String fullname, String email, int role) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.fullname = fullname;
        this.email = email;
        this.role = role;
    }

    // --- GETTER & SETTER ---

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getFullname() { return fullname; }
    public void setFullname(String fullname) { this.fullname = fullname; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    // --- MỚI THÊM: GETTER & SETTER CHO PHONE, ADDRESS ---
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    // ----------------------------------------------------

    public int getRole() { return role; }
    public void setRole(int role) { this.role = role; }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", fullname='" + fullname + '\'' +
                ", phone='" + phone + '\'' +
                ", role=" + role +
                '}';
    }
}