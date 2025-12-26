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

        // 1. Lấy các tham số từ URL
        String action = request.getParameter("action"); // Ví dụ: "add", "delete"
        String idStr = request.getParameter("id");      // ID sản phẩm hoặc ID dòng giỏ hàng
        String sessionId = request.getSession().getId(); // Session của người dùng

        try {
            // 2. XỬ LÝ CÁC HÀNH ĐỘNG (Thêm/Xóa)
            if (action != null && idStr != null) {
                int id = Integer.parseInt(idStr);

                // Trường hợp: Thêm vào giỏ
                if ("add".equals(action)) {
                    cartService.addToCart(sessionId, id);
                }
                // Trường hợp: Xóa khỏi giỏ
                else if ("delete".equals(action)) {
                    cartService.removeFromCart(id);
                }

                // Sau khi xử lý xong thì reload lại trang để cập nhật số liệu
                // và tránh việc user F5 lại bị gửi lặp yêu cầu
                response.sendRedirect("Cart");
                return;
            }

            // Hỗ trợ link cũ (nếu Home.jsp chỉ gửi id mà không có action) -> Mặc định là Thêm
            if (idStr != null && action == null) {
                cartService.addToCart(sessionId, Integer.parseInt(idStr));
                response.sendRedirect("Cart");
                return;
            }

            // 3. HIỂN THỊ GIỎ HÀNG (Mặc định khi vào trang Cart)
            List<Map<String, Object>> cartItems = cartService.getCartDetails(sessionId);

            request.setAttribute("cartItems", cartItems);
            request.getRequestDispatcher("/view/page_ThemVaoGiohang.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            // Nếu ID không phải số, chuyển hướng về trang chủ hoặc báo lỗi
            System.out.println("Lỗi format ID: " + e.getMessage());
            response.sendRedirect("Home");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}