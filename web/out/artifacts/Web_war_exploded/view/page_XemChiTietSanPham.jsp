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
        // 1. Lấy thông tin sản phẩm
        Product p = (Product) request.getAttribute("product");
        String ten = (p != null) ? p.getTenSp() : "Chi tiết sản phẩm";

        // 2. Xử lý Logic lấy Category an toàn (Fix lỗi chuyển trang bị null)
        String currentCategory = request.getParameter("category");
        if(currentCategory == null || currentCategory.equals("null") || currentCategory.isEmpty()) {
            currentCategory = "home_sanpham"; // Mặc định nếu thiếu
        }

        // 3. Lấy Review từ Database
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
    <style>
        .rating-section {
            margin-top: 20px;
        }
        .rating-header-custom {
            display: flex;
            align-items: center;
            border-bottom: 2px solid #f1f1f1;
            padding-bottom: 15px;
            margin-bottom: 20px;
        }
        .big-score-custom {
            font-size: 40px;
            font-weight: bold;
            color: #333; /* Màu đen xám sang trọng */
            margin-right: 15px;
        }
        .star-display i {
            font-size: 20px;
            color: #f1c40f;
        }
        .review-count-custom {
            margin-left: 15px;
            color: #666;
            font-size: 14px;
        }

        /* Form viết đánh giá */
        .write-review-box {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            border: 1px solid #e9ecef;
            margin-bottom: 30px;
        }
        .btn-submit-custom {
            background-color: #0d6efd; /* Màu Xanh dương chuẩn web */
            color: white;
            border: none;
            padding: 10px 25px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 600;
            transition: 0.3s;
        }
        .btn-submit-custom:hover {
            background-color: #0b5ed7;
        }

        /* Danh sách bình luận */
        .review-item-custom {
            display: flex;
            gap: 15px;
            padding: 20px 0;
            border-bottom: 1px solid #eee;
        }
        .avatar-circle {
            width: 45px;
            height: 45px;
            background-color: #e2e6ea;
            color: #495057;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 18px;
        }
        .review-name {
            font-weight: bold;
            color: #212529;
            margin-bottom: 3px;
        }
        .review-date {
            font-size: 12px;
            color: #888;
            margin-left: 10px;
        }
        .review-content {
            margin-top: 8px;
            line-height: 1.5;
            color: #444;
        }
        /* --- CSS CHO NÚT MUA HÀNG (STYLE XANH DƯƠNG) --- */
        .btn-actions {
            display: flex;
            gap: 15px;
            margin-top: 25px;
        }

        /* Nút Thêm vào giỏ: Nền nhạt, viền xanh */
        .btn-add-cart {
            background-color: #e7f1ff; /* Xanh rất nhạt */
            color: #0d6efd; /* Chữ xanh dương */
            border: 1px solid #0d6efd;
            padding: 12px 25px;
            font-size: 16px;
            font-weight: 600;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .btn-add-cart:hover {
            background-color: #cfe2ff; /* Đậm hơn chút khi di chuột */
        }

        /* Nút Mua ngay: Nền xanh đậm nổi bật */
        .btn-buy-now {
            background-color: #0d6efd; /* Xanh dương chuẩn */
            color: white;
            border: none;
            padding: 12px 35px; /* Rộng hơn chút */
            font-size: 16px;
            font-weight: 600;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 6px rgba(13, 110, 253, 0.2); /* Đổ bóng nhẹ cho đẹp */
        }
        .btn-buy-now:hover {
            background-color: #0b5ed7; /* Xanh đậm hơn khi di chuột */
            box-shadow: 0 4px 8px rgba(13, 110, 253, 0.4);
            transform: translateY(-1px); /* Hiệu ứng nổi lên nhẹ */
        }
    </style>
</head>
<body>

<header>
    <h1>Thiết Bị Vệ Sinh Và Phòng Tắm</h1>
    <nav>
        <form class="search-form" action="home.jsp" method="GET">
            <input type="text" name="search" placeholder="Tìm kiếm sản phẩm ..." class="search-input" value="<%= (request.getParameter("search") != null) ? request.getParameter("search") : "" %>" />
            <button type="submit" class="search-icon"><i class="fa fa-search"></i></button>
        </form>
        <ul class="user-menu">
            <li><a href="page_ThemVaoGiohang.jsp"><i class="fa-solid fa-cart-shopping"></i> Giỏ hàng</a></li>
            <li><a href="login_page.jsp"><i class="fas fa-user"></i> Đăng nhập</a></li>
        </ul>
    </nav>
</header>

<div class="menu-container">
    <div class="sidebar"><div class="menu-title"><i class="fa fa-bars" style="margin-right:10px"></i> DANH MỤC SẢN PHẨM</div></div>
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

            <%-- Phần thống kê nhỏ dưới tên sản phẩm --%>
            <div class="product-stats">
                <span style="color: #f1c40f; font-weight: bold;"><%= String.format("%.1f", avgRating) %></span>
                <i class="fa fa-star" style="color: #f1c40f;"></i>
                <span class="divider">|</span>
                <span class="stat-count"><%= totalReviews %> Đánh giá</span>
            </div>

            <div class="price-box">
                <span class="current-price"><fmt:formatNumber value="<%= p.getGia() %>" type="number" />đ</span>
                <% if(p.getGiamGia() > 0) { %>
                <span class="old-price"><fmt:formatNumber value="<%= p.getGia() / (1 - (double)p.getGiamGia()/100) %>" type="number" />đ</span>
                <span class="discount-tag">GIẢM <%= p.getGiamGia() %>%</span>
                <% } %>
            </div>

            <div class="shipping-info">
                <p><i class="fa-solid fa-truck-fast"></i> Miễn phí vận chuyển nội thành TP.HCM</p>
                <p><i class="fa-solid fa-shield-halved"></i> Bảo hành chính hãng 5 năm</p>
            </div>

            <div class="btn-actions">
                <a href="Cart?id=<%= p.getId() %>&category=<%= currentCategory %>" style="text-decoration: none;">
                    <button class="btn-add-cart"><i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ hàng</button>
                </a>
                <a href="Cart?id=<%= p.getId() %>&category=<%= currentCategory %>" style="text-decoration: none;">
                    <button class="btn-buy-now"> <i class="fa-solid fa-bag-shopping"></i> Mua ngay</button>
                </a>
            </div>
        </div>
    </div>

    <div class="details-grid">
        <div class="card-section info-col">
            <div class="section-title">Thông số kỹ thuật</div>
            <div class="detail-row"><span class="label">Danh mục</span> Thiết bị vệ sinh cao cấp</div>
            <div class="detail-row"><span class="label">Thương hiệu</span> TTCERA</div>
            <div class="detail-row"><span class="label">Chất liệu</span> Men sứ Nano chống bám bẩn</div>
            <div class="detail-row"><span class="label">Xuất xứ</span> Việt Nam / Thái Lan</div>

            <div class="section-title" style="margin-top: 30px;">Mô tả chi tiết</div>
            <div class="description-text">
                <%= p.getTenSp() %> sở hữu thiết kế hiện đại, tinh tế, phù hợp với mọi không gian phòng tắm.
                Sản phẩm được sản xuất trên dây chuyền công nghệ cao, đảm bảo độ bền vượt trội và an toàn cho sức khỏe người dùng.
            </div>
        </div>

        <div class="card-section contact-col">
            <div class="contact-box">
                <h3>Liên hệ tư vấn</h3>
                <p>Nhận báo giá các phụ kiện - thiết bị</p>
                <a href="tel:0909123456" class="btn-contact phone"><i class="fa fa-phone"></i> 0909.123.456</a>
            </div>
        </div>
    </div>

    <%-- KHU VỰC ĐÁNH GIÁ --%>
    <div class="card-section rating-section">
        <h3 style="border-left: 5px solid #0d6efd; padding-left: 10px; margin-bottom: 20px;">ĐÁNH GIÁ KHÁCH HÀNG</h3>

        <div class="rating-header-custom">
            <div class="big-score-custom"><%= String.format("%.1f", avgRating) %>/5</div>
            <div class="star-display">
                <% for(int i=1; i<=5; i++) {
                    if(i <= Math.round(avgRating)) { %><i class="fa fa-star"></i><% }
            else { %><i class="fa fa-star" style="color: #ddd;"></i><% }
            } %>
            </div>
            <div class="review-count-custom">(<%= totalReviews %> nhận xét)</div>
        </div>

        <%-- Form viết đánh giá --%>
        <% User currentUser = (User) session.getAttribute("user");
            if(currentUser != null) { %>
        <div class="write-review-box">
            <h4 style="margin-top: 0; margin-bottom: 15px; color: #333;">Viết nhận xét của bạn</h4>
            <form action="Review" method="POST">
                <input type="hidden" name="productId" value="<%= p.getId() %>">
                <input type="hidden" name="category" value="<%= currentCategory %>">

                <div style="margin-bottom: 15px;">
                    <label style="font-weight: 600;">Bạn cảm thấy thế nào?</label>
                    <select name="rating" style="padding: 8px; border-radius: 4px; border: 1px solid #ced4da; margin-left: 10px;">
                        <option value="5">5 Sao - Tuyệt vời</option>
                        <option value="4">4 Sao - Hài lòng</option>
                        <option value="3">3 Sao - Bình thường</option>
                        <option value="2">2 Sao - Không thích</option>
                        <option value="1">1 Sao - Tệ</option>
                    </select>
                </div>

                <textarea name="content" rows="3" style="width: 100%; padding: 10px; border: 1px solid #ced4da; border-radius: 4px;" placeholder="Chia sẻ trải nghiệm sử dụng sản phẩm..." required></textarea>

                <div style="margin-top: 15px;">
                    <button type="submit" class="btn-submit-custom"><i class="fa fa-paper-plane"></i> Gửi đánh giá</button>
                </div>
            </form>
        </div>
        <% } else { %>
        <div style="padding: 15px; background: #e2e3e5; border-radius: 5px; margin-bottom: 30px; text-align: center; color: #383d41;">
            Vui lòng <a href="Login" style="color: #0d6efd; font-weight: bold; text-decoration: underline;">Đăng nhập</a> để viết đánh giá.
        </div>
        <% } %>

        <%-- Danh sách bình luận --%>
        <div class="review-list-custom">
            <% if (reviewList != null && !reviewList.isEmpty()) {
                for (Review r : reviewList) { %>
            <div class="review-item-custom">
                <div class="avatar-circle">
                    <%= (r.getUserFullname() != null) ? r.getUserFullname().substring(0, 1).toUpperCase() : "U" %>
                </div>
                <div style="flex: 1;">
                    <div style="display: flex; align-items: baseline;">
                        <span class="review-name"><%= r.getUserFullname() %></span>
                        <span class="review-date"><%= r.getCreatedAt() %></span>
                    </div>
                    <div style="color: #f1c40f; font-size: 12px;">
                        <% for(int k=0; k<r.getRating(); k++) { %><i class="fa fa-star"></i><% } %>
                    </div>
                    <div class="review-content"><%= r.getContent() %></div>
                </div>
            </div>
            <%   }
            } else { %>
            <div style="text-align: center; padding: 30px; color: #999;">
                <i class="fa-regular fa-comments" style="font-size: 40px; margin-bottom: 10px;"></i>
                <p>Chưa có đánh giá nào cho sản phẩm này.</p>
            </div>
            <% } %>
        </div>
    </div>

    <% } else { %>
    <div class="card-section" style="text-align: center; padding: 100px;">
        <h2>Không tìm thấy sản phẩm này!</h2>
        <a href="Home" style="color: #0d6efd;">Quay lại trang chủ</a>
    </div>
    <% } %>
