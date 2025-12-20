package controller;

import services.UserServices;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import services.UserServices;

import java.io.IOException;

@WebServlet(name = "RegisterController", value = "/Register")
public class RegisterController extends HttpServlet {
    private UserServices userService = new UserServices();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("view/register_page.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        String user = request.getParameter("username-register");
        String pass = request.getParameter("password-register");
        String passRepeat = request.getParameter("password-register1");

        // 1. Kiểm tra khớp mật khẩu
        if (pass == null || !pass.equals(passRepeat)) {
            request.setAttribute("message", "Lỗi: Mật khẩu nhập lại không khớp!");
        } else {
            int result = userService.registerUser(email, user, pass);
            if (result > 0) {
                // Thành công -> Sang trang Login
                response.sendRedirect("Login");
                return;
            } else if (result == -1) {
                request.setAttribute("message", "Lỗi: Tài khoản hoặc Email này đã tồn tại!");
            } else {
                request.setAttribute("message", "Đăng ký thất bại. Vui lòng thử lại.");
            }
        }

        // Nếu thất bại thì giữ lại dữ liệu đã nhập
        request.setAttribute("emailVal", email);
        request.setAttribute("userVal", user);
        request.getRequestDispatcher("view/register_page.jsp").forward(request, response);
    }
}