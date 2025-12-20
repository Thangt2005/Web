package controller;

import model.Product;
import services.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "CheckoutController", value = "/Checkout")
public class ThanhtoanController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");

        if (idStr != null) {
            ProductService service = new ProductService();
            Product p = service.getProductById(Integer.parseInt(idStr));

            // Đẩy đối tượng sản phẩm sang trang JSP
            request.setAttribute("product", p);
        }

        // Chuyển hướng về file JSP trong thư mục view
        request.getRequestDispatcher("view/checkout.jsp").forward(request, response);
    }
}