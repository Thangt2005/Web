package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Product;
import services.ProductService;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "SearchSuggest", value = "/SearchSuggest")
public class SearchSuggestController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String keyword = request.getParameter("keyword");

        ProductService service = new ProductService();
        List<Product> list = service.getSearchSuggestions(keyword);

        PrintWriter out = response.getWriter();
        // Trả về danh sách <li> để hiển thị
        for (Product p : list) {
            out.println("<div class='suggestion-item' onclick=\"selectSuggest('" + p.getTenSp() + "')\">");
            out.println("<img src='image_all/" + p.getHinhAnh() + "' width='30'>");
            out.println("<span>" + p.getTenSp() + "</span>");
            out.println("</div>");
        }
    }
}