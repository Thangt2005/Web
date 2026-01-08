<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Product" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%
        String path = request.getContextPath();
        String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    %>
    <base href="<%=basePath%>">
    <meta charset="UTF-8" />
    <%
        Product p = (Product) request.getAttribute("product");
        String ten = (p != null) ? p.getTenSp() : "Chi tiết sản phẩm";
    %>
    <title><%= ten %></title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link rel="stylesheet" href="css_TrangChiTiet.css" />
</head>
<body>

<header>
    <h1>Thiết Bị Vệ Sinh Và Phòng Tắm</h1>
    <nav>
        <form class="search-form" action="home.jsp" method="GET">
            <input
                    type="text"
                    name="search"
                    placeholder="Tìm kiếm sản phẩm ..."
                    class="search-input"
                    value="<%= (request.getParameter("search") != null) ? request.getParameter("search") : "" %>"
            />
            <button type="submit" class="search-icon">
                <i class="fa fa-search"></i>
            </button>
        </form>

        <ul class="user-menu">
            <li>
                <a href="page_ThemVaoGiohang.jsp">
                    <i class="fa-solid fa-cart-shopping"></i> Giỏ hàng
                </a>
            </li>
            <li>
                <a href="login_page.jsp">
                    <i class="fas fa-user"></i> Đăng nhập
                </a>
            </li>
        </ul>
    </nav>
</header>

<div class="menu-container">
    <div class="sidebar">
        <div class="menu-title">
            <i class="fa fa-bars" style="margin-right:10px"></i> DANH MỤC SẢN PHẨM
        </div>
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

<main>
    <% if (p != null) { %>
    <div class="card-section product-briefing">
        <div class="product-gallery">
            <img src="image_all/<%= p.getHinhAnh() %>" alt="<%= p.getTenSp() %>" />
        </div>

        <div class="product-main-info">
            <h1 class="product-title"><%= p.getTenSp() %></h1>

            <div class="product-stats">
                <span class="rating-score">5.0</span>
                <div class="stars">
                    <i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i>
                </div>
                <span class="divider">|</span>
                <span class="stat-count">128 Đánh giá</span>
                <span class="divider">|</span>
                <span class="stat-count">456 Đã bán</span>
            </div>

            <div class="price-box">
                <span class="current-price"><fmt:formatNumber value="<%= p.getGia() %>" type="number" />đ</span>
                <% if(p.getGiamGia() > 0) { %>
                <span class="old-price">
                        <fmt:formatNumber value="<%= p.getGia() / (1 - (double)p.getGiamGia()/100) %>" type="number" />đ
                    </span>
                <span class="discount-tag">GIẢM <%= p.getGiamGia() %>%</span>
                <% } %>
            </div>

            <div class="shipping-info">
                <p><i class="fa-solid fa-truck-fast"></i> Vận chuyển: Miễn phí vận chuyển cho đơn hàng trên 5 triệu</p>
            </div>

            <div class="btn-actions">
                <a href="Cart?id=<%= p.getId() %>&category=<%= request.getParameter("category") %>" style="text-decoration: none;">
                    <button class="btn-add-cart"><i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ hàng</button>
                </a>
                <a href="Cart?id=<%= p.getId() %>&category=<%= request.getParameter("category") %>" style="text-decoration: none;">
                    <button class="btn-buy-now"> <i class="fa-solid fa-bag-shopping"></i> Mua ngay</button>
                </a>
            </div>
        </div>
    </div>

    <div class="details-grid">
        <div class="card-section info-col">
            <div class="section-title">Chi tiết sản phẩm</div>
            <div class="detail-row"><span class="label">Danh mục</span> Thiết bị vệ sinh cao cấp</div>
            <div class="detail-row"><span class="label">Thương hiệu</span> TTCERA</div>
            <div class="detail-row"><span class="label">Bảo hành</span> 5 năm</div>
            <div class="detail-row"><span class="label">Kho hàng</span> 250 sản phẩm</div>

            <div class="section-title" style="margin-top: 30px;">Mô tả sản phẩm</div>
            <div class="description-text">
                <%= p.getTenSp() %> mang đến vẻ đẹp hiện đại cho căn phòng tắm của anh.
                Sản phẩm được làm từ chất liệu cao cấp, chống bám bẩn và dễ vệ sinh.
                Sự lựa chọn hoàn hảo cho nhà phố và chung cư sang trọng.
            </div>
        </div>

        <div class="card-section contact-col">
            <div class="contact-box">
                <h3>Tư vấn sản phẩm</h3>
                <p>Liên hệ hotline để nhận báo giá tốt nhất!</p>
                <a href="tel:0909123456" class="btn-contact phone"><i class="fa fa-phone"></i> 0909.123.456</a>
            </div>
        </div>
    </div>

    <div class="card-section rating-section">
        <div class="section-title">ĐÁNH GIÁ SẢN PHẨM</div>
        <div class="rating-header">
            <div class="rating-summary">
                <div class="big-score">5.0 <span style="font-size: 16px;">trên 5</span></div>
                <div class="stars" style="font-size: 20px;"><i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i></div>
            </div>
            <div class="filter-btns">
                <button class="active">Tất cả</button>
                <button>5 Sao (120)</button>
                <button>Có Bình luận (85)</button>
                <button>Có Hình ảnh (40)</button>
            </div>
        </div>

        <div class="comment-item">
            <div class="user-avt"></div>
            <div class="comment-body">
                <p class="username">Khách hàng ẩn danh</p>
                <div class="stars small"><i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i></div>
                <p class="text">Sản phẩm rất tốt, đóng gói cẩn thận. Shop phục vụ chuyên nghiệp.</p>
            </div>
        </div>
    </div>

    <% } else { %>
    <div class="card-section" style="text-align: center; padding: 100px;">
        <h2>Không tìm thấy sản phẩm này!</h2>
        <a href="Home" style="color: #ee4d2d;">Quay lại trang chủ</a>
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