package controller;

import model.Order;
import model.OrderDetail;
import model.User;
import services.OrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminOrderController", value = "/AdminOrder")
public class AdminOrderController extends HttpServlet {
    private OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // --- CHECK QUYỀN ADMIN ---
        HttpSession session = request.getSession();
        Object sessionObj = session.getAttribute("user");
        User auth = (sessionObj instanceof User) ? (User) sessionObj : null;

        if (auth == null || auth.getRole() != 1) {
            response.sendRedirect("Home");
            return;
        }
        // -------------------------

        String action = request.getParameter("action");
        String idStr = request.getParameter("id");

        // 1. Xem chi tiết đơn hàng
        if ("view".equals(action) && idStr != null) {
            int orderId = Integer.parseInt(idStr);
            List<OrderDetail> details = orderService.getOrderDetails(orderId);
            request.setAttribute("orderDetails", details);
            request.setAttribute("orderId", orderId);
            // Vẫn lấy danh sách đơn hàng để hiển thị bên dưới modal (hoặc trang chính)
            // Nhưng để đơn giản, ta chỉ hiển thị trang danh sách
        }

        // 2. Cập nhật trạng thái (Duyệt đơn / Giao hàng / Hủy)
        if ("updateStatus".equals(action) && idStr != null) {
            int orderId = Integer.parseInt(idStr);
            int status = Integer.parseInt(request.getParameter("status"));
            orderService.updateStatus(orderId, status);
            response.sendRedirect("AdminOrder"); // Load lại trang
            return;
        }

        // 3. Mặc định: Lấy danh sách đơn hàng hiển thị
        List<Order> orders = orderService.getAllOrders();
        request.setAttribute("orderList", orders);

        request.getRequestDispatcher("view/page_admin_order.jsp").forward(request, response);
    }
}