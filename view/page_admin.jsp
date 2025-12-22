<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Product, java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link rel="stylesheet" href="admin_style.css" />
</head>
<body>
<div class="wrapper">
    <header>
        <h1><i class="fas fa-user-shield"></i> Trang Quản Trị</h1>
        <nav><ul><li><a href="Home" style="color:white;"><i class="fa fa-home"></i> Về trang chủ</a></li></ul></nav>
    </header>

    <div class="main-admin-container">
        <div class="admin-sidebar-panel">
            <div class="menu-title">MENU HỆ THỐNG</div>
            <ul>
                <li class="active-admin"><a href="Admin"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                <li><a href="AdminOrder"><i class="fas fa-shopping-cart"></i> Đơn hàng</a></li>
                <li><a href="Admin?viewTable=home_sanpham"><i class="fas fa-box"></i> Sản phẩm</a></li>
                <li><a href="AdminCustomer"><i class="fas fa-users"></i> Khách hàng</a></li>
            </ul>
        </div>

        <div class="dashboard-content">
            <h2>Tổng quan hệ thống</h2>
            <div class="stats-grid">
                <div class="stat-card"><h3>TỔNG SẢN PHẨM</h3><p>${totalProducts}</p></div>
                <div class="stat-card" style="border-top-color: #2ecc71;">
                    <h3>TỔNG DOANH THU</h3>
                    <p><fmt:formatNumber value="${totalRevenue}" type="number" />đ</p>
                </div>
            </div>

            <% if(request.getAttribute("productEdit") != null) {
                Product p = (Product) request.getAttribute("productEdit");
            %>
            <div class="content-block" style="border: 2px solid #3498db; margin-bottom: 20px;">
                <h3><i class="fa fa-edit"></i> Đang sửa: <%= p.getTenSp() %></h3>
                <form action="Admin" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="<%= p.getId() %>">
                    <input type="hidden" name="category" value="<%= request.getAttribute("categoryEdit") %>">
                    <input type="hidden" name="old_image" value="<%= p.getHinhAnh() %>">
                    <input type="text" name="ten_sp" value="<%= p.getTenSp() %>" required style="width:100%; margin-bottom:10px;">
                    <button type="submit" class="btn-update">LƯU THAY ĐỔI</button>
                    <a href="Admin" style="margin-left:10px; color:red;">Hủy</a>
                </form>
            </div>
            <% } %>

            <div class="content-block" style="margin-bottom:30px;">
                <h3><i class="fa fa-plus-circle"></i> Thêm Sản Phẩm Mới</h3>
                <form action="Admin" method="POST" enctype="multipart/form-data">
                    <select name="category" required style="width:100%; padding:8px; margin-bottom:10px;">
                        <option value="home_sanpham">Trang chủ</option>
                        <option value="combo_sanpham">Combo</option>
                        <option value="lavabo_sanpham">Lavabo</option>
                        <option value="toilet_sanpham">Bồn cầu</option>
                    </select>
                    <input type="text" name="ten_sp" placeholder="Tên sản phẩm" required style="width:100%; margin-bottom:10px;">
                    <input type="number" name="gia" placeholder="Giá" required>
                    <input type="number" name="giam_gia" value="0">
                    <input type="file" name="hinh_anh" required>
                    <button type="submit" class="btn-submit">THÊM MỚI</button>
                </form>
            </div>

            <div class="content-block">
                <h3><i class="fa fa-list"></i> Danh Sách Sản Phẩm</h3>
                <select onchange="location.href='Admin?viewTable=' + this.value" style="margin-bottom:15px; padding:8px; border-radius:4px; border:1px solid #ccc;">
                    <option value="all" ${currentViewTable == 'all' || currentViewTable == null ? 'selected' : ''}>--- Xem tất cả hệ thống ---</option>

                    <option value="home_sanpham" ${currentViewTable == 'home_sanpham' ? 'selected' : ''}>Sản phẩm Trang Chủ</option>
                    <option value="combo_sanpham" ${currentViewTable == 'combo_sanpham' ? 'selected' : ''}>Combo Tiết Kiệm</option>
                    <option value="bontam_sanpham" ${currentViewTable == 'bontam_sanpham' ? 'selected' : ''}>Bồn Tắm</option>
                    <option value="bontieunam_sanpham" ${currentViewTable == 'bontieunam_sanpham' ? 'selected' : ''}>Bồn Tiểu Nam</option>
                    <option value="chauruachen_sanpham" ${currentViewTable == 'chauruachen_sanpham' ? 'selected' : ''}>Chậu Rửa Chén</option>
                    <option value="lavabo_sanpham" ${currentViewTable == 'lavabo_sanpham' ? 'selected' : ''}>Lavabo</option>
                    <option value="tulavabo_sanpham" ${currentViewTable == 'tulavabo_sanpham' ? 'selected' : ''}>Tủ Lavabo</option>
                    <option value="toilet_sanpham" ${currentViewTable == 'toilet_sanpham' ? 'selected' : ''}>Bồn Cầu</option>
                    <option value="voirua_sanpham" ${currentViewTable == 'voirua_sanpham' ? 'selected' : ''}>Vòi Rửa</option>
                    <option value="voisentam_sanpham" ${currentViewTable == 'voisentam_sanpham' ? 'selected' : ''}>Vòi Sen Tắm</option>
                    <option value="voisen_sanpham" ${currentViewTable == 'voisen_sanpham' ? 'selected' : ''}>Vòi Sen Lẻ</option>
                    <option value="phukien_sanpham" ${currentViewTable == 'phukien_sanpham' ? 'selected' : ''}>Phụ Kiện Phòng Tắm</option>
                </select>
                <table class="data-table">
                    <thead><tr><th>Ảnh</th><th>Tên</th><th>Giá</th><th>Thao tác</th></tr></thead>
                    <tbody>
                    <% List<Product> list = (List<Product>) request.getAttribute("productList");
                        if(list != null) { for(Product p : list) { %>
                    <tr>
                        <td><img src="image_all/<%= p.getHinhAnh() %>"></td>
                        <td><%= p.getTenSp() %></td>
                        <td><fmt:formatNumber value="<%= p.getGia() %>" type="number" />đ</td>
                        <td>
                            <a href="Admin?action=edit&id=<%= p.getId() %>&category=<%= request.getAttribute("currentViewTable") %>" class="btn-edit">Sửa</a>
                            <a href="Admin?action=delete&id=<%= p.getId() %>&category=<%= request.getAttribute("currentViewTable") %>" class="btn-delete" onclick="return confirm('Xóa?')">Xóa</a>
                        </td>
                    </tr>
                    <% }} %>
                    </tbody>
                </table>
            </div>
        </div>
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
</div>
</body>
</html>