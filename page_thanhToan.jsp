<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %> <%-- Nếu lỗi thì đổi thành http://java.sun.com/jsp/jstl/fmt --%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh Toán Đơn Hàng</title>
    <link rel="stylesheet" href="homeStyle.css" /> 
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <style>
        /* CSS riêng cho form thanh toán cho đẹp */
        .checkout-container { width: 800px; margin: 30px auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); display: flex; gap: 30px; }
        .product-summary { flex: 1; border-right: 1px solid #eee; padding-right: 20px; }
        .customer-form { flex: 1.5; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input, .form-group textarea { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; }
        .btn-confirm { width: 100%; padding: 12px; background: #c49a00; color: white; border: none; font-size: 16px; font-weight: bold; cursor: pointer; border-radius: 4px; }
        .btn-confirm:hover { background: #a38100; }
        .product-img { width: 100%; max-width: 200px; border-radius: 5px; }
    </style>
</head>
<body>

    <h2 style="text-align: center; padding: 20px; background: #eee; margin: 0;">XÁC NHẬN THANH TOÁN</h2>

    <%
        // Lấy ID sản phẩm từ đường dẫn
        String idStr = request.getParameter("id");
        String tenSp = "";
        String hinhAnh = "";
        double gia = 0;
        
        if (idStr != null) {
            Connection conn = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                // Anh Thắng nhớ kiểm tra port 3306 hay 3307 nhé
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8", "root", "");
                
                String sql = "SELECT * FROM home_sanpham WHERE id = ?";
                PreparedStatement pst = conn.prepareStatement(sql);
                pst.setInt(1, Integer.parseInt(idStr));
                ResultSet rs = pst.executeQuery();
                
                if (rs.next()) {
                    tenSp = rs.getString("ten_sp");
                    hinhAnh = rs.getString("hinh_anh");
                    gia = rs.getDouble("gia");
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (conn != null) conn.close();
            }
        }
    %>

    <div class="checkout-container">
        <div class="product-summary">
            <h3 style="color: #c49a00; border-bottom: 2px solid #c49a00; padding-bottom: 10px;">Sản phẩm bạn chọn</h3>
            <% if (!tenSp.isEmpty()) { %>
                <img src="image_all/<%= hinhAnh %>" class="product-img" alt="Anh san pham">
                <h4><%= tenSp %></h4>
                <p style="color: red; font-size: 18px; font-weight: bold;">
                    Giá: <%= String.format("%,.0f", gia) %>đ
                </p>
            <% } else { %>
                <p style="color:red">Không tìm thấy sản phẩm!</p>
            <% } %>
            <br>
            <a href="home.jsp" style="color: #666; text-decoration: underline;">&laquo; Quay lại chọn thêm</a>
        </div>

        <div class="customer-form">
            <h3 style="color: #333; border-bottom: 2px solid #333; padding-bottom: 10px;">Thông tin giao hàng</h3>
            
            <%-- Form này sẽ gửi đến trang xử lý đặt hàng (Ví dụ: process_order.jsp) --%>
            <form action="process_order.jsp" method="POST">
                <input type="hidden" name="productId" value="<%= idStr %>">
                <input type="hidden" name="totalPrice" value="<%= gia %>">

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