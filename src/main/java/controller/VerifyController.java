package controller;

import services.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "VerifyController", value = "/Verify")
public class VerifyController extends HttpServlet {
    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy token từ đường link (ví dụ: .../Verify?token=abc-xyz)
        String token = request.getParameter("token");

        if (token != null && userService.verifyAccount(token)) {
            // Xác thực thành công
            request.setAttribute("message", "Kích hoạt tài khoản thành công! Bạn hãy đăng nhập.");
            request.getRequestDispatcher("view/login_page.jsp").forward(request, response);
        } else {
            // Token sai hoặc đã dùng rồi
            request.setAttribute("message", "Link xác thực không hợp lệ hoặc đã hết hạn!");
            request.getRequestDispatcher("view/login_page.jsp").forward(request, response);
        }
    }
}