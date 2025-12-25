package controller;

import model.Product;
import services.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ComboController", value = "/Combo")
public class ComboController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Lấy từ khóa tìm kiếm từ thanh search (nếu có)
        String search = request.getParameter("search");

        // 2. Gọi Service để lấy dữ liệu
        ProductService service = new ProductService();

        List<Product> list = service.getProductsByTable("combo_sanpham", search);

        // 3. Đẩy dữ liệu sang JSP
        request.setAttribute("productList", list);
        request.setAttribute("txtSearch", search);

        // 4. Chuyển hướng sang file JSP (Bỏ dấu / ở đầu để base href hoạt động)
        request.getRequestDispatcher("view/page_combo.jsp").forward(request, response);
    }
}