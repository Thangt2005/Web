package controller;

import model.User;
import services.CartServices;
import services.OrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CheckoutControllerNew", value = "/ThanhToan")
public class CheckoutController extends HttpServlet {

    private CartServices cartService = new CartServices();
    private OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String sessionId = session.getId();
        List<Map<String, Object>> cartItems = cartService.getCartDetails(sessionId);

        if (cartItems == null || cartItems.isEmpty()) {
            response.sendRedirect("Cart");
            return;
        }

        // Tính lại tổng tiền để hiển thị (nếu cần)
        double totalMoney = 0;
        for (Map<String, Object> item : cartItems) {
            double gia = Double.parseDouble(item.get("gia").toString());
            int soLuong = Integer.parseInt(item.get("so_luong").toString());
            totalMoney += (gia * soLuong);
        }

        request.setAttribute("totalMoney", totalMoney);
        request.setAttribute("cartItems", cartItems);
        request.getRequestDispatcher("/view/page_thanhToan.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 1. Lấy dữ liệu từ Form
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // Lấy phương thức thanh toán (COD hoặc PAYPAL)
        String paymentMethod = request.getParameter("paymentMethod");
        if(paymentMethod == null) paymentMethod = "COD"; // Mặc định là COD cho chắc ăn

        // 2. Lấy thông tin User và Giỏ hàng
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        int userId = (user != null) ? user.getId() : 0;

        List<Map<String, Object>> cartItems = cartService.getCartDetails(session.getId());
        if (cartItems == null || cartItems.isEmpty()) {
            response.sendRedirect("Cart");
            return;
        }

        // 3. GỌI SERVICE (QUAN TRỌNG: PHẢI TRUYỀN THÊM paymentMethod)
        // --- SỬA DÒNG NÀY ---
        int orderId = orderService.createOrder(userId, fullname, phone, address, cartItems, paymentMethod);

        if (orderId > 0) {
            // --- Đặt hàng thành công ---

            if ("PAYPAL".equals(paymentMethod)) {
                // Nếu chọn PayPal -> Chuyển sang trang thanh toán, chưa xóa giỏ hàng vội
                response.sendRedirect("AuthorizePayment?orderId=" + orderId);
            } else {
                // Nếu là COD -> Xóa giỏ hàng ngay và báo thành công
                cartService.removeCart(session.getId());
                response.sendRedirect("OrderSuccess?id=" + orderId);
            }

        } else {
            // --- Thất bại ---
            request.setAttribute("error", "Hệ thống đang bận, vui lòng thử lại sau!");
            request.getRequestDispatcher("/view/page_thanhToan.jsp").forward(request, response);
        }
    }
}