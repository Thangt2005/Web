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

        // 1. Lấy Session và các định danh
        HttpSession session = request.getSession();
        String sessionId = session.getId();

        // Lấy userId (Giả sử bạn lưu ID người dùng vào session khi đăng nhập thành công)
        // Nếu là khách chưa đăng nhập, userId sẽ là null
        Object userId = session.getAttribute("userId");

        // 2. Lấy các tham số từ URL
        String spId = request.getParameter("id");
        String category = request.getParameter("category");
        String action = request.getParameter("action");

        if (spId != null) {
            try {
                int id = Integer.parseInt(spId);

                // 3. Gọi Service với đầy đủ sessionId và userId để lưu trữ bền vững
                if ("delete".equals(action)) {
                    cartService.removeProduct(sessionId, userId, id, category);
                }
                else if ("decrease".equals(action)) {
                    cartService.decreaseQuantity(sessionId, userId, id, category);
                }
                else {
                    // Mặc định là Thêm/Tăng
                    cartService.addToCart(sessionId, userId, id, category);
                }

                // 4. Redirect để sạch URL
                response.sendRedirect("Cart");
                return;
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // 5. HIỂN THỊ GIỎ HÀNG (Truyền cả 2 định danh để lấy đúng dữ liệu)
        List<Map<String, Object>> cartItems = cartService.getCartDetails(sessionId, userId);
        request.setAttribute("cartItems", cartItems);
        request.getRequestDispatcher("/view/page_ThemVaoGiohang.jsp").forward(request, response);
    }
}