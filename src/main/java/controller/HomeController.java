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

@WebServlet(name = "HomeController", value = "/Home")
public class HomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Lấy từ khóa tìm kiếm
        String search = request.getParameter("search");

        // 2. Gọi Service để lấy dữ liệu
        ProductService service = new ProductService();
        List<Product> list = service.getAllProducts(search);

        // 3. Đẩy dữ liệu sang trang JSP
        request.setAttribute("productList", list);
        request.setAttribute("txtSearch", search); // Để giữ lại chữ trong ô tìm kiếm

        // 4. Chuyển hướng về giao diện
        request.getRequestDispatcher("view/home.jsp").forward(request, response);
    }
}