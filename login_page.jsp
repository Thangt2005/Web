<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.sql" prefix="sql" %>

<%! 
    // Khai báo biến Java để lưu thông báo lỗi
    String errorMessage = null; 
%>

<%
    // 1. Kiểm tra nếu có POST request (Người dùng bấm ĐĂNG NHẬP)
    if ("POST".equals(request.getMethod())) {
        // Lấy dữ liệu từ form
        String u = request.getParameter("username");
        String p = request.getParameter("password");
        
        // Cố gắng kết nối và xác thực
        try {
            // 2. Thiết lập kết nối CSDL (Lưu ý: Không dùng thẻ sql:setDataSource ở đây 
            // vì nó thiết lập biến JSTL, không phải đối tượng kết nối Java)
            java.sql.Connection conn = null;
            java.sql.PreparedStatement pstmt = null;
            java.sql.ResultSet rs = null;
            
            // Đây là cách kết nối CSDL truyền thống bằng Java trong Scriptlet (cần thư viện JDBC driver trong classpath)
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = java.sql.DriverManager.getConnection("jdbc:mysql://localhost:3307/login?useUnicode=true&characterEncoding=UTF-8", "root", "");
            
            // 3. Sử dụng Prepared Statement để chống SQL Injection (Mặc dù đây là Scriptlet, vẫn nên làm)
            String sql = "SELECT * FROM login WHERE username=? AND password=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, u);
            pstmt.setString(2, p);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                // Đăng nhập thành công
                // Thiết lập Session (trong Java EE, Session được quản lý qua request.getSession())
                session.setAttribute("user", u);
                
                // Chuyển hướng sang trang home.jsp
                response.sendRedirect("home.jsp");
                return; // Kết thúc code
            } else {
                // Đăng nhập thất bại
                errorMessage = "Sai tài khoản hoặc mật khẩu! Vui lòng thử lại.";
            }
            
            // Đóng kết nối
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
            
        } catch (Exception e) {
            errorMessage = "Lỗi hệ thống: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <title>Đăng nhập</title>
    <link rel="stylesheet" href="style.css" />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
    />
  </head>
  <body>
    <header>
      <h1>Thiết Bị Vệ Sinh Và Phòng Tắm</h1>
    </header>
    
    <div class="login-container">
      <h2>Đăng nhập</h2>

      <%-- Hiển thị thông báo lỗi nếu có --%>
      <% if (errorMessage != null) { %>
          <div style="color: red; text-align: center; margin-bottom: 10px;">
              <%= errorMessage %>
          </div>
      <% } %>

      <div class="social-login">
        <button class="facebook"><i class="fa-brands fa-facebook-f"></i><span> Facebook</span></button>
        <button class="twitter"><i class="fa-brands fa-twitter"></i><span> Twitter</span></button>
        <button class="google"><i class="fa-brands fa-google"></i> <span> Google</span></button>
      </div>

      <h3>Đăng nhập bằng email</h3>

      <%-- action="" gửi lại chính trang này, method="POST" --%>
      <form class="email-login" id="login-form" action="login_page.jsp" method="POST"> 
        <input
          type="text"
          id="email"
          name="username" 
          placeholder="Username hoặc E-mail"
          required
        />

        <div class="password-wrapper">
          <input
            type="password"
            id="password"
            name="password"
            placeholder="Mật khẩu"
            required
          />
          <span class="toggle-password"></span>
        </div>

        <button type="submit" class="login-btn">ĐĂNG NHẬP</button>
      </form>

      <p class="links">
        <a href="forget_pass.jsp">Quên mật khẩu?</a> | <%-- Cập nhật đuôi file --%>
        <a href="register_page.jsp">Đăng ký tài khoản</a> <%-- Cập nhật đuôi file --%>
      </p>
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
            <a href="https://www.facebook.com/huuthang11092005"
              ><i class="fa-brands fa-facebook"></i
            ></a>
            <a href="https://www.youtube.com/@huuthangtran9024/posts"
              ><i class="fa-brands fa-youtube"></i
            ></a>
            <a href="https://www.tiktok.com/@thangtt26"
              ><i class="fa-brands fa-tiktok"></i
            ></a>
          </div>
        </div>
      </div>

      <div class="footer-bottom">
        © 2025 Thiết Bị Vệ Sinh & Phòng Tắm - All Rights Reserved.
      </div>
    </footer>
  </body>
</html>