package model;

import java.io.Serializable;

public class User implements Serializable {
    private int id;
    private String username;
    private String password;
    private String fullname;
    private String email;
    private int role; // Quan trọng: Biến này dùng để phân quyền (0: User, 1: Admin)

    // 1. Constructor rỗng (Bắt buộc phải có để dùng trong UserService)
    public User() {
    }

    // 2. Constructor đầy đủ
    public User(int id, String username, String password, String fullname, String email, int role) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.fullname = fullname;
        this.email = email;
        this.role = role;
    }

    // Constructor rút gọn (nếu code cũ của anh có dùng thì giữ lại cho đỡ lỗi)
    public User(int id, String username, String password, String fullname, String email) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.fullname = fullname;
        this.email = email;
    }

    // --- CÁC HÀM GETTER VÀ SETTER ---

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    // --- QUAN TRỌNG NHẤT: Hàm getRole và setRole ---
    public int getRole() {
        return role;
    }

    public void setRole(int role) {
        this.role = role;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", fullname='" + fullname + '\'' +
                ", role=" + role +
                '}';
    }
}