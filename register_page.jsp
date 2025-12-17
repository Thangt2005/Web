<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    // --- PHẦN 1: XỬ LÝ JAVA BACKEND ---
    String registrationMessage = "";
    String msgColor = "red";

    // Kiểm tra nếu người dùng nhấn nút Đăng ký (gửi POST)
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        request.setCharacterEncoding("UTF-8"); // Nhận tiếng Việt từ form

        String email = request.getParameter("email");
        String username = request.getParameter("username-register");
        String password = request.getParameter("password-register");
        String passwordRepeat = request.getParameter("password-register1");

        // 1. Kiểm tra mật khẩu nhập lại có khớp không
        if (password == null || !password.equals(passwordRepeat)) {
            registrationMessage = "Lỗi: Mật khẩu nhập lại không khớp!";
        } else {
            Connection conn = null;
            PreparedStatement ps = null;

            try {
                // 2. Kết nối Database login - Cổng 3306
                Class.forName("com.mysql.cj.jdbc.Driver");
                String url = "jdbc:mysql://localhost:3306/login?useUnicode=true&characterEncoding=UTF-8";
                String user = "root";
                String pass = ""; // Mật khẩu database của anh thường để trống
                
                conn = DriverManager.getConnection(url, user, pass);

                // 3. Lệnh thêm tài khoản mới
                String sql = "INSERT INTO login (email, username, password) VALUES (?, ?, ?)";
                ps = conn.prepareStatement(sql);
                ps.setString(1, email);
                ps.setString(2, username);
                ps.setString(3, password);

                int row = ps.executeUpdate();
                if (row > 0) {
                    // Thành công -> Chuyển hướng sang trang đăng nhập
                    response.sendRedirect("login_page.jsp");
                    return;
                } else {
                    registrationMessage = "Đăng ký thất bại. Vui lòng thử lại.";
                }

            } catch (SQLException e) {
                // Xử lý lỗi trùng lặp (Username hoặc Email đã tồn tại)
                if (e.getErrorCode() == 1062) {
                    registrationMessage = "Lỗi: Tài khoản hoặc Email này đã tồn tại!";
                } else {
                    registrationMessage = "Lỗi hệ thống: " + e.getMessage();
                }
            } catch (Exception e) {
                registrationMessage = "Lỗi: " + e.getMessage();
            } finally {
                // Đóng kết nối
                if (ps != null) try { ps.close(); } catch (SQLException ignore) {}
                if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>Đăng kí Tài khoản</title>
    <link rel="stylesheet" href="style.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</head>
<body>
    <header>
        <h1>Thiết Bị Vệ Sinh Và Phòng Tắm</h1>
    </header>

    <div class="register-container">
        <h2>Đăng Kí</h2>

        <% if (!registrationMessage.isEmpty()) { %>
            <div style="text-align: center; color: <%= msgColor %>; margin-bottom: 15px; font-weight: bold;">
                <%= registrationMessage %>
            </div>
        <% } %>

        <div class="social-login">
            <button class="facebook">
                <i class="fa-brands fa-facebook-f"></i>
                <span>Đăng kí bằng Facebook</span>
            </button>
            <button class="twitter">
                <i class="fa-brands fa-twitter"></i> <span>Đăng kí bằng Twitter</span>
            </button>
            <button class="google">
                <i class="fa-brands fa-google"></i> <span>Đăng kí bằng Google</span>
            </button>
            
            <h3>Tạo tài khoản tại đây</h3>

            <form class="email-register" id="register-form" method="POST" action="register_page.jsp">
                <input
                    type="email"
                    id="email"
                    name="email"
                    placeholder="E-mail"
                    required
                    value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>"
                />
                <input
                    type="text"
                    id="username-register"
                    name="username-register"
                    placeholder="Username"
                    required
                    value="<%= request.getParameter("username-register") != null ? request.getParameter("username-register") : "" %>"
                />
                <input
                    type="password"
                    id="password-register"
                    name="password-register"
                    placeholder="Password"
                    required
                />
                <input
                    type="password"
                    id="password-register1"
                    name="password-register1"
                    placeholder="Password repeat"
                    required
                />
                <button type="submit" class="login-btn">ĐĂNG KÍ</button>
            </form>
            
            <p class="links">
                <a href="#">Đã có tài khoản?</a> |
                <a href="login_page.jsp">Đăng nhập ngay</a>
            </p>
        </div>
    </div>

    <footer class="footer">
        <div class="footer-container">
            <div class="footer-column">
                <h3>VỀ CHÚNG TÔI</h3>
                <p>Chuyên cung cấp thiết bị vệ sinh, phòng tắm chính hãng, giá tốt nhất thị trường.</p>
            </div>
            <div class="footer-column">
                <h3>LIÊN HỆ</h3>
                <p><i class="fa-solid fa-phone"></i> 0909 123 456</p>
                <p><i class="fa-solid fa-envelope"></i> contact@thietbivesinh.vn</p>
                <p><i class="fa-solid fa-location-dot"></i> TP. Hồ Chí Minh</p>
            </div>
        </div>
        <div class="footer-bottom">
            © 2025 Thiết Bị Vệ Sinh & Phòng Tắm - All Rights Reserved.
        </div>
    </footer>
</body>
</html>