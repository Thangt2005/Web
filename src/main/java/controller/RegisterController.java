package controller;

import services.UserService;
import services.EmailService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "RegisterController", value = "/Register")
public class RegisterController extends HttpServlet {

    private UserService userService = new UserService();
    private EmailService emailService = new EmailService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("view/register_page.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Lấy dữ liệu
        String email = request.getParameter("email");
        String user = request.getParameter("username-register");
        String pass = request.getParameter("password-register");
        String passRepeat = request.getParameter("password-register1");

        // --- VALIDATION ---
        if (pass == null || !pass.equals(passRepeat)) {
            request.setAttribute("message", "Mật khẩu nhập lại không khớp!");
            forwardWithError(request, response, email, user);
            return;
        }

        if (!isStrongPassword(pass)) {
            request.setAttribute("message", "Mật khẩu phải >8 ký tự, bao gồm chữ hoa, thường, số và ký tự đặc biệt (@#$%^&+=)!");
            forwardWithError(request, response, email, user);
            return;
        }

        if (userService.checkEmailExists(email)) {
            request.setAttribute("message", "Email này đã được sử dụng!");
            forwardWithError(request, response, email, user);
            return;
        }

        // --- XỬ LÝ ---
        String token = userService.registerUser(email, user, pass);

        if (token != null) {
            // Gửi mail trong luồng riêng để web chạy nhanh
            final String recipientEmail = email;
            final String verifyToken = token;

            new Thread(() -> {
                emailService.sendVerificationEmail(recipientEmail, verifyToken);
            }).start();

            request.setAttribute("message", "Đăng ký thành công! Vui lòng kiểm tra Email để kích hoạt.");
            request.getRequestDispatcher("view/login_page.jsp").forward(request, response);
        } else {
            request.setAttribute("message", "Lỗi hệ thống, vui lòng thử lại.");
            forwardWithError(request, response, email, user);
        }
    }

    // Hàm phụ trợ
    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, String email, String user) throws ServletException, IOException {
        request.setAttribute("emailVal", email);
        request.setAttribute("userVal", user);
        request.getRequestDispatcher("view/register_page.jsp").forward(request, response);
    }

    private boolean isStrongPassword(String password) {
        // Giải thích Regex:
        // (?=.*[0-9])       : Phải có ít nhất 1 số
        // (?=.*[a-z])       : Phải có ít nhất 1 chữ thường
        // (?=.*[A-Z])       : Phải có ít nhất 1 chữ hoa
        // (?=.*[@#$%^&+=!]) : Phải có ít nhất 1 ký tự đặc biệt trong đám này
        // .{8,}             : Độ dài tối thiểu 8 ký tự
        return password != null && password.matches("^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=!]).{8,}$");
    }
}