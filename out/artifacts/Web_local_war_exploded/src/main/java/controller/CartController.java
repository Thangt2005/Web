package controller;

import services.CartServices;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet(name = "CartController", value = "/Cart")
public class CartController extends HttpServlet {
    // Sửa tên Class Service cho khớp với file CartServices.java
    private CartServices cartService = new CartServices();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String spId = request.getParameter("id");
        String sessionId = request.getSession().getId();

        if (spId != null) {
            // Gọi đúng tên hàm addToCart
            cartService.addToCart(sessionId, Integer.parseInt(spId));
            response.sendRedirect("Cart");
            return;
        }

        // Gọi đúng tên hàm getCartDetails
        List<Map<String, Object>> cartItems = cartService.getCartDetails(sessionId);
        double total = 0;
        for (Map<String, Object> item : cartItems) {
            total += (double) item.get("tam_tinh");
        }

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("totalPrice", total);
        request.getRequestDispatcher("view/page_ThemVaoGiohang.jsp").forward(request, response);
    }
}