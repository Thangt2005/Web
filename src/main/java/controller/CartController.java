package controller;

import services.CartServices;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.UUID; // Thêm thư viện này để tạo ID ngẫu nhiên duy nhất

@WebServlet("/Cart")
public class CartController extends HttpServlet {

    private CartServices cartService = new CartServices();

    // Tên của Cookie lưu mã giỏ hàng
    private static final String CART_COOKIE_NAME = "USER_CART_TOKEN";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Lấy hoặc tạo mã định danh giỏ hàng (Thay thế cho session.getId())
        String cartToken = getCartTokenFromCookie(request, response);

        // 2. Lấy các tham số từ URL
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        String loai = request.getParameter("loai");
        if (loai == null) {
            loai = "home";
        }

        try {
            // 3. XỬ LÝ CÁC HÀNH ĐỘNG (Dùng cartToken thay vì sessionId)
            if (action != null && idStr != null) {
                int id = Integer.parseInt(idStr);

                if ("add".equals(action)) {
                    cartService.addToCart(cartToken, id, loai);
                } else if ("delete".equals(action)) {
                    cartService.removeFromCart(id);
                }

                response.sendRedirect("Cart");
                return;
            }

            // Hỗ trợ link cũ
            if (idStr != null && action == null) {
                cartService.addToCart(cartToken, Integer.parseInt(idStr), loai);
                response.sendRedirect("Cart");
                return;
            }

            // 4. HIỂN THỊ GIỎ HÀNG (Dùng cartToken thay vì sessionId)
            List<Map<String, Object>> cartItems = cartService.getCartDetails(cartToken);

            request.setAttribute("cartItems", cartItems);
            request.getRequestDispatcher("/view/page_ThemVaoGiohang.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            System.out.println("Lỗi format ID: " + e.getMessage());
            response.sendRedirect("Home");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // --- HÀM HỖ TRỢ: LẤY HOẶC TẠO COOKIE ---
    private String getCartTokenFromCookie(HttpServletRequest request, HttpServletResponse response) {
        String token = null;
        Cookie[] cookies = request.getCookies();

        // 1. Tìm xem trình duyệt đã có Cookie "USER_CART_TOKEN" chưa
        if (cookies != null) {
            for (Cookie c : cookies) {
                if (CART_COOKIE_NAME.equals(c.getName())) {
                    token = c.getValue();
                    break;
                }
            }
        }

        // 2. Nếu chưa có, tạo token mới và lưu vào Cookie
        if (token == null || token.trim().isEmpty()) {
            token = UUID.randomUUID().toString(); // Tạo chuỗi ngẫu nhiên duy nhất

            Cookie newCookie = new Cookie(CART_COOKIE_NAME, token);
            newCookie.setMaxAge(60 * 60 * 24 * 30); // Sống trong 30 ngày (tính bằng giây)
            newCookie.setPath("/"); // Cookie có hiệu lực trên toàn bộ website

            response.addCookie(newCookie);
        }

        return token;
    }
}