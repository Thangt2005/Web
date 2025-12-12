<?php
// --- PHẦN 1: KẾT NỐI CSDL & XỬ LÝ FORM ---
$servername = "localhost:3307"; // Anh giữ nguyên port 3307 của anh
$username   = "root";
$password   = "";
$dbname     = "login"; // Kết nối vào Login để kiểm tra admin

$conn = mysqli_connect($servername, $username, $password, $dbname);
if (!$conn) { die("Kết nối thất bại: " . mysqli_connect_error()); }
mysqli_set_charset($conn, "utf8");

// --- XỬ LÝ THÊM SẢN PHẨM & UPLOAD ẢNH ---
$message = "";
if (isset($_POST['btn_add_product'])) {
    $ten_sp   = $_POST['ten_sp'];
    $gia      = $_POST['gia'];
    $giam_gia = $_POST['giam_gia'];
    $table_loai = $_POST['category']; 

    // Xử lý Upload ảnh
    $target_dir = "image_all/";
    // Kiểm tra xem thư mục có tồn tại không, nếu không thì tạo
    if (!file_exists($target_dir)) { mkdir($target_dir, 0777, true); }
    
    $image_name = basename($_FILES["hinh_anh"]["name"]);
    $target_file = $target_dir . $image_name;

    if (move_uploaded_file($_FILES["hinh_anh"]["tmp_name"], $target_file)) {
        // QUAN TRỌNG: Thêm 'db.' trước tên bảng để chèn vào đúng database 'db'
        // Ví dụ: INSERT INTO db.db_bontam ...
        $sql_insert = "INSERT INTO db.$table_loai (ten_sp, hinh_anh, gia, giam_gia) 
                       VALUES ('$ten_sp', '$image_name', '$gia', '$giam_gia')";
        
        if (mysqli_query($conn, $sql_insert)) {
            $message = "<div style='color:green; padding:10px; border:1px solid green; margin-bottom:10px;'>✅ Thêm thành công vào bảng $table_loai!</div>";
        } else {
            $message = "<div style='color:red;'>❌ Lỗi SQL: " . mysqli_error($conn) . "</div>";
        }
    } else {
        $message = "<div style='color:red;'>❌ Lỗi upload ảnh! Hãy kiểm tra lại thư mục image_all.</div>";
    }
}

// --- THỐNG KÊ TỔNG SẢN PHẨM ---
// SỬA LỖI Ở ĐÂY: Chỉ đường sang database 'db' để đếm
// Tạm thời bỏ 'combo_sanpham' vì anh tạo nhầm nó thành Database
$sql_count = "SELECT 
    (SELECT COUNT(*) FROM db.db_bontam) + 
    (SELECT COUNT(*) FROM db.db_bontieunam) + 
    (SELECT COUNT(*) FROM db.db_phukien) as total";

$result_count = mysqli_query($conn, $sql_count);

if ($result_count) {
    $data_count = mysqli_fetch_assoc($result_count);
    $total_products = $data_count['total'];
} else {
    $total_products = 0; // Nếu lỗi thì hiện số 0 để không chết trang web
    // Uncomment dòng dưới để xem lỗi nếu cần
    // echo mysqli_error($conn); 
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
        .admin-form-container { background: white; padding: 20px; border-radius: 8px; margin-top: 20px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input, .form-group select { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; }
        .btn-submit { background: #28a745; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; }
    </style>
  </head>
  <body>
    <header>
      <h1>Quản Trị Hệ Thống</h1>
      <nav>
        <ul class="user-menu">
           <li><a href="home.php"><i class="fa fa-home"></i> Trang Chủ</a></li>
           <li><a href="#"><i class="fas fa-user-cog"></i> Admin</a></li>
        </ul>
      </nav>
    </header>

    <div class="menu-container">
      <div class="main-admin-container" style="display:flex; width:100%;">
        <div class="admin-sidebar-panel" style="width: 250px; min-height: 100vh; background: #333; color: white;">
           <div class="menu-title" style="padding: 15px;">CHỨC NĂNG</div>
           <ul style="list-style:none; padding:0;">
             <li class="active-admin" style="padding:15px; border-bottom:1px solid #444;">Dashboard</li>
           </ul>
        </div>

        <main class="dashboard-content" style="flex:1; padding: 20px; background: #f4f4f4;">
          <h2>Dashboard Tổng quan</h2>
          
          <div class="stats-grid" style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px;">
            <div class="stat-card" style="background:white; padding:20px; text-align:center;">
              <h3>TỔNG SẢN PHẨM</h3>
              <p style="font-size:30px; color:blue; font-weight:bold;"><?php echo $total_products; ?></p>
            </div>
            <div class="stat-card" style="background:white; padding:20px; text-align:center;">
               <h3>DOANH THU</h3><p style="font-size:30px; color:green;">150.000.000đ</p>
            </div>
          </div>

          <div class="admin-form-container">
              <h3><i class="fa fa-plus-circle"></i> Thêm Sản Phẩm Mới</h3>
              <?php echo $message; ?>
              
              <form action="" method="POST" enctype="multipart/form-data">
                  <div class="form-group">
                      <label>Chọn Loại (Bảng CSDL):</label>
                      <select name="category" required>
                          <option value="db_bontam">Bồn Tắm (vào db.db_bontam)</option>
                          <option value="db_bontieunam">Bồn Tiểu Nam (vào db.db_bontieunam)</option>
                          <option value="db_phukien">Phụ Kiện (vào db.db_phukien)</option>
                          </select>
                  </div>
                  <div class="form-group">
                      <label>Tên Sản Phẩm:</label>
                      <input type="text" name="ten_sp" required>
                  </div>
                  <div class="form-group">
                      <label>Giá (VNĐ):</label>
                      <input type="number" name="gia" required>
                  </div>
                  <div class="form-group">
                      <label>Giảm giá (%):</label>
                      <input type="number" name="giam_gia" value="0">
                  </div>
                  <div class="form-group">
                      <label>Ảnh Minh Họa:</label>
                      <input type="file" name="hinh_anh" required>
                  </div>
                  <button type="submit" name="btn_add_product" class="btn-submit">Lưu Sản Phẩm</button>
              </form>
          </div>
        </main>
      </div>
    </div>
  </body>
</html>