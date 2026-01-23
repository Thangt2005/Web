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
    <title>Chính sách giao hàng</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link rel="stylesheet" href="policyStyle.css" />
    <style>
        .policy-content h2 { color: #ee4d2d; margin-bottom: 15px; border-bottom: 2px solid #eee; padding-bottom: 10px; }
        .policy-content h3 { margin-top: 20px; color: #333; }
        .policy-content p, .policy-content li { line-height: 1.6; color: #555; margin-bottom: 10px; }
        .policy-content ul { padding-left: 20px; }
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
    <div class="sidebar">
        <div class="menu-title"><i class="fa fa-bars" style="margin-right:10px"></i> DANH MỤC</div>
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
            <li><a href="PhuKien">Phụ Kiện</a></li>
        </ul>
    </div>
</div>

<main style="padding-top: 20px;">
    <div class="card-section policy-content" style="padding: 40px; min-height: 500px;">
        <h2><i class="fa-solid fa-truck-fast"></i> CHÍNH SÁCH GIAO HÀNG</h2>

        <h3>1. Phạm vi giao hàng</h3>
        <p>Chúng tôi hỗ trợ giao hàng trên toàn quốc. Đối với khu vực nội thành TP.HCM, chúng tôi cam kết giao hàng trong ngày.</p>

        <h3>2. Phí vận chuyển</h3>
        <ul>
            <li><strong>Miễn phí vận chuyển:</strong> Cho tất cả đơn hàng có giá trị từ 5.000.000đ trở lên.</li>
            <li><strong>Phí giao hàng tiêu chuẩn:</strong> 30.000đ cho đơn hàng dưới 5.000.000đ (Nội thành).</li>
            <li><strong>Ngoại thành & Tỉnh:</strong> Phí vận chuyển sẽ được tính theo đơn giá của đơn vị vận chuyển (GHTK, Viettel Post...).</li>
        </ul>

        <h3>3. Thời gian giao hàng</h3>
        <p>Thời gian giao hàng dự kiến từ 1 - 5 ngày làm việc tùy thuộc vào địa chỉ nhận hàng của quý khách.</p>

        <h3>4. Kiểm tra hàng hóa</h3>
        <p>Quý khách được quyền kiểm tra hàng hóa (đồng kiểm) trước khi thanh toán. Nếu sản phẩm bị lỗi hoặc bể vỡ do vận chuyển, vui lòng từ chối nhận hàng và liên hệ ngay hotline 0909.123.456.</p>
    </div>
</main>

<footer class="footer">
    <div class="footer-container">
        <div class="footer-column">
            <h3>VỀ CHÚNG TÔI</h3>
            <p>Chuyên cung cấp thiết bị vệ sinh chính hãng.</p>
        </div>
        <div class="footer-column">
            <h3>LIÊN HỆ</h3>
            <p><i class="fa-solid fa-phone"></i> 0909 123 456</p>
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
            <div class="social-icons">
                <a href="#"><i class="fa-brands fa-facebook"></i></a>
            </div>
        </div>
    </div>
    <div class="footer-bottom">© 2025 Thiết Bị Vệ Sinh & Phòng Tắm.</div>
</footer>
</body>
</html>