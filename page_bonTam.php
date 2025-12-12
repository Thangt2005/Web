<?php
// 1. Kết nối CSDL
$servername = "localhost:3307";
$username   = "root";
$password   = "";
$dbname     = "db";

$conn = mysqli_connect($servername, $username, $password, $dbname);

if (!$conn) {
    die("Kết nối thất bại: " . mysqli_connect_error());
}

mysqli_set_charset($conn, "utf8");

// 2. Lấy danh sách sản phẩm (nếu muốn chỉ lấy COMBO, bạn phải thêm cột 'loai')
$sql = "SELECT * FROM bontam_sanpham";
$result = mysqli_query($conn, $sql);
?>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <title>Trang chủ</title>
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
    />
    <link rel="stylesheet" href="Combo_style.css" />
  </head>
  <body>
    <header>
      <h1>Thiết Bị Vệ Sinh Và Phòng Tắm</h1>
      <nav>
        <form class="search-form" action="#" method="GET">
          <input
            type="text"
            name="search"
            placeholder="Tìm kiếm sản phẩm ..."
            class="search-input"
          />
          <button type="submit" class="search-icon">
            <i class="fa fa-search"></i>
          </button>
        </form>

        <ul class="user-menu">
          <li>
            <a href="page_ThemVaoGiohang.html">
              <i class="fa-solid fa-cart-shopping"></i> Giỏ hàng
            </a>
          </li>
          <li>
            <a href="login_page.html">
              <i class="fas fa-user"></i> Đăng nhập
            </a>
          </li>
        </ul>
      </nav>
    </header>

    <div class="menu-container">
      <div class="sidebar">
        <div class="menu-title">
          <i class="fa fa-bars"></i> DANH MỤC SẢN PHẨM
        </div>
      </div>

      <div class="top-menu">
        <ul>
           <li><a href="home.php">Trang chủ</a></li>
          <li><a href="page_combo.php">Combo</a></li>
          <li><a href="toilet_page.php">Bồn Cầu</a></li>
          <li><a href="lavabo-page.php">Lavabo</a></li>
          <li><a href="page_Tulavabo.php">Tủ Lavabo</a></li>
          <li><a href="page_VoiSenTam.php">Vòi Sen Tắm</a></li>
          <li><a href="page_ChauRuaChen.php">Chậu Rửa Chén</a></li>
          <li><a href="page_bonTam.php">Bồn Tắm</a></li>
          <li><a href="page_voiRua.php">Vòi Rửa</a></li>
          <li><a href="page_BonTieuNam.php">Bồn Tiểu Nam</a></li>
          <li><a href="page_PhuKien.php">Phụ Kiện</a></li>
        </ul>
      </div>
    </div>
    <!--  PHẦN NỘI DUNG PAGE LAVABO  -->
    <main class="main-content">
      <h2>Một số mẫu Bồn Tắm bán chạy</h2>

      <div class="combo-grid">
       <?php 
        // 3. Hiển thị sản phẩm
        if (mysqli_num_rows($result) > 0) {
            while ($row = mysqli_fetch_assoc($result)) {
        ?>
            <div class="product-combo">
                <h3><?php echo $row['ten_sp']; ?></h3>

                <img src="image_all/<?php echo $row['hinh_anh']; ?>"
                     alt="<?php echo $row['ten_sp']; ?>">

                <p class="price">
                    <?php echo number_format($row['gia']); ?>đ
                    <span class="dis">-<?php echo $row['giam_gia']; ?>%</span>
                </p>

                <div class="button-group">
                    <button class="add-to-cart">
                        <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ hàng
                    </button>
                    <button class="buy">
                        <i class="fa-solid fa-bag-shopping"></i> Đặt mua
                    </button>
                </div>
            </div>
        <?php 
            }
        } else {
            echo "<p>Chưa có sản phẩm nào!</p>";
        }
        ?>
      </div>
</main>
      <footer class="footer">
        <div class="footer-container">
          <div class="footer-column">
            <h3>VỀ CHÚNG TÔI</h3>
            <p>
              Chuyên cung cấp thiết bị vệ sinh, phòng tắm chính hãng, giá tốt
              nhất thị trường.
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
    </main>
  </body>
</html>
