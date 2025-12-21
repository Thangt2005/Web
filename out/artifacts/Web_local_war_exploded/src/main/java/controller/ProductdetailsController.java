package controller;

import model.Product;
import services.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "ProductdetailsController", value = "/ProductDetail")
public class ProductdetailsController extends HttpServlet {
    // PHẢI CÓ DÒNG NÀY ĐỂ HẾT LỖI ĐỎ Ở DÒNG 22
    private ProductService service = new ProductService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        String category = request.getParameter("category"); // Lấy tên bảng từ URL

        // Nếu không có category, mặc định lấy từ bảng home_sanpham
        if (category == null || category.isEmpty()) {
            category = "home_sanpham";
        }

        if (id != null) {
            Product p = service.getProductById(category, Integer.parseInt(id));
            request.setAttribute("product", p);
        }

        // Forward đến đúng file JSP trong thư mục view
        request.getRequestDispatcher("view/page_XemChiTietSanPham.jsp").forward(request, response);
    }
}