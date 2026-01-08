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
    <title>Sản Phẩm Phụ Kiện</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="homeStyle.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="js/main.js"></script>
</head>
<body>

<header>
    <h1>Thiết Bị Vệ Sinh Và Phòng Tắm</h1>
    <nav>
        <form class="search-form" method="get" action="Combo" autocomplete="off">
            <input type="text" id="search-input" name="search" class="search-input"
                   placeholder="Tìm kiếm com bo..."
                   value="<%= (request.getAttribute("txtSearch") != null) ? request.getAttribute("txtSearch") : "" %>"
                   onkeyup="searchProducts(this)">
            <button type="submit" class="search-icon"><i class="fa fa-search"></i></button>

            <ul id="suggestion-box" class="suggestion-box"></ul>
        </form>

        <ul class="user-menu">
            <li><a href="Cart"><i class="fa-solid fa-cart-shopping"></i> Giỏ hàng</a></li>

            <%
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
            <% } else { %>
            <li>
                <a href="view/login_page.jsp">
                    <i class="fa-solid fa-user"></i> Đăng nhập
                </a>
            </li>
            <% } %>
        </ul>
    </nav>
</header>

<div class="menu-container">
    <div class="sidebar">
        <div class="menu-title"><i class="fa fa-bars"></i> DANH MỤC SẢN PHẨM</div>
    </div>
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
            <li><a href="PhuKien" class="active">Phụ Kiện</a></li>
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
    <h2>Sản phẩm Phụ Kiện Nổi Bật</h2>
    <% } %>

    <div class="product-grid">
        <%
            List<Product> list = (List<Product>) request.getAttribute("productList");
            if (list != null && !list.isEmpty()) {
                for (Product p : list) {
        %>
        <div class="product-card">
            <img src="<%= p.getHinhAnh() %>" alt="<%= p.getTenSp() %>" onerror="this.src='https://via.placeholder.com/200?text=No+Image'">

            <h3><a href="ProductDetail?id=<%= p.getId() %>"><%= p.getTenSp() %></a></h3>
            <p class="price">
                <%= String.format("%,.0f", p.getGia()) %>đ
                <span class="discount">-<%= p.getGiamGia() %>%</span>
            </p>
            <div class="button-group">
                <button class="add-to-cart" type="button" onclick="window.location.href='Cart?id=<%= p.getId() %>'">
                    <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ
                </button>

                <button class="buy" type="button" onclick="muaNgay(<%= p.getId() %>)">
                    <i class="fa-solid fa-bag-shopping"></i> Đặt mua
                </button>
            </div>
        </div> <%
        }
    } else {
    %>
        <div style="text-align: center; width: 100%; padding: 50px;">
            <i class="fa-solid fa-magnifying-glass" style="font-size: 40px; color: #ccc;"></i>
            <p>Không tìm thấy sản phẩm nào!</p>
        </div>
        <% } %>
    </div>
</main>

<footer class="footer">
    <div class="footer-bottom">
        © 2025 Thiết Bị Vệ Sinh & Phòng Tắm - All Rights Reserved.
    </div>
</footer>

<script>
    // Hàm xử lý gợi ý tìm kiếm
    function searchProducts(input) {
        let keyword = input.value.trim();
        let suggestionBox = document.getElementById("suggestion-box");

        if (keyword.length < 2) {
            suggestionBox.style.display = "none";
            return;
        }

        $.ajax({
            url: "SearchSuggest", // Servlet xử lý gợi ý
            type: "GET",
            data: { keyword: keyword },
            success: function (data) {
                suggestionBox.innerHTML = data;
                suggestionBox.style.display = "block";
            }
        });
    }
</script>
</body>
</html>