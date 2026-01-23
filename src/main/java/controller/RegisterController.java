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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng đến trang đăng ký
        request.getRequestDispatcher("view/register_page.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 1. Cấu hình tiếng Việt
        request.setCharacterEncoding("UTF-8");

        // 2. Lấy dữ liệu từ Form
        String email = request.getParameter("email");
        String username = request.getParameter("username-register");
        String pass = request.getParameter("password-register");
        String passRepeat = request.getParameter("password-register1");

        // Biểu thức Regex kiểm tra mật khẩu mạnh (8+ ký tự, Hoa, Thường, Số, Ký tự đặc biệt)
        String strongPasswordRegex = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=!])(?=\\S+$).{8,}$";

        String errorMessage = null;

        // 3. Các bước kiểm tra logic (Validation)
        if (pass == null || !pass.equals(passRepeat)) {
            errorMessage = "Lỗi: Mật khẩu nhập lại không khớp!";
        }
        else if (!pass.matches(strongPasswordRegex)) {
            errorMessage = "Mật khẩu quá yếu! Cần ít nhất 8 ký tự, có chữ Hoa, Thường, Số và Ký tự đặc biệt.";
        }
        else if (userService.checkEmailExists(email)) {
            errorMessage = "Lỗi: Email này đã được đăng ký sử dụng!";
        }

        // 4. Xử lý Đăng ký
        if (errorMessage == null) {
            // Gọi hàm registerUser từ UserService (Hàm này đã có sẵn MD5 và gán role=0)
            int result = userService.registerUser(email, username, pass);

            if (result > 0) {
                // Đăng ký THÀNH CÔNG -> Về trang Đăng nhập
                response.sendRedirect("Login");
                return;
            } else {
                errorMessage = "Đăng ký thất bại do lỗi hệ thống. Vui lòng thử lại sau!";
            }
        }

        // 5. Nếu có lỗi: Quay lại trang đăng ký và giữ lại dữ liệu đã nhập (trừ mật khẩu)
        request.setAttribute("message", errorMessage);
        request.setAttribute("emailVal", email);
        request.setAttribute("userVal", username);request.getRequestDispatcher("view/register_page.jsp").forward(request, response);
    }
}