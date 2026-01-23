<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%
        String path = request.getContextPath();
        String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    %>
    <base href="<%=basePath%>">
    <meta charset="UTF-8" />
    <title>Hướng dẫn thanh toán</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link rel="stylesheet" href="policyStyle.css" />
    <style>
        .policy-content h2 { color: #ee4d2d; margin-bottom: 15px; border-bottom: 2px solid #eee; padding-bottom: 10px; }
        .payment-method { display: flex; align-items: flex-start; margin-bottom: 20px; border: 1px solid #eee; padding: 15px; border-radius: 5px; }
        .payment-icon { font-size: 30px; color: #28a745; margin-right: 15px; width: 40px; text-align: center; }
        .payment-info h4 { margin: 0 0 5px 0; color: #333; }
        .bank-info { background: #f9f9f9; padding: 10px; margin-top: 10px; border-radius: 4px; font-family: monospace; font-size: 14px; }
    </style>
</head>
<body>

<header>
    <h1>Thiết Bị Vệ Sinh Và Phòng Tắm</h1>
    <nav>
        <form class="search-form" action="home.jsp" method="GET">
            <input type="text" name="search" placeholder="Tìm kiếm sản phẩm ..." class="search-input" />
            <button type="submit" class="search-icon"><i class="fa fa-search"></i></button>
        </form>
        <ul class="user-menu">
            <li><a href="page_ThemVaoGiohang.jsp"><i class="fa-solid fa-cart-shopping"></i> Giỏ hàng</a></li>
            <li><a href="login_page.jsp"><i class="fas fa-user"></i> Đăng nhập</a></li>
        </ul>
    </nav>
</header>

<div class="menu-container">
    <div class="sidebar"><div class="menu-title"><i class="fa fa-bars" style="margin-right:10px"></i> DANH MỤC</div></div>
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

<main style="padding-top: 20px;">
    <div class="card-section policy-content" style="padding: 40px; min-height: 500px;">
        <h2><i class="fa-regular fa-credit-card"></i> HƯỚNG DẪN THANH TOÁN</h2>

        <p>Chúng tôi cung cấp đa dạng các hình thức thanh toán để thuận tiện nhất cho quý khách:</p>

        <div class="payment-method">
            <div class="payment-icon"><i class="fa-solid fa-money-bill-wave"></i></div>
            <div class="payment-info">
                <h4>1. Thanh toán tiền mặt khi nhận hàng (COD)</h4>
                <p>Quý khách hàng sẽ thanh toán trực tiếp cho nhân viên giao hàng sau khi đã kiểm tra đầy đủ hàng hóa.</p>
            </div>
        </div>

        <div class="payment-method">
            <div class="payment-icon" style="color: #003087;"><i class="fa-brands fa-paypal"></i></div>
            <div class="payment-info">
                <h4>2. Thanh toán qua PayPal</h4>
                <p>Chúng tôi chấp nhận thanh toán quốc tế qua cổng PayPal. Quý khách vui lòng chọn phương thức này tại bước Thanh Toán trên website.</p>
            </div>
        </div>
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
                <li><a href="view/page_ChinhSachGiaoHang.jsp">Chính sách giao hàng</a></li>
                <li><a href="view/page_ChinhSachBaoHanh.jsp">Chính sách bảo hành</a></li>
                <li><a href="view/page_HuongDanThanhToan.jsp">Hướng dẫn thanh toán</a></li>
                <li><a href="view/page_ChamSocKhachHang.jsp">Chăm sóc khách hàng</a></li>
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