<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User, java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>Quản Lý Khách Hàng</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link rel="stylesheet" href="admin_style.css" />
    <style>
        /* Tận dụng lại CSS từ Admin và bổ sung khoảng cách cho bảng */
        .data-table b { color: #2c3e50; }
        .btn-delete-user { color: #e74c3c; text-decoration: none; font-weight: 500; }
        .btn-delete-user:hover { text-decoration: underline; }
    </style>
</head>
<body>
<div class="wrapper">
    <header>
        <h1><i class="fas fa-user-shield"></i> Trang Quản Trị</h1>
        <nav><ul><li><a href="Home" style="color:white;"><i class="fa fa-home"></i> Về trang chủ</a></li></ul></nav>
    </header>

    <div class="main-admin-container">
        <div class="admin-sidebar-panel">
            <div class="menu-title">MENU HỆ THỐNG</div>
            <ul>
                <li><a href="Admin"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                <li class="active-admin"><a href="AdminCustomer"><i class="fas fa-users"></i> Khách hàng</a></li>
            </ul>
        </div>

        <div class="dashboard-content">
            <h2>Quản lý tài khoản khách hàng</h2>

            <div class="stats-grid">
                <div class="stat-card">
                    <h3>TỔNG KHÁCH HÀNG</h3>
                    <p>${userList.size()}</p>
                </div>
                <div class="stat-card" style="border-top-color: #3498db;">
                    <h3>TÀI KHOẢN MỚI</h3>
                    <p>Trong tháng này</p>
                </div>
            </div>

            <div class="content-block">
                <h3><i class="fa fa-users"></i> Danh Sách Thành Viên</h3>
                <table class="data-table">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tên đăng nhập</th>
                        <th>Họ và tên</th>
                        <th>Email</th>
                        <th>Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        List<User> userList = (List<User>) request.getAttribute("userList");
                        if (userList != null && !userList.isEmpty()) {
                            for (User u : userList) {
                    %>
                    <tr>
                        <td><%= u.getId() %></td>
                        <td><b><%= u.getUsername() %></b></td>
                        <td><%= u.getFullname() %></td>
                        <td><%= u.getEmail() %></td>
                        <td>
                            <a href="AdminCustomer?action=delete&id=<%= u.getId() %>"
                               class="btn-delete-user"
                               onclick="return confirm('Anh có chắc chắn muốn xóa tài khoản này không?')">
                                <i class="fa fa-trash"></i> Xóa
                            </a>
                        </td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="5" style="text-align: center;">Chưa có dữ liệu khách hàng.</td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
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
            </div>
            <div class="footer-column">
                <h3>KẾT NỐI</h3>
                <div class="social-icons">
                    <a href="https://www.facebook.com/huuthang11092005" target="_blank"><i class="fa-brands fa-facebook"></i></a>
                    <a href="https://www.youtube.com/@huuthang9024" target="_blank"><i class="fa-brands fa-youtube"></i></a>
                </div>
            </div>
        </div>
        <div class="footer-bottom">
            © 2025 Thiết Bị Vệ Sinh & Phòng Tắm - All Rights Reserved.
        </div>
    </footer>
</div>
</body>
</html>