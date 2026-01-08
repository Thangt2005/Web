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

        // 1. Lấy Session ID trước khi làm bất cứ việc gì khác
        String sessionId = request.getSession().getId();

        // 2. Lấy các tham số từ URL
        String spId = request.getParameter("id");
        String category = request.getParameter("category");
        String action = request.getParameter("action");

        if (spId != null) {
            try {
                int id = Integer.parseInt(spId);

                // 3. Phân loại hành động (Check action trước khi gọi service)
                if ("delete".equals(action)) {
                    cartService.removeProduct(sessionId, id);
                }
                else if ("decrease".equals(action)) {
                    cartService.decreaseQuantity(sessionId, id);
                }
                else {
                    // Mặc định là Thêm/Tăng (nút + hoặc nút Thêm vào giỏ)
                    // Luôn truyền đủ 3 tham số: sessionId, id, category
                    cartService.addToCart(sessionId, id, category);
                }

                // 4. Redirect để sạch URL
                response.sendRedirect("Cart");
                return;
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // 5. HIỂN THỊ GIỎ HÀNG
        List<Map<String, Object>> cartItems = cartService.getCartDetails(sessionId);
        request.setAttribute("cartItems", cartItems);
        request.getRequestDispatcher("/view/page_ThemVaoGiohang.jsp").forward(request, response);
    }
}