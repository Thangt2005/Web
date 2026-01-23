package controller;

import services.UserService;
import utils.EmailUtils; // Import file Utils vừa tạo
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

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("view/forget_pass.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");

        // 1. Kiểm tra email có tồn tại không
        if (userService.checkEmailExists(email)) {

            // 2. Tạo mật khẩu ngẫu nhiên (hoặc link reset)
            String newPassword = UUID.randomUUID().toString().substring(0, 8); // Lấy 8 ký tự ngẫu nhiên

            try {
                // 3. Gửi email trước (để đảm bảo gửi được mới đổi pass)
                String subject = "Khôi phục mật khẩu - Thiết Bị Vệ Sinh";
                String content = "<h3>Xin chào!</h3>"
                        + "<p>Bạn vừa yêu cầu lấy lại mật khẩu.</p>"
                        + "<p>Mật khẩu mới của bạn là: <b style='color:red; font-size:18px;'>" + newPassword + "</b></p>"
                        + "<p>Vui lòng đăng nhập và đổi lại mật khẩu ngay lập tức.</p>";

                EmailUtils.sendEmail(email, subject, content);

                // 4. Nếu gửi mail thành công -> Lưu mật khẩu mới vào Database
                userService.updatePassword(email, newPassword);

                request.setAttribute("message", "Thành công! Mật khẩu mới đã được gửi vào email: " + email);
                request.setAttribute("msgColor", "green");

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("message", "Lỗi gửi mail: " + e.getMessage());
                request.setAttribute("msgColor", "red");
            }

        } else {
            request.setAttribute("message", "Lỗi: Email này không tồn tại trong hệ thống!");
            request.setAttribute("msgColor", "red");
        }

        request.setAttribute("emailVal", email);
        request.getRequestDispatcher("view/forget_pass.jsp").forward(request, response);
    }
}