<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Product" %>
<%@ page import="model.Review" %>
<%@ page import="model.User" %>
<%@ page import="services.ReviewService" %>
<%@ page import="java.util.List" %>
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
        User authUser = (User) session.getAttribute("user");
        boolean isLoggedIn = (authUser != null);

        Product p = (Product) request.getAttribute("product");
        String ten = (p != null) ? p.getTenSp() : "Chi tiết sản phẩm";
        String currentCategory = request.getParameter("category");
        if(currentCategory == null || currentCategory.equals("null")) currentCategory = "home_sanpham";

        ReviewService reviewService = new ReviewService();
        List<Review> reviewList = null;
        double avgRating = 0;
        int totalReviews = 0;
        if (p != null) {
            reviewList = reviewService.getReviewsByProduct(p.getId(), currentCategory);
            avgRating = reviewService.getAverageRating(p.getId(), currentCategory);
            totalReviews = (reviewList != null) ? reviewList.size() : 0;
        }
    %>
    <title><%= ten %></title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link rel="stylesheet" href="css_TrangChiTiet.css" />
</head>
<body>

<header>
    <div class="header-content">
        <h1><a href="Home">Thiết Bị Vệ Sinh Và Phòng Tắm</a></h1>

        <div class="search-box">
            <form class="search-form" action="Home" method="GET">
                <input type="text" name="search" class="search-input" placeholder="Tìm kiếm sản phẩm ..." value="<%= (request.getParameter("search") != null) ? request.getParameter("search") : "" %>" />
                <button type="submit" class="search-btn"><i class="fa fa-search"></i></button>
            </form>
        </div>

        <ul class="user-actions">
            <li>
                <a href="Cart"><i class="fa-solid fa-cart-shopping"></i> Giỏ hàng</a>
            </li>

            <% if (isLoggedIn) { %>
            <li>
                <a href="Logout"><i class="fa-solid fa-right-from-bracket"></i> Đăng xuất</a>
            </li>
            <% } else { %>
            <li>
                <a href="view/login_page.jsp"><i class="fas fa-user"></i> Đăng nhập</a>
            </li>
            <% } %>
        </ul>
    </div>
</header>

