package controller;

import services.CartServices;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/Cart")
public class CartController extends HttpServlet {

    private CartServices cartService = new CartServices();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String spId = request.getParameter("id");
        String sessionId = request.getSession().getId();

        // ====== THÊM SẢN PHẨM ======
        if (spId != null) {
            cartService.addToCart(sessionId, Integer.parseInt(spId));
            response.sendRedirect("Cart");
            return;
        }

        // ====== HIỂN THỊ GIỎ ======
        List<Map<String, Object>> cartItems = cartService.getCartDetails(sessionId);

        request.setAttribute("cartItems", cartItems);
        request.getRequestDispatcher("/view/page_ThemVaoGiohang.jsp")
                .forward(request, response);
    }
}
