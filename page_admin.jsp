<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.sql.*, java.util.*" %>
<%@ page import="jakarta.servlet.http.Part" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.sql" prefix="sql" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<%-- LOGIC XỬ LÝ UPLOAD VÀ THÊM SẢN PHẨM --%>
<%
    String message = "";
    request.setCharacterEncoding("UTF-8");
    
    // Kiểm tra xem có phải method POST và có nút btn_add không
    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("btn_add_product") != null) {
        Connection conn = null;
        PreparedStatement pst = null;
        try {
            // 1. Lấy dữ liệu Text
            String tableLoai = request.getParameter("category");
            String tenSp = request.getParameter("ten_sp");
            String gia = request.getParameter("gia");
            String giamGia = request.getParameter("giam_gia");

            // 2. Xử lý Upload Ảnh (Chỉ hoạt động khi đã cấu hình web.xml)
            String fileName = "";
            try {
                Part filePart = request.getPart("hinh_anh");
                if (filePart != null && filePart.getSize() > 0) {
                    fileName = filePart.getSubmittedFileName();
                    // Lưu vào thư mục image_all
                    String uploadPath = application.getRealPath("") + File.separator + "image_all";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdir();
                    
                    filePart.write(uploadPath + File.separator + fileName);
                }
            } catch (Exception ex) {
                // Lỗi này xảy ra nếu chưa cấu hình web.xml
                message = "Lỗi Upload: Chưa cấu hình Multipart trong web.xml!";
            }

            // 3. Lưu vào Database
            if (!message.startsWith("Lỗi")) {
                Class.forName("com.mysql.cj.jdbc.Driver");
                // Anh kiểm tra lại port 3306 hay 3307 nhé
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8", "root", "");

                String sqlInsert = "INSERT INTO " + tableLoai + " (ten_sp, hinh_anh, gia, giam_gia) VALUES (?, ?, ?, ?)";
                pst = conn.prepareStatement(sqlInsert);
                pst.setString(1, tenSp);
                pst.setString(2, fileName);
                pst.setString(3, gia);
                pst.setString(4, giamGia);

                int row = pst.executeUpdate();
                if (row > 0) {
                    message = "<div class='success-message'><i class='fa fa-check-circle'></i> Thêm thành công vào bảng: <b>" + tableLoai + "</b></div>";
                }
            }
        } catch (Exception e) {
            message = "<div class='error-message'>Lỗi hệ thống: " + e.getMessage() + "</div>";
            e.printStackTrace();
        } finally {
            if (pst != null) pst.close();
            if (conn != null) conn.close();
        }
    }
%>

<%-- KẾT NỐI DB ĐỂ THỐNG KÊ --%>
<sql:setDataSource var="dbConnection" driver="com.mysql.cj.jdbc.Driver"
  url="jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8" user="root" password="" />

<c:catch var="dbException">
    <sql:query dataSource="${dbConnection}" var="stats">
        SELECT 
            (SELECT COUNT(*) FROM chauruachen_sanpham) + (SELECT COUNT(*) FROM lavabo_sanpham) + 
            (SELECT COUNT(*) FROM tulavabo_sanpham) + (SELECT COUNT(*) FROM toilet_sanpham) + 
            (SELECT COUNT(*) FROM voisentam_sanpham) + (SELECT COUNT(*) FROM voisen_sanpham) + 
            (SELECT COUNT(*) FROM voirua_sanpham) + (SELECT COUNT(*) FROM bontam_sanpham) + 
            (SELECT COUNT(*) FROM bontieunam_sanpham) + (SELECT COUNT(*) FROM phukien_sanpham) + 
            (SELECT COUNT(*) FROM combo_sanpham) + (SELECT COUNT(*) FROM home_sanpham) as total
    </sql:query>
    <c:set var="totalProducts" value="${stats.rows[0].total}" />
</c:catch>

