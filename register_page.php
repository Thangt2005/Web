<?php
session_start(); 
$registration_message = "";
$conn = false; // Khởi tạo biến kết nối (dùng Procedural)

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    
    $e = $_POST['email'];
    $u = $_POST['username-register'];
    $p = $_POST['password-register'];
    $p1 = $_POST['password-register1']; // Mật khẩu nhập lại

    // 1. KIỂM TRA MẬT KHẨU NHẬP LẠI (Sửa lỗi Logic)
    if ($p !== $p1) {
        $registration_message = "<h2 style='color: red;'>Lỗi: Mật khẩu nhập lại không khớp.</h2>";
    } else {
        
        // Cấu hình Kết nối MySQL
        $servername = "localhost"; 
        $db_user = "root";       
        $db_pass = "";           
        $dbname = "login";        
        $port = 3307;             
        
        // 2. KẾT NỐI (Lưu vào biến $conn)
        $conn = mysqli_connect($servername, $db_user, $db_pass, $dbname, $port);
        
        if (mysqli_connect_error()) {
            $registration_message = "<h2 style='color: red;'>Lỗi kết nối database: " . mysqli_connect_error() . "</h2>";
        } else {
            
            // Mã hóa mật khẩu sau khi biết kết nối thành công
            $hashed_password = password_hash($p, PASSWORD_DEFAULT);
            
            // 3. CÂU LỆNH SQL ĐÃ SỬA: Thêm cột 'password' và dùng Prepared Statements
            $sql = "INSERT INTO login (email, username, password) VALUES (?, ?, ?)";
            
            // 4. CHUẨN BỊ (Procedural)
            $stmt = mysqli_prepare($conn, $sql);
            
            if ($stmt) {
                // 'sss' là 3 tham số chuỗi: email, username, hashed_password
                mysqli_stmt_bind_param($stmt, "sss", $e, $u, $hashed_password); 
                
                if (mysqli_stmt_execute($stmt)) {
                    // Đăng ký thành công -> Chuyển hướng
                    header("Location: login_page.php");
                    exit();
                } else {
                    // Lỗi chèn (ví dụ: Username/Email đã tồn tại)
                    if (mysqli_errno($conn) == 1062) { 
                         $registration_message = "<h2 style='color: red;'>Tài khoản đã tồn tại (Username/Email đã được sử dụng).</h2>";
                    } else {
                        $registration_message = "<h2 style='color: red;'>Lỗi đăng ký: " . mysqli_error($conn) . "</h2>";
                    }
                }
                mysqli_stmt_close($stmt);
            } else {
                $registration_message = "<h2 style='color: red;'>Lỗi chuẩn bị truy vấn.</h2>";
            }
            mysqli_close($conn);
        }
    }
}
?>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>Đăng kí</title>
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

    <!-- Khung chứa toàn bộ nội dung đăng kí -->
    <div class="register-container">
      <h2>Đăng Kí</h2>
      <!-- Các nút đăng kí tài khoản bằng mạng xã hội -->
      <div class="social-login">
        <button class="facebook">
          <i class="fa-brands fa-facebook-f"></i>
          <span>Đăng kí bằng Facebook</span>
        </button>

        <button class="twitter">
          <i class="fa-brands fa-twitter"></i> <span>Đăng kí bằng Twitter</span>
        </button>

        <button class="google">
          <i class="fa-brands fa-google"></i> <span>Đăng kí bằng Google</span>
        </button>
        <!-- Tiêu đề phụ -->
        <h3>Tạo tài khoản tại đây</h3>

        <!-- Form đăng kí -->
        <form class="email-register" id="register-form">
          <!-- Trường nhập email -->
          <input
            type="email"
            id="email"
            name="email"
            placeholder="E-mail"
            required
          />
          <!-- Trường nhập tên đăng nhập -->
          <input
            type="text"
            id="username-register"
            name="username-register"
            placeholder="Username"
            required
          />
          <!--trường nhập mật khẩu-->
          <input
            type="text"
            id="password-register"
            name="password-register"
            placeholder="Password"
            required
          />
          <!--trường nhập lại mật khẩu-->
          <input
            type="password"
            id="password-register1"
            name="password-register1"
            placeholder="Password repeat "
            required
          />
          <!-- Nút đăng kí -->
          <button type="submit" class="login-btn">ĐĂNG KÍ</button>
        </form>
        <p class="links">
          <a href="#">Đã có tài khoản?</a> |
          <a href="login_page.php">Đăng nhập ngay</a>
        </p>
      </div>
    </div>
    <!-- ========== FOOTER ========== -->
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
            <a href="#"><i class="fa-brands fa-facebook"></i></a>
            <a href="#"><i class="fa-brands fa-youtube"></i></a>
            <a href="#"><i class="fa-brands fa-tiktok"></i></a>
          </div>
        </div>
      </div>

      <div class="footer-bottom">
        © 2025 Thiết Bị Vệ Sinh & Phòng Tắm - All Rights Reserved.
      </div>
    </footer>
  </body>
</html>
