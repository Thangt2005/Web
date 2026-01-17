package controller;

import model.User;
import services.CartServices;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CheckoutControllerNew", value = "/ThanhToan")
public class CheckoutController extends HttpServlet {

    private CartServices cartService = new CartServices();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Lấy thông tin định danh từ Session
        HttpSession session = request.getSession();
        String sessionId = session.getId();

        // Lấy userId từ đối tượng User đã lưu khi đăng nhập Facebook/Hệ thống
        User user = (User) session.getAttribute("user");
        Object userId = (user != null) ? user.getId() : null;

        // 2. CẬP NHẬT: Gọi hàm lấy giỏ hàng với 2 tham số (sessionId và userId)
        // Điều này giúp lấy đúng sản phẩm đã lưu bền vững trong DB
        List<Map<String, Object>> cartItems = cartService.getCartDetails(sessionId);

        // 3. Kiểm tra giỏ hàng trống
        if (cartItems == null || cartItems.isEmpty()) {
            response.sendRedirect("Cart"); // Không có hàng thì không cho thanh toán
            return;
        }

        // 4. Đẩy dữ liệu sang trang JSP thanh toán
        request.setAttribute("cartItems", cartItems);
        request.getRequestDispatcher("/view/page_thanhToan.jsp").forward(request, response);
    }
}