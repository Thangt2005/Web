package model;

import java.time.LocalDateTime;

public class TokenForgetPassword {
    private int id, userId;
    private boolean isUsed;
    private String token;
    private LocalDateTime expiryTime;

    // 1. Constructor không đối số (No-argument Constructor)
    public TokenForgetPassword() {
    }

    // 2. Constructor đầy đủ đối số (All-arguments Constructor)
    public TokenForgetPassword(int id, int userId, boolean isUsed, String token, LocalDateTime expiryTime) {
        this.id = id;
        this.userId = userId;
        this.isUsed = isUsed;
        this.token = token;
        this.expiryTime = expiryTime;
    }

    // 3. Getter và Setter
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

    public boolean isIsUsed() { // Lưu ý: Với kiểu boolean, getter thường bắt đầu bằng 'is'
        return isUsed;
    }

    public void setIsUsed(boolean isUsed) {
        this.isUsed = isUsed;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public LocalDateTime getExpiryTime() {
        return expiryTime;
    }

    public void setExpiryTime(LocalDateTime expiryTime) {
        this.expiryTime = expiryTime;
    }

    // 4. Override toString (Tùy chọn - giúp bạn debug dễ dàng hơn khi in đối tượng)
    @Override
    public String toString() {
        return "TokenForgetPassword{" +
                "id=" + id +
                ", userId=" + userId +
                ", isUsed=" + isUsed +
                ", token='" + token + '\'' +
                ", expiryTime=" + expiryTime +
                '}';
    }
}