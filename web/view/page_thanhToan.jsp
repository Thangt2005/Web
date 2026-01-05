<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Product" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%
        String path = request.getContextPath();
        String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    %>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <title>Thanh Toán Đơn Hàng - MVC</title>
    <link rel="stylesheet" href="homeStyle.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <style>
        .checkout-container { width: 800px; margin: 30px auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); display: flex; gap: 30px; }
        .product-summary { flex: 1; border-right: 1px solid #eee; padding-right: 20px; }
        .customer-form { flex: 1.5; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input, .form-group textarea { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; }
        .btn-confirm { width: 100%; padding: 12px; background: #c49a00; color: white; border: none; font-size: 16px; font-weight: bold; cursor: pointer; border-radius: 4px; }
        .product-img { width: 100%; max-width: 200px; border-radius: 5px; }
    </style>
</head>
<body>

<h2 style="text-align: center; padding: 20px; background: #eee; margin: 0;">XÁC NHẬN THANH TOÁN</h2>

<div class="checkout-container">
    <div class="product-summary">
        <h3 style="color: #c49a00; border-bottom: 2px solid #c49a00; padding-bottom: 10px;">Sản phẩm bạn chọn</h3>
        <%
            Product p = (Product) request.getAttribute("product");
            if (p != null) {
        %>
        <img src="image_all/<%= p.getHinhAnh() %>" class="product-img" alt="Anh san pham">
        <h4><%= p.getTenSp() %></h4>
        <p style="color: red; font-size: 18px; font-weight: bold;">
            Giá: <%= String.format("%,.0f", p.getGia()) %>đ
        </p>
        <% } else { %>
        <p style="color:red">Không tìm thấy thông tin sản phẩm!</p>
        <% } %>
        <br>
        <a href="Home" style="color: #666; text-decoration: underline;">&laquo; Quay lại chọn thêm</a>
    </div>

    <div class="customer-form">
        <h3 style="color: #333; border-bottom: 2px solid #333; padding-bottom: 10px;">Thông tin giao hàng</h3>

        <form action="ProcessOrder" method="POST">
            <input type="hidden" name="productId" value="<%= (p != null) ? p.getId() : "" %>">
            <input type="hidden" name="totalPrice" value="<%= (p != null) ? p.getGia() : 0 %>">

            <div class="form-group">
                <label>Họ và tên người nhận:</label>
                <input type="text" name="customerName" required placeholder="Nhập họ tên...">
            </div>

            <div class="form-group">
                <label>Số điện thoại:</label>
                <input type="text" name="customerPhone" required placeholder="Nhập số điện thoại...">
            </div>

            <div class="form-group">
                <label>Địa chỉ giao hàng:</label>
                <textarea name="customerAddress" rows="3" required placeholder="Số nhà, đường, phường/xã..."></textarea>
            </div>

            <div class="form-group">
                <label>Ghi chú (nếu có):</label>
                <textarea name="note" rows="2"></textarea>
            </div>

            <button type="submit" class="btn-confirm">
                <i class="fa-solid fa-check-circle"></i> XÁC NHẬN ĐẶT HÀNG
            </button>
        </form>
    </div>
</div>
</body>
</html>