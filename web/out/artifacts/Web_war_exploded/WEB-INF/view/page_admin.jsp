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
    <style>
        /* CSS bổ sung để form đẹp hơn */
        .form-group { margin-bottom: 15px; }
        .form-label { font-weight: bold; display: block; margin-bottom: 5px; color: #333; }
        .form-control { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; }
        .row-flex { display: flex; gap: 15px; }
        .col-half { flex: 1; }
        .btn-cancel { text-decoration: none; color: #e74c3c; margin-left: 10px; font-weight: bold; }
        .preview-img { height: 50px; border: 1px solid #ccc; padding: 2px; vertical-align: middle; margin-right: 10px; }
    </style>
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
                <li><a href="AdminCustomer"><i class="fas fa-users"></i> Khách hàng</a></li>
                <li><a href="AdminOrder"><i class="fas fa-shopping-cart"></i> Đơn hàng</a></li>
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

            <%-- --- FORM SỬA SẢN PHẨM (ĐÃ CẬP NHẬT ĐẦY ĐỦ) --- --%>
            <% if(request.getAttribute("productEdit") != null) {
                Product p = (Product) request.getAttribute("productEdit");
            %>
            <div class="content-block" style="border: 2px solid #3498db; background: #f9fcff;">
                <h3 style="color: #2980b9; border-bottom: 1px solid #eee; padding-bottom: 10px;">
                    <i class="fa fa-edit"></i> Đang sửa sản phẩm: <span style="color:red"><%= p.getTenSp() %></span>
                </h3>

                <form action="Admin" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="<%= p.getId() %>">
                    <input type="hidden" name="category" value="<%= request.getAttribute("categoryEdit") %>">
                    <input type="hidden" name="old_image" value="<%= p.getHinhAnh() %>">

                    <%-- Tên sản phẩm --%>
                    <div class="form-group">
                        <label class="form-label">Tên sản phẩm:</label>
                        <input type="text" name="ten_sp" value="<%= p.getTenSp() %>" class="form-control" required>
                    </div>

                    <%-- Giá và Giảm giá (Nằm cùng 1 hàng) --%>
                    <div class="row-flex">
                        <div class="form-group col-half">
                            <label class="form-label">Giá (VNĐ):</label>
                            <%-- String.format để bỏ số thập phân .0 thừa --%>
                            <input type="number" name="gia" value="<%= String.format("%.0f", p.getGia()) %>" class="form-control" required>
                        </div>
                        <div class="form-group col-half">
                            <label class="form-label">Giảm giá (%):</label>
                            <input type="number" name="giam_gia" value="<%= p.getGiamGia() %>" class="form-control">
                        </div>
                    </div>

                    <%-- Ảnh sản phẩm --%>
                    <div class="form-group">
                        <label class="form-label">Hình ảnh:</label>
                        <div style="display: flex; align-items: center;">
                            <img src="image_all/<%= p.getHinhAnh() %>" class="preview-img" alt="Ảnh cũ">
                            <input type="file" name="hinh_anh" style="flex: 1;">
                        </div>
                        <small style="color: #666; font-style: italic;">(Để trống nếu không muốn đổi ảnh)</small>
                    </div>

                    <div style="margin-top: 20px;">
                        <button type="submit" class="btn-update" style="padding: 10px 20px; background: #3498db; color: white; border: none; cursor: pointer;">
                            <i class="fa fa-save"></i> LƯU THAY ĐỔI
                        </button>
                        <a href="Admin" class="btn-cancel">Hủy bỏ</a>
                    </div>
                </form>
            </div>
            <% } %>
            <%-- --- KẾT THÚC FORM SỬA --- --%>


            <%-- --- FORM THÊM MỚI (ĐÃ CẬP NHẬT ĐỦ BẢNG) --- --%>
            <div class="content-block" style="margin-bottom:30px;">
                <h3><i class="fa fa-plus-circle"></i> Thêm Sản Phẩm Mới</h3>
                <form action="Admin" method="POST" enctype="multipart/form-data">
                    <div class="form-group">
                        <label class="form-label">Chọn danh mục:</label>
                        <select name="category" required class="form-control">
                            <option value="" disabled selected>-- Chọn bảng dữ liệu --</option>
                            <option value="home_sanpham">Sản phẩm Trang Chủ</option>
                            <option value="combo_sanpham">Combo Tiết Kiệm</option>
                            <option value="toilet_sanpham">Bồn Cầu</option>
                            <option value="lavabo_sanpham">Lavabo</option>
                            <option value="tulavabo_sanpham">Tủ Lavabo</option>
                            <option value="voisentam_sanpham">Vòi Sen Tắm</option>
                            <option value="chauruachen_sanpham">Chậu Rửa Chén</option>
                            <option value="bontam_sanpham">Bồn Tắm</option>
                            <option value="voirua_sanpham">Vòi Rửa</option>
                            <option value="bontieunam_sanpham">Bồn Tiểu Nam</option>
                            <option value="phukien_sanpham">Phụ Kiện</option>
                        </select>
                    </div>

                    <input type="text" name="ten_sp" placeholder="Tên sản phẩm" class="form-control" style="margin-bottom: 10px;" required>

                    <div class="row-flex" style="margin-bottom: 10px;">
                        <input type="number" name="gia" placeholder="Giá tiền" class="form-control" required>
                        <input type="number" name="giam_gia" placeholder="Giảm giá (%)" value="0" class="form-control">
                    </div>

                    <input type="file" name="hinh_anh" required style="margin-bottom: 10px;">
                    <button type="submit" class="btn-submit">THÊM MỚI</button>
                </form>
            </div>


            <%-- --- DANH SÁCH SẢN PHẨM --- --%>
            <div class="content-block">
                <h3><i class="fa fa-list"></i> Danh Sách Sản Phẩm</h3>

                <%-- Dropdown chọn bảng để xem --%>
                <select onchange="location.href='Admin?viewTable=' + this.value" style="margin-bottom:15px; padding:8px; border-radius:4px; border:1px solid #ccc; width: 300px;">
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
                    <option value="phukien_sanpham" ${currentViewTable == 'phukien_sanpham' ? 'selected' : ''}>Phụ Kiện Phòng Tắm</option>
                </select>

                <table class="data-table">
                    <thead><tr><th>Ảnh</th><th>Tên</th><th>Giá</th><th>Thao tác</th></tr></thead>
                    <tbody>
                    <% List<Product> list = (List<Product>) request.getAttribute("productList");
                        if(list != null && !list.isEmpty()) {
                            for(Product p : list) { %>
                    <tr>
                        <td><img src="image_all/<%= p.getHinhAnh() %>" style="width: 50px; height: 50px; object-fit: cover; border: 1px solid #eee;"></td>
                        <td><%= p.getTenSp() %></td>
                        <td><fmt:formatNumber value="<%= p.getGia() %>" type="number" />đ</td>
                        <td>
                            <a href="Admin?action=edit&id=<%= p.getId() %>&category=<%= request.getAttribute("currentViewTable") %>" class="btn-edit"><i class="fa fa-pen"></i> Sửa</a>
                            <a href="Admin?action=delete&id=<%= p.getId() %>&category=<%= request.getAttribute("currentViewTable") %>" class="btn-delete" onclick="return confirm('Bạn có chắc muốn xóa sản phẩm này không?')"><i class="fa fa-trash"></i> Xóa</a>
                        </td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="4" style="text-align: center; padding: 20px; color: #666;">
                            Chưa có dữ liệu hoặc chưa chọn bảng danh mục.
                        </td>
                    </tr>
                    <% } %>
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
                    <li><a href="view/page_ChinhSachGiaoHang.jsp">Chính sách giao hàng</a></li>
                    <li><a href="view/page_ChinhSachBaoHanh.jsp">Chính sách bảo hành</a></li>
                    <li><a href="view/page_HuongDanThanhToan.jsp">Hướng dẫn thanh toán</a></li>
                    <li><a href="view/page_ChamSocKhachHang.jsp">Chăm sóc khách hàng</a></li>
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