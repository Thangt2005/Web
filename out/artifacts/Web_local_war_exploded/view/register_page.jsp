%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%
        String path = request.getContextPath();
        String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    %>
    <base href="<%=basePath%>">
    <meta charset="UTF-8" />
    <title>Đăng kí Tài khoản - MVC</title>
    <link rel="stylesheet" href="style.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</head>
<body>
<header>
    <h1>Thiết Bị Vệ Sinh Và Phòng Tắm</h1>
</header>

<div class="register-container">
    <h2>Đăng Kí</h2>

    <%-- Hiển thị thông báo lỗi từ Controller --%>
    <% if (request.getAttribute("message") != null) { %>
    <div style="text-align: center; color: red; margin-bottom: 15px; font-weight: bold;">
        <%= request.getAttribute("message") %>
    </div>
    <% } %>

    <div class="social-login">
        <button class="facebook"><i class="fa-brands fa-facebook-f"></i><span> Đăng kí bằng Facebook</span></button>
        <button class="google"><i class="fa-brands fa-google"></i><span> Đăng kí bằng Google</span></button>

        <h3>Tạo tài khoản tại đây</h3>

        <form class="email-register" method="POST" action="Register">
            <input type="email" name="email" placeholder="E-mail" required
                   value="<%= request.getAttribute("emailVal") != null ? request.getAttribute("emailVal") : "" %>" />

            <input type="text" name="username-register" placeholder="Username" required
                   value="<%= request.getAttribute("userVal") != null ? request.getAttribute("userVal") : "" %>" />

            <div class="password-wrapper">
                <input type="password" name="password-register" id="password"
                       placeholder="Mật khẩu (8+ ký tự, Hoa, Thường, Số, @)" required
                       pattern="^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=!])(?=\S+$).{8,}$"
                       title="Mật khẩu phải từ 8 ký tự, có 1 chữ hoa, 1 chữ thường, 1 số và 1 ký tự đặc biệt">
                <i class="fa-solid fa-eye toggle-password" onclick="toggleVisibility('password', this)"></i>
            </div>

            <div class="password-wrapper">
                <input type="password" name="password-register1" id="password-confirm"
                       placeholder="Nhập lại mật khẩu" required>
                <i class="fa-solid fa-eye toggle-password" onclick="toggleVisibility('password-confirm', this)"></i>
            </div>

            <button type="submit" class="login-btn">ĐĂNG KÍ</button>
        </form>

        <p class="links">
            <a href="Login">Đã có tài khoản? Đăng nhập ngay</a>
        </p>
    </div>
</div>

<footer class="footer">