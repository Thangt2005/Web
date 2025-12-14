<<<<<<<< HEAD:page_ThemVaoGiohang.jsp
========
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

>>>>>>>> 6482930432cecd30e7524b4d1cbecb07c628100b:page_Tulavabo.jsp

<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <title>Trang Giỏ Hàng</title>
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
    />
    <link rel="stylesheet" href="css_ThemVaoGioHang.css" />
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
              <i class="fas fa-user"></i> thangtt26
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
          <li><a href="home.php">Trang chủ</a></li>
          <li><a href="page_combo.php">Combo</a></li>
          <li><a href="toilet_page.php">Bồn Cầu</a></li>
          <li><a href="lavabo-page.php">Lavabo</a></li>
          <li><a href="page_Tulavabo.php">Tủ Lavabo</a></li>
          <li><a href="page_VoiSenTam.php">Vòi Sen Tắm</a></li>
          <li><a href="page_ChauRuaChen.php">Chậu Rửa Chén</a></li>
          <li><a href="page_bonTam.php">Bồn Tắm</a></li>
          <li><a href="page_voiRua.php">Vòi Rửa</a></li>
          <li><a href="page_BonTieuNam.php">Bồn Tiểu Nam</a></li>
          <li><a href="page_PhuKien.php">Phụ Kiện</a></li>
          <li><a href="page_admin.php">Admin</a></li>
        </ul>
      </div>
    </div>
    <main class="cart-container">
      <table class="cart-table">
        <thead>
          <tr>
            <th>Sản phẩm</th>
            <th>Giá</th>
            <th>Số lượng</th>
            <th>Tạm tính</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td class="product-info">
              <button class="remove-btn">✖</button>
              <img
                src="image_all/voiLavabo.png"
                alt="Vòi Lavabo Inox 304 LB271"
              />
              <span>Vòi Lavabo Inox 304 LB271</span>
            </td>
            <td>400.000đ</td>
            <td class="qty">
              <button>-</button>
              <input type="text" value="1" />
              <button>+</button>
            </td>
            <td>400.000đ</td>
          </tr>

          <tr>
            <td class="product-info">
              <button class="remove-btn">✖</button>
              <img
                src="image_all\voiSen2.png"
                alt="Vòi Sen Tắm Nóng Lạnh LB21"
              />
              <span>Vòi Sen Tắm Nóng Lạnh LB21</span>
            </td>
            <td>3.200.000đ</td>
            <td class="qty">
              <button>-</button>
              <input type="text" value="1" />
              <button>+</button>
            </td>
            <td>3.200.000đ</td>
          </tr>

          <tr>
            <td class="product-info">
              <button class="remove-btn">✖</button>
              <img src="image_all\voiSen1.png" alt="Sen Cây Nóng Lạnh SC113" />
              <span>Sen Cây Nóng Lạnh SC113</span>
            </td>
            <td>820,000đ</td>
            <td class="qty">
              <button>-</button>
              <input type="text" value="1" />
              <button>+</button>
            </td>
            <td>820,000đ</td>
          </tr>
        </tbody>
      </table>
      <div class="cart-actions">
        <button class="update-btn">Cập nhật giỏ hàng</button>
      </div>

<<<<<<<< HEAD:page_ThemVaoGiohang.jsp
      <div class="cart-total">
        <h3>Tổng cộng giỏ hàng</h3>
        <p><span>Tạm tính</span> <span>4.420.000đ</span></p>
        <p><span>Tổng</span> <span>4.420.000đ</span></p>
        <button class="checkout-btn">Tiến hành thanh toán</button>
      </div>
========
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
>>>>>>>> 6482930432cecd30e7524b4d1cbecb07c628100b:page_Tulavabo.jsp
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
