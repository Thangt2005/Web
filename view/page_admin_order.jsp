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
    .badge { padding: 5px 10px; border-radius: 4px; color: white; font-weight: bold; font-size: 12px; }
    .bg-warning { background-color: #f39c12; } /* Chờ xác nhận */
    .bg-info { background-color: #3498db; }    /* Đang giao */
    .bg-success { background-color: #2ecc71; } /* Thành công */
    .bg-danger { background-color: #e74c3c; }  /* Đã hủy */
    .action-btn { margin-right: 5px; text-decoration: none; padding: 5px 8px; border-radius: 3px; font-size: 12px; color: white; }
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
  <footer class="footer"><div class="footer-bottom">© 2025 Thiết Bị Vệ Sinh Admin</div></footer>
</div>
</body>
</html>