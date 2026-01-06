<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%
        String path = request.getContextPath();
        String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    %>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <title>Sản Phẩm Bồn Cầu</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="homeStyle.css">
</head>
<body>

<header>
    <h1>Thiết Bị Vệ Sinh Và Phòng Tắm</h1>
    <nav>
        <form class="search-form" method="get" action="Toilet">
            <input type="text" name="search" class="search-input" placeholder="Tìm kiếm bồn cầu..."
                   value="<%= (request.getAttribute("txtSearch") != null) ? request.getAttribute("txtSearch") : "" %>">
            <button class="search-icon"><i class="fa fa-search"></i></button>
        </form>

        <ul class="user-menu">
            <li><a href="Cart"><i class="fa-solid fa-cart-shopping"></i> Giỏ hàng</a></li>

            <%
                // CODE MỚI: Kiểm tra session user
                String username = (String) session.getAttribute("user");
                if (username != null && !username.isEmpty()) {
            %>
            <li>
                <a href="#" style="font-weight: bold; color: yellow;">
                    <i class="fas fa-user"></i> Xin chào, <%= username %>
                </a>
            </li>
            <li>
                <a href="Logout">
                    <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
                </a>
            </li>
            <%
            } else {
            %>
            <li>
                <a href="view/login_page.jsp">
                    <i class="fa-solid fa-user"></i> Đăng nhập
                </a>
            </li>
            <%
                }
            %>
        </ul>
    </nav>
</header>

<div class="menu-container">
    <div class="sidebar">
        <div class="menu-title"><i class="fa fa-bars"></i> DANH MỤC SẢN PHẨM</div>
    </div>
    <div class="top-menu">
        <ul>
            <li><a href="Home" class="active">Trang chủ</a></li>
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
            <li><a href="Admin">Admin</a></li>
        </ul>
    </div>
</div>

<main class="main-content">
    <%
        String search = (String) request.getAttribute("txtSearch");
        if (search != null && !search.isEmpty()) {
    %>
    <h2>Kết quả tìm kiếm cho: "<%= search %>"</h2>
    <% } else { %>
    <h2>Sản phẩm Bồn Cầu Nổi Bật</h2>
    <% } %>

    <div class="product-grid">
        <%
            List<Product> list = (List<Product>) request.getAttribute("productList");
            if (list != null && !list.isEmpty()) {
                for (Product p : list) {
        %>
        <div class="product-card">
            <%-- Đã cập nhật: Lấy link trực tiếp từ database --%>
            <img src="<%= p.getHinhAnh() %>" alt="<%= p.getTenSp() %>">

            <h3><a href="TrangChiTiet.jsp?id=<%= p.getId() %>"><%= p.getTenSp() %></a></h3>
            <p class="price">
                <%= String.format("%,.0f", p.getGia()) %>đ
                <span class="discount">-<%= p.getGiamGia() %>%</span>
            </p>
            <div class="button-group">
                <a href="page_ThemVaoGiohang.jsp?id=<%= p.getId() %>">
                    <button class="add-to-cart"><i class="fa-solid fa-cart-plus"></i> Thêm</button>
                </a>
                <button class="buy">Mua</button>
            </div>
        </div>
        <%
            }
        } else {
        %>
        <p style="text-align: center; width: 100%;">Không tìm thấy sản phẩm nào!</p>
        <% } %>
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