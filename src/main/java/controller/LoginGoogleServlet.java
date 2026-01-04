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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String code = request.getParameter("code");
        if (code != null) {
            String accessToken = GoogleUtils.getToken(code);
            GoogleUser user = GoogleUtils.getUserInfo(accessToken);

            // Đăng nhập thành công, lưu vào session
            HttpSession session = request.getSession();
            session.setAttribute("userGoogle", user);

            response.sendRedirect("Home");
        }
    }
}