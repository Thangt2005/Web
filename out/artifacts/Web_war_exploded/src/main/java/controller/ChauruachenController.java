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

@WebServlet(name = "ChauRuaChenController", value = "/ChauRuaChen")
public class ChauruachenController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String search = request.getParameter("search");

        ProductService service = new ProductService();
        List<Product> list = service.getProductsByTable("chauruachen_sanpham", search);

        // Đẩy dữ liệu sang trang JSP
        request.setAttribute("productList", list);
        request.setAttribute("txtSearch", search);

        // Chuyển hướng về file JSP trong thư mục view
        request.getRequestDispatcher("view/page_ChauRuaChen.jsp").forward(request, response);
    }
}