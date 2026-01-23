package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "OrderSuccessController", urlPatterns = {"/OrderSuccess"})
public class OrderSuccessController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy mã đơn hàng từ URL (ví dụ ?id=5) để hiện ra cho khách vui
        String orderId = request.getParameter("id");
        request.setAttribute("orderId", orderId);

        // Chuyển hướng sang giao diện thông báo đẹp
        request.getRequestDispatcher("/view/orderSuccess.jsp").forward(request, response);
    }
}