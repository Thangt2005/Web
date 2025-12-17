<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- Import thư viện SQL --%>
<%@ page import="java.sql.*" %>

<%
    // --- PHẦN 1: XỬ LÝ JAVA (BACKEND) - LOGIC ĐĂNG NHẬP ---
    
    // 1. Khai báo biến
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    // Biến lưu thông báo kết quả đăng nhập (thành công/thất bại)
    String message = ""; 

    // 2. Lấy dữ liệu từ FORM POST
    String inputUsername = request.getParameter("username");
    String inputPassword = request.getParameter("password");
    
    // Chỉ xử lý logic đăng nhập khi người dùng bấm nút (method là POST)
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        
        // Kiểm tra xem người dùng đã nhập đủ thông tin chưa
        if (inputUsername != null && !inputUsername.trim().isEmpty() && 
            inputPassword != null && !inputPassword.trim().isEmpty()) {
            
            try {
                // Load Driver MySQL
                Class.forName("com.mysql.cj.jdbc.Driver");
                
                // Cấu hình kết nối database = db
                String url = "jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8";
                String user = "root";
                String pass = "";

                // Tạo kết nối
                conn = DriverManager.getConnection(url, user, pass);

                // Câu lệnh SQL: Kiểm tra tài khoản trong bảng `login`
                // SỬ DỤNG ? (Placeholder) ĐỂ CHỐNG SQL INJECTION
                String sql = "SELECT username FROM login WHERE username = ? AND password = ?";
                
                ps = conn.prepareStatement(sql);
                ps.setString(1, inputUsername);
                ps.setString(2, inputPassword); 

                rs = ps.executeQuery();

                // Xử lý kết quả truy vấn
                if (rs.next()) {
                    // *** ĐĂNG NHẬP THÀNH CÔNG ***
                    
                    // Thiết lập Session
                    session.setAttribute("isLoggedIn", true);
                    session.setAttribute("user", inputUsername);
                    
                    // Chuyển hướng sang trang chủ hoặc trang dashboard
                    response.sendRedirect("index.jsp"); 
                    return; // Dừng việc render trang login này
                    
                } else {
                    // *** ĐĂNG NHẬP THẤT BẠI ***
                    message = "Tên đăng nhập hoặc Mật khẩu không đúng!";
                }

            } catch (ClassNotFoundException e) {
                message = "Lỗi Driver: Không tìm thấy thư viện MySQL Connector Java.";
                e.printStackTrace();
            } catch (SQLException e) {
                message = "Lỗi SQL: " + e.getMessage();
                e.printStackTrace();
            } finally {
                // 5. Đóng kết nối
                try { if (rs != null) rs.close(); } catch (SQLException e) { /* log */ }
                try { if (ps != null) ps.close(); } catch (SQLException e) { /* log */ }
                try { if (conn != null) conn.close(); } catch (SQLException e) { /* log */ }
            }
        } else {
            message = "Vui lòng nhập đầy đủ Tên đăng nhập và Mật khẩu.";
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

      <%-- Hiển thị thông báo kết quả đăng nhập --%>
      <% if (message != null && !message.trim().isEmpty()) { %>
          <div style="color: red; text-align: center; margin-bottom: 10px;">
              <%= message %>
          </div>
      <% } %>

      <div class="social-login">
        <button class="facebook"><i class="fa-brands fa-facebook-f"></i><span> Facebook</span></button>
        <button class="twitter"><i class="fa-brands fa-twitter"></i><span> Twitter</span></button>
        <button class="google"><i class="fa-brands fa-google"></i> <span> Google</span></button>

      </div>

      <h3>Đăng nhập bằng email</h3>
      <%-- action="login_page.jsp" để gửi dữ liệu trở lại chính trang này --%>
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
        <a href="forget_pass.jsp">Quên mật khẩu?</a> | 
        <a href="register_page.jsp">Đăng ký tài khoản</a> 
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