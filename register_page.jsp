<<<<<<< HEAD
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>

<%! 
    // Khối Declaration: Định nghĩa các biến và hằng số toàn cục (Giống như biến thành viên của Servlet)
    private static final String JDBC_URL = "jdbc:mysql://localhost:3307/login?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";

    // Tải Driver một lần khi JSP được khởi tạo
    public void jspInit() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("Lỗi Driver DB: Không tìm thấy MySQL JDBC Driver.");
            e.printStackTrace();
        }
    }
%>

<%
    // Khối Scriptlet: Thực thi logic Java khi trang được yêu cầu
    String registrationMessage = "";

    // 1. KIỂM TRA PHƯƠNG THỨC POST
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        
        // Đặt Encoding cho Request (quan trọng để xử lý tiếng Việt)
        request.setCharacterEncoding("UTF-8"); 
        
        // Lấy dữ liệu từ form
        String email = request.getParameter("email");
        String username = request.getParameter("username-register");
        String password = request.getParameter("password-register");
        String passwordRepeat = request.getParameter("password-register1");

        // 2. KIỂM TRA MẬT KHẨU NHẬP LẠI
        if (!password.equals(passwordRepeat)) {
            registrationMessage = "<h2 style='color: red;'>Lỗi: Mật khẩu nhập lại không khớp.</h2>";
        } else {
            // LƯU Ý BẢO MẬT: Dùng mật khẩu thô (Chỉ cho Demo)
            String hashedPassword = password;

            // 3. KẾT NỐI VÀ THỰC THI JDBC
            try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASSWORD)) {
                String sql = "INSERT INTO login (email, username, password) VALUES (?, ?, ?)";
                
                try (PreparedStatement statement = conn.prepareStatement(sql)) {
                    statement.setString(1, email);
                    statement.setString(2, username);
                    statement.setString(3, hashedPassword);

                    int rowInserted = statement.executeUpdate();
                    if (rowInserted > 0) {
                        // Đăng ký thành công -> Chuyển hướng
                        response.sendRedirect("login_page.jsp");
                        return; // Dừng việc render trang JSP
                    } else {
                        registrationMessage = "<h2 style='color: red;'>Đăng ký thất bại. Vui lòng thử lại.</h2>";
                    }
                }
            } catch (SQLException e) {
                // Xử lý lỗi Database (Ví dụ: Lỗi Unique Key 1062)
                if (e.getErrorCode() == 1062) {
                    registrationMessage = "<h2 style='color: red;'>Tài khoản đã tồn tại (Username/Email đã được sử dụng).</h2>";
                } else {
                    registrationMessage = "<h2 style='color: red;'>Lỗi DB: " + e.getMessage() + "</h2>";
                    e.printStackTrace();
                }
            }
        }
    }
%>
=======
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

>>>>>>> 6482930432cecd30e7524b4d1cbecb07c628100b
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
<<<<<<< HEAD
    <title>Đăng kí Tài khoản</title>
=======
    <title>Đăng kí</title>
>>>>>>> 6482930432cecd30e7524b4d1cbecb07c628100b
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
<<<<<<< HEAD
      
      <% 
          // Cú pháp Expression: in ra giá trị của biến Java registrationMessage
          if (!registrationMessage.isEmpty()) {
              out.println(registrationMessage);
          }
      %>
      
=======

      <c:if test="${not empty message}">
        <div
          style="text-align: center; color: ${msgColor}; margin-bottom: 10px; font-weight: bold;"
        >
          ${message}
        </div>
      </c:if>

>>>>>>> 6482930432cecd30e7524b4d1cbecb07c628100b
      <div class="social-login">
        <button class="facebook">
          <i class="fa-brands fa-facebook-f"></i>
          <span>Đăng kí bằng Facebook</span>
        </button>
<<<<<<< HEAD
        <button class="twitter">
          <i class="fa-brands fa-twitter"></i> <span>Đăng kí bằng Twitter</span>
        </button>
        <button class="google">
          <i class="fa-brands fa-google"></i> <span>Đăng kí bằng Google</span>
        </button>
        
        <h3>Tạo tài khoản tại đây</h3>

        <form class="email-register" id="register-form" method="post" action="register_page.jsp">
=======

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
>>>>>>> 6482930432cecd30e7524b4d1cbecb07c628100b
          <input
            type="email"
            id="email"
            name="email"
            placeholder="E-mail"
            required
<<<<<<< HEAD
            <%-- Giữ lại giá trị đã nhập nếu có lỗi --%>
            value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>"
=======
            value="${param.email}"
>>>>>>> 6482930432cecd30e7524b4d1cbecb07c628100b
          />
          <input
            type="text"
            id="username-register"
            name="username-register"
            placeholder="Username"
            required
<<<<<<< HEAD
            value="<%= request.getParameter("username-register") != null ? request.getParameter("username-register") : "" %>"
=======
            value="${param['username-register']}"
>>>>>>> 6482930432cecd30e7524b4d1cbecb07c628100b
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
<<<<<<< HEAD
    
=======

>>>>>>> 6482930432cecd30e7524b4d1cbecb07c628100b
    <footer class="footer">
      <div class="footer-container">
        <div class="footer-column">
          <h3>VỀ CHÚNG TÔI</h3>
          <p>
            Chuyên cung cấp thiết bị vệ sinh, phòng tắm chính hãng, giá tốt nhất
            thị trường.
          </p>
        </div>
<<<<<<< HEAD
=======

>>>>>>> 6482930432cecd30e7524b4d1cbecb07c628100b
        <div class="footer-column">
          <h3>LIÊN HỆ</h3>
          <p><i class="fa-solid fa-phone"></i> 0909 123 456</p>
          <p><i class="fa-solid fa-envelope"></i> contact@thietbivesinh.vn</p>
          <p><i class="fa-solid fa-location-dot"></i> TP. Hồ Chí Minh</p>
        </div>
<<<<<<< HEAD
=======

>>>>>>> 6482930432cecd30e7524b4d1cbecb07c628100b
        <div class="footer-column">
          <h3>HỖ TRỢ KHÁCH HÀNG</h3>
          <ul>
            <li><a href="#">Chính sách giao hàng</a></li>
            <li><a href="#">Chính sách bảo hành</a></li>
            <li><a href="#">Hướng dẫn thanh toán</a></li>
            <li><a href="#">Chăm sóc khách hàng</a></li>
          </ul>
        </div>
<<<<<<< HEAD
=======

>>>>>>> 6482930432cecd30e7524b4d1cbecb07c628100b
        <div class="footer-column">
          <h3>KẾT NỐI VỚI CHÚNG TÔI</h3>
          <div class="social-icons">
            <a href="#"><i class="fa-brands fa-facebook"></i></a>
            <a href="#"><i class="fa-brands fa-youtube"></i></a>
            <a href="#"><i class="fa-brands fa-tiktok"></i></a>
          </div>
        </div>
      </div>
<<<<<<< HEAD
=======

>>>>>>> 6482930432cecd30e7524b4d1cbecb07c628100b
      <div class="footer-bottom">
        © 2025 Thiết Bị Vệ Sinh & Phòng Tắm - All Rights Reserved.
      </div>
    </footer>
  </body>
<<<<<<< HEAD
</html>
=======
</html>
>>>>>>> 6482930432cecd30e7524b4d1cbecb07c628100b
