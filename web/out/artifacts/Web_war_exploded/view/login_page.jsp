<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";

    // Thông tin đăng nhập Google
    String googleClientId = "379073277304-to5o2hb23ku2cpmbcgh64fn247kb035d.apps.googleusercontent.com";
    String googleRedirectUri = basePath + "LoginGoogle";
    String googleLoginUrl = "https://accounts.google.com/o/oauth2/auth?scope=email%20profile"
            + "&redirect_uri=" + googleRedirectUri
            + "&response_type=code"
            + "&client_id=" + googleClientId
            + "&approval_prompt=force";

    // Thông tin đăng nhập Facebook
    String facebookAppId = "2028528684599680";
    String facebookRedirectUri = basePath + "LoginFacebook";
    String facebookLoginUrl = "https://www.facebook.com/dialog/oauth"
            + "?client_id=" + facebookAppId
            + "&redirect_uri=" + facebookRedirectUri
            + "&scope=public_profile";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
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

    <%-- 1. Hiển thị thông báo thành công (Khi reset password xong) --%>
    <% if ("reset_success".equals(request.getParameter("msg"))) { %>
    <div style="background-color: #f6ffed; border: 1px solid #b7eb8f; color: #52c41a; padding: 10px; text-align: center; margin-bottom: 15px; border-radius: 8px; font-weight: bold;">
        <i class="fa-solid fa-circle-check"></i> Đặt lại mật khẩu thành công! Vui lòng đăng nhập.
    </div>
    <% } %>

    <%-- 2. Hiển thị thông báo lỗi từ Controller (Sai tài khoản/mật khẩu) --%>
    <% if (request.getAttribute("message") != null) { %>
    <div style="color: red; text-align: center; margin-bottom: 10px; font-weight: bold;">
        <i class="fa-solid fa-triangle-exclamation"></i> <%= request.getAttribute("message") %>
    </div>
    <% } %>

    <div class="social-login">
        <a href="<%= facebookLoginUrl.trim() %>" style="text-decoration: none;">
            <button class="facebook" type="button">
                <i class="fa-brands fa-facebook-f"></i><span> Đăng nhập bằng Facebook</span>
            </button>
        </a>

        <button class="google" onclick="window.location.href='<%= googleLoginUrl %>'">
            <i class="fa-brands fa-google"></i> <span>Đăng nhập bằng Google</span>
        </button>
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
        <a href="view/forget_pass.jsp">Quên mật khẩu?</a> |
        <a href="view/register_page.jsp">Đăng ký tài khoản</a>
    </p>
</div>

<footer class="footer">
    <%-- Phần footer giữ nguyên như code của bạn --%>
    <div class="footer-container">
        <div class="footer-column">
            <h3>VỀ CHÚNG TÔI</h3>
            <p>Chuyên cung cấp thiết bị vệ sinh, phòng tắm chính hãng, giá tốt nhất thị trường.</p>
        </div>
        <div class="footer-column">
            <h3>LIÊN HỆ</h3>
            <p><i class="fa-solid fa-phone"></i> 0909 123 456</p>
            <p><i class="fa-solid fa-envelope"></i> contact@thietbivesinh.vn</p>
        </div>
        <div class="footer-column">
            <h3>HỖ TRỢ KHÁCH HÀNG</h3>
            <ul>
                <li><a href="view/page_ChinhSachGiaoHang.jsp">Chính sách giao hàng</a></li>
                <li><a href="view/page_ChinhSachBaoHanh.jsp">Chính sách bảo hành</a></li>
            </ul>
        </div>
        <div class="footer-column">
            <h3>KẾT NỐI</h3>
            <div class="social-icons">
                <a href="#"><i class="fa-brands fa-facebook"></i></a>
                <a href="#"><i class="fa-brands fa-youtube"></i></a>
            </div>
        </div>
    </div>
    <div class="footer-bottom">
        © 2025 Thiết Bị Vệ Sinh & Phòng Tắm - All Rights Reserved.
    </div>
</footer>
</body>
</html>