<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<sql:setDataSource var="myDataSource" 
    driver="com.mysql.cj.jdbc.Driver"
    url="jdbc:mysql://localhost:3307/db?useUnicode=true&characterEncoding=UTF-8"
    user="root" 
    password=""/>

<sql:query dataSource="${myDataSource}" var="result">
    SELECT * FROM home_sanpham
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
        <form class="search-form" action="#" method="GET">
          <input
            type="text"
            name="search"
            placeholder="Tìm kiếm sản phẩm ..."
            class="search-input"
          />
          <button type="submit" class="search-icon">
            <i class="fa fa-search"></i>
          </button>
        </form>

        <ul class="user-menu">
          <li>
            <a href="page_ThemVaoGiohang.php">
              <i class="fa-solid fa-cart-shopping"></i> Giỏ hàng
            </a>
          </li>
          <li>
            <a href="login_page.php">
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
        <h2>Sản phẩm nổi bật</h2>
        <div class="product-grid">
            
            <c:choose>
                <c:when test="${result.rowCount > 0}">
                    <c:forEach var="row" items="${result.rows}">
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
  </body>
</html>