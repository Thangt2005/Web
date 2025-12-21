<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%
        String path = request.getContextPath();
        String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    %>
    <base href="<%=basePath%>">
    <meta charset="UTF-8" />
    <title>Giỏ Hàng - MVC</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <%-- Đảm bảo file CSS đã nằm ngoài thư mục WEB-INF --%>
    <link rel="stylesheet" href="css_ThemVaoGioHang.css" />
</head>
<body>
<header>
    <h1>Thiết Bị Vệ Sinh Và Phòng Tắm</h1>
    <nav>
        <ul class="user-menu">
            <li><a href="Cart"><i class="fa-solid fa-cart-shopping"></i> Giỏ hàng</a></li>
            <li><a href="#"><i class="fas fa-user"></i> thangtt26</a></li>
        </ul>
    </nav>
</header>

<div class="menu-container">
    <div class="top-menu">
        <ul>
            <li><a href="Home">Trang chủ</a></li>
            <li><a href="Combo">Combo</a></li>
            <li><a href="BonTam">Bồn Tắm</a></li>
            <li><a href="BonTieuNam">Bồn Tiểu Nam</a></li>
            <li><a href="TuLavabo">Tủ Lavabo</a></li>
        </ul>
    </div>
</div>

<main class="cart-container">
    <h2 style="text-align:center; margin: 20px 0;">CHI TIẾT GIỎ HÀNG</h2>
    <table class="cart-table">
        <thead>
        <tr>
            <th>Sản phẩm</th>
            <th>Giá</th>
            <th>Số lượng</th>
            <th>Tạm tính</th>
        </tr>
        </thead>
        <tbody>
        <%
            List<Map<String, Object>> items = (List<Map<String, Object>>) request.getAttribute("cartItems");
            if (items != null && !items.isEmpty()) {
                for (Map<String, Object> item : items) {
        %>
        <tr>
            <td class="product-info">
                <img src="image_all/<%= item.get("hinh_anh") %>" alt="Product" />
                <span><%= item.get("ten_sp") %></span>
            </td>
            <td><fmt:formatNumber value='<%= item.get("gia") %>' type="number" />đ</td>
            <td class="qty">
                <input type="number" value="<%= item.get("so_luong") %>" readonly />
            </td>
            <td><fmt:formatNumber value='<%= item.get("tam_tinh") %>' type="number" />đ</td>
        </tr>
        <%
            }
        } else {
        %>
        <tr><td colspan='4' style='text-align:center;'>Giỏ hàng trống!</td></tr>
        <% } %>
        </tbody>
    </table>

    <div class="cart-total">
        <h3>Tổng cộng giỏ hàng</h3>
        <p><span>Tổng tiền:</span> <strong><fmt:formatNumber value="${totalPrice}" type="number" />đ</strong></p>
        <button class="checkout-btn">Tiến hành thanh toán</button>
        <a href="Home" style="display:block; text-align:center; margin-top:10px; color:#c49a00;">Tiếp tục mua hàng</a>
    </div>
</main>

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