package controller;

import model.FacebookUser;
import utils.FacebookUtils;
import utils.FacebookConstants;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/LoginFacebook")
public class LoginFacebookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String code = request.getParameter("code");

        if (code == null || code.isEmpty()) {
            // Nếu chưa có code -> Chuyển hướng sang trang đăng nhập Facebook
            String loginUrl = "https://www.facebook.com/dialog/oauth?client_id="
                    + FacebookConstants.FACEBOOK_APP_ID
                    + "&redirect_uri=" + FacebookConstants.FACEBOOK_REDIRECT_URI
                    + "&scope=public_profile,email";
            response.sendRedirect(loginUrl);
        } else {
            // Nếu đã có code -> Xử lý lấy Token và User
            String accessToken = FacebookUtils.getToken(code);
            FacebookUser fbUser = FacebookUtils.getUserInfo(accessToken);

            if (fbUser != null) {
                HttpSession session = request.getSession();

                // ĐỒNG BỘ VỚI CODE CŨ
                session.setAttribute("user", fbUser.getName());
                session.setAttribute("isLoggedIn", true);

                // Lưu thêm ID để lấy ảnh đại diện (Mẹo: dùng link graph)
                // Link ảnh: https://graph.facebook.com/{ID}/picture?type=large
                session.setAttribute("fbID", fbUser.getId());

                response.sendRedirect("Home");
            } else {
                request.setAttribute("message", "Đăng nhập Facebook thất bại!");
                request.getRequestDispatcher("view/login_page.jsp").forward(request, response);
            }
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}