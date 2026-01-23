package controller;

import model.Review;
import model.User;
import services.ReviewService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "ReviewController", value = "/Review")
public class ReviewController extends HttpServlet {
    private ReviewService reviewService = new ReviewService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 1. Kiểm tra đăng nhập
        HttpSession session = request.getSession();
        // Anh lưu ý: object trong session tên là "user" (như các file trước anh gửi)
        User user = (User) session.getAttribute("user");

        // Lấy thông tin sản phẩm để nếu lỗi thì redirect về đúng chỗ
        String productIdStr = request.getParameter("productId");
        String category = request.getParameter("category");

        if (user == null) {
            // Chưa đăng nhập -> Chuyển sang trang Login
            response.sendRedirect("Login");
            return;
        }

        // 2. Lấy dữ liệu từ form
        try {
            int productId = Integer.parseInt(productIdStr);
            int rating = Integer.parseInt(request.getParameter("rating"));
            String content = request.getParameter("content");

            // 3. Tạo đối tượng Review và lưu
            Review r = new Review();
            r.setUserId(user.getId());
            r.setProductId(productId);
            r.setCategory(category);
            r.setRating(rating);
            r.setContent(content);

            reviewService.addReview(r);

            // 4. Quay lại trang chi tiết sản phẩm cũ
            // Đường dẫn này phải khớp với cách anh gọi trang chi tiết (ví dụ: ProductDetail?id=1&category=bontam)
            response.sendRedirect("ProductDetail?id=" + productId + "&category=" + category);

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("Home"); // Lỗi dữ liệu thì về trang chủ
        }
    }
}