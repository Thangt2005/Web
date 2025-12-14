<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<<<<<<< HEAD

=======
>>>>>>> 6482930432cecd30e7524b4d1cbecb07c628100b
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.sql" prefix="sql" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<<<<<<< HEAD
<!-- ================== SEARCH PARAM ================== -->
<c:set var="search" value="${param.search}" />
<c:set var="keyword" value="%${search}%" />

<!-- ================== DATABASE ================== -->
<sql:setDataSource var="ds"
    driver="com.mysql.cj.jdbc.Driver"
    url="jdbc:mysql://localhost:3307/db?useUnicode=true&characterEncoding=UTF-8"
    user="root"
    password=""
/>

<!-- ================== QUERY BỒN TẮM ================== -->
<sql:query dataSource="${ds}" var="products">
    SELECT * FROM bontam_sanpham
    <c:if test="${not empty search}">
        WHERE ten_sp LIKE ?
        <sql:param value="${keyword}" />
    </c:if>
</sql:query>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Bồn Tắm</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="Combo_style.css">
</head>

<body>

<!-- ================== HEADER ================== -->
<header>
    <h1>Thiết Bị Vệ Sinh Và Phòng Tắm</h1>

    <nav>
        <form class="search-form" method="get" action="page_bonTam.jsp">
            <input
                type="text"
                name="search"
                class="search-input"
                placeholder="Tìm kiếm bồn tắm..."
                value="${search}"
            >
            <button class="search-icon">
                <i class="fa fa-search"></i>
            </button>
        </form>

        <ul class="user-menu">
            <li>
                <a href="page_ThemVaoGiohang.jsp">
                    <i class="fa-solid fa-cart-shopping"></i> Giỏ hàng
                </a>
            </li>
            <li>
                <a href="login_page.jsp">
                    <i class="fa-solid fa-user"></i> Đăng nhập
                </a>
            </li>
        </ul>
    </nav>
</header>

<!-- ================== MENU ================== -->
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

<!-- ================== MAIN ================== -->
<main class="main-content">

    <h2>
        <c:choose>
            <c:when test="${not empty search}">
                Kết quả tìm kiếm cho: "<b>${search}</b>" (Bồn Tắm)
            </c:when>
            <c:otherwise>
               Combo thiết bị vệ sinh & phòng tắm
            </c:otherwise>
        </c:choose>
    </h2>

    <div class="combo-grid">

        <c:choose>
            <c:when test="${products.rowCount > 0}">
                <c:forEach var="p" items="${products.rows}">
                    <div class="product-combo">

                        <h3>${p.ten_sp}</h3>

                        <img src="image_all/${p.hinh_anh}" alt="${p.ten_sp}">

                        <p class="price">
                            <fmt:formatNumber value="${p.gia}" type="number" groupingUsed="true"/>đ
                            <span class="dis">-${p.giam_gia}%</span>
                        </p>

                        <div class="button-group">
                            <a href="page_ThemVaoGiohang.jsp?id=${p.id}">
                                <button class="add-to-cart">
                                    <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ
                                </button>
                            </a>
                            <button class="buy">
                                <i class="fa-solid fa-bag-shopping"></i> Mua ngay
                            </button>
                        </div>

                    </div>
                </c:forEach>
            </c:when>

            <c:otherwise>
                <p>
                    Không tìm thấy sản phẩm bồn tắm
                    <c:if test="${not empty search}">
                        với từ khóa "<b>${search}</b>"
                    </c:if>
                </p>
            </c:otherwise>
        </c:choose>

    </div>
</main>

<!-- ================== FOOTER ================== -->
<footer class="footer">
    <div class="footer-container">

        <div class="footer-column">
            <h3>VỀ CHÚNG TÔI</h3>
            <p>Chuyên cung cấp thiết bị vệ sinh, phòng tắm chính hãng.</p>
        </div>

        <div class="footer-column">
            <h3>LIÊN HỆ</h3>
            <p><i class="fa fa-phone"></i> 0909 123 456</p>
            <p><i class="fa fa-envelope"></i> contact@thietbivesinh.vn</p>
            <p><i class="fa fa-location-dot"></i> TP. Hồ Chí Minh</p>
        </div>

        <div class="footer-column">
            <h3>HỖ TRỢ</h3>
            <ul>
                <li><a href="#">Giao hàng</a></li>
                <li><a href="#">Bảo hành</a></li>
                <li><a href="#">Thanh toán</a></li>
            </ul>
        </div>

        <div class="footer-column">
            <h3>KẾT NỐI</h3>
            <div class="social-icons">
                <a href="#"><i class="fa-brands fa-facebook"></i></a>
                <a href="#"><i class="fa-brands fa-youtube"></i></a>
                <a href="#"><i class="fa-brands fa-tiktok"></i></a>
            </div>
        </div>

    </div>

    <div class="footer-bottom">
        © 2025 Thiết Bị Vệ Sinh & Phòng Tắm
    </div>
</footer>

</body>
</html>
=======
<sql:setDataSource var="myDataSource" 
    driver="com.mysql.cj.jdbc.Driver"
    url="jdbc:mysql://localhost:3307/db?useUnicode=true&characterEncoding=UTF-8"
    user="root" 
    password=""/>

<sql:query dataSource="${myDataSource}" var="result">
    SELECT * FROM bontam_sanpham
</sql:query>

<!DOCTYPE html>
  <head>
    <meta charset="UTF-8" />
    <title>Sản phẩm Bồn Tắm</title>
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
    />
    <link rel="stylesheet" href="Combo_style.css" />
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
            <a href="page_ThemVaoGiohang.jsp">
              <i class="fa-solid fa-cart-shopping"></i> Giỏ hàng
            </a>
          </li>
          <li>
            <a href="login_page.jsp">
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
      <h2>Một số mẫu Bồn Tắm bán chạy</h2>

      <div class="combo-grid">
       
       <c:choose>
            <c:when test="${result.rowCount > 0}">
                <c:forEach var="row" items="${result.rows}">
                    <div class="product-combo">
                        <h3>${row.ten_sp}</h3>

                        <img src="image_all/${row.hinh_anh}" alt="${row.ten_sp}">

                        <p class="price">
                            <fmt:formatNumber value="${row.gia}" type="number" groupingUsed="true"/>đ
                            <span class="dis">-${row.giam_gia}%</span>
                        </p>

                        <div class="button-group">
                            <button class="add-to-cart">
                                <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ hàng
                            </button>
                            <button class="buy">
                                <i class="fa-solid fa-bag-shopping"></i> Đặt mua
                            </button>
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
              Chuyên cung cấp thiết bị vệ sinh, phòng tắm chính hãng, giá tốt
              nhất thị trường.
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
>>>>>>> 6482930432cecd30e7524b4d1cbecb07c628100b
