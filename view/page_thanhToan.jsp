<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="model.User" %>

<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    DecimalFormat formatter = new DecimalFormat("###,###");

    // Lấy thông tin user đăng nhập
    User user = (User) session.getAttribute("user");

    // Xử lý nội dung hiển thị để tránh hiện chữ "null"
    String displayFullname = (user != null && user.getFullname() != null) ? user.getFullname() : "";

    // Nếu chưa có SĐT thì hiện dòng nhắc
    String displayPhone = (user != null && user.getPhone() != null) ? user.getPhone() : "Hãy nhập số điện thoại";

    // Nếu chưa có địa chỉ thì hiện dòng nhắc
    String displayAddress = (user != null && user.getAddress() != null) ? user.getAddress() : "Hãy nhập địa chỉ giao hàng";
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <title>Thanh Toán Đơn Hàng</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        body { font-family: "Segoe UI", Arial, sans-serif; background: #f4f4f4; margin: 0; padding: 0; color: #333; }
        .checkout-container { width: 1000px; margin: 30px auto; background: #fff; display: flex; box-shadow: 0 0 15px rgba(0,0,0,0.1); border-radius: 8px; overflow: hidden; }
        .checkout-left, .checkout-right { padding: 30px; }
        .checkout-left { width: 45%; border-right: 1px solid #eee; background: #fafafa; }
        .checkout-right { width: 55%; background: #fff; }
        h2 { color: #333; margin-top: 0; border-bottom: 2px solid #d70018; padding-bottom: 10px; display: inline-block; font-size: 20px; text-transform: uppercase; }

        .order-item { display: flex; align-items: center; margin-bottom: 15px; border-bottom: 1px dashed #ddd; padding-bottom: 10px; }
        .order-item img { width: 60px; height: 60px; object-fit: cover; border: 1px solid #ddd; margin-right: 15px; border-radius: 4px; }
        .item-info { flex: 1; }
        .item-name { font-weight: 600; font-size: 14px; color: #333; display: block; margin-bottom: 4px; }
        .item-meta { font-size: 13px; color: #666; }
        .item-total { font-weight: bold; color: #d70018; font-size: 15px; }

        .order-summary { margin-top: 20px; border-top: 2px solid #333; padding-top: 15px; }
        .summary-row { display: flex; justify-content: space-between; margin-bottom: 10px; font-size: 15px; }
        .total-price { font-size: 22px; color: #d70018; font-weight: bold; }

        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 600; font-size: 14px; }
        .form-group input, .form-group textarea { width: 100%; padding: 12px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; font-family: inherit; transition: border 0.3s; }
        .form-group input:focus, .form-group textarea:focus { border-color: #d70018; outline: none; }

        /* Hiệu ứng cho lời nhắc màu xám nhẹ để người dùng biết cần sửa */
        .input-reminder { color: #888; font-style: italic; }

        .btn-confirm { width: 100%; padding: 14px; background: #d70018; color: #fff; border: none; font-size: 16px; font-weight: bold; cursor: pointer; text-transform: uppercase; border-radius: 4px; transition: background 0.3s; }
        .btn-confirm:hover { background: #a80015; }
        .back-link { display: block; margin-top: 15px; text-align: center; color: #666; text-decoration: none; font-size: 14px; }

        .payment-option { border: 1px solid #ddd; border-radius: 6px; padding: 12px; margin-bottom: 10px; cursor: pointer; display: flex; align-items: center; transition: all 0.2s; }
        .payment-option:hover { background: #f9f9f9; border-color: #aaa; }
        .payment-option input { width: auto; margin-right: 15px; transform: scale(1.2); }
        .header-title { text-align: center; padding: 25px 0; font-size: 28px; font-weight: bold; text-transform: uppercase; color: #333; background: #fff; margin-bottom: 20px; border-bottom: 1px solid #eee; }
        .error-msg { color: red; background: #ffe6e6; padding: 10px; border-radius: 4px; margin-bottom: 15px; text-align: center; }
    </style>
</head>
<body>

<div class="header-title">Xác nhận thanh toán</div>

<div class="checkout-container">
    <div class="checkout-left">
        <h2>Sản phẩm bạn chọn</h2>
        <div class="order-list">
            <%
                List<Map<String, Object>> items = (List<Map<String, Object>>) request.getAttribute("cartItems");
                double finalTotal = 0;
                if (items != null && !items.isEmpty()) {
                    for (Map<String, Object> item : items) {
                        double gia = Double.parseDouble(item.get("gia").toString());
                        int soLuong = Integer.parseInt(item.get("so_luong").toString());
                        double tamTinh = gia * soLuong;
                        finalTotal += tamTinh;
            %>
            <div class="order-item">
                <img src="<%= item.get("hinh_anh") %>" onerror="this.src='https://via.placeholder.com/60'">
                <div class="item-info">
                    <span class="item-name"><%= item.get("ten_sp") %></span>
                    <div class="item-meta"><%= formatter.format(gia) %>đ x <%= soLuong %></div>
                </div>
                <div class="item-total"><%= formatter.format(tamTinh) %>đ</div>
            </div>
            <% } } else { %>
            <p style="color: red; text-align: center;">Giỏ hàng trống! Vui lòng quay lại chọn sản phẩm.</p>
            <% } %>
        </div>

        <div class="order-summary">
            <div class="summary-row"><span>Tạm tính:</span><span><%= formatter.format(finalTotal) %>đ</span></div>
            <div class="summary-row"><span>Phí vận chuyển:</span><span style="color: #28a745;">Miễn phí</span></div>
            <div class="summary-row" style="margin-top: 15px; padding-top: 15px; border-top: 1px dashed #ccc;">
                <strong>Thành tiền:</strong><span class="total-price"><%= formatter.format(finalTotal) %>đ</span>
            </div>
        </div>
        <a href="Cart" class="back-link">« Quay lại giỏ hàng</a>
    </div>

    <div class="checkout-right">
        <h2>Thông tin giao hàng</h2>
        <% if(request.getAttribute("error") != null) { %>
        <div class="error-msg"><i class="fa-solid fa-triangle-exclamation"></i> <%= request.getAttribute("error") %></div>
        <% } %>

        <form action="ThanhToan" method="POST">
            <div class="form-group">
                <label>Họ và tên người nhận:</label>
                <input type="text" name="fullname" placeholder="Ví dụ: Nguyễn Văn A" required
                       value="<%= displayFullname %>">
            </div>

            <div class="form-group">
                <label>Số điện thoại:</label>
                <input type="text" name="phone" required
                       value="<%= displayPhone %>"
                       onfocus="if(this.value=='Hãy nhập số điện thoại') this.value='';"
                       onblur="if(this.value=='') this.value='Hãy nhập số điện thoại';">
            </div>

            <div class="form-group">
                <label>Địa chỉ nhận hàng:</label>
                <textarea name="address" rows="3" required
                          onfocus="if(this.value=='Hãy nhập địa chỉ giao hàng') this.value='';"
                          onblur="if(this.value=='') this.value='Hãy nhập địa chỉ giao hàng';"><%= displayAddress %></textarea>
            </div>

            <div class="form-group">
                <label>Phương thức thanh toán:</label>
                <label class="payment-option">
                    <input type="radio" name="paymentMethod" value="COD" checked>
                    <i class="fa-solid fa-money-bill-wave" style="color: #28a745;"></i>
                    <span>Thanh toán khi nhận hàng (COD)</span>
                </label>
                <label class="payment-option">
                    <input type="radio" name="paymentMethod" value="PAYPAL">
                    <i class="fa-brands fa-paypal" style="color: #00457C;"></i>
                    <span>Thanh toán qua PayPal</span>
                </label>
            </div>

            <div class="form-group">
                <label>Ghi chú (nếu có):</label>
                <textarea name="note" rows="2" placeholder="Lời nhắn cho shipper..."></textarea>
            </div>

            <input type="hidden" name="totalAmount" value="<%= finalTotal %>">
            <button type="submit" class="btn-confirm">Đặt hàng ngay</button>
        </form>
    </div>
</div>

</body>
</html>