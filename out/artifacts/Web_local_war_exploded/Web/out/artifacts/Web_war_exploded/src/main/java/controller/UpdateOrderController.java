package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import services.OrderService;
import java.io.IOException;

@WebServlet(name = "UpdateOrderController", urlPatterns = {"/UpdateOrder"})
public class UpdateOrderController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 1. Lấy ID và Status từ nút bấm trên trang JSP của anh
            int id = Integer.parseInt(request.getParameter("id"));
            int status = Integer.parseInt(request.getParameter("status"));

            // 2. Gọi Service cập nhật trạng thái đơn hàng
            OrderService os = new OrderService();
            os.updateStatus(id, status);

            // 3. Xong thì quay lại trang danh sách đơn hàng
            response.sendRedirect("AdminOrder");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("AdminOrder");
        }
    }
}