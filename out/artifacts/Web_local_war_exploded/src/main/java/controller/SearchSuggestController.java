package controller;

import model.Product;
import services.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "SearchSuggest", value = "/SearchSuggest")
public class SearchSuggestController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Cấu hình tiếng Việt
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String keyword = request.getParameter("keyword");
        PrintWriter out = response.getWriter();
        ProductService service = new ProductService();

        // Gọi hàm tìm kiếm toàn cục (Search Everywhere)
        List<Product> list = service.getSearchSuggestions(keyword);

        // Xuất HTML trả về cho Ajax
        for (Product p : list) {
            // Xác định bảng để tạo link (Lấy từ category bạn đã set trong Service)
            String targetTable = (p.getCategory() != null) ? p.getCategory() : "home_sanpham";

            // Tạo thẻ li, onclick gọi hàm JS selectProduct
            out.println("<li class='suggest-item' onclick=\"selectProduct(" + p.getId() + ", '" + targetTable + "')\">");
            out.println("  <img src='image_all/" + p.getHinhAnh() + "' alt='img'>");
            out.println("  <div class='info'>");
            out.println("    <span class='name'>" + p.getTenSp() + "</span>");
            out.println("    <span class='price'>" + String.format("%,.0f", p.getGia()) + "đ</span>");
            out.println("  </div>");
            out.println("</li>");
        }
    }
}