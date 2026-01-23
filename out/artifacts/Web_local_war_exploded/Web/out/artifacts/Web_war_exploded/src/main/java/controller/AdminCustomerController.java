package controller;

import model.User;
import services.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminCustomerController", value = "/AdminCustomer")
public class AdminCustomerController extends HttpServlet {
    private UserService service = new UserService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String id = request.getParameter("id");

        // Xử lý xóa khách hàng
        if ("delete".equals(action) && id != null) {
            service.deleteUser(Integer.parseInt(id));
            response.sendRedirect("AdminCustomer");
            return;
        }

        // Lấy danh sách và đẩy sang JSP
        List<User> userList = service.getAllUsers();
        request.setAttribute("userList", userList);
        request.getRequestDispatcher("view/page_admin_customer.jsp").forward(request, response);
    }
}