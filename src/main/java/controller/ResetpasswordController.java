package controller;

import services.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "ResetPasswordController", value = "/ResetPassword")
public class ResetpasswordController extends HttpServlet {
    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");

        // Kiểm tra token có hợp lệ không
        int userId = userService.validateToken(token);

        if (userId != -1) {
            // Nếu hợp lệ, truyền token sang trang JSP và hiển thị form
            request.setAttribute("token", token);
            request.getRequestDispatcher("view/reset_pass.jsp").forward(request, response);
        } else {
            // Nếu không hợp lệ, báo lỗi
            request.setAttribute("message", "Liên kết không hợp lệ hoặc đã hết hạn!");
            request.setAttribute("msgColor", "red");
            request.getRequestDispatcher("view/forget_pass.jsp").forward(request, response);
        }
    }
    // Giai đoạn 2: Khi người dùng nhấn nút "XÁC NHẬN ĐỔI MẬT KHẨU"
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");

        // Kiểm tra lại một lần nữa để đảm bảo tính bảo mật
        int userId = userService.validateToken(token);

        if (userId != -1) {
            // 1. Cập nhật mật khẩu mới vào bảng login (đã được MD5 bên trong hàm này)
            userService.updatePasswordById(userId, newPassword);

            // 2. Vô hiệu hóa token (set isUsed = 1) để link không dùng lại được nữa
            userService.markTokenAsUsed(token);

            // 3. Thông báo thành công và chuyển về trang đăng nhập
            // Bạn có thể gửi tham số qua URL để trang login hiện thông báo đẹp hơn
            response.sendRedirect(request.getContextPath() + "/view/login_page.jsp?msg=reset_success");
        } else {
            // Trường hợp hy hữu: Token hết hạn ngay đúng lúc đang nhập mật khẩu
            request.setAttribute("message", "Đã có lỗi xảy ra hoặc phiên làm việc hết hạn.");
            request.setAttribute("msgColor", "red");
            request.getRequestDispatcher("view/forget_pass.jsp").forward(request, response);
        }
    }
}