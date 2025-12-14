<?php
// --- PHẦN 1: KẾT NỐI CSDL ---
$servername = "localhost:3307"; 
$username   = "root";
$password   = "";
$dbname     = "db"; // Kết nối vào Database 'db' (đã chứa tất cả các bảng)

$conn = mysqli_connect($servername, $username, $password, $dbname);
if (!$conn) { die("Kết nối thất bại: " . mysqli_connect_error()); }
mysqli_set_charset($conn, "utf8");

// --- PHẦN 2: XỬ LÝ THÊM SẢN PHẨM & UPLOAD ẢNH ---
$message = "";
if (isset($_POST['btn_add_product'])) {
    $ten_sp   = $_POST['ten_sp'];
    $gia      = $_POST['gia'];
    $giam_gia = $_POST['giam_gia'];
    $table_loai = $_POST['category']; // Tên bảng: chauchauen_sanpham, toilet_sanpham...

    // Xử lý Upload ảnh
    $target_dir = "image_all/";
    if (!file_exists($target_dir)) { mkdir($target_dir, 0777, true); }
    
    $image_name = basename($_FILES["hinh_anh"]["name"]);
    $target_file = $target_dir . $image_name;

    if (move_uploaded_file($_FILES["hinh_anh"]["tmp_name"], $target_file)) {
        // SQL INSERT INTO (Sẽ chèn vào bảng đã chọn trong Database 'db')
        $sql_insert = "INSERT INTO $table_loai (ten_sp, hinh_anh, gia, giam_gia) 
                       VALUES ('$ten_sp', '$image_name', '$gia', '$giam_gia')";
        
        if (mysqli_query($conn, $sql_insert)) {
            $message = "<div style='background-color: #d4edda; color: #155724; padding: 15px; margin-bottom: 20px; border: 1px solid #c3e6cb; border-radius: 4px;'>
                            ✅ Thêm sản phẩm thành công vào bảng <b>$table_loai</b>!
                        </div>";
        } else {
            $message = "<div style='color:red;'>❌ Lỗi SQL: " . mysqli_error($conn) . "</div>";
        }
    } else {
        $message = "<div style='color:red;'>❌ Lỗi upload ảnh! Hãy kiểm tra lại thư mục image_all.</div>";
    }
}

// --- PHẦN 3: THỐNG KÊ TỔNG SẢN PHẨM (Đã cập nhật đủ 7 bảng) ---
// Đếm tổng số lượng sản phẩm từ tất cả các bảng sản phẩm của anh
$sql_count = "SELECT 
    (SELECT COUNT(*) FROM chauchauen_sanpham) + 
    (SELECT COUNT(*) FROM lavabo_sanpham) + 
    (SELECT COUNT(*) FROM toilet_sanpham) + 
    (SELECT COUNT(*) FROM voisen_sanpham) + 
    (SELECT COUNT(*) FROM voirua_sanpham) + 
    (SELECT COUNT(*) FROM tulavabo_sanpham) +
    (SELECT COUNT(*) FROM bontieunam_sanpham) +
    (SELECT COUNT(*) FROM bontam_sanpham) +
    (SELECT COUNT(*) FROM login) as total"; // Anh có thể thêm login để đếm tổng user

$result_count = mysqli_query($conn, $sql_count);
$total_products = 0;

if ($result_count) {
    $data_count = mysqli_fetch_assoc($result_count);
    $total_products = $data_count['total']; // Tổng số sản phẩm và User (nếu tính cả login)
}
?>

