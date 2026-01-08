package controller;

import model.Product;
import services.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "ProductdetailsController", value = "/ProductDetail")
public class ProductdetailsController extends HttpServlet {

    private ProductService service = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Lấy ID sản phẩm từ URL
        String idParam = request.getParameter("id");
        // 2. Lấy tên bảng (category) từ URL gửi lên (ví dụ: lavabo_sanpham, toilet_sanpham)
        String category = request.getParameter("category");

        // 3. Kiểm tra logic lấy bảng
        // Nếu trên URL không có tham số category, ta mới mặc định là home_sanpham
        if (category == null || category.trim().isEmpty()) {
            category = "home_sanpham";
        }

        if (idParam != null) {
            try {
                int productId = Integer.parseInt(idParam);

                // Gọi service truyền cả tên bảng và ID vào để tìm đúng nơi
                Product p = service.getProductById(category, productId);

                if (p != null) {
                    request.setAttribute("product", p);
                } else {
                    request.setAttribute("errorMessage", "Không tìm thấy sản phẩm trong danh mục " + category);
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // 4. Chuyển hướng đến trang hiển thị chi tiết
        request.getRequestDispatcher("view/page_XemChiTietSanPham.jsp").forward(request, response);
    }
}