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

@WebServlet(name = "BonTieuNamController", value = "/BonTieuNam")
public class BontieunamController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String search = request.getParameter("search");

        ProductService service = new ProductService();
        List<Product> list = service.getProductsByTable("bontieunam_sanpham", search);

        request.setAttribute("productList", list);
        request.setAttribute("txtSearch", search);

        // Chuyển hướng sang file JSP nằm trong thư mục view
        request.getRequestDispatcher("view/page_BonTieuNam.jsp").forward(request, response);
    }
}