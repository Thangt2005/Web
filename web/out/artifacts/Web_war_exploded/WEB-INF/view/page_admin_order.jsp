  <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
  <%@ page import="model.Order, model.OrderDetail, java.util.List" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
  <!DOCTYPE html>
  <html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <title>Quản Lý Đơn Hàng</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link rel="stylesheet" href="admin_style.css" />
    <style>
      /* Badge trạng thái */
      .badge {
        padding: 6px 12px;
        border-radius: 20px; /* Bo tròn kiểu viên thuốc nhìn hiện đại hơn */
        color: white;
        font-weight: 600;
        font-size: 11px;
        display: inline-block;
        min-width: 80px;
        text-align: center;
      }

      /* Màu sắc trạng thái */
      .bg-warning { background-color: #f39c12; } /* Cam */
      .bg-info    { background-color: #3498db; } /* Xanh dương */
      .bg-success { background-color: #2ecc71; } /* Xanh lá */
      .bg-danger  { background-color: #e74c3c; } /* Đỏ */

      /* --- CSS NÚT THAO TÁC (ĐÃ SỬA LỖI) --- */
      .action-btn {
        display: inline-flex;       /* Giúp căn giữa icon và chữ */
        align-items: center;        /* Căn giữa theo chiều dọc */
        justify-content: center;
        gap: 5px;                   /* Khoảng cách giữa Icon và Chữ */

        text-decoration: none;
        padding: 6px 10px;          /* Tăng độ dày nút bấm */
        border-radius: 4px;
        font-size: 13px;            /* Chữ to hơn xíu cho dễ đọc */
        color: white !important;

        margin-right: 5px;          /* Khoảng cách ngang */
        margin-bottom: 5px;         /* Khoảng cách dọc (để nếu xuống dòng không bị dính) */

        white-space: nowrap;        /* QUAN TRỌNG: Chống chữ bị gãy xuống dòng */
        border: none;
        cursor: pointer;
        transition: 0.2s;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1); /* Đổ bóng nhẹ cho nổi */
      }

      /* Hiệu ứng khi di chuột vào nút */
      .action-btn:hover {
        opacity: 0.9;
        transform: translateY(-1px); /* Nút nảy lên xíu khi hover */
      }

      td:last-child {
        white-space: nowrap; /* Giữ các nút nằm trên 1 hàng nếu đủ chỗ */
      }
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
          <li><a href="Admin"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
          <li><a href="AdminCustomer"><i class="fas fa-users"></i> Khách hàng</a></li>
          <%-- Thêm menu Đơn hàng vào đây --%>
          <li class="active-admin"><a href="AdminOrder"><i class="fas fa-shopping-cart"></i> Đơn hàng</a></li>
        </ul>
      </div>

      <div class="dashboard-content">
        <h2><i class="fa fa-list-alt"></i> Quản Lý Đơn Hàng</h2>

        <%-- BẢNG DANH SÁCH ĐƠN HÀNG --%>
        <div class="content-block">
          <table class="data-table">
            <thead>
            <tr>
              <th>Mã Đơn</th>
              <th>Khách Hàng</th>
              <th>Ngày Đặt</th>
              <th>Tổng Tiền</th>
              <th>Trạng Thái</th>
              <th style="width: 250px;">Thao Tác</th>
            </tr>
            </thead>
            <tbody>
            <%
              List<Order> list = (List<Order>) request.getAttribute("orderList");
              if(list != null) {
                for(Order o : list) {
                  String badgeClass = "";
                  if(o.getStatus() == 1) badgeClass = "bg-warning";
                  else if(o.getStatus() == 2) badgeClass = "bg-info";
                  else if(o.getStatus() == 3) badgeClass = "bg-success";
                  else badgeClass = "bg-danger";
            %>
            <tr>
              <td>#<%= o.getId() %></td>
              <td>
                <b><%= o.getFullname() %></b><br>
                <small><%= o.getPhone() %></small>
              </td>
              <td><%= o.getCreatedAt() %></td>
              <td><fmt:formatNumber value="<%= o.getTotalMoney() %>" type="number"/>đ</td>
              <td><span class="badge <%= badgeClass %>"><%= o.getStatusName() %></span></td>
              <td>
                <%-- Logic nút bấm chuyển trạng thái --%>
                <% if(o.getStatus() == 1) { %>
                <a href="AdminOrder?action=updateStatus&id=<%= o.getId() %>&status=2" class="action-btn bg-info"><i class="fa fa-truck"></i> Giao hàng</a>
                <a href="AdminOrder?action=updateStatus&id=<%= o.getId() %>&status=4" class="action-btn bg-danger" onclick="return confirm('Hủy đơn này?')"><i class="fa fa-times"></i> Hủy</a>
                <% } else if(o.getStatus() == 2) { %>
                <a href="AdminOrder?action=updateStatus&id=<%= o.getId() %>&status=3" class="action-btn bg-success"><i class="fa fa-check"></i> Hoàn thành</a>
                <% } %>

                <a href="AdminOrder?action=view&id=<%= o.getId() %>" class="action-btn" style="background:#555;"><i class="fa fa-eye"></i> Chi tiết</a>
              </td>
            </tr>
            <%      }
            } %>
            </tbody>
          </table>
        </div>

        <%-- HIỂN THỊ CHI TIẾT ĐƠN HÀNG (NẾU CÓ) --%>
        <%
          List<OrderDetail> details = (List<OrderDetail>) request.getAttribute("orderDetails");
          if(details != null) {
        %>
        <div class="content-block" style="margin-top: 20px; border: 2px solid #3498db;">
          <h3>Chi tiết đơn hàng #<%= request.getAttribute("orderId") %></h3>
          <table class="data-table">
            <thead><tr><th>Sản phẩm</th><th>Giá</th><th>Số lượng</th><th>Thành tiền</th></tr></thead>
            <tbody>
            <% for(OrderDetail d : details) { %>
            <tr>
              <td><%= d.getProductName() %></td>
              <td><fmt:formatNumber value="<%= d.getPrice() %>"/>đ</td>
              <td><%= d.getQuantity() %></td>
              <td><fmt:formatNumber value="<%= d.getPrice() * d.getQuantity() %>"/>đ</td>
            </tr>
            <% } %>
            </tbody>
          </table>
          <br>
          <a href="AdminOrder" class="btn-cancel" style="background: #95a5a6; color: white; padding: 5px 10px; border-radius: 3px;">Đóng chi tiết</a>
        </div>
        <% } %>

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