package controller;

import model.User;
import services.CartServices;
import services.OrderServices;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

// Đây là đường dẫn mà Form bên trang thanh toán đang gọi tới
@WebServlet("/PlaceOrder")
public class PlaceOrderController extends HttpServlet {

    private OrderServices orderService = new OrderServices();
    private CartServices cartService = new CartServices();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 1. Lấy dữ liệu từ form
        String hoTen = request.getParameter("fullname");
        String sdt = request.getParameter("phone");
        String diaChi = request.getParameter("address");
        String ghiChu = request.getParameter("note");
        String totalStr = request.getParameter("totalAmount");
        double tongTien = (totalStr != null) ? Double.parseDouble(totalStr) : 0;

        // 2. Lấy thông tin User và Giỏ hàng
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        int userId = (user != null) ? user.getId() : 0;
        String sessionId = session.getId();
        List<Map<String, Object>> cartItems = cartService.getCartDetails(sessionId);

        // 3. Lưu đơn hàng vào Database
        int orderId = orderService.createOrder(userId, hoTen, sdt, diaChi, ghiChu, tongTien, cartItems);

        if (orderId > 0) {
            // Lưu xong thì xóa giỏ hàng cũ đi
            // (Anh tự thêm hàm clearCart vào CartServices sau nhé, hoặc tạm thời để đó)

            // 4. CHUYỂN HƯỚNG SANG TRANG PAYPAL
            // PayPal tính bằng USD, mình tạm chia 25000 để đổi ra USD nhé
            double totalUSD = tongTien / 25000;

            request.setAttribute("orderId", orderId);
            request.setAttribute("totalUSD", String.format("%.2f", totalUSD)); // Làm tròn 2 số lẻ

            request.getRequestDispatcher("/view/page_paypal.jsp").forward(request, response);
        } else {
            response.sendRedirect("Cart"); // Lỗi thì quay về giỏ
        }
    }
}