</main>

<footer class="footer">
    <div class="footer-container">
        <div class="footer-column"><h3>VỀ CHÚNG TÔI</h3><p>Chuyên cung cấp thiết bị vệ sinh chính hãng, giá tốt nhất thị trường.</p></div>
        <div class="footer-column"><h3>LIÊN HỆ</h3><p><i class="fa-solid fa-phone"></i> 0909 123 456</p><p><i class="fa-solid fa-envelope"></i> contact@thietbivesinh.vn</p></div>
        <div class="footer-column">
            <h3>HỖ TRỢ KHÁCH HÀNG</h3>
            <ul>
                <li><a href="#">Chính sách giao hàng</a></li>
                <li><a href="#">Chính sách bảo hành</a></li>
                <li><a href="#">Hướng dẫn thanh toán</a></li>
                <li><a href="#">Chăm sóc khách hàng</a></li>
            </ul>
        </div>
        <div class="footer-column"><h3>KẾT NỐI</h3><div class="social-icons"><a href="https://www.facebook.com/huuthang11092005" target="_blank"><i class="fa-brands fa-facebook"></i></a></div></div>
    </div>
    <div class="footer-bottom">© 2025 Thiết Bị Vệ Sinh & Phòng Tắm - All Rights Reserved.</div>
</footer>
</body>
</html>