<div class="main-navigation">
    <div class="nav-container">
        <div class="category-label">
            <i class="fa fa-bars"></i> DANH MỤC SẢN PHẨM
        </div>
        <ul class="nav-menu">
            <li><a href="Home" class="active">Trang chủ</a></li>
            <li><a href="Combo">Combo</a></li>
            <li><a href="Toilet">Bồn Cầu</a></li>
            <li><a href="Lavabo">Lavabo</a></li>
            <li><a href="TuLavabo">Tủ Lavabo</a></li>
            <li><a href="VoiSenTam">Sen Tắm</a></li>
            <li><a href="ChauRuaChen">Chậu Rửa</a></li>
            <li><a href="BonTam">Bồn Tắm</a></li>
            <li><a href="VoiRua">Vòi Rửa</a></li>
            <li><a href="PhuKien">Phụ Kiện</a></li>
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
                <span style="color:#d70018; font-weight:bold;"><%= String.format("%.1f", avgRating) %> <i class="fa fa-star" style="color:#ffcc00"></i></span>
                | <span><%= totalReviews %> Đánh giá</span>
            </div>

            <div class="price-box">
                <span class="current-price"><fmt:formatNumber value="<%= p.getGia() %>" type="number" />đ</span>
                <% if(p.getGiamGia() > 0) { %>
                <span class="old-price"><fmt:formatNumber value="<%= p.getGia() / (1 - (double)p.getGiamGia()/100) %>" type="number" />đ</span>
                <span class="discount-tag">-<%= p.getGiamGia() %>%</span>
                <% } %>
            </div>

            <div class="shipping-info">
                <p><i class="fa-solid fa-truck-fast"></i> Miễn phí vận chuyển nội thành TP.HCM</p>
                <p><i class="fa-solid fa-shield-halved"></i> Bảo hành chính hãng 5 năm</p>
            </div>

            <div class="btn-actions">
                <a href="Cart?id=<%= p.getId() %>&category=<%= currentCategory %>" class="btn-add-cart">
                    <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ
                </a>
                <a href="Cart?id=<%= p.getId() %>&category=<%= currentCategory %>" class="btn-buy-now">
                    <i class="fa-solid fa-bag-shopping"></i> Mua ngay
                </a>
            </div>
        </div>
    </div>

    <div class="details-grid">
        <div class="card-section info-col">
            <div class="section-title">THÔNG SỐ KỸ THUẬT</div>
            <div class="detail-row"><span class="label">Danh mục:</span> Thiết bị vệ sinh cao cấp</div>
            <div class="detail-row"><span class="label">Thương hiệu:</span> TTCERA</div>
            <div class="detail-row"><span class="label">Chất liệu:</span> Men sứ Nano chống bám bẩn</div>
            <div class="detail-row"><span class="label">Xuất xứ:</span> Việt Nam / Thái Lan</div>

            <div class="section-title" style="margin-top: 30px;">MÔ TẢ CHI TIẾT</div>
            <div class="description-text">
                <%= (p.getMoTa() != null && !p.getMoTa().isEmpty()) ? p.getMoTa() : "Thông tin sản phẩm đang được cập nhật." %>
            </div>
        </div>

        <div class="card-section contact-col">
            <div class="contact-box">
                <h3>LIÊN HỆ TƯ VẤN</h3>
                <p>Nhận báo giá chi tiết</p>
                <a href="tel:0909123456" class="btn-phone"><i class="fa fa-phone"></i> 0909.123.456</a>
            </div>
        </div>
    </div>

    <div class="card-section rating-section">
        <div class="section-title">ĐÁNH GIÁ KHÁCH HÀNG</div>

        <div class="rating-header-custom">
            <div class="big-score-custom"><%= String.format("%.1f", avgRating) %>/5</div>
            <div class="star-display">
                <% for(int i=1; i<=5; i++) {
                    if(i <= Math.round(avgRating)) { %><i class="fa fa-star" style="color:#ffcc00"></i><% }
            else { %><i class="fa fa-star" style="color:#ddd;"></i><% }
            } %>
            </div>
            <div>(<%= totalReviews %> nhận xét)</div>
        </div>

        <% if(isLoggedIn) { %>
        <div style="margin-bottom: 30px; background: #f9f9f9; padding: 20px; border-radius: 8px;">
            <h4 style="margin-top:0;">Viết nhận xét</h4>
            <form action="Review" method="POST">
                <input type="hidden" name="productId" value="<%= p.getId() %>">
                <input type="hidden" name="category" value="<%= currentCategory %>">
                <select name="rating" style="padding: 8px; margin-bottom: 10px;">
                    <option value="5">5 Sao - Tuyệt vời</option>
                    <option value="4">4 Sao - Hài lòng</option>
                    <option value="3">3 Sao - Bình thường</option>
                    <option value="1">1 Sao - Tệ</option>
                </select>
                <textarea name="content" rows="3" style="width:100%; padding:10px;" placeholder="Nhập nội dung..." required></textarea>
                <button type="submit" class="btn-submit-custom" style="margin-top:10px;">Gửi đánh giá</button>
            </form>
        </div>
        <% } else { %>
        <div style="padding: 15px; background: #f8d7da; color: #721c24; border-radius: 5px; margin-bottom: 20px;">
            Vui lòng <a href="view/login_page.jsp" style="font-weight: bold; text-decoration: underline;">Đăng nhập</a> để viết đánh giá.
        </div>
        <% } %>

        <% if (reviewList != null && !reviewList.isEmpty()) {
            for (Review r : reviewList) { %>
        <div class="review-item-custom">
            <div class="avatar-circle">
                <%= (r.getUserFullname() != null) ? r.getUserFullname().substring(0, 1).toUpperCase() : "U" %>
            </div>
            <div>
                <div style="font-weight:bold;"><%= r.getUserFullname() %></div>
                <div style="font-size:12px; color:#d70018;">
                    <% for(int k=0; k<r.getRating(); k++) { %><i class="fa fa-star"></i><% } %>
                </div>
                <div style="margin-top:5px;"><%= r.getContent() %></div>
            </div>
        </div>
        <%   }
        } else { %>
        <p style="text-align:center; color:#999;">Chưa có đánh giá nào.</p>
        <% } %>
    </div>

    <% } else { %>
    <div style="text-align: center; padding: 100px;">
        <h2>Không tìm thấy sản phẩm!</h2>
        <a href="Home" style="color: #0d6efd;">Về trang chủ</a>
    </div>
    <% } %>
</main>

<footer class="footer">
    <div class="footer-container">
        <div class="footer-column">
            <h3>VỀ CHÚNG TÔI</h3>
            <p>Chuyên cung cấp thiết bị vệ sinh, phòng tắm chính hãng, giá tốt nhất thị trường.</p>
        </div>
        <div class="footer-column">
            <h3>LIÊN HỆ</h3>
            <ul>
                <li><i class="fa fa-phone"></i> 0909 123 456</li>
                <li><i class="fa fa-envelope"></i> contact@thietbivesinh.vn</li>
                <li><i class="fa-solid fa-location-dot"></i> TP. Hồ Chí Minh</li>
            </ul>
        </div>
        <div class="footer-column">
            <h3>HỖ TRỢ KHÁCH HÀNG</h3>
            <ul>
                <li><a href="view/page_ChinhSachGiaoHang.jsp">Chính sách giao hàng</a></li>
                <li><a href="view/page_ChinhSachBaoHanh.jsp">Chính sách bảo hành</a></li>
                <li><a href="view/page_HuongDanThanhToan.jsp">Hướng dẫn thanh toán</a></li>
                <li><a href="view/page_ChamSocKhachHang.jsp">Chăm sóc khách hàng</a></li>
            </ul>
        </div>
        <div class="footer-column">
            <h3>KẾT NỐI</h3>
            <div class="social-icons" style="display: flex; gap: 10px;">
                <a href="https://www.facebook.com/huuthang11092005" target="_blank"><i class="fa-brands fa-facebook"></i></a>
                <a href="https://www.youtube.com/@huuthangtran9024/posts" target="_blank"><i class="fa-brands fa-youtube"></i></a>
                <a href="https://www.tiktok.com/@thangtt26" target="_blank"><i class="fa-brands fa-tiktok"></i></a>
            </div>
        </div>
    </div>
    <div class="footer-bottom">© 2025 Thiết Bị Vệ Sinh & Phòng Tắm - All Rights Reserved.</div>
</footer>

</body>
</html>