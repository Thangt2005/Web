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

        // Lấy userId từ đối tượng User đã lưu trong session
        User user = (User) session.getAttribute("user");
        Object userId = (user != null) ? user.getId() : null;
        String sessionId = session.getId();

        // CẬP NHẬT: Truyền cả sessionId và userId để lấy đúng giỏ hàng bền vững
        List<Map<String, Object>> cartItems = cartService.getCartDetails(sessionId, userId);

        if (cartItems == null || cartItems.isEmpty()) {
            response.sendRedirect("Cart"); // Giỏ hàng trống thì không cho đặt
            return;
        }

        // 3. Lưu đơn hàng vào Database
        // Lưu ý: Chuyển userId về int (0 nếu null) để phù hợp với hàm createOrder cũ của bạn
        int orderId = orderService.createOrder((userId != null ? (int)userId : 0), hoTen, sdt, diaChi, ghiChu, tongTien, cartItems);

        if (orderId > 0) {
            // 4. XÓA GIỎ HÀNG SAU KHI ĐẶT HÀNG THÀNH CÔNG
            cartService.clearCart(sessionId, userId);

            // 5. CHUYỂN HƯỚNG SANG TRANG PAYPAL
            double totalUSD = tongTien / 25000;
            request.setAttribute("orderId", orderId);
            request.setAttribute("totalUSD", String.format("%.2f", totalUSD));
            request.getRequestDispatcher("/view/page_paypal.jsp").forward(request, response);
        } else {
            response.sendRedirect("Cart");
        }
    }
}