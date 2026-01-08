package controller;

import services.OrderServices;
import services.CartServices;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/PaymentSuccess")
public class PaymentSuccessController extends HttpServlet {

    private OrderServices orderService = new OrderServices();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. Lấy ID đơn hàng từ tham số truyền về
        String orderIdStr = request.getParameter("orderId");

        if (orderIdStr != null) {
            int orderId = Integer.parseInt(orderIdStr);

            // 2. Cập nhật trạng thái đơn hàng thành "Đã thanh toán"
            orderService.updateOrderStatus(orderId, "Đã thanh toán (PayPal)");

            // 3. Xóa giỏ hàng hiện tại (Vì đã mua xong rồi)
            // Cách nhanh nhất là hủy session cũ hoặc xóa attribute giỏ hàng
            // Ở đây em ví dụ là xóa session giỏ hàng trong Database (nếu anh có hàm đó),
            // hoặc đơn giản là xóa Session Cart trên Java:
            request.getSession().removeAttribute("cart");

            // Nếu anh muốn xóa kỹ trong DB thì gọi hàm: cartService.removeCartBySession(sessionId);
        }

        // 4. Chuyển hướng về trang chủ và báo thành công
        response.sendRedirect("Home?status=success_payment");
    }
}