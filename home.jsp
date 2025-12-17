<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.DecimalFormat" %>

<%
    // --- PHẦN 1: XỬ LÝ BACKEND (JAVA) ---
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String errorMessage = "";
    DecimalFormat formatter = new DecimalFormat("###,###"); // Định dạng tiền tệ: 1.500.000

    try {
        // 1. Load Driver & Kết nối
        Class.forName("com.mysql.cj.jdbc.Driver");
        // Lưu ý: Anh kiểm tra lại port 3306 hoặc 3307 tùy máy anh nhé
        String url = "jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8";
        String user = "root";
        String pass = "";
        conn = DriverManager.getConnection(url, user, pass);

        // 2. Xử lý logic Tìm kiếm
        String searchTerm = request.getParameter("search");
        String sql = "SELECT * FROM home_sanpham";
        
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql += " WHERE ten_sp LIKE ?";
        }

        ps = conn.prepareStatement(sql);

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            ps.setString(1, "%" + searchTerm.trim() + "%");
        }

        rs = ps.executeQuery();

    } catch (Exception e) {
        errorMessage = "Lỗi kết nối CSDL: " + e.getMessage();
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ - Thiết bị vệ sinh</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link rel="stylesheet" href="homeStyle.css" />
    
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="js/main.js"></script>
  </head>
  <body>
  
    <header>
      <h1>Thiết Bị Vệ Sinh Và Phòng Tắm</h1>
      <nav>
        <form class="search-form" action="home.jsp" method="GET">
          <input
            type="text"
            name="search"
            placeholder="Tìm kiếm sản phẩm ..."
            class="search-input"
            value="<%= (request.getParameter("search") != null) ? request.getParameter("search") : "" %>"
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
          <li><a href="home.jsp" class="active">Trang chủ</a></li>
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
        <%-- Tiêu đề động --%>
        <% if (request.getParameter("search") != null && !request.getParameter("search").isEmpty()) { %>
            <h2>Kết quả tìm kiếm cho: "<%= request.getParameter("search") %>"</h2>
        <% } else { %>
            <h2>Sản phẩm nổi bật</h2>
        <% } %>

        <%-- Hiển thị lỗi DB nếu có --%>
        <% if (!errorMessage.isEmpty()) { %>
            <div style="color: red; text-align: center; padding: 20px; font-weight: bold; background: #ffe6e6; border: 1px solid red; margin: 10px;">
                <%= errorMessage %>
            </div>
        <% } %>

        <div class="product-grid">
        <% 
            // --- PHẦN 2: VÒNG LẶP HIỂN THỊ SẢN PHẨM ---
            if (rs != null) {
                boolean hasData = false;
                while (rs.next()) { 
                    hasData = true;
                    int id = rs.getInt("id");
                    String tenSp = rs.getString("ten_sp");
                    String hinhAnh = rs.getString("hinh_anh");
                    double gia = rs.getDouble("gia");
                    int giamGia = rs.getInt("giam_gia");
        %>
            <div class="product-card">
                <img src="image_all/<%= hinhAnh %>" alt="<%= tenSp %>" onerror="this.src='https://via.placeholder.com/200?text=No+Image'">
                
                <h3>
                    <a href="TrangChiTiet.jsp?id=<%= id %>">
                        <%= tenSp %>
                    </a>
                </h3>
                
                <p class="price">
                    <%= formatter.format(gia) %>đ
                    <% if(giamGia > 0) { %>
                        <span class="discount">-<%= giamGia %>%</span>
                    <% } %>
                </p>
                
                <div class="button-group">
                    <%-- NÚT 1: GỌI HÀM JS THÊM GIỎ HÀNG --%>
                    <button class="add-to-cart" type="button" onclick="themVaoGioHang(<%= id %>)">
                        <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ
                    </button>
                    
                    <%-- NÚT 2: GỌI HÀM JS MUA NGAY --%>
                    <button class="buy" type="button" onclick="muaNgay(<%= id %>)">
                        <i class="fa-solid fa-bag-shopping"></i> Đặt mua
                    </button>
                </div>
            </div>
            <% 
                } // Kết thúc while
                
                if (!hasData) {
            %>
                    <div style="text-align: center; width: 100%; padding: 40px; color: #666;">
                        <i class="fa-solid fa-box-open" style="font-size: 40px; margin-bottom: 10px;"></i>
                        <p>Không tìm thấy sản phẩm nào phù hợp!</p>
                        <a href="home.jsp" style="color: #007bff; text-decoration: underline;">Quay lại trang chủ</a>
                    </div>
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
            <a href="https://www.facebook.com/huuthang11092005" target="_blank"><i class="fa-brands fa-facebook"></i></a>
            <a href="https://www.youtube.com/@huuthangtran9024/posts" target="_blank"><i class="fa-brands fa-youtube"></i></a>
            <a href="https://www.tiktok.com/@thangtt26" target="_blank"><i class="fa-brands fa-tiktok"></i></a>
          </div>
        </div>
      </div>

      <div class="footer-bottom">
        © 2025 Thiết Bị Vệ Sinh & Phòng Tắm - All Rights Reserved.
      </div>
    </footer>
  </body>
</html>

<%
    // --- PHẦN 3: ĐÓNG KẾT NỐI (Bắt buộc) ---
    try { if(rs != null) rs.close(); } catch(Exception e) {}
    try { if(ps != null) ps.close(); } catch(Exception e) {}
    try { if(conn != null) conn.close(); } catch(Exception e) {}
%>