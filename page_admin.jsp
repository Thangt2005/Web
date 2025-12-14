<<<<<<< HEAD
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
=======
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ page import="java.io.*, java.sql.*, java.util.*" %>
<%@ page import="jakarta.servlet.http.Part" %> <%@ taglib
uri="jakarta.tags.core" prefix="c" %> <%@ taglib uri="jakarta.tags.sql"
prefix="sql" %> <%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<sql:setDataSource
  var="dbConnection"
  driver="com.mysql.cj.jdbc.Driver"
  url="jdbc:mysql://localhost:3307/db?useUnicode=true&characterEncoding=UTF-8"
  user="root"
  password=""
/>

<% String message = ""; /* Kiem tra method POST va nut bam */ if
("POST".equalsIgnoreCase(request.getMethod()) &&
request.getParameter("btn_add_product") != null) { Connection conn = null;
PreparedStatement pst = null; try { String tenSp =
request.getParameter("ten_sp"); String gia = request.getParameter("gia"); String
giamGia = request.getParameter("giam_gia"); String tableLoai =
request.getParameter("category"); /* Xu ly file upload */ Part filePart =
request.getPart("hinh_anh"); String fileName = filePart.getSubmittedFileName();
/* Duong dan luu anh */ String uploadPath = application.getRealPath("") +
File.separator + "image_all"; File uploadDir = new File(uploadPath); if
(!uploadDir.exists()) uploadDir.mkdir(); String fullPath = uploadPath +
File.separator + fileName; filePart.write(fullPath); /* Luu vao Database */
Class.forName("com.mysql.cj.jdbc.Driver"); conn =
DriverManager.getConnection("jdbc:mysql://localhost:3307/db?useUnicode=true&characterEncoding=UTF-8",
"root", ""); String sqlInsert = "INSERT INTO " + tableLoai + " (ten_sp,
hinh_anh, gia, giam_gia) VALUES (?, ?, ?, ?)"; pst =
conn.prepareStatement(sqlInsert); pst.setString(1, tenSp); pst.setString(2,
fileName); pst.setString(3, gia); pst.setString(4, giamGia); int row =
pst.executeUpdate(); if (row > 0) { message = "
<div
  style="
    color: green;
    background: #d4edda;
    padding: 10px;
    margin-bottom: 10px;
    border-radius: 5px;
  "
>
  Thêm sản phẩm thành công!
</div>
"; } } catch (Exception e) { message = "
<div
  style="
    color: red;
    background: #f8d7da;
    padding: 10px;
    margin-bottom: 10px;
    border-radius: 5px;
  "
>
  Lỗi: " + e.getMessage() + "
</div>
"; e.printStackTrace(); } finally { if (pst != null) pst.close(); if (conn !=
null) conn.close(); } } %>

<sql:query dataSource="${dbConnection}" var="stats">
  SELECT (SELECT COUNT(*) FROM chauchauen_sanpham) + (SELECT COUNT(*) FROM
  lavabo_sanpham) + (SELECT COUNT(*) FROM toilet_sanpham) + (SELECT COUNT(*)
  FROM voisentam_sanpham) + (SELECT COUNT(*) FROM voirua_sanpham) + (SELECT
  COUNT(*) FROM tulavabo_sanpham) + (SELECT COUNT(*) FROM bontieunam_sanpham) +
  (SELECT COUNT(*) FROM bontam_sanpham) + (SELECT COUNT(*) FROM login) as total
</sql:query>

<c:set var="totalProducts" value="${stats.rows[0].total}" />

