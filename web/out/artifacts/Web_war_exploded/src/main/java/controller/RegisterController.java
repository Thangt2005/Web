package controller;

import services.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "RegisterController", value = "/Register")
public class RegisterController extends HttpServlet {
    private UserService userService = new UserService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("view/register_page.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 1. Lấy dữ liệu
        String email = request.getParameter("email");
        String user = request.getParameter("username-register");
        String pass = request.getParameter("password-register");
        String passRepeat = request.getParameter("password-register1");

        // 2. Kiểm tra mật khẩu nhập lại
        if (pass == null || !pass.equals(passRepeat)) {
            request.setAttribute("message", "Lỗi: Mật khẩu nhập lại không khớp!");
            forwardToRegister(request, response, email, user);
            return;
        }

        // 3. GỌI SERVICE ĐĂNG KÝ (Chỉ truyền 3 tham số, bỏ token)
        int result = userService.registerUser(email, user, pass);

        if (result > 0) {
            // Thành công -> Chuyển sang trang đăng nhập và báo thành công
            request.setAttribute("message", "Đăng ký thành công! Bạn có thể đăng nhập ngay.");
            request.getRequestDispatcher("view/login_page.jsp").forward(request, response);
        } else if (result == -1) {
            request.setAttribute("message", "Lỗi: Tài khoản hoặc Email này đã tồn tại!");
            forwardToRegister(request, response, email, user);
        } else {
            request.setAttribute("message", "Đăng ký thất bại. Vui lòng thử lại.");
            forwardToRegister(request, response, email, user);
        }
    }

    private void forwardToRegister(HttpServletRequest request, HttpServletResponse response, String email, String user) throws ServletException, IOException {
        request.setAttribute("emailVal", email);
        request.setAttribute("userVal", user);
        request.getRequestDispatcher("view/register_page.jsp").forward(request, response);
    }
}