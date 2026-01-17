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

        // 1. Lấy Session ID
        String sessionId = request.getSession().getId();

        // 2. Lấy các tham số từ URL
        String spId = request.getParameter("id");
        String category = request.getParameter("category"); // Quan trọng: Phải lấy được category
        String action = request.getParameter("action");

        if (spId != null) {
            try {
                int id = Integer.parseInt(spId);

                // 3. Phân loại hành động và truyền thêm category
                if ("delete".equals(action)) {
                    // CẬP NHẬT: Truyền thêm category để xóa đúng sản phẩm của bảng đó
                    cartService.removeProduct(sessionId, id, category);
                }
                else if ("decrease".equals(action)) {
                    // CẬP NHẬT: Truyền thêm category để giảm đúng sản phẩm của bảng đó
                    cartService.decreaseQuantity(sessionId, id, category);
                }
                else {
                    // Thêm sản phẩm (Truyền 3 tham số như cũ)
                    cartService.addToCart(sessionId, id, category);
                }

                // 4. Redirect để làm sạch URL, tránh việc F5 lại trang sẽ bị thêm sản phẩm lần nữa
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