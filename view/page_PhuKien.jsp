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
    <title>Sản Phẩm Tủ Phụ Kiện</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="homeStyle.css">
    <script src="js/main.js"></script>
</head>
<body>

<header>
    <h1>Thiết Bị Vệ Sinh Và Phòng Tắm</h1>
    <nav>
        <div class="search-container" style="position: relative;">
            <form class="search-form" action="PhuKien" method="GET" id="searchForm">
                <input
                        type="text"
                        id="search-input"
                        name="search"
                        placeholder="Tìm kiếm phụ kiện..."
                        class="search-input"
                        autocomplete="off"
                        value="<%= (request.getAttribute("txtSearch") != null) ? request.getAttribute("txtSearch") : "" %>"
                        onkeyup="searchProducts(this)"
                />
                <button type="submit" class="search-icon">
                    <i class="fa fa-search"></i>
                </button>
            </form>
            <div id="suggestion-box" class="suggestion-box"></div>
        </div>

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
            <li><a href="Logout"><i class="fa-solid fa-right-from-bracket"></i> Đăng xuất</a></li>
            <% } else { %>
            <li><a href="view/login_page.jsp"><i class="fa-solid fa-user"></i> Đăng nhập</a></li>
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
    <h2>Sản phẩm Phụ Kiện</h2>
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

            <h3><a href="ProductDetail?id=<%= p.getId() %>&category=phukien_sanpham">
                <%= p.getTenSp() %>
            </a>
            </h3>
            <p class="price">
                <%= String.format("%,.0f", p.getGia()) %>đ
                <span class="discount">-<%= p.getGiamGia() %>%</span>
            </p>
            <<div class="button-group">
                <button class="add-to-cart" type="button"
                        onclick="window.location.href='Cart?id=<%= p.getId() %>&category=phukien_sanpham'">
                    <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ
                </button>
                <button class="buy" type="button"
                        onclick="window.location.href='Cart?id=<%= p.getId() %>&category=phukien_sanpham'">
                    <i class="fa-solid fa-bag-shopping"></i> Đặt mua
                </button>
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

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> <script>
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
            url: "SearchSuggest", // Gọi đến Servlet
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

    // Hàm khi click vào một gợi ý -> Chuyển hướng đến trang chi tiết
    function selectProduct(id, tableName) {
        // Chuyển hướng đến trang chi tiết sản phẩm (Cập nhật đường dẫn cho đúng logic của bạn)
        window.location.href = "ProductDetail?id=" + id + "&table=" + tableName;
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