<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link rel="stylesheet" href="admin_style.css" /> 
    <style>
        body { font-family: 'Segoe UI', sans-serif; margin: 0; background: #f4f4f4; }
        /* Header tối màu cho đúng chuẩn HCI */
        header { background: #1a1a1a; color: white; padding: 15px 20px; display: flex; justify-content: space-between; align-items: center; border-bottom: 3px solid #c0a750; }
        .admin-sidebar-panel { width: 260px; min-height: 100vh; background: #2c2c2c; color: white; padding-top: 20px; }
        .admin-sidebar-panel ul { list-style:none; padding:0; margin: 0; }
        .admin-sidebar-panel ul li a { color: #cfd2d6; text-decoration: none; display: block; padding: 12px 20px; border-bottom: 1px solid #3d444a; }
        .admin-sidebar-panel ul li a:hover { background: #444; color: white; padding-left: 25px; transition: 0.3s; }
        
        .admin-form-container { background: white; padding: 25px; border-radius: 8px; margin-top: 20px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: bold; }
        .form-group input, .form-group select { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; }
        .btn-submit { background: #28a745; color: white; padding: 12px 25px; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; font-weight: bold; width: 100%; }
        
        .success-message { background-color: #d4edda; color: #155724; padding: 15px; margin-bottom: 20px; border: 1px solid #c3e6cb; border-radius: 4px;}
        .error-message { background-color: #f8d7da; color: #721c24; padding: 15px; margin-bottom: 20px; border: 1px solid #f5c6cb; border-radius: 4px;}
        
        /* Stats Box */
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: white; padding: 20px; border-radius: 8px; text-align: center; box-shadow: 0 2px 5px rgba(0,0,0,0.05); border-left: 5px solid #007bff; }
    </style>
  </head>
  <body>

    <header>
      <h1 style="margin:0; font-size: 22px;"><i class="fas fa-user-shield"></i> Trang Quản Trị</h1>
      <div><a href="home.jsp" style="color:white; text-decoration:none;"><i class="fa fa-home"></i> Về trang chủ</a></div>
    </header>

    <div style="display:flex; width:100%;">
        <div class="admin-sidebar-panel">
           <div class="menu-title">QUẢN LÝ CHUNG</div>
           <ul>
             <li style="background: #444;"><a href="page_admin.jsp" style="color:white;"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
             <li><a href="#"><i class="fas fa-shopping-cart"></i> Đơn hàng</a></li>
           </ul>
        </div>
        
        <main style="flex:1; padding: 25px;">
          <h2>Dashboard Tổng quan</h2>
          
          <div class="stats-grid">
            <div class="stat-card">
              <h3 style="color:#666; font-size:14px; margin-top:0;">TỔNG SẢN PHẨM</h3>
              <p style="font-size:36px; font-weight:bold; color:#007bff; margin:10px 0;">
                <c:choose>
                    <c:when test="${not empty dbException}">--</c:when>
                    <c:otherwise><c:out value="${totalProducts}" default="0" /></c:otherwise>
                </c:choose>
              </p>
            </div>
            <div class="stat-card" style="border-left-color: #28a745;">
               <h3 style="color:#666; font-size:14px; margin-top:0;">DOANH THU</h3>
               <p style="font-size:36px; font-weight:bold; color:#28a745; margin:10px 0;">150.000.000đ</p>
            </div>
          </div>

          <div class="admin-form-container">
              <h3 style="border-bottom: 2px solid #eee; padding-bottom: 15px; margin-top:0; color: #333;">
                  <i class="fa fa-plus-circle" style="color: #007bff;"></i> Thêm Sản Phẩm Mới
              </h3>
              
              <%= message %>

              <%-- Form action để trống = gửi về chính trang này --%>
              <form action="" method="POST" enctype="multipart/form-data">
                  <div class="form-group">
                      <label>1. Chọn Danh Mục (Bảng CSDL):</label>
                      <select name="category" required>
                           <option value="">-- Vui lòng chọn --</option>
                           <option value="chauruachen_sanpham">Chậu Rửa Chén</option>
                           <option value="lavabo_sanpham">Lavabo</option>
                           <option value="tulavabo_sanpham">Tủ Lavabo</option>
                           <option value="bontam_sanpham">Bồn Tắm</option>
                           <option value="toilet_sanpham">Bồn Cầu/Toilet</option>
                           <option value="bontieunam_sanpham">Bồn Tiểu Nam</option>
                           <option value="voisentam_sanpham">Vòi Sen Tắm</option>
                           <option value="voisen_sanpham">Vòi Sen</option>
                           <option value="voirua_sanpham">Vòi Rửa</option>
                           <option value="phukien_sanpham">Phụ Kiện</option>
                           <option value="combo_sanpham">Combo</option>
                           <option value="home_sanpham">Sản phẩm Home</option>
                      </select>
                  </div>
                  <div class="form-group">
                      <label>2. Tên Sản Phẩm:</label>
                      <input type="text" name="ten_sp" required placeholder="Nhập tên sản phẩm...">
                  </div>
                  <div style="display: flex; gap: 20px;">
                      <div class="form-group" style="flex: 1;">
                          <label>3. Giá Tiền (VNĐ):</label>
                          <input type="number" name="gia" required placeholder="Ví dụ: 1500000">
                      </div>
                      <div class="form-group" style="flex: 1;">
                          <label>4. Giảm Giá (%):</label>
                          <input type="number" name="giam_gia" value="0" placeholder="Nhập % giảm">
                      </div>
                  </div>
                  <div class="form-group">
                      <label>5. Hình Ảnh (Upload):</label>
                      <input type="file" name="hinh_anh" accept="image/*" required>
                  </div>
                  
                  <button type="submit" name="btn_add_product" value="true" class="btn-submit">
                      <i class="fa fa-save"></i> Lưu Sản Phẩm
                  </button>
              </form>
          </div>
        </main>
    </div>
  </body>
</html>