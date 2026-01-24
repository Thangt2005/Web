package controller;

import services.UserService;
import utils.EmailUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.UUID;

@WebServlet(name = "ForgetPassController", value = "/ForgetPassword")
public class ForgetpassController extends HttpServlet {
    private UserService userService = new UserService();

    // HÀM CẦN BỔ SUNG
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("view/forget_pass.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        int userId = userService.getUserIdByEmail(email);

        if (userId != -1) {
            String token = UUID.randomUUID().toString();
            userService.saveToken(userId, token);

            try {
                // Đảm bảo "YourProject" khớp với Context Path của bạn trong Tomcat
                String resetLink = "http://localhost:8080/ResetPassword?token=" + token;

                String subject = "Đặt lại mật khẩu - Thiết Bị Vệ Sinh";
                String content = "<h3>Yêu cầu đặt lại mật khẩu</h3>"
                        + "<p>Vui lòng nhấn vào đường link dưới đây để đặt lại mật khẩu của bạn:</p>"
                        + "<a href='" + resetLink + "'>Nhấn vào đây để đổi mật khẩu</a>";

                EmailUtils.sendEmail(email, subject, content);
                request.setAttribute("message", "Thành công! Vui lòng kiểm tra email.");
                request.setAttribute("msgColor", "green");
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("message", "Lỗi gửi mail: " + e.getMessage());
                request.setAttribute("msgColor", "red");
            }
        } else {
            request.setAttribute("message", "Lỗi: Email này không tồn tại!");
            request.setAttribute("msgColor", "red");
        }
        request.getRequestDispatcher("view/forget_pass.jsp").forward(request, response);
    }
}