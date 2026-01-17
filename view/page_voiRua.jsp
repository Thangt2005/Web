<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>
<%@ page import="model.User" %> <%-- 1. Bắt buộc import User --%>

<%
    // --- 2. XỬ LÝ LOGIC KIỂM TRA SESSION CHUẨN ---
    Object sessionObj = session.getAttribute("user");

    String displayName = "";
    boolean isLoggedIn = false;
    boolean isAdmin = false;

    if (sessionObj != null) {
        isLoggedIn = true;

        if (sessionObj instanceof User) {
            User u = (User) sessionObj;
            displayName = u.getUsername();
            if (u.getRole() == 1) {
                isAdmin = true;
            }
        } else if (sessionObj instanceof String) {
            displayName = (String) sessionObj;
            isAdmin = false;
        }
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%
        String path = request.getContextPath();
        String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    %>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <title>Sản Phẩm Vòi Rửa</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="homeStyle.css">
    <script src="js/main.js"></script>
</head>
<body>

<header>
    <h1>Thiết Bị Vệ Sinh Và Phòng Tắm</h1>
    <nav>
        <form class="search-form" method="get" action="VoiRua" autocomplete="off">
            <input type="text" id="search-input" name="search" class="search-input"
                   placeholder="Tìm kiếm vòi rửa..."
                   value="<%= (request.getAttribute("txtSearch") != null) ? request.getAttribute("txtSearch") : "" %>"
                   onkeyup="searchProducts(this)"> <button class="search-icon"><i class="fa fa-search"></i></button>

            <ul id="suggestion-box" class="suggestion-box"></ul>
        </form>

        <ul class="user-menu">
            <li><a href="Cart"><i class="fa-solid fa-cart-shopping"></i> Giỏ hàng</a></li>

            <% if (isLoggedIn) { %>
            <%-- 3. Hiện nút Admin nếu là Admin --%>
            <% if (isAdmin) { %>
            <li>
                <a href="Admin" style="color: #ff4757; font-weight: bold;">
                    <i class="fas fa-user-shield"></i> Quản Trị
                </a>
            </li>
            <% } %>

            <li>
                <a href="#" style="font-weight: bold; color: yellow;">
                    <i class="fas fa-user"></i> Xin chào, <%= displayName %>
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
                    <i class="fas fa-user"></i> Đăng nhập
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

            <%-- 4. Active đúng tab Vòi Rửa --%>
            <li><a href="VoiRua" class="active">Vòi Rửa</a></li>

            <li><a href="BonTieuNam">Bồn Tiểu Nam</a></li>
            <li><a href="PhuKien">Phụ Kiện</a></li>

            <% if (isAdmin) { %>
            <li><a href="Admin" style="color: yellow; font-weight: bold;">Admin</a></li>
            <% } %>
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
    <h2>Sản phẩm Vòi Rửa</h2>
    <% } %>

    <div class="product-grid">
        <%
            List<Product> list = (List<Product>) request.getAttribute("productList");
            if (list != null && !list.isEmpty()) {
                for (Product p : list) {
        %>
        <div class="product-card">
            <%-- 5. Sửa đường dẫn ảnh --%>
            <img src="../image_all/<%= p.getHinhAnh() %>" alt="<%= p.getTenSp() %>" onerror="this.src='https://via.placeholder.com/200?text=No+Image'">

            <h3><a href="ProductDetail?id=<%= p.getId() %>&category=voirua_sanpham">
                <%= p.getTenSp() %>
            </a>
            </h3>
            <p class="price">
                <%= String.format("%,.0f", p.getGia()) %>đ
                <span class="discount">-<%= p.getGiamGia() %>%</span>
            </p>
            <div class="button-group">
                <button class="add-to-cart" type="button"
                        onclick="window.location.href='Cart?id=<%= p.getId() %>&category=voirua_sanpham'">
                    <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ
                </button>
                <button class="buy" type="button"
                        onclick="window.location.href='Cart?id=<%= p.getId() %>&category=voirua_sanpham'">
                    <i class="fa-solid fa-bag-shopping"></i> Đặt mua
                </button>
            </div>
        </div>
        <%
            }
        } else {
        %>
        <div style="text-align: center; width: 100%; padding: 40px; color: #666;">
            <i class="fa-solid fa-box-open" style="font-size: 40px; margin-bottom: 10px;"></i>
            <p>Không tìm thấy sản phẩm nào!</p>
        </div>
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

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    // Hàm gọi tìm kiếm
    function searchProducts(input) {
        let keyword = input.value.trim();
        let suggestionBox = document.getElementById("suggestion-box");

        // Nếu từ khóa quá ngắn thì ẩn đi
        if (keyword.length < 2) {
            suggestionBox.style.display = "none";
            suggestionBox.innerHTML = "";
            return;
        }

        $.ajax({
            url: "SearchSuggest",
            type: "GET",
            data: { keyword: keyword },
            success: function (response) {
                if (response.trim() !== "") {
                    suggestionBox.innerHTML = response;
                    suggestionBox.style.display = "block";
                } else {
                    suggestionBox.style.display = "none";
                }
            },
            error: function () {
                console.log("Lỗi tìm kiếm gợi ý");
            }
        });
    }

    // Ẩn gợi ý khi click ra ngoài
    document.addEventListener('click', function(e) {
        let searchForm = document.querySelector('.search-form');
        let suggestionBox = document.getElementById("suggestion-box");
        if (!searchForm.contains(e.target)) {
            suggestionBox.style.display = 'none';
        }
    });
</script>
</body>
</html>