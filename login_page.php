<?php

session_start(); // Khởi động session

// Chỉ xử lý khi bấm nút (POST)
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // 1. Lấy dữ liệu
    $u = $_POST['username'];
    $p = $_POST['password'];    
    
    // 2. Kết nối Database 
    $db = mysqli_connect("localhost", "root", "", "login", 3307);

    if (!$db) {
        die("Kết nối thất bại: " . mysqli_connect_error());
    }

    // 3. Truy vấn
    $sql = "SELECT * FROM login WHERE username='$u' AND password='$p'";
    
    $result = mysqli_query($db, $sql);

    if (mysqli_num_rows($result) > 0) {
        // Đăng nhập thành công -> Chuyển hướng sang trang home.html
        header("Location: home.html");
        exit(); // Kết thúc code để chuyển trang ngay lập tức
    } else {
        // Đăng nhập thất bại -> Hiện thông báo bằng JavaScript cho đẹp
        echo "<script>alert('Sai tài khoản hoặc mật khẩu! Vui lòng thử lại.');</script>";
    }
}
?>

<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <title>Đăng nhập</title>
    <link rel="stylesheet" href="style.css" />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
    />
  </head>
  <body>
    <header>
      <h1>Thiết Bị Vệ Sinh Và Phòng Tắm</h1>
    </header>
    
    <div class="login-container">
      <h2>Đăng nhập</h2>
      <div class="social-login">
        <button class="facebook"><i class="fa-brands fa-facebook-f"></i><span> Facebook</span></button>
        <button class="twitter"><i class="fa-brands fa-twitter"></i><span> Twitter</span></button>
        <button class="google"><i class="fa-brands fa-google"></i> <span> Google</span></button>
      </div>

      <h3>Đăng nhập bằng email</h3>

      <form class="email-login" id="login-form" action="" method="POST">
        <input
          type="text"
          id="email"
          name="username" 
          placeholder="Username hoặc E-mail"
          required
        />

        <div class="password-wrapper">
          <input
            type="password"
            id="password"
            name="password"
            placeholder="Mật khẩu"
            required
          />
          <span class="toggle-password"></span>
        </div>

        <button type="submit" class="login-btn">ĐĂNG NHẬP</button>
      </form>

      <p class="links">
        <a href="forget_pass.html">Quên mật khẩu?</a> |
        <a href="register_page.html">Đăng ký tài khoản</a>
      </p>
    </div>
    
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
            <a href="https://www.facebook.com/huuthang11092005"
              ><i class="fa-brands fa-facebook"></i
            ></a>
            <a href="https://www.youtube.com/@huuthangtran9024/posts"
              ><i class="fa-brands fa-youtube"></i
            ></a>
            <a href="https://www.tiktok.com/@thangtt26"
              ><i class="fa-brands fa-tiktok"></i
            ></a>
          </div>
        </div>
      </div>

      <div class="footer-bottom">
        © 2025 Thiết Bị Vệ Sinh & Phòng Tắm - All Rights Reserved.
      </div>
    </footer>
  </body>
</html>
