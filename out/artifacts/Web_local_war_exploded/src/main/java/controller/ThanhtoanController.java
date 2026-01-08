package controller;

import model.Product;
import services.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "CheckoutController", value = "/Checkout")
public class ThanhtoanController extends HttpServlet {
    private ProductService service = new ProductService(); // Đưa ra ngoài làm biến dùng chung

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        String category = request.getParameter("category"); // 1. Lấy thêm category từ URL

        // 2. Mặc định nếu không có category thì lấy bảng home
        if (category == null || category.isEmpty()) {
            category = "home_sanpham";
        }

        if (idStr != null) {
            // 3. Truyền đủ 2 tham số: category và id
            Product p = service.getProductById(category, Integer.parseInt(idStr));

            request.setAttribute("product", p);
        }

        // 4. Chuyển hướng về file JSP trong thư mục view
        request.getRequestDispatcher("view/page_thanhToan.jsp").forward(request, response);
    }
}