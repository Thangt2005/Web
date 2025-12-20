<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%
        String path = request.getContextPath();
        String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    %>
    <base href="<%=basePath%>">
    <meta charset="UTF-8" />
    <title>Đăng nhập - MVC</title>
    <link rel="stylesheet" href="style.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</head>
<body>
<header>
    <h1>Thiết Bị Vệ Sinh Và Phòng Tắm</h1>
</header>

<div class="login-container">
    <h2>Đăng nhập</h2>

    <%-- Hiển thị thông báo lỗi từ Controller --%>
    <% if (request.getAttribute("message") != null) { %>
    <div style="color: red; text-align: center; margin-bottom: 10px; font-weight: bold;">
        <%= request.getAttribute("message") %>
    </div>
    <% } %>

    <div class="social-login">
        <button class="facebook"><i class="fa-brands fa-facebook-f"></i><span> Facebook</span></button>
        <button class="google"><i class="fa-brands fa-google"></i> <span> Google</span></button>
    </div>

    <h3>Đăng nhập bằng tài khoản</h3>
    <form class="email-login" action="Login" method="POST">
        <input type="text" name="username" placeholder="Username hoặc E-mail" required />

        <div class="password-wrapper">
            <input type="password" name="password" placeholder="Mật khẩu" required />
        </div>

        <button type="submit" class="login-btn">ĐĂNG NHẬP</button>
    </form>

    <p class="links">
        <a href="ForgetPassword">Quên mật khẩu?</a> |
        <a href="register_page.jsp">Đăng ký tài khoản</a>
    </p>
</div>

<footer class="footer">
    <div class="footer-bottom">
        © 2025 Thiết Bị Vệ Sinh & Phòng Tắm - All Rights Reserved.
    </div>
</footer>
</body>
</html>