<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link rel="stylesheet" href="admin_style.css" />
    <style>
        /* Các style inline cơ bản */
        .admin-form-container { background: white; padding: 20px; border-radius: 8px; margin-top: 20px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input, .form-group select { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; }
        .btn-submit { background: #28a745; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; font-weight: bold;}
        .btn-submit:hover { background: #218838; }
        /* Style cho Sidebar */
        .admin-sidebar-panel { width: 250px; min-height: 100vh; background: #333; color: white; padding-top: 20px; }
        .admin-sidebar-panel ul { list-style:none; padding:0; }
        .admin-sidebar-panel ul li a { color: white; text-decoration: none; display: block; padding: 12px 15px; transition: background 0.3s; }
        .admin-sidebar-panel ul li a:hover, .admin-sidebar-panel ul li.active-admin a { background: #555; }
        .admin-sidebar-panel .menu-title { padding: 15px; font-weight: bold; text-transform: uppercase; border-bottom: 1px solid #555; margin-bottom: 10px; }
    </style>
  </head>
  <body>
    <header>
      <h1>Quản Trị Hệ Thống</h1>
      <nav>
        <ul class="user-menu">
           <li><a href="home.php"><i class="fa fa-home"></i> Xem Trang Web</a></li>
           <li><a href="#"><i class="fas fa-user-cog"></i> Admin Thắng</a></li>
        </ul>
      </nav>
    </header>

    <div class="menu-container">
      <div class="main-admin-container" style="display:flex; width:100%;">
        
        <div class="admin-sidebar-panel">
           <div class="menu-title">CHỨC NĂNG QUẢN LÝ</div>
           <ul>
             <li class="active-admin"><a href="page_admin.php"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
             <li class="menu-divider" style="padding: 5px 15px; font-size: 12px; color: #bbb; border-top: 1px solid #555;">SẢN PHẨM</li>
             <li><a href="?view=chauchauen_sanpham"><i class="fas fa-mug-hot"></i> Chậu Rửa Chén</a></li>
             <li><a href="?view=lavabo_sanpham"><i class="fas fa-toilet"></i> Lavabo</a></li>
             <li><a href="?view=toilet_sanpham"><i class="fas fa-toilet-paper"></i> Bồn Cầu/Toilet</a></li>
             <li><a href="?view=voisen_sanpham"><i class="fas fa-shower"></i> Vòi Sen Tắm</a></li>
             <li><a href="?view=voirua_sanpham"><i class="fas fa-tint"></i> Vòi Rửa</a></li>
             <li class="menu-divider" style="padding: 5px 15px; font-size: 12px; color: #bbb; border-top: 1px solid #555;">KHÁC</li>
             <li><a href="?view=login"><i class="fas fa-users"></i> Quản lý User</a></li>
             <li><a href="#"><i class="fas fa-shopping-cart"></i> Đơn hàng</a></li>
           </ul>
        </div>
        <main class="dashboard-content" style="flex:1; padding: 20px; background: #f4f4f4;">
          <h2>Dashboard Tổng quan</h2>

          <div class="stats-grid" style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 30px;">
            <div class="stat-card" style="background:white; padding:20px; border-radius:8px; text-align:center;">
              <h3 style="color:#666; font-size:14px;">TỔNG SẢN PHẨM</h3>
              <p style="font-size:30px; font-weight:bold; color:#007bff; margin:10px 0;"><?php echo $total_products; ?></p>
            </div>
            <div class="stat-card" style="background:white; padding:20px; border-radius:8px; text-align:center;">
               <h3 style="color:#666; font-size:14px;">DOANH THU</h3>
               <p style="font-size:30px; font-weight:bold; color:green; margin:10px 0;">150.000.000đ</p>
            </div>
          </div>

          <div class="admin-form-container">
              <h3 style="border-bottom: 2px solid #eee; padding-bottom: 10px; margin-bottom: 20px;">
                  <i class="fa fa-plus-circle"></i> Thêm Sản Phẩm Mới
              </h3>
              
              <?php echo $message; ?>

              <form action="" method="POST" enctype="multipart/form-data">
                  <div class="form-group">
                      <label>1. Chọn Loại Sản Phẩm (Bảng CSDL):</label>
                      <select name="category" required>
                         <option value="home_sanpham">Home</option>
                          <option value="chauchauen_sanpham">Chậu Rửa Chén</option>
                          <option value="lavabo_sanpham">Lavabo</option>
                          <option value="tulavabo_sanpham">Tủ Lavabo</option>
                          <option value="bontam_sanpham">Bồn Tắm/Toilet</option>
                          <option value="toilet_sanpham">Bồn Cầu/Toilet</option>
                          <option value="voisentam_sanpham">Vòi Sen Tắm</option>
                          <option value="voirua_sanpham">Vòi Rửa</option>
                          <option value="bontieunam_sanpham">Bồn Tiểu Nam</option>
                          <option value="phukien_sanpham">Phụ Kiện</option>
                      </select>
                  </div>
                  <div class="form-group"><label>2. Tên Sản Phẩm:</label><input type="text" name="ten_sp" required placeholder="Nhập tên sản phẩm..."></div>
                  <div class="form-group"><label>3. Giá Tiền (VNĐ):</label><input type="number" name="gia" required placeholder="Ví dụ: 1500000"></div>
                  <div class="form-group"><label>4. Giảm Giá (%):</label><input type="number" name="giam_gia" value="0" placeholder="0"></div>
                  <div class="form-group"><label>5. Hình Ảnh (Chọn file từ máy tính):</label><input type="file" name="hinh_anh" required></div>
                  <button type="submit" name="btn_add_product" class="btn-submit">Lưu Sản Phẩm</button>
              </form>
          </div>

        </main>
      </div>
    </div>
  </body>
</html>