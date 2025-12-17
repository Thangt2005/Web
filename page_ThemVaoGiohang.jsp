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