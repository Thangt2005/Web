<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    String spIdStr = request.getParameter("id");
    String sessionId = session.getId(); 
    Connection conn = null;

    // Mặc định quay lại home nếu không xác định được trang trước đó
    String urlQuayLai = "home.jsp";
    // Nếu anh muốn nó quay lại đúng trang vừa đứng (ví dụ đang ở trang combo), dùng header này:
    if (request.getHeader("referer") != null) {
        urlQuayLai = request.getHeader("referer");
    }

    if (spIdStr != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8", "root", "");

            // 1. Lấy/Tạo Giỏ hàng
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

            // 2. Lấy thông tin sản phẩm
            PreparedStatement psProduct = conn.prepareStatement("SELECT ten_sp, hinh_anh, gia FROM home_sanpham WHERE id = ?");
            psProduct.setInt(1, Integer.parseInt(spIdStr));
            ResultSet rsProduct = psProduct.executeQuery();

            if (rsProduct.next()) {
                // 3. Kiểm tra và thêm vào chi tiết giỏ
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
            
            // XỬ LÝ XONG -> QUAY LẠI TRANG CŨ KÈM THÔNG BÁO THÀNH CÔNG
            // Dấu ?status=success để trang home biết mà hiện thông báo
            if (urlQuayLai.contains("?")) {
                response.sendRedirect(urlQuayLai + "&status=success");
            } else {
                response.sendRedirect(urlQuayLai + "?status=success");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("home.jsp?status=error");
        } finally {
            if (conn != null) conn.close();
        }
    } else {
        response.sendRedirect("home.jsp");
    }
%>