package controller;

import services.CartServices;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CheckoutController", value = "/Checkout")
public class ThanhtoanController extends HttpServlet {
    private CartServices cartService = new CartServices();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Lấy Token từ Cookie thay vì Session
        String cartToken = getCartToken(request);

        if (cartToken == null) {
            response.sendRedirect("Cart"); // Quay lại giỏ hàng nếu chưa có token
            return;
        }

        // 2. Lấy dữ liệu từ Service bằng cartToken
        List<Map<String, Object>> cartItems = cartService.getCartDetails(cartToken);

        // --- RÀNG BUỘC: PHẢI CÓ SẢN PHẨM MỚI CHO THANH TOÁN ---
        if (cartItems == null || cartItems.isEmpty()) {
            response.sendRedirect("Cart?error=empty");
            return;
        }

        double tongTien = 0;
        for (Map<String, Object> item : cartItems) {
            tongTien += (double) item.get("tam_tinh");
        }

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("tongTien", tongTien);
        request.getRequestDispatcher("view/page_thanhToan.jsp").forward(request, response);
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