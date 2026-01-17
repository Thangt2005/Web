<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.DecimalFormat" %>
<<<<<<< HEAD
<%@ page import="model.User" %>

<%
    // 1. CẤU HÌNH ĐƯỜNG DẪN CƠ BẢN
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";

    // 2. XỬ LÝ LOGIC NGƯỜI DÙNG (SESSION)
    // Lấy thông tin user ngay từ đầu để dùng cho việc ẩn hiện menu
    Object obj = session.getAttribute("user");
    User authUser = null;
    if (obj != null) {
        authUser = (User) obj;
    }

    // 3. XỬ LÝ KẾT NỐI CSDL VÀ TÌM KIẾM SẢN PHẨM
=======
<%@ page import="model.User" %> <%-- Bắt buộc phải import model User --%>

<%
    // 1. CẤU HÌNH ĐƯỜNG DẪN
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";

    // 2. XỬ LÝ LOGIC KIỂM TRA ĐĂNG NHẬP (THÔNG MINH)
    // Đoạn này chấp nhận cả User Object lẫn String (Google/FB)
    Object sessionObj = session.getAttribute("user");

    String displayName = "";      // Tên hiển thị
    boolean isLoggedIn = false;   // Cờ đánh dấu đã đăng nhập chưa
    boolean isAdmin = false;      // Cờ đánh dấu có phải admin không

    if (sessionObj != null) {
        isLoggedIn = true; // Đã có dữ liệu user -> Đã đăng nhập

        // TRƯỜNG HỢP 1: Đăng nhập thường (Lưu Object User)
        if (sessionObj instanceof User) {
            User u = (User) sessionObj;
            // Anh kiểm tra file User.java xem hàm lấy tên là getUsername() hay getFullName() nhé
            displayName = u.getUsername();

            // Kiểm tra quyền Admin (Ví dụ role = 1 là admin)
            if (u.getRole() == 1) {
                isAdmin = true;
            }
        }
        // TRƯỜNG HỢP 2: Đăng nhập Google/Facebook (Lưu String tên)
        else if (sessionObj instanceof String) {
            displayName = (String) sessionObj;
            isAdmin = false; // Google/FB mặc định là khách hàng
        }
    }
%>

<%
    // 3. KẾT NỐI DATABASE & LẤY SẢN PHẨM
>>>>>>> c1261a59003dd00faf6650fc20280451ade6646d
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String errorMessage = "";
    DecimalFormat formatter = new DecimalFormat("###,###");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8";
<<<<<<< HEAD
        String user = "root";
        String pass = ""; // Anh điền pass database của anh vào đây nếu có
        conn = DriverManager.getConnection(url, user, pass);
=======
        String userDB = "root";
        String passDB = "";
        conn = DriverManager.getConnection(url, userDB, passDB);
>>>>>>> c1261a59003dd00faf6650fc20280451ade6646d

        String searchTerm = request.getParameter("search");

        // Mặc định lấy bảng home_sanpham.
        // Nếu anh muốn chuyển tab (Combo, Toilet...) thì cần dùng Controller gửi tên bảng sang như em đã hướng dẫn trước đó.
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
    <base href="<%=basePath%>">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ - Thiết bị vệ sinh</title>
    <base href="<%=basePath%>">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link rel="stylesheet" href="homeStyle.css" />

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="js/main.js"></script>
</head>
<body>

<header>
    <h1>Thiết Bị Vệ Sinh Và Phòng Tắm</h1>
    <nav>
        <div class="search-container" style="position: relative;">
            <form class="search-form" action="Home" method="GET" id="searchForm">
                <input
                        type="text"
                        id="searchInput"
                        name="search"
                        placeholder="Tìm kiếm sản phẩm ..."
                        class="search-input"
                        autocomplete="off"
                        value="<%= (request.getParameter("search") != null) ? request.getParameter("search") : "" %>"
                />
                <button type="submit" class="search-icon">
                    <i class="fa fa-search"></i>
                </button>
            </form>
            <div id="suggestionBox" class="suggestion-box"></div>
        </div>

        <ul class="user-menu">
            <%-- Link Giỏ hàng --%>
            <li><a href="Cart"><i class="fa-solid fa-cart-shopping"></i> Giỏ hàng</a></li>

            <%
