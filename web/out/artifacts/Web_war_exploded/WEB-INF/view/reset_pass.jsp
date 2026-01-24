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
    <title>Đặt Lại Mật Khẩu</title>
    <%-- Dùng lại file CSS của trang Forget Pass để đồng bộ giao diện --%>
    <link rel="stylesheet" href="css_forget_pass.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />
</head>
<body>
<header>
    <h1>THIẾT BỊ VỆ SINH & PHÒNG TẮM</h1>
</header>

<div class="login-container">
    <h2>Đặt Lại Mật Khẩu</h2>
    <div class="forgot-password-form">
        <p style="margin-bottom: 20px;">
            Vui lòng nhập mật khẩu mới cho tài khoản của bạn.
        </p>

        <%-- Hiển thị thông báo lỗi nếu có --%>
        <% if (request.getAttribute("message") != null) { %>
        <div style="text-align: center; color: <%= request.getAttribute("msgColor") %>; margin-bottom: 15px; font-weight: bold;">
            <%= request.getAttribute("message") %>
        </div>
        <% } %>

        <form action="ResetPassword" method="POST" onsubmit="return validatePassword()">
            <input type="hidden" name="token" value="<%= request.getAttribute("token") %>"/>

            <div class="email-login password-wrapper">
                <input type="password" name="newPassword" id="newPassword"
                       placeholder="Nhập mật khẩu mới" required />
                <i class="fa-solid fa-eye toggle-password" onclick="toggleVisibility('newPassword', this)"></i>
            </div>

            <div class="email-login password-wrapper" style="margin-top: 15px;">
                <input type="password" id="confirmPassword"
                       placeholder="Xác nhận mật khẩu mới" required />
                <i class="fa-solid fa-eye toggle-password" onclick="toggleVisibility('confirmPassword', this)"></i>
            </div>

            <p id="error-js" style="color: red; font-size: 13px; margin-top: 5px; display: none;"></p>

            <button type="submit" class="login-btn" style="margin-top: 20px;">XÁC NHẬN ĐỔI MẬT KHẨU</button>
        </form>

        <div class="back-to-login">
            <a href="view/login_page.jsp">&#8592; Hủy bỏ và Quay lại</a>
        </div>
    </div>
</div>

<footer class="footer">
    <div class="footer-bottom">
        © 2025 Thiết Bị Vệ Sinh & Phòng Tắm - All Rights Reserved.
    </div>
</footer>

<%-- Script kiểm tra mật khẩu khớp nhau trước khi gửi đi --%>
<script>
    function validatePassword() {
        var pass = document.getElementById("newPassword").value;
        var confirm = document.getElementById("confirmPassword").value;
        var error = document.getElementById("error-js");

        if (pass.length < 6) {
            error.innerHTML = "Mật khẩu phải có ít nhất 6 ký tự!";
            error.style.display = "block";
            return false;
        }

        if (pass !== confirm) {
            error.innerHTML = "Mật khẩu xác nhận không khớp!";
            error.style.display = "block";
            return false;
        }
        return true;
    }
    function toggleVisibility(inputId, icon) {
        const input = document.getElementById(inputId);
        if (input.type === "password") {
            input.type = "text";
            // Đổi icon sang mắt gạch chéo
            icon.classList.remove("fa-eye");
            icon.classList.add("fa-eye-slash");
        } else {
            input.type = "password";
            // Đổi icon về mắt mở
            icon.classList.remove("fa-eye-slash");
            icon.classList.add("fa-eye");
        }
    }
</script>
</body>
</html>