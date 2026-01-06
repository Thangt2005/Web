package controller;

import services.CartServices;
import services.OrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ProcessOrder", value = "/ProcessOrder")
public class ProcessOrderController extends HttpServlet {
    private CartServices cartService = new CartServices();
    private OrderService orderService = new OrderService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 1. Lấy mã giỏ hàng từ Cookie
        String cartToken = getCartToken(request);
        if (cartToken == null) {
            response.sendRedirect("Cart");
            return;
        }

        // 2. Lấy thông tin từ Form
        String name = request.getParameter("customerName");
        String phone = request.getParameter("customerPhone");
        String address = request.getParameter("customerAddress");
        String note = request.getParameter("note");

        // 3. Kiểm tra lại giỏ hàng một lần nữa (Bảo mật server-side)
        List<Map<String, Object>> items = cartService.getCartDetails(cartToken);
        if (items == null || items.isEmpty()) {
            response.sendRedirect("Cart?error=empty");
            return;
        }

        double total = 0;
        for (Map<String, Object> item : items) {
            total += (double) item.get("tam_tinh");
        }

        // 4. Lưu vào Database (Sử dụng cartToken làm session_id)
        boolean isSaved = orderService.saveOrder(cartToken, name, phone, address, note, total, items);

        if (isSaved) {
            // Đặt hàng xong thì xóa giỏ hàng
            cartService.clearCart(cartToken);
            response.sendRedirect("view/order_success.jsp");
        } else {
            response.getWriter().println("Lỗi hệ thống, không thể lưu đơn hàng!");
        }
    }

    private String getCartToken(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("USER_CART_TOKEN".equals(c.getName())) return c.getValue();
            }
        }
        return null;
    }
}