<<<<<<< HEAD
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
=======
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    // --- PHẦN 1: LOGIC XỬ LÝ THÊM SẢN PHẨM VÀO GIỎ HÀNG (JAVA) ---
    String spIdStr = request.getParameter("id");
    String sessionId = session.getId(); 
    Connection conn = null;

    if (spIdStr != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Anh kiểm tra port 3306 hoặc 3307 tùy máy anh nhé
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/db?useUnicode=true&characterEncoding=UTF-8", "root", "");

            // 1. Lấy hoặc Tạo Giỏ hàng cho Session này
            int gioHangId = 0;
            PreparedStatement psCart = conn.prepareStatement("SELECT id FROM giohang WHERE session_id = ?");
            psCart.setString(1, sessionId);
            ResultSet rsCart = psCart.executeQuery();
            
            if (rsCart.next()) {
                gioHangId = rsCart.getInt("id");
            } else {
                PreparedStatement psNewCart = conn.prepareStatement("INSERT INTO giohang (session_id) VALUES (?)", Statement.RETURN_GENERATED_KEYS);
                psNewCart.setString(1, sessionId);
                psNewCart.executeUpdate();
                ResultSet rsKeys = psNewCart.getGeneratedKeys();
                if (rsKeys.next()) gioHangId = rsKeys.getInt(1);
            }

            // 2. Lấy thông tin sản phẩm (Lấy từ bảng home_sanpham làm mẫu)
            PreparedStatement psProduct = conn.prepareStatement("SELECT ten_sp, hinh_anh, gia FROM home_sanpham WHERE id = ?");
            psProduct.setInt(1, Integer.parseInt(spIdStr));
            ResultSet rsProduct = psProduct.executeQuery();

            if (rsProduct.next()) {
                // 3. Kiểm tra sản phẩm có trong giỏ chưa để tăng số lượng hoặc thêm mới
                PreparedStatement psCheck = conn.prepareStatement("SELECT id FROM giohang_chitiet WHERE giohang_id = ? AND sanpham_id = ?");
                psCheck.setInt(1, gioHangId);
                psCheck.setInt(2, Integer.parseInt(spIdStr));
                ResultSet rsCheck = psCheck.executeQuery();

                if (rsCheck.next()) {
                    PreparedStatement psUpdate = conn.prepareStatement("UPDATE giohang_chitiet SET so_luong = so_luong + 1 WHERE id = ?");
                    psUpdate.setInt(1, rsCheck.getInt("id"));
                    psUpdate.executeUpdate();
                } else {
                    PreparedStatement psInsert = conn.prepareStatement("INSERT INTO giohang_chitiet (giohang_id, sanpham_id, ten_sp, hinh_anh, gia, so_luong) VALUES (?, ?, ?, ?, ?, 1)");
                    psInsert.setInt(1, gioHangId);
                    psInsert.setInt(2, Integer.parseInt(spIdStr));
                    psInsert.setString(3, rsProduct.getString("ten_sp"));
                    psInsert.setString(4, rsProduct.getString("hinh_anh"));
                    psInsert.setDouble(5, rsProduct.getDouble("gia"));
                    psInsert.executeUpdate();
                }
            }
            // Sau khi thêm xong, reload lại trang (không kèm tham số id nữa) để hiển thị danh sách
            response.sendRedirect("page_ThemVaoGiohang.jsp");
            return; 

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (conn != null) conn.close();
        }
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>Giỏ Hàng Của Bạn</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link rel="stylesheet" href="css_ThemVaoGioHang.css" />
</head>
<body>
    <header>
        <h1>Thiết Bị Vệ Sinh Và Phòng Tắm</h1>
        <nav>
            <form class="search-form" action="#" method="GET">
                <input type="text" name="search" placeholder="Tìm kiếm sản phẩm ..." class="search-input" />
                <button type="submit" class="search-icon"><i class="fa fa-search"></i></button>
            </form>
            <ul class="user-menu">
                <li><a href="page_ThemVaoGiohang.jsp"><i class="fa-solid fa-cart-shopping"></i> Giỏ hàng</a></li>
                <li><a href="#"><i class="fas fa-user"></i> thangtt26</a></li>
            </ul>
        </nav>
    </header>

    <div class="menu-container">
        <div class="sidebar">
            <div class="menu-title"><i class="fa fa-bars"></i> DANH MỤC SẢN PHẨM</div>
        </div>
        <div class="top-menu">
            <ul>
                <li><a href="home.jsp">Trang chủ</a></li>
                <li><a href="page_combo.jsp">Combo</a></li>
                <li><a href="page_bonTam.jsp">Bồn Tắm</a></li>
                <li><a href="page_BonTieuNam.jsp">Bồn Tiểu Nam</a></li>
                <li><a href="page_Tulavabo.jsp">Tủ Lavabo</a></li>
            </ul>
        </div>
    </div>

    <main class="cart-container">
        <h2 style="text-align:center; margin: 20px 0;">CHI TIẾT GIỎ HÀNG</h2>
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
                <%
                    // --- PHẦN 2: TRUY VẤN HIỂN THỊ DỮ LIỆU GIỎ HÀNG ---
                    double tongCong = 0;
                    try {
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/db?useUnicode=true&characterEncoding=UTF-8", "root", "");
                        PreparedStatement psDisplay = conn.prepareStatement(
                            "SELECT gc.* FROM giohang_chitiet gc JOIN giohang g ON gc.giohang_id = g.id WHERE g.session_id = ?");
                        psDisplay.setString(1, sessionId);
                        ResultSet rsDisplay = psDisplay.executeQuery();
                        
                        boolean coHang = false;
                        while(rsDisplay.next()) {
                            coHang = true;
                            double gia = rsDisplay.getDouble("gia");
                            int soLuong = rsDisplay.getInt("so_luong");
                            double tamTinh = gia * soLuong;
                            tongCong += tamTinh;
                %>
                <tr>
                    <td class="product-info">
                        <img src="image_all/<%= rsDisplay.getString("hinh_anh") %>" alt="Product" />
                        <span><%= rsDisplay.getString("ten_sp") %></span>
                    </td>
                    <td><fmt:formatNumber value="<%= gia %>" type="number" />đ</td>
                    <td class="qty">
                        <input type="number" value="<%= soLuong %>" min="1" readonly />
                    </td>
                    <td><fmt:formatNumber value="<%= tamTinh %>" type="number" />đ</td>
                </tr>
                <% 
                        }
                        if(!coHang) {
                            out.print("<tr><td colspan='4' style='text-align:center;'>Giỏ hàng trống!</td></tr>");
                        }
                    } catch (Exception e) { e.printStackTrace(); } finally { if(conn != null) conn.close(); }
                %>
            </tbody>
        </table>

        <div class="cart-total">
            <h3>Tổng cộng giỏ hàng</h3>
            <p><span>Tổng tiền:</span> <strong><fmt:formatNumber value="<%= tongCong %>" type="number" />đ</strong></p>
            <button class="checkout-btn">Tiến hành thanh toán</button>
            <a href="home.jsp" style="display:block; text-align:center; margin-top:10px; color:#c49a00;">Tiếp tục mua hàng</a>
        </div>
    </main>

    <footer class="footer">
        <div class="footer-bottom">© 2025 Thiết Bị Vệ Sinh & Phòng Tắm - thangtt26</div>
    </footer>
</body>
</html>
>>>>>>> 26e919d11d098780a5c4b2e3d8bfa0fc1f3c99d9