>>>>>>> 6482930432cecd30e7524b4d1cbecb07c628100b
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <title>Admin Dashboard</title>
<<<<<<< HEAD
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link rel="stylesheet" href="admin_style.css" /> 
    <style>
        /* Các style inline cơ bản */
        .admin-form-container { background: white; padding: 20px; border-radius: 8px; margin-top: 20px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input, .form-group select { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; }
        .btn-submit { background: #28a745; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; font-weight: bold;}
        .btn-submit:hover { background: #218838; }
        /* Style cho Sidebar */
        .admin-sidebar-panel { width: 250px; min-height: 100vh; background: #333; color: white; padding-top: 20px; }
        .admin-sidebar-panel ul { list-style:none; padding:0; }
        .admin-sidebar-panel ul li a { color: white; text-decoration: none; display: block; padding: 12px 15px; transition: background 0.3s; }
        .admin-sidebar-panel ul li a:hover, .admin-sidebar-panel ul li.active-admin a { background: #555; }
        .admin-sidebar-panel .menu-title { padding: 15px; font-weight: bold; text-transform: uppercase; border-bottom: 1px solid #555; margin-bottom: 10px; }
        /* Style cho Message */
        .success-message { background-color: #d4edda; color: #155724; padding: 15px; margin-bottom: 20px; border: 1px solid #c3e6cb; border-radius: 4px; }
        .error-message { color: red; }
    </style>
  </head>
  <body>

<%-- Định nghĩa kết nối CSDL (Cần JSTL, JDBC Driver) --%>
<sql:setDataSource var="db" driver="com.mysql.cj.jdbc.Driver"
                   url="jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8"
                   user="root" password="" />

<%-- Truy vấn thống kê tổng sản phẩm (Cần tách ra DAO/Service trong thực tế) --%>
<c:catch var="dbException">
    <sql:query var="totalResult" dataSource="${db}">
        SELECT 
            (SELECT COUNT(*) FROM chauruachen_sanpham) + 
            (SELECT COUNT(*) FROM lavabo_sanpham) + 
            (SELECT COUNT(*) FROM toilet_sanpham) + 
            (SELECT COUNT(*) FROM voisentam_sanpham) + 
            (SELECT COUNT(*) FROM voirua_sanpham) + 
            (SELECT COUNT(*) FROM tulavabo_sanpham) +
            (SELECT COUNT(*) FROM bontieunam_sanpham) +
            (SELECT COUNT(*) FROM bontam_sanpham) +
            (SELECT COUNT(*) FROM login) as total
    </sql:query>
</c:catch>

<c:choose>
    <c:when test="${not empty dbException}">
        <%-- Xử lý lỗi kết nối CSDL --%>
        <c:set var="totalProducts" value="Lỗi CSDL" scope="request" />
        <c:set var="message" value="<div class='error-message'>❌ Lỗi kết nối hoặc truy vấn CSDL: ${dbException.message}</div>" scope="request" />
    </c:when>
    <c:otherwise>
        <%-- Lấy tổng số sản phẩm --%>
        <c:set var="totalProducts" value="${totalResult.rows[0].total}" scope="request" />
    </c:otherwise>
</c:choose>

<%
    // PHẦN 2: XỬ LÝ THÊM SẢN PHẨM & UPLOAD ẢNH (Logic này nên nằm trong Servlet)
    // Trong môi trường JSP, việc xử lý form POST và upload file thường được thực hiện 
    // bởi một Servlet riêng. Đoạn mã này chỉ là giả định xử lý sau khi một Servlet 
    // đã nhận request và chuyển kết quả lại (chuyển tiếp/redirect)
    String message = (String) request.getAttribute("message");
    if (message == null) {
        message = "";
    }
%>

=======
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
    />
    <link rel="stylesheet" href="admin_style.css" />
    <style>
      .admin-form-container {
        background: white;
        padding: 20px;
        border-radius: 8px;
        margin-top: 20px;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
      }
      .form-group {
        margin-bottom: 15px;
      }
      .form-group label {
        display: block;
        margin-bottom: 5px;
        font-weight: bold;
      }
      .form-group input,
      .form-group select {
        width: 100%;
        padding: 8px;
        border: 1px solid #ddd;
        border-radius: 4px;
      }
      .btn-submit {
        background: #28a745;
        color: white;
        padding: 10px 20px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 16px;
        font-weight: bold;
      }
      .btn-submit:hover {
        background: #218838;
      }
      .admin-sidebar-panel {
        width: 250px;
        min-height: 100vh;
        background: #333;
        color: white;
        padding-top: 20px;
      }
      .admin-sidebar-panel ul {
        list-style: none;
        padding: 0;
      }
      .admin-sidebar-panel ul li a {
        color: white;
        text-decoration: none;
        display: block;
        padding: 12px 15px;
        transition: background 0.3s;
      }
      .admin-sidebar-panel ul li a:hover,
      .admin-sidebar-panel ul li.active-admin a {
        background: #555;
      }
      .admin-sidebar-panel .menu-title {
        padding: 15px;
        font-weight: bold;
        text-transform: uppercase;
        border-bottom: 1px solid #555;
        margin-bottom: 10px;
      }
    </style>
  </head>
  <body>
>>>>>>> 6482930432cecd30e7524b4d1cbecb07c628100b
    <header>
      <h1>Quản Trị Hệ Thống</h1>
      <nav>
        <ul class="user-menu">
<<<<<<< HEAD
           <li><a href="home.jsp"><i class="fa fa-home"></i> Xem Trang Web</a></li>
           <li><a href="#"><i class="fas fa-user-cog"></i> Admin Thắng</a></li>
=======
          <li>
            <a href="index.jsp"><i class="fa fa-home"></i> Xem Trang Web</a>
          </li>
          <li>
            <a href="#"><i class="fas fa-user-cog"></i> Admin Thắng</a>
          </li>
>>>>>>> 6482930432cecd30e7524b4d1cbecb07c628100b
        </ul>
      </nav>
    </header>

    <div class="menu-container">
<<<<<<< HEAD
      <div class="main-admin-container" style="display:flex; width:100%;">
        
        <div class="admin-sidebar-panel">
           <div class="menu-title">CHỨC NĂNG QUẢN LÝ</div>
           <ul>
             <li class="active-admin"><a href="admin_dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
             <li class="menu-divider" style="padding: 5px 15px; font-size: 12px; color: #bbb; border-top: 1px solid #555;">SẢN PHẨM</li>
             <li><a href="?view=chauruachen_sanpham"><i class="fas fa-mug-hot"></i> Chậu Rửa Chén</a></li>
             <li><a href="?view=lavabo_sanpham"><i class="fas fa-toilet"></i> Lavabo</a></li>
             <li><a href="?view=toilet_sanpham"><i class="fas fa-toilet-paper"></i> Bồn Cầu/Toilet</a></li>
             <li><a href="?view=voisen_sanpham"><i class="fas fa-shower"></i> Vòi Sen Tắm</a></li>
             <li><a href="?view=voirua_sanpham"><i class="fas fa-tint"></i> Vòi Rửa</a></li>
             <li class="menu-divider" style="padding: 5px 15px; font-size: 12px; color: #bbb; border-top: 1px solid #555;">KHÁC</li>
             <li><a href="?view=login"><i class="fas fa-users"></i> Quản lý User</a></li>
             <li><a href="#"><i class="fas fa-shopping-cart"></i> Đơn hàng</a></li>
           </ul>
        </div>
        
        <main class="dashboard-content" style="flex:1; padding: 20px; background: #f4f4f4;">
          <h2>Dashboard Tổng quan</h2>

          <div class="stats-grid" style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 30px;">
            <div class="stat-card" style="background:white; padding:20px; border-radius:8px; text-align:center;">
              <h3 style="color:#666; font-size:14px;">TỔNG SẢN PHẨM</h3>
              <%-- Hiển thị tổng sản phẩm từ JSTL --%>
              <p style="font-size:30px; font-weight:bold; color:#007bff; margin:10px 0;">
                <c:out value="${totalProducts}"/>
              </p>
            </div>
            <div class="stat-card" style="background:white; padding:20px; border-radius:8px; text-align:center;">
               <h3 style="color:#666; font-size:14px;">DOANH THU</h3>
               <p style="font-size:30px; font-weight:bold; color:green; margin:10px 0;">150.000.000đ</p>
=======
      <div class="main-admin-container" style="display: flex; width: 100%">
        <div class="admin-sidebar-panel">
          <div class="menu-title">CHỨC NĂNG QUẢN LÝ</div>
          <ul>
            <li class="active-admin">
              <a href="page_admin.jsp"
                ><i class="fas fa-tachometer-alt"></i> Dashboard</a
              >
            </li>
            <li
              class="menu-divider"
              style="
                padding: 5px 15px;
                font-size: 12px;
                color: #bbb;
                border-top: 1px solid #555;
              "
            >
              SẢN PHẨM
            </li>
            <li>
              <a href="#"><i class="fas fa-mug-hot"></i> Chậu Rửa Chén</a>
            </li>
            <li>
              <a href="#"><i class="fas fa-toilet"></i> Lavabo</a>
            </li>
            <li>
              <a href="#"><i class="fas fa-toilet-paper"></i> Bồn Cầu/Toilet</a>
            </li>
            <li>
              <a href="#"><i class="fas fa-shower"></i> Vòi Sen Tắm</a>
            </li>
            <li>
              <a href="#"><i class="fas fa-tint"></i> Vòi Rửa</a>
            </li>
          </ul>
        </div>

        <main
          class="dashboard-content"
          style="flex: 1; padding: 20px; background: #f4f4f4"
        >
          <h2>Dashboard Tổng quan</h2>

          <div
            class="stats-grid"
            style="
              display: grid;
              grid-template-columns: repeat(4, 1fr);
              gap: 20px;
              margin-bottom: 30px;
            "
          >
            <div
              class="stat-card"
              style="
                background: white;
                padding: 20px;
                border-radius: 8px;
                text-align: center;
              "
            >
              <h3 style="color: #666; font-size: 14px">TỔNG SẢN PHẨM</h3>
              <p
                style="
                  font-size: 30px;
                  font-weight: bold;
                  color: #007bff;
                  margin: 10px 0;
                "
              >
                <c:out value="${totalProducts}" default="0" />
              </p>
            </div>
            <div
              class="stat-card"
              style="
                background: white;
                padding: 20px;
                border-radius: 8px;
                text-align: center;
              "
            >
              <h3 style="color: #666; font-size: 14px">DOANH THU</h3>
              <p
                style="
                  font-size: 30px;
                  font-weight: bold;
                  color: green;
                  margin: 10px 0;
                "
              >
                150.000.000đ
              </p>
>>>>>>> 6482930432cecd30e7524b4d1cbecb07c628100b
            </div>
          </div>

          <div class="admin-form-container">
<<<<<<< HEAD
              <h3 style="border-bottom: 2px solid #eee; padding-bottom: 10px; margin-bottom: 20px;">
                  <i class="fa fa-plus-circle"></i> Thêm Sản Phẩm Mới
              </h3>
              
              <%-- Hiển thị message từ Servlet hoặc logic xử lý form ở trên --%>
              <%= message %>

              <%-- action="AddProductServlet" (Khuyến nghị chuyển form sang Servlet) --%>
              <form action="AddProductServlet" method="POST" enctype="multipart/form-data">
                  <div class="form-group">
                      <label>1. Chọn Loại Sản Phẩm (Bảng CSDL):</label>
                      <select name="category" required>
                           <option value="home_sanpham">Home</option>
                           <option value="chauruachen_sanpham">Chậu Rửa Chén</option>
                           <option value="lavabo_sanpham">Lavabo</option>
                           <option value="tulavabo_sanpham">Tủ Lavabo</option>
                           <option value="bontam_sanpham">Bồn Tắm/Toilet</option>
                           <option value="toilet_sanpham">Bồn Cầu/Toilet</option>
                           <option value="voisentam_sanpham">Vòi Sen Tắm</option>
                           <option value="voirua_sanpham">Vòi Rửa</option>
                           <option value="bontieunam_sanpham">Bồn Tiểu Nam</option>
                           <option value="phukien_sanpham">Phụ Kiện</option>
                      </select>
                  </div>
                  <div class="form-group"><label>2. Tên Sản Phẩm:</label><input type="text" name="ten_sp" required placeholder="Nhập tên sản phẩm..."></div>
                  <div class="form-group"><label>3. Giá Tiền (VNĐ):</label><input type="number" name="gia" required placeholder="Ví dụ: 1500000"></div>
                  <div class="form-group"><label>4. Giảm Giá (%):</label><input type="number" name="giam_gia" value="0" placeholder="0"></div>
                  <div class="form-group"><label>5. Hình Ảnh (Chọn file từ máy tính):</label><input type="file" name="hinh_anh" required></div>
                  <button type="submit" name="btn_add_product" class="btn-submit">Lưu Sản Phẩm</button>
              </form>
          </div>

=======
            <h3
              style="
                border-bottom: 2px solid #eee;
                padding-bottom: 10px;
                margin-bottom: 20px;
              "
            >
              <i class="fa fa-plus-circle"></i> Thêm Sản Phẩm Mới
            </h3>

            <%= message %>

            <form
              action="page_admin.jsp"
              method="POST"
              enctype="multipart/form-data"
            >
              <div class="form-group">
                <label>1. Chọn Loại Sản Phẩm (Bảng CSDL):</label>
                <select name="category" required>
                  <option value="home_sanpham">Home</option>
                  <option value="chauchauen_sanpham">Chậu Rửa Chén</option>
                  <option value="lavabo_sanpham">Lavabo</option>
                  <option value="tulavabo_sanpham">Tủ Lavabo</option>
                  <option value="bontam_sanpham">Bồn Tắm/Toilet</option>
                  <option value="toilet_sanpham">Bồn Cầu/Toilet</option>
                  <option value="voisentam_sanpham">Vòi Sen Tắm</option>
                  <option value="voirua_sanpham">Vòi Rửa</option>
                  <option value="bontieunam_sanpham">Bồn Tiểu Nam</option>
                  <option value="phukien_sanpham">Phụ Kiện</option>
                </select>
              </div>
              <div class="form-group">
                <label>2. Tên Sản Phẩm:</label
                ><input type="text" name="ten_sp" required />
              </div>
              <div class="form-group">
                <label>3. Giá Tiền (VNĐ):</label
                ><input type="number" name="gia" required />
              </div>
              <div class="form-group">
                <label>4. Giảm Giá (%):</label
                ><input type="number" name="giam_gia" value="0" />
              </div>
              <div class="form-group">
                <label>5. Hình Ảnh:</label
                ><input type="file" name="hinh_anh" required />
              </div>

              <button
                type="submit"
                name="btn_add_product"
                value="true"
                class="btn-submit"
              >
                Lưu Sản Phẩm
              </button>
            </form>
          </div>
>>>>>>> 6482930432cecd30e7524b4d1cbecb07c628100b
        </main>
      </div>
    </div>
  </body>
<<<<<<< HEAD
</html>
=======
</html>
>>>>>>> 6482930432cecd30e7524b4d1cbecb07c628100b
