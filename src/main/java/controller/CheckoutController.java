package controller;

import model.User;
import services.CartServices;
import services.OrderService; // Nhớ import cái này
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CheckoutControllerNew", value = "/ThanhToan")
public class CheckoutController extends HttpServlet {

    private CartServices cartService = new CartServices();
    private OrderService orderService = new OrderService(); // Gọi Service Đơn hàng

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // ... (Code doGet cũ của anh giữ nguyên để hiển thị form) ...
        HttpSession session = request.getSession();
        String sessionId = session.getId();
        List<Map<String, Object>> cartItems = cartService.getCartDetails(sessionId);

        if (cartItems == null || cartItems.isEmpty()) {
            response.sendRedirect("Cart");
            return;
        }
        request.setAttribute("cartItems", cartItems);
        request.getRequestDispatcher("/view/page_thanhToan.jsp").forward(request, response);
    }

    // --- ĐÂY LÀ PHẦN ANH ĐANG THIẾU ---
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 1. Lấy thông tin người nhận từ Form
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String paymentMethod = request.getParameter("paymentMethod"); // COD hoặc PayPal

        // 2. Lấy thông tin giỏ hàng & User
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        int userId = (user != null) ? user.getId() : 0; // Nếu chưa login thì để 0 hoặc bắt login

        // Lấy lại giỏ hàng để lưu vào DB (tránh việc user hack HTML gửi giá sai)
        List<Map<String, Object>> cartItems = cartService.getCartDetails(session.getId());

        if (cartItems == null || cartItems.isEmpty()) {
            response.sendRedirect("Cart");
            return;
        }

        // 3. GỌI SERVICE ĐỂ LƯU VÀO DATABASE
        // Hàm này sẽ trả về ID đơn hàng (Ví dụ: 7)
        int orderId = orderService.createOrder(userId, fullname, phone, address, cartItems);

        if (orderId > 0) {
            // --- Lưu thành công ---

            // Xóa giỏ hàng sau khi đặt (Tùy logic anh, thường PayPal xong mới xóa)
            // cartService.clearCart(session.getId());

            if ("PAYPAL".equals(paymentMethod)) {
                // 4A. Nếu chọn PayPal -> Chuyển sang trang xử lý PayPal
                // Gửi kèm orderId thật vừa tạo được
                response.sendRedirect("AuthorizePayment?orderId=" + orderId);
            } else {
                // 4B. Nếu chọn COD (Thanh toán khi nhận hàng) -> Báo thành công luôn
                // Xóa giỏ hàng ở đây
                cartService.removeCart(session.getId());
                response.sendRedirect("OrderSuccess?id=" + orderId);
            }

        } else {
            // Lưu thất bại
            request.setAttribute("error", "Đặt hàng thất bại, vui lòng thử lại!");
            request.getRequestDispatcher("/view/page_thanhToan.jsp").forward(request, response);
        }
    }
}