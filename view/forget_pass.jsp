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
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quên Mật Khẩu </title>
    <link rel="stylesheet" href="css_forget_pass.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />
</head>
<body>
<header>
    <h1>THIẾT BỊ VỆ SINH & PHÒNG TẮM</h1>
</header>

<div class="login-container">
    <h2>Quên Mật Khẩu</h2>
    <div class="forgot-password-form">
        <p>
            Vui lòng nhập địa chỉ email đã đăng ký của bạn. Chúng tôi sẽ gửi một
            liên kết để bạn đặt lại mật khẩu.
        </p>

        <%-- Hiển thị thông báo từ Controller --%>
        <% if (request.getAttribute("message") != null) { %>
        <div style="text-align: center; color: <%= request.getAttribute("msgColor") %>; margin-bottom: 15px; font-weight: bold;">
            <%= request.getAttribute("message") %>
        </div>
        <% } %>

        <form action="ForgetPassword" method="POST">
            <div class="email-login">
                <input type="email" name="email" placeholder="Nhập Email của bạn" required
                       value="<%= request.getAttribute("emailVal") != null ? request.getAttribute("emailVal") : "" %>"/>
            </div>
            <button type="submit" class="login-btn">GỬI YÊU CẦU ĐẶT LẠI</button>
        </form>

        <div class="back-to-login">
            <a href="login_page.jsp">&#8592; Quay lại Đăng nhập</a>
        </div>
    </div>
</div>

<footer class="footer">
    <div class="footer-bottom">
        © 2025 Thiết Bị Vệ Sinh & Phòng Tắm - All Rights Reserved.
    </div>
</footer>
</body>
</html>