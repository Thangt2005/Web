package controller;

import services.UserServices;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import services.UserServices;

import java.io.IOException;

@WebServlet(name = "ForgetPassController", value = "/ForgetPassword")
public class ForgetpassController extends HttpServlet {
    private UserServices userService = new UserServices();

    // Hiển thị trang khi người dùng nhấn vào link Quên mật khẩu
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("view/forget_pass.jsp").forward(request, response);
    }

    // Xử lý khi người dùng nhấn nút "GỬI YÊU CẦU"
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");

        if (userService.checkEmailExists(email)) {
            request.setAttribute("message", "Yêu cầu đã được gửi! Vui lòng kiểm tra hộp thư đến của email: " + email);
            request.setAttribute("msgColor", "green");
        } else {
            request.setAttribute("message", "Lỗi: Email này không tồn tại trong hệ thống!");
            request.setAttribute("msgColor", "red");
        }

        request.setAttribute("emailVal", email); // Giữ lại email đã nhập trong ô input
        request.getRequestDispatcher("view/forget_pass.jsp").forward(request, response);
    }
}