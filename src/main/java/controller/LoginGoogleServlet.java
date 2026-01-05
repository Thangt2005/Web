package controller;

import model.GoogleUser;
import utils.GoogleUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/LoginGoogle")
public class LoginGoogleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String code = request.getParameter("code");

        if (code != null && !code.isEmpty()) {
            // Lấy token và thông tin người dùng từ Google
            String accessToken = GoogleUtils.getToken(code);
            GoogleUser googlePojo = GoogleUtils.getUserInfo(accessToken);

            if (googlePojo != null) {
                //code kiểm tra
                System.out.println("Tên lấy từ Google: " + googlePojo.getName());
                System.out.println("Email lấy từ Google: " + googlePojo.getEmail());
                //----------------------------
                HttpSession session = request.getSession();

                // --- PHẦN QUAN TRỌNG: ĐỒNG BỘ VỚI LOGIN THƯỜNG ---

                // 1. Đặt tên biến là "user" để Header/Trang chủ nhận diện được
                // (Anh có thể chọn googlePojo.getEmail() nếu muốn hiện email)
                session.setAttribute("user", googlePojo.getName());

                // 2. Đặt cờ isLoggedIn = true để hệ thống biết đã đăng nhập
                session.setAttribute("isLoggedIn", true);

                // 3. (Tùy chọn) Lưu thêm object google để sau này lấy Avatar nếu cần
                session.setAttribute("userGoogle", googlePojo);

                // --- KẾT THÚC PHẦN ĐỒNG BỘ ---

                // Chuyển hướng về Servlet Home (Thay vì view/home.jsp để tránh lỗi mất CSS)
                response.sendRedirect("Home");
            } else {
                // Nếu không lấy được thông tin thì quay về trang đăng nhập
                request.setAttribute("message", "Đăng nhập Google thất bại!");
                request.getRequestDispatcher("view/login_page.jsp").forward(request, response);
            }
        } else {
            // Nếu không có code trả về
            request.getRequestDispatcher("view/login_page.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}