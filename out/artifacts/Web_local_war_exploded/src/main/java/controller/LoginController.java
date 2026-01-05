package controller;

import services.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "LoginController", value = "/Login")
public class LoginController extends HttpServlet {
    private UserService userService = new UserService();

    // Hiển thị trang đăng nhập
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("view/login_page.jsp").forward(request, response);
    }

    // Xử lý logic khi người dùng nhấn ĐĂNG NHẬP
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        if (userService.checkLogin(user, pass)) {
            // *** ĐĂNG NHẬP THÀNH CÔNG ***
            HttpSession session = request.getSession();
            session.setAttribute("isLoggedIn", true);
            session.setAttribute("user", user);

            // Chuyển hướng sang Servlet Home
            response.sendRedirect("Home");
        } else {
            // *** ĐĂNG NHẬP THẤT BẠI ***
            request.setAttribute("message", "Tên đăng nhập hoặc Mật khẩu không đúng!");
            request.getRequestDispatcher("view/login_page.jsp").forward(request, response);
        }
    }
}