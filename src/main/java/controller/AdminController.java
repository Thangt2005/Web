package controller;

import services.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;

@WebServlet(name = "AdminController", value = "/Admin")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10)
public class AdminController extends HttpServlet {
    private ProductService services = new ProductService();

    // Hiển thị trang Dashboard và Thống kê
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("totalProducts", services.getTotalProducts());
        request.getRequestDispatcher("view/page_admin.jsp").forward(request, response);
    }

    // Xử lý thêm sản phẩm
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String category = request.getParameter("category");
        String tenSp = request.getParameter("ten_sp");
        String gia = request.getParameter("gia");
        String giamGia = request.getParameter("giam_gia");

        // Xử lý Upload Ảnh
        Part filePart = request.getPart("hinh_anh");
        String fileName = filePart.getSubmittedFileName();
        String uploadPath = getServletContext().getRealPath("") + File.separator + "image_all";
        filePart.write(uploadPath + File.separator + fileName);

        // Lưu vào DB
        boolean success = services.addProduct(category, tenSp, fileName, gia, giamGia);

        if (success) {
            request.setAttribute("message", "Thêm thành công vào bảng " + category);
        } else {
            request.setAttribute("message", "Lỗi: Không thể lưu vào hệ thống!");
        }

        doGet(request, response); // Quay lại trang Admin để cập nhật số liệu
    }
}