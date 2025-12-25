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
        // 1. Lấy từ khóa tìm kiếm từ thanh Search trên Header
        String search = request.getParameter("search");

        // 2. Gọi Service để lấy dữ liệu (Sửa tên hàm thành searchAllProducts)
        ProductService service = new ProductService();
        List<Product> list = service.searchEverywhere(search);

        // 3. Đẩy dữ liệu sang trang JSP
        request.setAttribute("productList", list);
        request.setAttribute("txtSearch", search); // Giữ lại từ khóa trong ô Input sau khi load trang

        // 4. Chuyển hướng về giao diện home.jsp (bỏ dấu / ở đầu nếu dùng thẻ <base>)
        request.getRequestDispatcher("view/home.jsp").forward(request, response);
    }
}