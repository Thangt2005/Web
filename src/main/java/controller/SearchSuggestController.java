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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Đảm bảo hiển thị tiếng Việt đúng
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String keyword = request.getParameter("keyword");

        ProductService service = new ProductService();
        List<Product> list = service.getSearchSuggestions(keyword);

        PrintWriter out = response.getWriter();

        // Trả về danh sách các thẻ <div> để hiển thị
        for (Product p : list) {
            // Thay vì gọi selectSuggest, mình gọi lệnh chuyển trang trực tiếp
            // Giả sử đường dẫn xem chi tiết của anh là: ProductDetail?id=123

            out.println("<div class='suggestion-item' onclick=\"window.location.href='ProductDetail?id=" + p.getId() + "'\" style='cursor: pointer;'>");

            // Phần hiển thị ảnh và tên vẫn giữ nguyên
            out.println("<img src='" + p.getHinhAnh() + "' width='40' height='40' style='object-fit:cover; margin-right:10px; border-radius:4px;'>");
            out.println("<span>" + p.getTenSp() + "</span>");

            out.println("</div>");
        }
    }
}