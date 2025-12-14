<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="jakarta.tags.core" prefix="c" %> <%@
taglib uri="jakarta.tags.sql" prefix="sql" %> <%-- Đặt encoding để nhận tiếng
Việt từ form --%> <% request.setCharacterEncoding("UTF-8"); %>

<c:if test="${pageContext.request.method == 'POST'}">
  <c:choose>
    <c:when test="${param['password-register'] != param['password-register1']}">
      <c:set var="message" value="Lỗi: Mật khẩu nhập lại không khớp!" />
      <c:set var="msgColor" value="red" />
    </c:when>

    <c:otherwise>
      <sql:setDataSource
        var="dbConnection"
        driver="com.mysql.cj.jdbc.Driver"
        url="jdbc:mysql://localhost:3307/login?useUnicode=true&characterEncoding=UTF-8"
        user="root"
        password=""
      />

      <c:catch var="dbError">
        <sql:update dataSource="${dbConnection}" var="insertCount">
          INSERT INTO login (email, username, password) VALUES (?, ?, ?)
          <sql:param value="${param.email}" />
          <sql:param value="${param['username-register']}" />
          <sql:param value="${param['password-register']}" />
        </sql:update>
      </c:catch>

      <c:choose>
        <c:when test="${not empty dbError}">
          <c:set
            var="message"
            value="Đăng ký thất bại: Tài khoản hoặc Email đã tồn tại!"
          />
          <c:set var="msgColor" value="red" />
        </c:when>
        <c:when test="${insertCount > 0}">
          <c:redirect url="login_page.jsp" />
        </c:when>
        <c:otherwise>
          <c:set
            var="message"
            value="Đăng ký không thành công. Vui lòng thử lại."
          />
          <c:set var="msgColor" value="red" />
        </c:otherwise>
      </c:choose>
    </c:otherwise>
  </c:choose>
</c:if>

<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <title>Đăng kí</title>
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

    <div class="register-container">
      <h2>Đăng Kí</h2>

      <c:if test="${not empty message}">
        <div
          style="text-align: center; color: ${msgColor}; margin-bottom: 10px; font-weight: bold;"
        >
          ${message}
        </div>
      </c:if>

      <div class="social-login">
        <button class="facebook">
          <i class="fa-brands fa-facebook-f"></i>
          <span>Đăng kí bằng Facebook</span>
        </button>

        <button class="twitter">
          <i class="fa-brands fa-twitter"></i> <span>Đăng kí bằng Twitter</span>
        </button>

        <button class="google">
          <i class="fa-brands fa-google"></i> <span>Đăng kí bằng Google</span>
        </button>
        <h3>Tạo tài khoản tại đây</h3>

        <form
          class="email-register"
          id="register-form"
          method="POST"
          action="register_page.jsp"
        >
          <input
            type="email"
            id="email"
            name="email"
            placeholder="E-mail"
            required
            value="${param.email}"
          />
          <input
            type="text"
            id="username-register"
            name="username-register"
            placeholder="Username"
            required
            value="${param['username-register']}"
          />
          <input
            type="password"
            id="password-register"
            name="password-register"
            placeholder="Password"
            required
          />
          <input
            type="password"
            id="password-register1"
            name="password-register1"
            placeholder="Password repeat "
            required
          />
          <button type="submit" class="login-btn">ĐĂNG KÍ</button>
        </form>
        <p class="links">
          <a href="#">Đã có tài khoản?</a> |
          <a href="login_page.jsp">Đăng nhập ngay</a>
        </p>
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
            <a href="#"><i class="fa-brands fa-facebook"></i></a>
            <a href="#"><i class="fa-brands fa-youtube"></i></a>
            <a href="#"><i class="fa-brands fa-tiktok"></i></a>
          </div>
        </div>
      </div>

      <div class="footer-bottom">
        © 2025 Thiết Bị Vệ Sinh & Phòng Tắm - All Rights Reserved.
      </div>
    </footer>
  </body>
</html>
