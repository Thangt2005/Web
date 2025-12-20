<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link rel="stylesheet" href="admin_style.css" />
    <style>
        body { font-family: 'Segoe UI', sans-serif; margin: 0; background: #f4f4f4; }
        header { background: #1a1a1a; color: white; padding: 15px 20px; display: flex; justify-content: space-between; align-items: center; border-bottom: 3px solid #c0a750; }
        .admin-sidebar-panel { width: 260px; min-height: 100vh; background: #2c2c2c; color: white; padding-top: 20px; }
        .admin-sidebar-panel ul li a { color: #cfd2d6; text-decoration: none; display: block; padding: 12px 20px; border-bottom: 1px solid #3d444a; }
        .admin-form-container { background: white; padding: 25px; border-radius: 8px; margin-top: 20px; }
        .btn-submit { background: #28a745; color: white; padding: 12px 25px; border: none; border-radius: 4px; cursor: pointer; width: 100%; font-weight: bold; }
        .success-box { background: #d4edda; color: #155724; padding: 10px; border-radius: 4px; margin-bottom: 10px; }
    </style>
</head>
<body>
<header>
    <h1 style="margin:0; font-size: 22px;"><i class="fas fa-user-shield"></i> Trang Quản Trị</h1>
    <div><a href="Home" style="color:white; text-decoration:none;"><i class="fa fa-home"></i> Về trang chủ</a></div>
</header>

<div style="display:flex;">
    <div class="admin-sidebar-panel">
        <ul>
            <li style="background: #444;"><a href="Admin"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
            <li><a href="#"><i class="fas fa-shopping-cart"></i> Đơn hàng</a></li>
        </ul>
    </div>

    <main style="flex:1; padding: 25px;">
        <h2>Dashboard Tổng quan</h2>

        <div style="display: flex; gap: 20px; margin-bottom: 30px;">
            <div style="background: white; padding: 20px; flex: 1; border-left: 5px solid #007bff; border-radius: 8px;">
                <h3 style="color:#666; font-size:14px; margin:0;">TỔNG SẢN PHẨM</h3>
                <p style="font-size:36px; font-weight:bold; color:#007bff; margin:10px 0;">${totalProducts}</p>
            </div>
        </div>

        <div class="admin-form-container">
            <h3><i class="fa fa-plus-circle"></i> Thêm Sản Phẩm Mới</h3>

            <% if(request.getAttribute("message") != null) { %>
            <div class="success-box"><%= request.getAttribute("message") %></div>
            <% } %>

            <form action="Admin" method="POST" enctype="multipart/form-data">
                <div style="margin-bottom: 15px;">
                    <label>1. Chọn Danh Mục:</label>
                    <select name="category" required style="width: 100%; padding: 8px;">
                        <option value="lavabo_sanpham">Lavabo</option>
                        <option value="bontam_sanpham">Bồn Tắm</option>
                        <option value="toilet_sanpham">Bồn Cầu</option>
                        <option value="home_sanpham">Sản phẩm Home</option>
                    </select>
                </div>
                <div style="margin-bottom: 15px;">
                    <label>2. Tên Sản Phẩm:</label>
                    <input type="text" name="ten_sp" required style="width: 100%; padding: 8px;">
                </div>
                <div style="display: flex; gap: 20px; margin-bottom: 15px;">
                    <div style="flex:1;">
                        <label>3. Giá:</label>
                        <input type="number" name="gia" required style="width: 100%; padding: 8px;">
                    </div>
                    <div style="flex:1;">
                        <label>4. Giảm giá (%):</label>
                        <input type="number" name="giam_gia" value="0" style="width: 100%; padding: 8px;">
                    </div>
                </div>
                <div style="margin-bottom: 20px;">
                    <label>5. Hình Ảnh:</label>
                    <input type="file" name="hinh_anh" accept="image/*" required>
                </div>
                <button type="submit" class="btn-submit">LƯU SẢN PHẨM</button>
            </form>
        </div>
    </main>
</div>
</body>
</html>