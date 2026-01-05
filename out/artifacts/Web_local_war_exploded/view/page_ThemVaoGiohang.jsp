<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.DecimalFormat" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    DecimalFormat formatter = new DecimalFormat("###,###");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ Hàng - Thiết Bị Vệ Sinh</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link rel="stylesheet" href="homeStyle.css" /> <%-- Dùng chung style header/footer --%>
    <link rel="stylesheet" href="css_ThemVaoGioHang.css" />
</head>
<body>

<header>
    <h1>Thiết Bị Vệ Sinh Và Phòng Tắm</h1>
    <nav>
        <ul class="user-menu">
            <li><a href="Home"><i class="fa-solid fa-house"></i> Tiếp tục mua hàng</a></li>
            <li><a href="#"><i class="fas fa-user"></i> Anh Thắng</a></li>
        </ul>
    </nav>
</header>

<main class="cart-container">
    <h2 style="text-align:center; margin: 30px 0; color: #333;">CHI TIẾT GIỎ HÀNG CỦA ANH</h2>

    <table class="cart-table">
        <thead>
        <tr>
            <th>Sản phẩm</th>
            <th>Giá</th>
            <th>Số lượng</th>
            <th>Tạm tính</th>
            <th>Thao tác</th>
        </tr>
        </thead>
        <tbody>
        <%
            // Lấy danh sách sản phẩm chi tiết từ CartController (Servlet) truyền sang
            List<Map<String, Object>> items = (List<Map<String, Object>>) request.getAttribute("cartItems");
            double totalPrice = 0;

            if (items != null && !items.isEmpty()) {
                for (Map<String, Object> item : items) {
                    double gia = (double) item.get("gia");
                    int soLuong = (int) item.get("so_luong");
                    double tamTinh = gia * soLuong;
                    totalPrice += tamTinh;
        %>
        <tr>
            <td class="product-info">
                <img src="image_all/<%= item.get("hinh_anh") %>" alt="Product" onerror="this.src='https://via.placeholder.com/80'"/>
                <span class="product-name"><%= item.get("ten_sp") %></span>
            </td>
            <td class="price"><%= formatter.format(gia) %>đ</td>
            <td class="qty">
                <div class="qty-control">
                    <input type="number" value="<%= soLuong %>" min="1" readonly />
                </div>
            </td>
            <td class="subtotal"><%= formatter.format(tamTinh) %>đ</td>
            <td>
                <a href="Cart?action=delete&id=<%= item.get("id") %>" class="remove-btn" onclick="return confirm('bạn chắc chắn muốn xóa sản phẩm này?')">
                    <i class="fa-solid fa-trash"></i> Xóa
                </a>
            </td>
        </tr>
        <%
            }
        } else {
        %>
        <tr>
            <td colspan="5" style="text-align:center; padding: 50px;">
                <i class="fa-solid fa-cart-shopping" style="font-size: 50px; color: #ccc;"></i>
                <p style="margin-top: 15px; color: #666;">Giỏ hàng của anh Thắng đang trống ạ!</p>
                <a href="Home" class="checkout-btn" style="display:inline-block; width: auto; padding: 10px 30px; margin-top: 10px;">
                    Quay lại mua sắm ngay
                </a>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>

    <% if (items != null && !items.isEmpty()) { %>
    <div class="cart-total">
        <div class="total-row">
            <span>Tổng cộng giỏ hàng:</span>
            <strong class="total-amount"><%= formatter.format(totalPrice) %>đ</strong>
        </div>
        <div class="action-buttons">
            <a href="Home" class="continue-shopping">Tiếp tục mua hàng</a>
            <button class="checkout-btn" onclick="window.location.href='view/page_thanhToan.jsp'">Tiến hành thanh toán</button>
        </div>
    </div>
    <% } %>
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