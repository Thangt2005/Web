<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.util.*" %>
<%@ page import="model.User" %>

<%
    // 1. CẤU HÌNH ĐƯỜNG DẪN
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";

    // 2. XỬ LÝ LOGIC KIỂM TRA ĐĂNG NHẬP
    Object sessionObj = session.getAttribute("user");

    String displayName = "";      // Tên hiển thị
    boolean isLoggedIn = false;   // Cờ đánh dấu đã đăng nhập chưa
    boolean isAdmin = false;      // Cờ đánh dấu có phải admin không

    if (sessionObj != null) {
        isLoggedIn = true;
        if (sessionObj instanceof User) {
            User u = (User) sessionObj;
            displayName = u.getUsername(); // Hoặc u.getFullName() tùy model của anh
            if (u.getRole() == 1) {
                isAdmin = true;
            }
        } else if (sessionObj instanceof String) {
            displayName = (String) sessionObj;
            isAdmin = false;
        }
    }
%>

<%
    // 3. KẾT NỐI DATABASE & XỬ LÝ PHÂN TRANG
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String errorMessage = "";
    DecimalFormat formatter = new DecimalFormat("###,###");

    // --- Cấu hình phân trang ---
    int productsPerPage = 20; // Số sản phẩm trên 1 trang
    int currentPage = 1;      // Trang hiện tại mặc định là 1

    String pageParam = request.getParameter("page");
    if (pageParam != null && !pageParam.isEmpty()) {
        try {
            currentPage = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
    }

    // Tính vị trí bắt đầu (OFFSET) trong SQL
    int offset = (currentPage - 1) * productsPerPage;
    int totalProducts = 0;
    int totalPages = 0;

    String searchTerm = request.getParameter("search");
    if (searchTerm == null) searchTerm = "";
    searchTerm = searchTerm.trim();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8";
        String userDB = "root";
        String passDB = "";
        conn = DriverManager.getConnection(url, userDB, passDB);

        // BƯỚC A: Đếm tổng số bản ghi (để tính số trang)
        String countSql = "SELECT COUNT(*) FROM home_sanpham";
        if (!searchTerm.isEmpty()) {
            countSql += " WHERE ten_sp LIKE ?";
        }

        PreparedStatement psCount = conn.prepareStatement(countSql);
        if (!searchTerm.isEmpty()) {
            psCount.setString(1, "%" + searchTerm + "%");
        }
        ResultSet rsCount = psCount.executeQuery();
        if (rsCount.next()) {
            totalProducts = rsCount.getInt(1);
        }
        rsCount.close();
        psCount.close();

        // Tính tổng số trang (làm tròn lên)
        totalPages = (int) Math.ceil((double) totalProducts / productsPerPage);

        // BƯỚC B: Lấy dữ liệu hiển thị (có LIMIT và OFFSET)
        String sql = "SELECT * FROM home_sanpham";

        if (!searchTerm.isEmpty()) {
            sql += " WHERE ten_sp LIKE ?";
        }

        // Thêm giới hạn phân trang
        sql += " LIMIT ? OFFSET ?";

        ps = conn.prepareStatement(sql);

        int paramIndex = 1;
        if (!searchTerm.isEmpty()) {
            ps.setString(paramIndex++, "%" + searchTerm + "%");
        }
        ps.setInt(paramIndex++, productsPerPage);
        ps.setInt(paramIndex++, offset);

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
    <base href="<%=basePath%>">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link rel="stylesheet" href="homeStyle.css" />

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="js/main.js"></script>

    <%-- CSS nội bộ cho nút phân trang (Anh có thể chuyển vào homeStyle.css nếu muốn) --%>
    <style>
        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 30px;
            gap: 5px;
        }
        .page-link {
            display: inline-block;
            padding: 8px 16px;
            text-decoration: none;
            color: #333;
            border: 1px solid #ddd;
            border-radius: 4px;
            transition: background-color 0.3s;
        }
        .page-link.active {
            background-color: #007bff;
            color: white;
            border-color: #007bff;
        }
        .page-link:hover:not(.active) {
            background-color: #f1f1f1;
        }
    </style>
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
                        value="<%= searchTerm %>"
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
                if (isLoggedIn) {
            %>

            <%-- 1. Nếu là Admin thì hiện nút Quản trị --%>
            <% if (isAdmin) { %>
            <li>
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
            <li>
                <a href="Logout">
                    <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
                </a>
            </li>

            <%
            } else {
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

            <% if (isAdmin) { %>
            <li><a href="Admin" style="color: yellow; font-weight: bold;">Admin</a></li>
            <% } %>

        </ul>
    </div>
</div>

<main class="main-content">
    <% if (!searchTerm.isEmpty()) { %>
    <h2>Kết quả tìm kiếm cho: "<%= searchTerm %>"</h2>
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
            boolean hasData = false;
            if (rs != null) {
                while (rs.next()) {
                    hasData = true;
                    int id = rs.getInt("id");
                    String tenSp = rs.getString("ten_sp");
                    String hinhAnh = rs.getString("hinh_anh");
                    double gia = rs.getDouble("gia");
                    int giamGia = rs.getInt("giam_gia");
        %>
        <div class="product-card">
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
                <button class="add-to-cart" type="button"
                        onclick="window.location.href='Cart?id=<%= id %>&category=home_sanpham'">
                    <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ
                </button>
                <button class="buy" type="button"
                        onclick="window.location.href='Cart?id=<%= id %>&category=home_sanpham'">
                    <i class="fa-solid fa-bag-shopping"></i> Đặt mua
                </button>
            </div>
        </div>
        <%
                }
            }

            if (!hasData) {
        %>
        <div style="text-align: center; width: 100%; padding: 40px; color: #666; grid-column: 1 / -1;">
            <i class="fa-solid fa-box-open" style="font-size: 40px; margin-bottom: 10px;"></i>
            <p>Không tìm thấy sản phẩm nào phù hợp!</p>
            <a href="Home" style="color: #007bff; text-decoration: underline;">Quay lại trang chủ</a>
        </div>
        <%
            }
        %>
    </div>

    <%-- KHU VỰC HIỂN THỊ NÚT PHÂN TRANG --%>
    <% if (totalPages > 1) { %>
    <div class="pagination">
        <%-- Xử lý tham số tìm kiếm để nối vào link phân trang --%>
        <% String searchParam = searchTerm.isEmpty() ? "" : "&search=" + searchTerm; %>

        <%-- Nút Previous --%>
        <% if (currentPage > 1) { %>
        <a href="Home?page=<%= currentPage - 1 %><%= searchParam %>" class="page-link">&laquo; Trước</a>
        <% } %>

        <%-- Danh sách các trang --%>
        <% for (int i = 1; i <= totalPages; i++) { %>
        <a href="Home?page=<%= i %><%= searchParam %>"
           class="page-link <%= (i == currentPage) ? "active" : "" %>">
            <%= i %>
        </a>
        <% } %>

        <%-- Nút Next --%>
        <% if (currentPage < totalPages) { %>
        <a href="Home?page=<%= currentPage + 1 %><%= searchParam %>" class="page-link">Sau &raquo;</a>
        <% } %>
    </div>
    <% } %>

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
                <li><a href="view/page_ChinhSachGiaoHang.jsp">Chính sách giao hàng</a></li>
                <li><a href="view/page_ChinhSachBaoHanh.jsp">Chính sách bảo hành</a></li>
                <li><a href="view/page_HuongDanThanhToan.jsp">Hướng dẫn thanh toán</a></li>
                <li><a href="view/page_ChamSocKhachHang.jsp">Chăm sóc khách hàng</a></li>
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
    // Đóng kết nối an toàn
    try { if(rs != null) rs.close(); } catch(Exception e) {}
    try { if(ps != null) ps.close(); } catch(Exception e) {}
    try { if(conn != null) conn.close(); } catch(Exception e) {}
%>