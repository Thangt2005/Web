<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<<<<<<< HEAD
<<<<<<< HEAD

<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.sql" prefix="sql" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

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

<!-- ================== QUERY BỒN CẦU ================== -->
<sql:query dataSource="${ds}" var="products">
    SELECT * FROM toilet_sanpham
    <c:if test="${not empty search}">
        WHERE ten_sp LIKE ?
        <sql:param value="${keyword}" />
    </c:if>
=======
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
=======
<%-- Import thư viện SQL --%>
<%@ page import="java.sql.*" %>
>>>>>>> 26e919d11d098780a5c4b2e3d8bfa0fc1f3c99d9

<%
    // --- PHẦN 1: XỬ LÝ JAVA (BACKEND) ---
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String errorMessage = "";

<<<<<<< HEAD
<sql:query dataSource="${myDataSource}" var="result">
    SELECT * FROM home_sanpham
>>>>>>> 6482930432cecd30e7524b4d1cbecb07c628100b
</sql:query>

<!DOCTYPE html>
<html lang="vi">
<<<<<<< HEAD
<head>
    <meta charset="UTF-8">
    <title>Bồn Tắm</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="Combo_style.css">
=======
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        // Anh kiểm tra lại tên DB và User/Pass
        String url = "jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8";
        String user = "root";
        String pass = "";

        conn = DriverManager.getConnection(url, user, pass);

        String searchTerm = request.getParameter("search");
    
        // Lấy dữ liệu từ bảng Bồn Tắm
        String sql = "SELECT * FROM toilet_sanpham"; 
        
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql += " WHERE ten_sp LIKE ?";
        }

        ps = conn.prepareStatement(sql);

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            ps.setString(1, "%" + searchTerm.trim() + "%");
        }

        rs = ps.executeQuery();

    } catch (Exception e) {
        errorMessage = "Lỗi: " + e.getMessage();
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Sản Phẩm Nổi Bật</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    
    <link rel="stylesheet" href="homeStyle.css">
>>>>>>> 26e919d11d098780a5c4b2e3d8bfa0fc1f3c99d9
</head>

<body>

<<<<<<< HEAD
<!-- ================== HEADER ================== -->
=======
>>>>>>> 26e919d11d098780a5c4b2e3d8bfa0fc1f3c99d9
<header>
    <h1>Thiết Bị Vệ Sinh Và Phòng Tắm</h1>

    <nav>
<<<<<<< HEAD
        <form class="search-form" method="get" action="toilet_page.jsp">
=======
        <form class="search-form" method="get" action="page_bonTam.jsp">
>>>>>>> 26e919d11d098780a5c4b2e3d8bfa0fc1f3c99d9
            <input
                type="text"
                name="search"
                class="search-input"
<<<<<<< HEAD
                placeholder="Tìm kiếm bồn cầu..."
                value="${search}"
=======
                placeholder="Tìm kiếm bồn tắm..."
                value="<%= (request.getParameter("search") != null) ? request.getParameter("search") : "" %>"
>>>>>>> 26e919d11d098780a5c4b2e3d8bfa0fc1f3c99d9
            >
            <button class="search-icon">
                <i class="fa fa-search"></i>
            </button>
<<<<<<< HEAD
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
                Danh sách sản phẩm Bồn Tắm
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
=======
  <head>
    <meta charset="UTF-8" />
    <title>Trang Combo</title>
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
=======
>>>>>>> 26e919d11d098780a5c4b2e3d8bfa0fc1f3c99d9
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
            
            <li class="active"><a href="page_bonTam.jsp">Bồn Tắm</a></li>
            
            <li><a href="page_voiRua.jsp">Vòi Rửa</a></li>
            <li><a href="page_BonTieuNam.jsp">Bồn Tiểu Nam</a></li>
            <li><a href="page_PhuKien.jsp">Phụ Kiện</a></li>
            <li><a href="page_admin.jsp">Admin</a></li>
        </ul>
    </div>
</div>

<main class="main-content">
        <% if (request.getParameter("search") != null && !request.getParameter("search").isEmpty()) { %>
            <h2>Kết quả tìm kiếm cho: "<%= request.getParameter("search") %>"</h2>
        <% } else { %>
            <h2>Sản phẩm Nổi Bật</h2>
        <% } %>

        <% if (!errorMessage.isEmpty()) { %>
            <div style="color: red; text-align: center; padding: 20px; font-weight: bold;">
                <%= errorMessage %>
            </div>
        <% } %>

        <div class="product-grid">
        <% 
            if (rs != null) {
                boolean hasData = false;
                while (rs.next()) { 
                    hasData = true;
                    String tenSp = rs.getString("ten_sp");
                    String hinhAnh = rs.getString("hinh_anh");
                    double gia = rs.getDouble("gia");
                    int giamGia = rs.getInt("giam_gia");
                    int id = rs.getInt("id");
        %>
            <div class="product-card">
                <img src="image_all/<%= hinhAnh %>" alt="<%= tenSp %>">
                <h3>
                    <a href="TrangChiTiet.jsp?id=<%= id %>">
                        <%= tenSp %>
                    </a>
                </h3>
                <p class="price">
                    <%= String.format("%,.0f", gia) %>đ
                    <span class="discount">-<%= giamGia %>%</span>
                </p>
                
                <div class="button-group">
                    <a href="page_ThemVaoGiohang.jsp?id=<%= id %>">
                        <button class="add-to-cart"><i class="fa-solid fa-cart-plus"></i> Thêm</button>
                    </a>
                    <button class="buy">Mua</button>
                </div>
            </div>
        <% 
                } // Kết thúc while
                
                if (!hasData) {
        %>
                    <p style="text-align: center; width: 100%;">Không tìm thấy sản phẩm nào!</p>
        <%
                }
            } 
        %>
        </div>
    </main>

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

<<<<<<< HEAD
      <div class="footer-bottom">
        © 2025 Thiết Bị Vệ Sinh & Phòng Tắm - All Rights Reserved.
      </div>
    </footer>
  </body>
>>>>>>> 6482930432cecd30e7524b4d1cbecb07c628100b
=======
</body>
>>>>>>> 26e919d11d098780a5c4b2e3d8bfa0fc1f3c99d9
</html>

<%
    // Đóng kết nối để giải phóng bộ nhớ
    try { if(rs != null) rs.close(); } catch(SQLException e) {}
    try { if(ps != null) ps.close(); } catch(SQLException e) {}
    try { if(conn != null) conn.close(); } catch(SQLException e) {}
%>