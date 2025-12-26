<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.DecimalFormat" %>

<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    DecimalFormat formatter = new DecimalFormat("###,###");

    // LẤY DANH SÁCH TỪ CONTROLLER (Quan trọng)
    List<Map<String, Object>> cartItems = (List<Map<String, Object>>) request.getAttribute("cartItems");
    Double tongTien = (Double) request.getAttribute("tongTien");
    if (tongTien == null) tongTien = 0.0;
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <title>Thanh Toán Đơn Hàng</title>
    <link rel="stylesheet" href="css_ThanhToan.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</head>
<body>

<h2 style="text-align: center; padding: 20px; background: #eee; margin: 0;">XÁC NHẬN THANH TOÁN</h2>

<div class="checkout-container">
    <div class="product-summary">
        <h3 style="color: #c49a00; border-bottom: 2px solid #c49a00; padding-bottom: 10px;">Đơn hàng của bạn</h3>

        <%
            if (cartItems != null && !cartItems.isEmpty()) {
                for (Map<String, Object> item : cartItems) {
        %>
        <div class="order-item">
            <img src="image_all/<%= item.get("hinh_anh") %>" alt="Product">
            <div class="item-info">
                <h4><%= item.get("ten_sp") %></h4>
                <p>Số lượng: <strong><%= item.get("so_luong") %></strong></p>
            </div>
            <div class="item-price">
                <%= formatter.format(item.get("tam_tinh")) %>đ
            </div>
        </div>
        <%
            }
        } else {
        %>
        <p style="color: red; text-align: center;">Giỏ hàng của bạn đang trống!</p>
        <p style="text-align: center;"><a href="Home">Quay lại mua hàng</a></p>
        <% } %>

        <div class="total-section">
            <span class="total-label">Tổng cộng:</span>
            <span class="total-price"><%= formatter.format(tongTien) %>đ</span>
        </div>
    </div>

    <div class="customer-form">
        <h3 style="color: #333; border-bottom: 2px solid #333; padding-bottom: 10px;">Thông tin giao hàng</h3>
        <form action="ProcessOrder" method="POST">
            <div class="form-group">
                <label>Họ tên:</label>
                <input type="text" name="customerName" required placeholder="Nhập họ tên...">
            </div>
            <div class="form-group">
                <label>SĐT:</label>
                <input type="text" name="customerPhone" required placeholder="Nhập số điện thoại...">
            </div>
            <div class="form-group">
                <label>Địa chỉ:</label>
                <textarea name="customerAddress" rows="3" required placeholder="Nhập địa chỉ..."></textarea>
            </div>
            <div class="form-group">
                <label>Ghi chú:</label>
                <textarea name="note" rows="2"></textarea>
            </div>
            <button type="submit" class="btn-confirm">XÁC NHẬN ĐẶT HÀNG</button>
        </form>
    </div>
</div>
</body>
</html>