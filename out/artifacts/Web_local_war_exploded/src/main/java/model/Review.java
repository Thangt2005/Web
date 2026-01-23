package model;

import java.sql.Timestamp;

public class Review {
    private int id;
    private int userId;
    private int productId;
    private String category;
    private int rating;
    private String content;
    private Timestamp createdAt;

    // Thuộc tính phụ để hiển thị tên người bình luận (lấy từ bảng login)
    private String userFullname;

    public Review() {
    }

    public Review(int id, int userId, int productId, String category, int rating, String content, Timestamp createdAt, String userFullname) {
        this.id = id;
        this.userId = userId;
        this.productId = productId;
        this.category = category;
        this.rating = rating;
        this.content = content;
        this.createdAt = createdAt;
        this.userFullname = userFullname;
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

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getUserFullname() {
        return userFullname;
    }

    public void setUserFullname(String userFullname) {
        this.userFullname = userFullname;
    }
}