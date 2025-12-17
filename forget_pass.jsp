<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    // --- PHẦN 1: XỬ LÝ JAVA BACKEND ---
    String message = "";
    String msgColor = "red";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");

        if (email != null && !email.trim().isEmpty()) {
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                // Kết nối Database login - Cổng 3306
                Class.forName("com.mysql.cj.jdbc.Driver");
                String url = "jdbc:mysql://localhost:3306/login?useUnicode=true&characterEncoding=UTF-8";
                String user = "root";
                String pass = ""; 
                
                conn = DriverManager.getConnection(url, user, pass);

                // Kiểm tra email có tồn tại trong bảng login không
                String sql = "SELECT * FROM login WHERE email = ?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, email);
                rs = ps.executeQuery();

                if (rs.next()) {
                    // Nếu tìm thấy Email
                    message = "Yêu cầu đã được gửi! Vui lòng kiểm tra hộp thư đến của email: " + email;
                    msgColor = "green";
                } else {
                    // Nếu không tìm thấy
                    message = "Lỗi: Email này không tồn tại trong hệ thống!";
                    msgColor = "red";
                }

            } catch (Exception e) {
                message = "Lỗi hệ thống: " + e.getMessage();
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quên Mật Khẩu</title>
    <link rel="stylesheet" href="css_forget_pass.css" />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
    />
  </head>
  <body>
    <header>
      <h1>THIẾT BỊ VỆ SINH & PHÒNG TẮM</h1>
    </header>

    <div class="login-container">
      <h2>Quên Mật Khẩu</h2>
      <div class="forgot-password-form">
        <p>
          Vui lòng nhập địa chỉ email đã đăng ký của bạn. Chúng tôi sẽ gửi một
          liên kết để bạn đặt lại mật khẩu.
        </p>

        <% if (!message.isEmpty()) { %>
            <div style="text-align: center; color: <%= msgColor %>; margin-bottom: 15px; font-weight: bold;">
                <%= message %>
            </div>
        <% } %>

        <form action="forget_pass.jsp" method="POST">
          <div class="email-login">
            <input type="email" name="email" placeholder="Nhập Email của bạn" required 
                   value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>"/>
          </div>
          <button type="submit" class="login-btn">GỬI YÊU CẦU ĐẶT LẠI</button>
        </form>
        
        <div class="back-to-login">
          <a href="login_page.jsp">&#8592; Quay lại Đăng nhập</a>
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
            <a href="https://www.facebook.com/huuthang11092005"><i class="fa-brands fa-facebook"></i></a>
            <a href="https://www.youtube.com/@huuthangtran9024/posts"><i class="fa-brands fa-youtube"></i></a>
            <a href="https://www.tiktok.com/@thangtt26"><i class="fa-brands fa-tiktok"></i></a>
          </div>
        </div>
      </div>

      <div class="footer-bottom">
        © 2025 Thiết Bị Vệ Sinh & Phòng Tắm - All Rights Reserved.
      </div>
    </footer>
  </body>
</html>