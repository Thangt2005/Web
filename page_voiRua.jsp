<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- Import thư viện SQL --%>
<%@ page import="java.sql.*" %>

<%
    // --- PHẦN 1: XỬ LÝ JAVA (BACKEND) ---
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String errorMessage = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        // Anh kiểm tra lại tên DB và User/Pass
        String url = "jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8";
        String user = "root";
        String pass = "";

        conn = DriverManager.getConnection(url, user, pass);

        String searchTerm = request.getParameter("search");
    
        // Lấy dữ liệu từ bảng Bồn Tắm
        String sql = "SELECT * FROM voirua_sanpham"; 
        
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
</head>

<body>

<header>
    <h1>Thiết Bị Vệ Sinh Và Phòng Tắm</h1>

    <nav>
        <form class="search-form" method="get" action="page_bonTam.jsp">
            <input
                type="text"
                name="search"
                class="search-input"
                placeholder="Tìm kiếm bồn tắm..."
                value="<%= (request.getParameter("search") != null) ? request.getParameter("search") : "" %>"
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

</body>
</html>

<%
    // Đóng kết nối để giải phóng bộ nhớ
    try { if(rs != null) rs.close(); } catch(SQLException e) {}
    try { if(ps != null) ps.close(); } catch(SQLException e) {}
    try { if(conn != null) conn.close(); } catch(SQLException e) {}
%>