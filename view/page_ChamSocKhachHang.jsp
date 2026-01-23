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
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

  <link rel="stylesheet" href="policyStyle.css" />

  <style>
    .contact-box { background: #f9f9f9; padding: 20px; border-radius: 8px; text-align: center; margin-bottom: 20px; border: 1px solid #eee; transition: 0.3s; }
    .contact-box:hover { transform: translateY(-5px); box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
    .contact-box i { font-size: 40px; color: #d70018; margin-bottom: 10px; }
    .contact-box strong { font-size: 18px; display: block; margin: 10px 0; }
    .contact-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-top: 20px; }

    .form-input { width: 100%; padding: 12px; margin-bottom: 15px; border: 1px solid #ddd; border-radius: 4px; outline: none; }
    .form-input:focus { border-color: #ffcc00; }
    .btn-submit { background: #d70018; color: white; border: none; padding: 12px 30px; border-radius: 4px; cursor: pointer; font-weight: bold; transition: 0.3s; }
    .btn-submit:hover { background: #a00000; }
  </style>
</head>
<body>

<header>
  <h1>Thiết Bị Vệ Sinh Và Phòng Tắm</h1>
  <nav>
    <form class="search-form" action="Home" method="GET">
      <input type="text" name="search" placeholder="Tìm kiếm sản phẩm ..." class="search-input" />
      <button type="submit" class="search-icon"><i class="fa fa-search"></i></button>
    </form>
    <ul class="user-menu">
      <li><a href="Cart"><i class="fa-solid fa-cart-shopping"></i> Giỏ hàng</a></li>
      <li><a href="view/login_page.jsp"><i class="fas fa-user"></i> Đăng nhập</a></li>
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
  <div class="policy-content" style="padding: 40px; min-height: 500px; background: white; max-width: 1100px; margin: 0 auto; border-radius: 8px;">
    <h2><i class="fa-solid fa-headset"></i> CHĂM SÓC KHÁCH HÀNG</h2>

    <p>Đội ngũ hỗ trợ của chúng tôi luôn sẵn sàng giải đáp mọi thắc mắc của quý khách hàng về sản phẩm và dịch vụ.</p>

    <div class="contact-grid">
      <div class="contact-box">
        <i class="fa-solid fa-phone-volume"></i>
        <strong>Hotline Tư Vấn</strong>
        <p>0909 123 456</p>
        <p>(8:00 - 17:00 hàng ngày)</p>
      </div>

      <div class="contact-box">
        <i class="fa-solid fa-envelope"></i>
        <strong>Email Hỗ Trợ</strong>
        <p>nonglam@hcmuaf.edu.vn</p>
        <p>Phản hồi trong 24h</p>
      </div>
    </div>

    <h3 style="margin-top: 30px;">Gửi thắc mắc cho chúng tôi</h3>
    <form id="contactForm" style="margin-top: 15px;">
      <input type="text" id="name" placeholder="Họ và tên" class="form-input" required>
      <input type="text" id="phone" placeholder="Số điện thoại" class="form-input" required>
      <textarea id="message" rows="4" placeholder="Nội dung cần hỗ trợ..." class="form-input" required></textarea>
      <button type="submit" class="btn-submit">Gửi yêu cầu</button>
    </form>
  </div>
</main>

<footer class="footer">
  <div class="footer-container">
    <div class="footer-column">
      <h3>VỀ CHÚNG TÔI</h3>
      <p>Chuyên cung cấp thiết bị vệ sinh, phòng tắm chính hãng, giá tốt nhất thị trường.</p>
    </div>
    <div class="footer-column">
      <h3>LIÊN HỆ</h3>
      <p><i class="fa-solid fa-phone"></i> 0909 123 456</p>
      <p><i class="fa-solid fa-envelope"></i> contact@thietbivesinh.vn</p>
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
        <a href="https://www.facebook.com/huuthang11092005" target="_blank"><i class="fa-brands fa-facebook"></i></a>
      </div>
    </div>
  </div>
  <div class="footer-bottom">© 2025 Thiết Bị Vệ Sinh & Phòng Tắm.</div>
</footer>

<script>
  document.getElementById('contactForm').addEventListener('submit', function(e) {
    e.preventDefault();
    Swal.fire({
      icon: 'success',
      title: 'Đã gửi yêu cầu!',
      text: 'Cảm ơn bạn đã liên hệ, chúng tôi sẽ liên hệ lại sớm nhất.',
      confirmButtonColor: '#d70018'
    });
    this.reset();
  });
</script>

</body>
</html>