package services;

import model.Review;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewService {
    private final String url = "jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8";
    private final String user = "root";
    private final String pass = "";

    // 1. Thêm bình luận mới
    public boolean addReview(Review review) {
        String sql = "INSERT INTO reviews (user_id, product_id, category, rating, content, created_at) VALUES (?, ?, ?, ?, ?, NOW())";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, review.getUserId());
            ps.setInt(2, review.getProductId());
            ps.setString(3, review.getCategory());
            ps.setInt(4, review.getRating());
            ps.setString(5, review.getContent());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 2. Lấy danh sách bình luận của 1 sản phẩm (Kèm tên người dùng)
    public List<Review> getReviewsByProduct(int productId, String category) {
        List<Review> list = new ArrayList<>();
        // Join với bảng login để lấy fullname người bình luận
        String sql = "SELECT r.*, u.fullname FROM reviews r JOIN login u ON r.user_id = u.id " +
                "WHERE r.product_id = ? AND r.category = ? ORDER BY r.created_at DESC";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setString(2, category);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Review r = new Review();
                r.setId(rs.getInt("id"));
                r.setUserId(rs.getInt("user_id"));
                r.setProductId(rs.getInt("product_id"));
                r.setCategory(rs.getString("category"));
                r.setRating(rs.getInt("rating"));
                r.setContent(rs.getString("content"));
                r.setCreatedAt(rs.getTimestamp("created_at"));
                r.setUserFullname(rs.getString("fullname")); // Lấy tên hiển thị
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. Tính điểm trung bình sao (Ví dụ: 4.5)
    public double getAverageRating(int productId, String category) {
        String sql = "SELECT AVG(rating) FROM reviews WHERE product_id = ? AND category = ?";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setString(2, category);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble(1); // Trả về số trung bình (vd: 4.2)
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }
}