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
        <button class="facebook"><i class="fa-brands fa-facebook-f"></i><span> Đăng kí Facebook</span></button>
        <button class="google"><i class="fa-brands fa-google"></i><span> Đăng kí Google</span></button>

        <h3>Tạo tài khoản tại đây</h3>

        <form class="email-register" method="POST" action="Register">
            <input type="email" name="email" placeholder="E-mail" required
                   value="<%= request.getAttribute("emailVal") != null ? request.getAttribute("emailVal") : "" %>" />
            <input type="text" name="username-register" placeholder="Username" required
                   value="<%= request.getAttribute("userVal") != null ? request.getAttribute("userVal") : "" %>" />
            <input type="password" name="password-register" placeholder="Mật khẩu" required />
            <input type="password" name="password-register1" placeholder="Nhập lại mật khẩu" required />
            <button type="submit" class="login-btn">ĐĂNG KÍ</button>
        </form>

        <p class="links">
            <a href="Login">Đã có tài khoản? Đăng nhập ngay</a>
        </p>
    </div>
</div>

<footer class="footer">
    <div class="footer-container">
        <div class="footer-column">
            <h3>VỀ CHÚNG TÔI</h3>
            <p>
                Chuyên cung cấp thiết bị vệ sinh, phòng tắm chính hãng, giá tốt nhất
                thị trường.
            </p>
        </div>

        <div class="footer-column">
            <h3>LIÊN HỆ</h3>
            <p><i class="fa-solid fa-phone"></i> 0909 123 456</p>
            <p><i class="fa-solid fa-envelope"></i> contact@thietbivesinh.vn</p>
            <p><i class="fa-solid fa-location-dot"></i> TP. Hồ Chí Minh</p>
        </div>

        <div class="footer-column">
            <h3>HỖ TRỢ KHÁCH HÀNG</h3>
            <ul>
                <li><a href="#">Chính sách giao hàng</a></li>
                <li><a href="#">Chính sách bảo hành</a></li>
                <li><a href="#">Hướng dẫn thanh toán</a></li>
                <li><a href="#">Chăm sóc khách hàng</a></li>
            </ul>
        </div>

        <div class="footer-column">
            <h3>KẾT NỐI VỚI CHÚNG TÔI</h3>
            <div class="social-icons">
                <a href="https://www.facebook.com/huuthang11092005" target="_blank"><i class="fa-brands fa-facebook"></i></a>
                <a href="https://www.youtube.com/@huuthangtran9024/posts" target="_blank"><i class="fa-brands fa-youtube"></i></a>
                <a href="https://www.tiktok.com/@thangtt26" target="_blank"><i class="fa-brands fa-tiktok"></i></a>
            </div>
        </div>
    </div>

    <div class="footer-bottom">
        © 2025 Thiết Bị Vệ Sinh & Phòng Tắm - All Rights Reserved.
    </div>
</footer>
</body>
</html>