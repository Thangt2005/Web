package controller;

import services.UserService;
import model.User; // 1. Nhớ import model User
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
        String username = request.getParameter("username");
        String pass = request.getParameter("password");

        // --- SỬA ĐỔI QUAN TRỌNG TẠI ĐÂY ---

        // Anh lưu ý: Hàm checkLogin bên UserService nên trả về đối tượng User (hoặc null)
        // thay vì trả về true/false.
        User userObject = userService.checkLogin(username, pass);

        if (userObject != null) {
            // *** ĐĂNG NHẬP THÀNH CÔNG ***
            HttpSession session = request.getSession();

            // 2. Lưu NGUYÊN ĐỐI TƯỢNG User vào session (để JSP lấy được role)
            session.setAttribute("user", userObject);

            // Có thể lưu thêm cái này nếu muốn check đơn giản
            session.setAttribute("isLoggedIn", true);

            // Chuyển hướng sang Servlet Home
            response.sendRedirect("Home");
        } else {
            // *** ĐĂNG NHẬP THẤT BẠI ***
            request.setAttribute("message", "Tên đăng nhập hoặc Mật khẩu không đúng!");
            request.getRequestDispatcher("view/login_page.jsp").forward(request, response);
        }
    }
}