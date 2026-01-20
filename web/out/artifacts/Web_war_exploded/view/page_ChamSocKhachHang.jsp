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
  <title>Chăm sóc khách hàng</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
  <link rel="stylesheet" href="policyStyle.css" />
  <style>
    .policy-content h2 { color: #ee4d2d; margin-bottom: 15px; border-bottom: 2px solid #eee; padding-bottom: 10px; }
    .contact-box { background: #f9f9f9; padding: 20px; border-radius: 8px; text-align: center; margin-bottom: 20px; border: 1px solid #eee; }
    .contact-box i { font-size: 40px; color: #ee4d2d; margin-bottom: 10px; }
    .contact-box strong { font-size: 18px; display: block; margin: 10px 0; }
    .contact-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
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
    <h2><i class="fa-solid fa-headset"></i> CHĂM SÓC KHÁCH HÀNG</h2>

    <p>Đội ngũ hỗ trợ của chúng tôi luôn sẵn sàng giải đáp mọi thắc mắc của quý khách.</p>

    <div class="contact-grid">
      <div class="contact-box">
        <i class="fa-solid fa-phone-volume"></i>
        <strong>Hotline Tư Vấn</strong>
        <p>0909 123 456</p>
        <p>(8:00 - 21:00 hàng ngày)</p>
      </div>

      <div class="contact-box">
        <i class="fa-solid fa-envelope"></i>
        <strong>Email Hỗ Trợ</strong>
        <p>contact@thietbivesinh.vn</p>
        <p>Phản hồi trong 24h</p>
      </div>

      <div class="contact-box">
        <i class="fa-solid fa-location-dot"></i>
        <strong>Showroom Chính</strong>
        <p>Khu Phố 6, Phường Linh Trung, Thủ Đức, TP.HCM</p>
      </div>

      <div class="contact-box">
        <i class="fa-brands fa-facebook-messenger"></i>
        <strong>Chat Trực Tuyến</strong>
        <p>Fanpage: Thiết Bị Vệ Sinh</p>
      </div>
    </div>

    <h3 style="margin-top: 30px;">Gửi thắc mắc cho chúng tôi</h3>
    <form style="margin-top: 15px;">
      <input type="text" placeholder="Họ và tên" style="width: 100%; padding: 10px; margin-bottom: 10px; border: 1px solid #ddd; border-radius: 4px;">
      <input type="text" placeholder="Số điện thoại" style="width: 100%; padding: 10px; margin-bottom: 10px; border: 1px solid #ddd; border-radius: 4px;">
      <textarea rows="4" placeholder="Nội dung cần hỗ trợ..." style="width: 100%; padding: 10px; margin-bottom: 10px; border: 1px solid #ddd; border-radius: 4px;"></textarea>
      <button style="background: #ee4d2d; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer;">Gửi yêu cầu</button>
    </form>
  </div>
</main>

<footer class="footer">
  <div class="footer-container">
    <div class="footer-column"><h3>VỀ CHÚNG TÔI</h3><p>Chuyên cung cấp thiết bị vệ sinh chính hãng.</p></div>
    <div class="footer-column"><h3>LIÊN HỆ</h3><p><i class="fa-solid fa-phone"></i> 0909 123 456</p></div>
    <div class="footer-column">
      <h3>HỖ TRỢ KHÁCH HÀNG</h3>
      <ul>
        <li><a href="view/page_ChinhSachGiaoHang.jsp">Chính sách giao hàng</a></li>
        <li><a href="view/page_ChinhSachBaoHanh.jsp">Chính sách bảo hành</a></li>
        <li><a href="view/page_HuongDanThanhToan.jsp">Hướng dẫn thanh toán</a></li>
        <li><a href="view/page_ChamSocKhachHang.jsp">Chăm sóc khách hàng</a></li>
      </ul>
    </div>
    <div class="footer-column"><h3>KẾT NỐI</h3><div class="social-icons"><a href="#"><i class="fa-brands fa-facebook"></i></a></div></div>
  </div>
  <div class="footer-bottom">© 2025 Thiết Bị Vệ Sinh & Phòng Tắm.</div>
</footer>
</body>
</html>