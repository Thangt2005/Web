<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.DecimalFormat" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    DecimalFormat formatter = new DecimalFormat("###,###");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ Hàng - Thiết Bị Vệ Sinh</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link rel="stylesheet" href="homeStyle.css" /> <%-- Dùng chung style header/footer --%>

    <style>
        /* CSS Riêng cho trang giỏ hàng để đẹp hơn */
        .cart-container { max-width: 1200px; margin: 0 auto; padding: 20px; font-family: Arial, sans-serif; }
        .cart-table { width: 100%; border-collapse: collapse; margin-bottom: 20px; background: #fff; box-shadow: 0 0 10px rgba(0,0,0,0.05); }
        .cart-table th { background: #f8f8f8; padding: 15px; text-align: left; border-bottom: 2px solid #ddd; }
        .cart-table td { padding: 15px; border-bottom: 1px solid #eee; vertical-align: middle; }

        .product-info { display: flex; align-items: center; }
        .product-info img { width: 80px; height: 80px; object-fit: cover; border: 1px solid #ddd; margin-right: 15px; border-radius: 4px; }
        .product-name { font-weight: bold; color: #333; }

        /* === Style cho bộ nút cộng trừ === */
        .qty-control { display: flex; align-items: center; border: 1px solid #ddd; width: fit-content; border-radius: 4px; }
        .qty-btn {
            display: inline-block;
            width: 30px;
            height: 30px;
            line-height: 30px;
            text-align: center;
            background: #f1f1f1;
            color: #333;
            text-decoration: none;
            font-weight: bold;
            font-size: 16px;
            transition: background 0.2s;
        }
        .qty-btn:hover { background: #ddd; }
        .qty-input {
            width: 40px;
            height: 30px;
            border: none;
            text-align: center;
            font-size: 14px;
            font-weight: bold;
            outline: none;
        }
        /* Ẩn nút tăng giảm mặc định của trình duyệt */
        input::-webkit-outer-spin-button, input::-webkit-inner-spin-button { -webkit-appearance: none; margin: 0; }

        .price, .subtotal { font-weight: bold; color: #333; }
        .remove-btn { color: #999; text-decoration: none; font-size: 14px; transition: 0.2s; }
        .remove-btn:hover { color: #d0011b; }

        .cart-total { text-align: right; margin-top: 20px; padding: 20px; background: #f9f9f9; border-radius: 4px; }
        .total-row { font-size: 18px; margin-bottom: 20px; }
        .total-amount { color: #d0011b; font-size: 24px; font-weight: bold; margin-left: 10px; }

        .action-buttons button, .action-buttons a.continue-shopping {
            padding: 12px 25px; border: none; cursor: pointer; font-size: 16px; border-radius: 4px; text-decoration: none; display: inline-block;
        }
        .continue-shopping { background: #fff; border: 1px solid #ddd; color: #333; margin-right: 10px; }
        .continue-shopping:hover { background: #f1f1f1; }
        .checkout-btn { background: #d0011b; color: #fff; }
        .checkout-btn:hover { background: #a80015; }
    </style>
</head>
<body>

<header>
    <h1>Thiết Bị Vệ Sinh Và Phòng Tắm</h1>
    <nav>
        <ul class="user-menu">
            <li><a href="Home"><i class="fa-solid fa-house"></i> Tiếp tục mua hàng</a></li>
            <li><a href="#"><i class="fas fa-user"></i> Anh Thắng</a></li>
        </ul>
    </nav>
</header>

<main class="cart-container">
    <h2 style="text-align:center; margin: 30px 0; color: #333;">CHI TIẾT GIỎ HÀNG</h2>

    <table class="cart-table">
        <thead>
        <tr>
            <th>Sản phẩm</th>
            <th>Giá</th>
            <th>Số lượng</th>
            <th>Tạm tính</th>
            <th>Thao tác</th>
        </tr>
        </thead>
        <tbody>
        <%
            // Lấy danh sách sản phẩm chi tiết từ CartController (Servlet) truyền sang
            List<Map<String, Object>> items = (List<Map<String, Object>>) request.getAttribute("cartItems");
            double totalPrice = 0;

            if (items != null && !items.isEmpty()) {
                for (Map<String, Object> item : items) {
                    double gia = (double) item.get("gia");
                    int soLuong = (int) item.get("so_luong");
                    double tamTinh = gia * soLuong;
                    totalPrice += tamTinh;
        %>
        <tr>
            <td class="product-info">
                <%-- Đảm bảo link ảnh đúng --%>
                <img src="<%= item.get("hinh_anh") %>" alt="Product" onerror="this.src='https://via.placeholder.com/80'"/>
                <span class="product-name"><%= item.get("ten_sp") %></span>
            </td>
            <td class="price"><%= formatter.format(gia) %>đ</td>
            <td class="qty">
                <%-- NÚT CỘNG TRỪ SỐ LƯỢNG --%>
                <div class="qty-control">
                    <%-- Nút TRỪ: Gọi action=decrease --%>
                    <a href="Cart?action=decrease&id=<%= item.get("id") %>" class="qty-btn">-</a>

                    <%-- Hiển thị số lượng --%>
                    <input type="number" class="qty-input" value="<%= soLuong %>" readonly />

                    <%-- Nút CỘNG: Gọi action=add (mặc định tăng) --%>
                    <a href="Cart?action=add&id=<%= item.get("id") %>" class="qty-btn">+</a>
                </div>
            </td>
            <td class="subtotal"><%= formatter.format(tamTinh) %>đ</td>
            <td>
                <%-- Link xóa sản phẩm gọi action=delete --%>
                <a href="Cart?action=delete&id=<%= item.get("id") %>" class="remove-btn" onclick="return confirm('Bạn chắc chắn muốn xóa sản phẩm này?')">
                    <i class="fa-solid fa-trash"></i> Xóa
                </a>
            </td>
        </tr>
        <%
            }
        } else {
        %>
        <tr>
            <td colspan="5" style="text-align:center; padding: 50px;">
                <i class="fa-solid fa-cart-shopping" style="font-size: 50px; color: #ccc;"></i>
                <p style="margin-top: 15px; color: #666;">Giỏ hàng đang trống !</p>
                <a href="Home" class="checkout-btn" style="display:inline-block; width: auto; padding: 10px 30px; margin-top: 10px;">
                    Quay lại mua sắm ngay
                </a>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>

    <% if (items != null && !items.isEmpty()) { %>
    <div class="cart-total">
        <div class="total-row">
            <span>Tổng cộng giỏ hàng:</span>
            <strong class="total-amount"><%= formatter.format(totalPrice) %>đ</strong>
        </div>
        <div class="action-buttons">
            <a href="Home" class="continue-shopping">Tiếp tục mua hàng</a>

            <button class="checkout-btn" onclick="window.location.href='ThanhToan'">Tiến hành thanh toán</button>
        </div>
    </div>
    <% } %>
</main>

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
</body>
</html>