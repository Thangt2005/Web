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

    // Sử dụng CartServices để lấy dữ liệu giỏ hàng
    private CartServices cartService = new CartServices();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. Lấy Session ID hiện tại
        String sessionId = request.getSession().getId();

        // 2. Lấy danh sách sản phẩm trong giỏ hàng từ Database
        List<Map<String, Object>> cartItems = cartService.getCartDetails(sessionId);

        // 3. Tính tổng tiền lại (để hiển thị con số cuối cùng)
        double tongTien = 0;
        if (cartItems != null) {
            for (Map<String, Object> item : cartItems) {
                double tamTinh = (double) item.get("tam_tinh"); // Lấy từ query SQL đã tính sẵn hoặc tự tính
                tongTien += tamTinh;
            }
        }

        // 4. Đẩy dữ liệu sang trang JSP
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("tongTien", tongTien);

        // 5. Chuyển hướng
        request.getRequestDispatcher("view/page_thanhToan.jsp").forward(request, response);
    }
}