package model;

public class User {
    private int id;
    private String username;
    private String password;
    private String fullname;
    private String email;

    // 1. Hàm khởi tạo không tham số (Bắt buộc phải có)
    public User() {
    }

    // 2. Hàm khởi tạo 5 tham số (Để sửa lỗi gạch đỏ ở UserServices)
    public User(int id, String username, String password, String fullname, String email) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.fullname = fullname;
        this.email = email;
    }

    // 3. Các hàm Getter và Setter (Để lấy dữ liệu hiển thị lên JSP)
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
}