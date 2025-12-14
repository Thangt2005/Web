<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.sql" prefix="sql" %>

<%-- Đặt encoding để nhận tiếng Việt từ form --%>
<% request.setCharacterEncoding("UTF-8"); %>

<c:if test="${pageContext.request.method == 'POST'}">
    <%-- 1. Thiết lập kết nối Database --%>
    <sql:setDataSource
        var="dbConnection"
        driver="com.mysql.cj.jdbc.Driver"
        url="jdbc:mysql://localhost:3307/login?useUnicode=true&characterEncoding=UTF-8"
        user="root"
        password=""
    />
    
    <c:catch var="dbError">
        <%-- 2. Thực hiện truy vấn kiểm tra tài khoản --%>
        <sql:query dataSource="${dbConnection}" var="userResult">
            SELECT * FROM login WHERE username = ? AND password = ?
            <sql:param value="${param.username}" />
            <sql:param value="${param.password}" />
        </sql:query>
    </c:catch>

    <c:choose>
        <c:when test="${not empty dbError}">
            <%-- Lỗi kết nối hoặc truy vấn --%>
            <c:set var="message" value="Lỗi hệ thống: Không thể kết nối hoặc truy vấn dữ liệu." />
            <c:set var="msgColor" value="red" />
        </c:when>
        <c:when test="${userResult.rowCount > 0}">
            <%-- 3. Đăng nhập thành công --%>
            <%-- Lưu thông tin user vào session (có thể lấy thêm email nếu cần) --%>
            <c:set var="loggedInUser" value="${param.username}" scope="session" />
            
            <%-- Chuyển hướng sang trang home.jsp (hoặc home.php như code cũ) --%>
            <c:redirect url="home.jsp" /> 
        </c:when>
        <c:otherwise>
            <%-- Đăng nhập thất bại --%>
            <c:set var="message" value="Sai tài khoản hoặc mật khẩu! Vui lòng thử lại." />
            <c:set var="msgColor" value="red" />
        </c:otherwise>
    </c:choose>
</c:if>

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
      
      <%-- Hiển thị thông báo (Lỗi hoặc Thành công) --%>
      <c:if test="${not empty message}">
          <div style="text-align: center; color: ${msgColor}; margin-bottom: 15px; font-weight: bold;">
              ${message}
          </div>
      </c:if>

      <div class="social-login">
        <button class="facebook"><i class="fa-brands fa-facebook-f"></i><span> Facebook</span></button>
        <button class="twitter"><i class="fa-brands fa-twitter"></i><span> Twitter</span></button>
        <button class="google"><i class="fa-brands fa-google"></i> <span> Google</span></button>
      </div>

      <h3>Đăng nhập bằng email</h3>

      <form class="email-login" id="login-form" action="" method="POST">
        <input
          type="text"
          id="email"
          name="username" 
          placeholder="Username hoặc E-mail"
          required
          value="${param.username}"
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
        <a href="forget_pass.html">Quên mật khẩu?</a> |
        <a href="register_page.jsp">Đăng ký tài khoản</a>
      </p>
    </div>
    
    <footer class="footer">
        <%-- Phần footer giữ nguyên --%>
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