<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    // 1. Lấy tham số ID từ URL
    String productId = request.getParameter("id");
    
    // Khởi tạo các biến chứa dữ liệu sản phẩm
    String tenSp = "", hinhAnh = "", maSp = "", thuongHieu = "TTCERA", baoHanh = "5 năm", moTa = "";
    double gia = 0, giamGia = 0;
    
    if (productId != null) {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Anh kiểm tra port 3306 hoặc 3307 tùy máy nhé
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8", "root", "");
            
            // 2. Truy vấn lấy chi tiết sản phẩm. 
            String sql = "SELECT * FROM home_sanpham WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(productId));
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                tenSp = rs.getString("ten_sp");
                hinhAnh = rs.getString("hinh_anh");
                gia = rs.getDouble("gia");
                giamGia = rs.getInt("giam_gia");
                maSp = rs.getString("id"); // Hoặc cột mã SP riêng nếu có
                // Nếu DB chưa có cột mô tả, em để mặc định hoặc lấy từ DB nếu anh đã thêm cột 'mo_ta'
                // moTa = rs.getString("mo_ta"); 
            }
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
    <title>Chi Tiết Sản Phẩm: <%= tenSp %></title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link rel="stylesheet" href="css_TrangChiTiet.css" />
</head>
<body>
    <header>
        <h1>Thiết Bị Vệ Sinh Và Phòng Tắm</h1>
        <nav>
            <form class="search-form" action="home.jsp" method="GET">
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
                <li><a href="toilet_page.jsp">Bồn Cầu</a></li>
                <li><a href="lavabo-page.jsp">Lavabo</a></li>
                <li><a href="page_Tulavabo.jsp">Tủ Lavabo</a></li>
                <li><a href="page_VoiSenTam.jsp">Vòi Sen Tắm</a></li>
                <li><a href="page_ChauRuaChen.jsp">Chậu Rửa Chén</a></li>
                <li><a href="page_bonTam.jsp">Bồn Tắm</a></li>
                <li><a href="page_voiRua.jsp">Vòi Rửa</a></li>
                <li><a href="page_BonTieuNam.jsp">Bồn Tiểu Nam</a></li>
                <li><a href="page_PhuKien.jsp">Phụ Kiện</a></li>
            </ul>
        </div>
    </div>

    <main>
        <div class="product-container">
            <div class="product-gallery">
                <img src="image_all/<%= hinhAnh %>" alt="<%= tenSp %>" />
            </div>

            <div class="product-info">
                <h1><%= tenSp %></h1>
                <p class="price">
                    <span class="current-price"><fmt:formatNumber value="<%= gia %>" type="number" />đ</span>
                    <% if(giamGia > 0) { %>
                        <span class="old-price"><fmt:formatNumber value="<%= gia / (1 - giamGia/100) %>" type="number" />đ</span>
                        <span class="discount">-<%= (int)giamGia %>%</span>
                    <% } %>
                </p>
                <p>Mã sản phẩm: <%= maSp %></p>
                <p>Thương hiệu: <%= thuongHieu %></p>
                <p>Bảo hành: <%= baoHanh %></p>

                <div class="actions">
                    <%-- Gửi ID sang file xử lý giỏ hàng --%>
                    <a href="page_ThemVaoGiohang.jsp?id=<%= maSp %>">
                        <button class="add-to-cart">
                            <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ hàng
                        </button>
                    </a>
                    <button class="buy">
                        <i class="fa-solid fa-bag-shopping"></i> Đặt mua
                    </button>
                </div>
            </div>
        </div>

        <div class="product-detail">
            <h2>Chi tiết sản phẩm</h2>
            <p>Chất liệu: Inox 304 / Sứ cao cấp (Tùy loại)</p>
            <p>Ứng dụng: Lắp đặt trong phòng tắm, nhà vệ sinh hiện đại.</p>
            <p>Bảo Hành Chính Hãng: <%= baoHanh %></p>
            <p>- Thiết kế sang trọng, bền bỉ với thời gian.</p>
            <p>- Bề mặt chống bám bẩn, dễ dàng vệ sinh làm sạch.</p>
            <p>- Sản phẩm được kiểm định chất lượng nghiêm ngặt trước khi đến tay người dùng.</p>
        </div>
    </main>

    <footer class="footer">
        <div class="footer-container">
            <div class="footer-column">
                <h3>VỀ CHÚNG TÔI</h3>
                <p>Chuyên cung cấp thiết bị vệ sinh chính hãng, giá tốt nhất.</p>
            </div>
            <div class="footer-column">
                <h3>LIÊN HỆ</h3>
                <p><i class="fa-solid fa-phone"></i> 0909 123 456</p>
                <p><i class="fa-solid fa-location-dot"></i> TP. Hồ Chí Minh</p>
            </div>
            <div class="footer-column">
                <h3>KẾT NỐI VỚI CHÚNG TÔI</h3>
                <div class="social-icons">
                    <a href="https://www.facebook.com/huuthang11092005"><i class="fa-brands fa-facebook"></i></a>
                    <a href="https://www.youtube.com/@huuthangtran9024/posts"><i class="fa-brands fa-youtube"></i></a>
                    <a href="https://www.tiktok.com/@thangtt26"><i class="fa-brands fa-tiktok"></i></a>
                </div>
            </div>
        </div>
        <div class="footer-bottom">© 2025 Thiết Bị Vệ Sinh & Phòng Tắm - thangtt26</div>
    </footer>
</body>
</html>