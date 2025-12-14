<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<<<<<<< HEAD
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.sql" prefix="sql" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
=======
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
>>>>>>> 6482930432cecd30e7524b4d1cbecb07c628100b

<sql:setDataSource var="myDataSource" 
    driver="com.mysql.cj.jdbc.Driver"
    url="jdbc:mysql://localhost:3307/db?useUnicode=true&characterEncoding=UTF-8"
    user="root" 
    password=""/>

<<<<<<< HEAD
<%-- 1. Lấy giá trị tìm kiếm từ tham số "search" --%>
<c:set var="searchTerm" value="${param.search}" />
<c:set var="searchQuery" value="SELECT * FROM home_sanpham" />

<%-- 2. Thêm điều kiện WHERE nếu có từ khóa tìm kiếm --%>
<c:if test="${not empty searchTerm}">
    <c:set var="searchQuery" value="${searchQuery} WHERE ten_sp LIKE ?" />
</c:if>

<sql:query dataSource="${myDataSource}" var="result">
    ${searchQuery}
    <c:if test="${not empty searchTerm}">
        <sql:param value="%${searchTerm}%" />
    </c:if>
=======
<sql:query dataSource="${myDataSource}" var="result">
    SELECT * FROM home_sanpham
>>>>>>> 6482930432cecd30e7524b4d1cbecb07c628100b
</sql:query>

<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <title>Trang chủ</title>
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
    />
    <link rel="stylesheet" href="homeStyle.css" />
  </head>
  <body>
    <header>
      <h1>Thiết Bị Vệ Sinh Và Phòng Tắm</h1>
      <nav>
<<<<<<< HEAD
        <%-- **THAY ĐỔI 1: Cập nhật form tìm kiếm** --%>
        <form class="search-form" action="home.jsp" method="GET">
=======
        <form class="search-form" action="#" method="GET">
>>>>>>> 6482930432cecd30e7524b4d1cbecb07c628100b
          <input
            type="text"
            name="search"
            placeholder="Tìm kiếm sản phẩm ..."
            class="search-input"
<<<<<<< HEAD
            <%-- Giữ lại từ khóa tìm kiếm cũ trên ô input --%>
            value="${searchTerm}"
=======
>>>>>>> 6482930432cecd30e7524b4d1cbecb07c628100b
          />
          <button type="submit" class="search-icon">
            <i class="fa fa-search"></i>
          </button>
        </form>

        <ul class="user-menu">
          <li>
<<<<<<< HEAD
            <a href="page_ThemVaoGiohang.jsp">
=======
            <a href="page_ThemVaoGiohang.php">
>>>>>>> 6482930432cecd30e7524b4d1cbecb07c628100b
              <i class="fa-solid fa-cart-shopping"></i> Giỏ hàng
            </a>
          </li>
          <li>
<<<<<<< HEAD
            <a href="login_page.jsp">
=======
            <a href="login_page.php">
>>>>>>> 6482930432cecd30e7524b4d1cbecb07c628100b
              <i class="fas fa-user"></i> Đăng nhập
            </a>
          </li>
        </ul>
      </nav>
    </header>

    <div class="menu-container">
      <div class="sidebar">
        <div class="menu-title">
          <i class="fa fa-bars"></i> DANH MỤC SẢN PHẨM
        </div>
      </div>

      <div class="top-menu">
        <ul>
          <li><a href="home.jsp">Trang chủ</a></li>
          <li><a href="page_combo.jsp">Combo</a></li>
          <li><a href="toilet_page.jsp">Bồn Cầu</a></li>
          <li><a href="lavabo-page.jsp">Lavabo</a></li>
          <li><a href="page_Tulavabo.jsp">Tủ Lavabo</a></li>
          <li><a href="page_VoiSenTam.jsp">Vòi Sen Tắm</a></li>
          <li><a href="page_ChauRuaChen.jsp">Chậu Rửa Chén</a></li>
          <li><a href="page_bonTam.jsp">Bồn Tắm</a></li>
          <li><a href="page_voiRua.jsp">Vòi Rửa</a></li>
          <li><a href="page_BonTieuNam.jsp">Bồn Tiểu Nam</a></li>
          <li><a href="page_PhuKien.jsp">Phụ Kiện</a></li>
          <li><a href="page_admin.jsp">Admin</a></li>
        </ul>
      </div>
    </div>


    <main class="main-content">
<<<<<<< HEAD
        <%-- Hiển thị tiêu đề theo kết quả tìm kiếm --%>
        <c:choose>
            <c:when test="${not empty searchTerm}">
                <h2>Kết quả tìm kiếm cho: "${searchTerm}"</h2>
            </c:when>
            <c:otherwise>
                <h2>Sản phẩm nổi bật</h2>
            </c:otherwise>
        </c:choose>

=======
        <h2>Sản phẩm nổi bật</h2>
>>>>>>> 6482930432cecd30e7524b4d1cbecb07c628100b
        <div class="product-grid">
            
            <c:choose>
                <c:when test="${result.rowCount > 0}">
                    <c:forEach var="row" items="${result.rows}">
<<<<<<< HEAD
                      <div class="product-card">
                          <img src="image_all/${row.hinh_anh}" alt="${row.ten_sp}">

                          <h3>
                              <a href="TrangChiTiet.jsp?id=${row.id}">
                                  ${row.ten_sp}
                              </a>
                          </h3>

                          <p class="price">
                              <fmt:formatNumber value="${row.gia}" type="number" groupingUsed="true"/>đ
                              <span class="discount">-${row.giam_gia}%</span>
                          </p>

                          <div class="button-group">
                              <a href="page_ThemVaoGiohang.jsp?id=${row.id}">
                                  <button class="add-to-cart"><i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ</button>
                              </a>
                              <button class="buy"><i class="fa-solid fa-bag-shopping"></i> Đặt mua</button>
                          </div>
                      </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <c:if test="${not empty searchTerm}">
                        <p>Không tìm thấy sản phẩm nào phù hợp với từ khóa: **${searchTerm}**</p>
                    </c:if>
                    <c:if test="${empty searchTerm}">
                        <p>Chưa có sản phẩm nào!</p>
                    </c:if>
=======
                        <div class="product-card">
                            <img src="image_all/${row.hinh_anh}" alt="${row.ten_sp}">

                            <h3>
                                <a href="TrangChiTiet.jsp?id=${row.id}">
                                    ${row.ten_sp}
                                </a>
                            </h3>

                            <p class="price">
                                <fmt:formatNumber value="${row.gia}" type="number" groupingUsed="true"/>đ
                                <span class="discount">-${row.giam_gia}%</span>
                            </p>

                            <div class="button-group">
                                <a href="page_ThemVaoGiohang.html">
                                    <button class="add-to-cart"><i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ</button>
                                </a>
                                <button class="buy"><i class="fa-solid fa-bag-shopping"></i> Đặt mua</button>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p>Chưa có sản phẩm nào!</p>
>>>>>>> 6482930432cecd30e7524b4d1cbecb07c628100b
                </c:otherwise>
            </c:choose>

        </div>
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
<<<<<<< HEAD
    </body>
=======
  </body>
>>>>>>> 6482930432cecd30e7524b4d1cbecb07c628100b
</html>