<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Product" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%
        // Thiết lập đường dẫn gốc để không bị lỗi CSS/Ảnh khi dùng Controller
        String path = request.getContextPath();
        String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    %>
    <base href="<%=basePath%>">
    <meta charset="UTF-8" />
    <%
        Product p = (Product) request.getAttribute("product");
        String ten = (p != null) ? p.getTenSp() : "Chi tiết sản phẩm";
    %>
    <title>Chi Tiết: <%= ten %></title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link rel="stylesheet" href="css_TrangChiTiet.css" />
</head>
<body>
<header>
    <h1>Thiết Bị Vệ Sinh Và Phòng Tắm</h1>
    <nav>
        <form class="search-form" action="Home" method="GET">
            <input type="text" name="search" placeholder="Tìm kiếm sản phẩm ..." class="search-input" />
            <button type="submit" class="search-icon"><i class="fa fa-search"></i></button>
        </form>
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
            <li><a href="Toilet">Bồn Cầu</a></li>
            <li><a href="Lavabo">Lavabo</a></li>
            <li><a href="TuLavabo">Tủ Lavabo</a></li>
            <li><a href="VoiSenTam">Vòi Sen Tắm</a></li>
            <li><a href="ChauRuaChen">Chậu Rửa Chén</a></li>
            <li><a href="BonTam">Bồn Tắm</a></li>
            <li><a href="VoiRua">Vòi Rửa</a></li>
            <li><a href="BonTieuNam">Bồn Tiểu Nam</a></li>
            <li><a href="PhuKien">Phụ Kiện</a></li>
        </ul>
    </div>
</div>

<main>
    <% if (p != null) { %>
    <div class="product-container">
        <div class="product-gallery">
            <img src="image_all/<%= p.getHinhAnh() %>" alt="<%= p.getTenSp() %>" />
        </div>

        <div class="product-info">
            <h1><%= p.getTenSp() %></h1>
            <p class="price">
                <span class="current-price"><fmt:formatNumber value="<%= p.getGia() %>" type="number" />đ</span>
                <% if(p.getGiamGia() > 0) { %>
                <span class="old-price">
                            <fmt:formatNumber value="<%= p.getGia() / (1 - (double)p.getGiamGia()/100) %>" type="number" />đ
                        </span>
                <span class="discount">-<%= p.getGiamGia() %>%</span>
                <% } %>
            </p>
            <p>Mã sản phẩm: <%= p.getId() %></p>
            <p>Thương hiệu: TTCERA</p>
            <p>Bảo hành: 5 năm</p>

            <div class="actions">
                <a href="Cart?id=<%= p.getId() %>">
                    <button class="add-to-cart"><i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ</button>
                </a>
                <a href="Checkout?id=<%= p.getId() %>">
                    <button class="buy"><i class="fa-solid fa-bag-shopping"></i> Đặt mua ngay</button>
                </a>
            </div>
        </div>
    </div>
    <% } else { %>
    <h2 style="text-align:center; padding: 50px;">Không tìm thấy thông tin sản phẩm!</h2>
    <% } %>

    <div class="product-detail">
        <h2>Chi tiết sản phẩm</h2>
        <p>Chất liệu: Inox 304 / Sứ cao cấp (Tùy loại)</p>
        <p>Ứng dụng: Lắp đặt trong phòng tắm, nhà vệ sinh hiện đại.</p>
        <p>- Thiết kế sang trọng, bền bỉ với thời gian.</p>
        <p>- Bề mặt chống bám bẩn, dễ dàng vệ sinh làm sạch.</p>
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