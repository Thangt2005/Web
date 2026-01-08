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
        // 1. LẤY TOKEN TỪ COOKIE (Giống CartController)
        String cartToken = null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("USER_CART_TOKEN".equals(c.getName())) {
                    cartToken = c.getValue();
                    break;
                }
            }
        }

        // 2. Nếu không có Token hoặc giỏ trống thì không cho thanh toán
        if (cartToken == null) {
            response.sendRedirect("Cart");
            return;
        }

        List<Map<String, Object>> cartItems = cartService.getCartDetails(cartToken);

        if (cartItems == null || cartItems.isEmpty()) {
            request.setAttribute("cartItems", null);
            request.setAttribute("tongTien", 0.0);
        } else {
            double tongTien = 0;
            for (Map<String, Object> item : cartItems) {
                tongTien += (double) item.get("tam_tinh");
            }
            request.setAttribute("cartItems", cartItems);
            request.setAttribute("tongTien", tongTien);
        }

        request.getRequestDispatcher("view/page_thanhToan.jsp").forward(request, response);
    }
}