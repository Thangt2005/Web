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

@WebServlet(name = "LavaboController", value = "/Lavabo")
public class LavaboController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Lấy từ khóa tìm kiếm từ thanh địa chỉ
        String search = request.getParameter("search");

        // 2. Gọi Service để lấy dữ liệu Lavabo
        ProductService service = new ProductService();
        List<Product> list = service.getProductsByTable("lavabo_sanpham", search);

        // 3. Đẩy dữ liệu và từ khóa sang JSP
        request.setAttribute("productList", list);
        request.setAttribute("txtSearch", search);

        // 4. Chuyển hướng về file giao diện trong thư mục view
        request.getRequestDispatcher("view/lavabo-page.jsp").forward(request, response);
    }
}