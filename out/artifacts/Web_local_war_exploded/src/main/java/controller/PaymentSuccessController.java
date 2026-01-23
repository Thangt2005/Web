package controller;

import services.OrderService; // Import đúng file mới (không có chữ s)
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/PaymentSuccess")
public class PaymentSuccessController extends HttpServlet {

    // Sửa: Dùng OrderService (số ít)
    private OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String orderIdStr = request.getParameter("orderId");

            if (orderIdStr != null) {
                int orderId = Integer.parseInt(orderIdStr);

                // Sửa: Hàm updateStatus bây giờ nhận số (int) chứ không nhận chuỗi
                // Status = 1: Đã xác nhận (Vì đã thanh toán thành công)
                orderService.updateStatus(orderId, 1);

                // Chuyển hướng về trang báo thành công
                response.sendRedirect("OrderSuccess?id=" + orderId);
            } else {
                response.sendRedirect("Home");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Home");
        }
    }
}