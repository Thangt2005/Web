<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="model.User" %>

<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    DecimalFormat formatter = new DecimalFormat("###,###");

    // Lấy thông tin user đăng nhập (để điền sẵn vào form nếu cần)
    User user = (User) session.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <title>Thanh Toán Đơn Hàng</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        body { font-family: Arial, sans-serif; background: #f4f4f4; margin: 0; padding: 0; }
        .checkout-container { width: 1000px; margin: 30px auto; background: #fff; display: flex; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .checkout-left, .checkout-right { padding: 30px; }
        .checkout-left { width: 45%; border-right: 1px solid #ddd; }
        .checkout-right { width: 55%; }
        h2 { color: #333; margin-top: 0; border-bottom: 2px solid #ffcc00; padding-bottom: 10px; display: inline-block; }

        /* CSS cho danh sách sản phẩm bên trái */
        .order-item { display: flex; align-items: center; margin-bottom: 15px; border-bottom: 1px dashed #eee; padding-bottom: 10px; }
        .order-item img { width: 60px; height: 60px; object-fit: cover; border: 1px solid #ddd; margin-right: 15px; }
        .item-info { flex: 1; }
        .item-name { font-weight: bold; font-size: 14px; color: #333; display: block; }
        .item-meta { font-size: 13px; color: #666; }
        .item-total { font-weight: bold; color: #d0011b; }

        .order-summary { margin-top: 20px; border-top: 2px solid #333; padding-top: 15px; }
        .summary-row { display: flex; justify-content: space-between; margin-bottom: 10px; font-size: 16px; }
        .total-price { font-size: 20px; color: #d0011b; font-weight: bold; }

        /* Form bên phải */
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input, .form-group textarea { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        .btn-confirm { width: 100%; padding: 12px; background: #d0011b; color: #fff; border: none; font-size: 16px; font-weight: bold; cursor: pointer; text-transform: uppercase; }
        .btn-confirm:hover { background: #a80015; }
        .back-link { display: block; margin-top: 15px; text-align: center; color: #666; text-decoration: none; }

        .header-title { text-align: center; padding: 20px 0; font-size: 24px; font-weight: bold; text-transform: uppercase; color: #333; }
    </style>
</head>
<body>

<div class="header-title">Xác nhận thanh toán</div>

<div class="checkout-container">
    <div class="checkout-left">
        <h2>Sản phẩm bạn chọn</h2>

        <div class="order-list">
            <%
                // Lấy dữ liệu từ CheckoutController gửi sang
                List<Map<String, Object>> items = (List<Map<String, Object>>) request.getAttribute("cartItems");
                double finalTotal = 0;

                if (items != null && !items.isEmpty()) {
                    for (Map<String, Object> item : items) {
                        double gia = (double) item.get("gia");
                        int soLuong = (int) item.get("so_luong");
                        double tamTinh = (double) item.get("tam_tinh");
                        finalTotal += tamTinh;
            %>
            <div class="order-item">
                <img src="<%= item.get("hinh_anh") %>" onerror="this.src='https://via.placeholder.com/60'">
                <div class="item-info">
                    <span class="item-name"><%= item.get("ten_sp") %></span>
                    <div class="item-meta">
                        <%= formatter.format(gia) %>đ x <%= soLuong %>
                    </div>
                </div>
                <div class="item-total">
                    <%= formatter.format(tamTinh) %>đ
                </div>
            </div>
            <%
                }
            } else {
            %>
            <p style="color: red;">Không tìm thấy thông tin sản phẩm! Vui lòng quay lại giỏ hàng.</p>
            <% } %>
        </div>

        <div class="order-summary">
            <div class="summary-row">
                <span>Tạm tính:</span>
                <span><%= formatter.format(finalTotal) %>đ</span>
            </div>
            <div class="summary-row">
                <span>Phí vận chuyển:</span>
                <span>Miễn phí</span>
            </div>
            <div class="summary-row" style="margin-top: 15px;">
                <strong>Thành tiền:</strong>
                <span class="total-price"><%= formatter.format(finalTotal) %>đ</span>
            </div>
        </div>

        <a href="Cart" class="back-link">« Quay lại giỏ hàng</a>
    </div>

    <div class="checkout-right">
        <h2>Thông tin giao hàng</h2>

        <form action="PlaceOrder" method="POST">
            <div class="form-group">
                <label>Họ và tên người nhận:</label>
                <input type="text" name="fullname" placeholder="Nhập họ tên..." required
                       value="<%= (user != null) ? user.getFullname() : "" %>">
            </div>

            <div class="form-group">
                <label>Số điện thoại:</label>
                <input type="text" name="phone" placeholder="Nhập số điện thoại..." required>
            </div>

            <div class="form-group">
                <label>Địa chỉ giao hàng:</label>
                <textarea name="address" rows="3" placeholder="Số nhà, đường, phường/xã..." required></textarea>
            </div>

            <div class="form-group">
                <label>Ghi chú (nếu có):</label>
                <textarea name="note" rows="2"></textarea>
            </div>

            <input type="hidden" name="totalAmount" value="<%= finalTotal %>">

            <button type="submit" class="btn-confirm">
                <i class="fa-solid fa-check-circle"></i> Xác nhận đặt hàng
            </button>
        </form>
    </div>
</div>

</body>
</html>