<<<<<<< HEAD
                if (authUser != null) {
                    // --- TRƯỜNG HỢP ĐÃ ĐĂNG NHẬP ---
=======
                // SỬ DỤNG BIẾN ĐÃ XỬ LÝ Ở TRÊN (isLoggedIn, isAdmin, displayName)
                if (isLoggedIn) {
>>>>>>> c1261a59003dd00faf6650fc20280451ade6646d
            %>

            <%-- 1. Nếu là Admin thì hiện nút Quản trị --%>
            <% if (isAdmin) { %>
            <li>
<<<<<<< HEAD
                <a href="#" style="font-weight: bold; color: yellow;">
                    <i class="fas fa-user"></i> Xin chào, <%= authUser.getUsername() %>
                </a>
            </li>

            <%
                // Logic kiểm tra quyền Admin: Chỉ hiện nếu role == 1
                if (authUser.getRole() == 1) {
            %>
            <li>
                <a href="Admin" style="color: red; font-weight: bold;">
                    <i class="fa-solid fa-user-shield"></i> Quản trị (Admin)
                </a>
            </li>
            <%
                }
            %>

=======
                <a href="Admin" style="color: #ff4757; font-weight: bold;">
                    <i class="fas fa-user-shield"></i> Trang Quản Trị
                </a>
            </li>
            <% } %>

            <%-- 2. Hiện tên User --%>
            <li>
                <a href="#" style="font-weight: bold; color: yellow;">
                    <i class="fas fa-user"></i> Xin chào, <%= displayName %>
                </a>
            </li>

            <%-- 3. Nút Đăng xuất --%>
>>>>>>> c1261a59003dd00faf6650fc20280451ade6646d
            <li>
                <a href="Logout">
                    <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
                </a>
            </li>

            <%
            } else {
<<<<<<< HEAD
                // --- TRƯỜNG HỢP CHƯA ĐĂNG NHẬP ---
=======
                // --- NẾU CHƯA ĐĂNG NHẬP ---
>>>>>>> c1261a59003dd00faf6650fc20280451ade6646d
            %>
            <li>
                <a href="view/login_page.jsp">
                    <i class="fas fa-user"></i> Đăng nhập
                </a>
            </li>
            <%
                }
            %>
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
            <li><a href="Home" class="active">Trang chủ</a></li>
            <li><a href="Combo">Combo</a></li>
            <li><a href="Toilet">Bồn Cầu</a></li>
            <li><a href="Lavabo">Lavabo</a></li>
            <li><a href="TuLavabo">Tủ Lavabo</a></li>
            <li><a href="VoiSenTam">Vòi Sen Tắm</a></li>
            <li><a href="ChauRuaChen">Chậu Rửa Chén</a></li>
            <li><a href="BonTam">Bồn Tắm</a></li>
            <li><a href="VoiRua">Vòi Rửa</a></li>
            <li><a href="BonTieuNam">Bồn Tiểu Nam</a></li>
            <li><a href="PhuKien">Phụ Kiện</a></li>

<<<<<<< HEAD
            <%
                // --- CODE ẨN HIỆN MENU ADMIN Ở THANH NAV ĐEN ---
                if (authUser != null && authUser.getRole() == 1) {
            %>
            <li><a href="Admin">Admin</a></li>
            <% } %>
=======
            <%-- Menu Admin ở thanh sidebar (chỉ hiện nếu là admin) --%>
            <% if (isAdmin) { %>
            <li><a href="Admin" style="color: yellow; font-weight: bold;">Admin</a></li>
            <% } %>

>>>>>>> c1261a59003dd00faf6650fc20280451ade6646d
        </ul>
    </div>
</div>

<main class="main-content">
    <% if (request.getParameter("search") != null && !request.getParameter("search").isEmpty()) { %>
    <h2>Kết quả tìm kiếm cho: "<%= request.getParameter("search") %>"</h2>
    <% } else { %>
    <h2>Sản phẩm nổi bật</h2>
    <% } %>

    <% if (!errorMessage.isEmpty()) { %>
    <div style="color: red; text-align: center; padding: 20px; font-weight: bold; background: #ffe6e6; border: 1px solid red; margin: 10px;">
        <%= errorMessage %>
    </div>
    <% } %>

    <div class="product-grid">
        <%
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
<<<<<<< HEAD
            <%-- Lấy link ảnh trực tiếp từ database --%>
=======
            <%-- Link ảnh trực tiếp từ DB --%>
>>>>>>> c1261a59003dd00faf6650fc20280451ade6646d
            <img src="<%= hinhAnh %>" alt="<%= tenSp %>" onerror="this.src='https://via.placeholder.com/200?text=No+Image'">

            <h3>
                <a href="ProductDetail?id=<%= id %>">
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
<<<<<<< HEAD
                <button class="add-to-cart" type="button" onclick="window.location.href='Cart?id=<%= id %>'">
                    <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ
                </button>
                <button class="buy" type="button" onclick="muaNgay(<%= id %>)">
=======
                <button class="add-to-cart" type="button"
                        onclick="window.location.href='Cart?id=<%= id %>&category=home_sanpham'">
                    <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ
                </button>
                <button class="buy" type="button"
                        onclick="window.location.href='Cart?id=<%= id %>&category=home_sanpham'">
>>>>>>> c1261a59003dd00faf6650fc20280451ade6646d
                    <i class="fa-solid fa-bag-shopping"></i> Đặt mua
                </button>
            </div>
        </div>
        <%
            }

            if (!hasData) {
        %>
        <div style="text-align: center; width: 100%; padding: 40px; color: #666;">
            <i class="fa-solid fa-box-open" style="font-size: 40px; margin-bottom: 10px;"></i>
            <p>Không tìm thấy sản phẩm nào phù hợp!</p>
            <a href="Home" style="color: #007bff; text-decoration: underline;">Quay lại trang chủ</a>
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
<<<<<<< HEAD
    // Đóng kết nối an toàn ở cuối file
=======
    // Đóng kết nối an toàn
>>>>>>> c1261a59003dd00faf6650fc20280451ade6646d
    try { if(rs != null) rs.close(); } catch(Exception e) {}
    try { if(ps != null) ps.close(); } catch(Exception e) {}
    try { if(conn != null) conn.close(); } catch(Exception e) {}
%>