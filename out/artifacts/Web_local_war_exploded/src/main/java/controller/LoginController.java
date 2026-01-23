package controller;

import services.UserService;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "LoginController", value = "/Login")
public class LoginController extends HttpServlet {
    // Khởi tạo Service
    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Chuyển hướng đến trang giao diện đăng nhập
        request.getRequestDispatcher("view/login_page.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Cấu hình tiếng Việt cho Request và Response
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // 2. Lấy dữ liệu từ form
        String username = request.getParameter("username");
        String pass = request.getParameter("password");

        // 3. Gọi Service kiểm tra
        // Hàm checkLogin trả về đối tượng User (nếu đúng) hoặc null (nếu sai)
        User userObject = userService.checkLogin(username, pass);

        if (userObject != null) {
            // --- TRƯỜNG HỢP: ĐĂNG NHẬP THÀNH CÔNG ---

            HttpSession session = request.getSession();

            // LƯU Ý QUAN TRỌNG:
            // Lưu nguyên đối tượng User vào Session.
            // Lúc này ở trang Home, bạn có thể lấy: user.getFullName(), user.getRole()...
            session.setAttribute("user", userObject);

            // Chuyển hướng về trang chủ (Servlet Home)
            response.sendRedirect("Home");
        } else {
            // --- TRƯỜNG HỢP: ĐĂNG NHẬP THẤT BẠI ---

            // Gửi thông báo lỗi
            request.setAttribute("message", "Tên đăng nhập hoặc Mật khẩu không đúng!");

            // Gửi lại username để JSP điền sẵn vào ô input (Trải nghiệm người dùng tốt hơn)
            // Bên JSP bạn đã có dòng: value="<%= request.getParameter("username")... %>" là đúng rồi.
            request.setAttribute("username", username);

            // Quay lại trang đăng nhập
            request.getRequestDispatcher("view/login_page.jsp").forward(request, response);
        }
    }
}