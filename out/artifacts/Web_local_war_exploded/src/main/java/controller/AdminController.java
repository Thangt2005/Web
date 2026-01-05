package controller;

import model.Product;
import services.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminController", value = "/Admin")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10)
public class AdminController extends HttpServlet {
    private ProductService services = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String id = request.getParameter("id");
        String category = request.getParameter("category"); // Tên bảng (source table)
        String viewTable = request.getParameter("viewTable"); // Bảng muốn xem trên danh sách

        // 1. XỬ LÝ XÓA SẢN PHẨM
        if ("delete".equals(action) && id != null && category != null) {
            services.deleteProduct(category, Integer.parseInt(id));
            // Chuyển hướng về trang Admin để làm sạch URL và tránh lỗi 404
            response.sendRedirect("Admin" + (viewTable != null ? "?viewTable=" + viewTable : ""));
            return;
        }

        // 2. XỬ LÝ LẤY DỮ LIỆU ĐỂ SỬA
        if ("edit".equals(action) && id != null && category != null) {
            Product p = services.getProductById(category, Integer.parseInt(id));
            request.setAttribute("productEdit", p);
            request.setAttribute("categoryEdit", category);
        }

        // 3. LẤY DANH SÁCH HIỂN THỊ (LỌC THEO BẢNG HOẶC XEM TẤT CẢ)
        List<Product> list = List.of();
        if (viewTable != null && !viewTable.equals("all")) {
            // Xem sản phẩm theo 1 bảng cụ thể (Lavabo, Bồn cầu...)
            list = services.getProductsByTable(viewTable,null);
        }

        // Gửi dữ liệu thống kê và danh sách sang JSP
        request.setAttribute("productList", list);
        request.setAttribute("currentViewTable", viewTable);
        request.setAttribute("totalProducts", services.getTotalProducts());
        request.setAttribute("totalRevenue", services.getTotalRevenue());

        request.getRequestDispatcher("view/page_admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("update".equals(action)) {
            // LOGIC CẬP NHẬT SẢN PHẨM (SỬA)
            int id = Integer.parseInt(request.getParameter("id"));
            String category = request.getParameter("category");
            String tenSp = request.getParameter("ten_sp");
            double gia = Double.parseDouble(request.getParameter("gia"));
            int giamGia = Integer.parseInt(request.getParameter("giam_gia"));
            String oldImage = request.getParameter("old_image");

            // Xử lý Upload ảnh mới
            Part filePart = request.getPart("hinh_anh");
            String fileName = filePart.getSubmittedFileName();

            if (fileName == null || fileName.isEmpty()) {
                fileName = oldImage; // Không chọn ảnh mới -> Giữ ảnh cũ
            } else {
                String uploadPath = getServletContext().getRealPath("") + File.separator + "image_all";
                filePart.write(uploadPath + File.separator + fileName);
            }
            services.updateProduct(category, id, tenSp, fileName, gia, giamGia);

        } else {
            // LOGIC THÊM SẢN PHẨM MỚI
            String category = request.getParameter("category");
            String tenSp = request.getParameter("ten_sp");
            String gia = request.getParameter("gia");
            String giamGia = request.getParameter("giam_gia");

            Part filePart = request.getPart("hinh_anh");
            String fileName = filePart.getSubmittedFileName();
            String uploadPath = getServletContext().getRealPath("") + File.separator + "image_all";
            filePart.write(uploadPath + File.separator + fileName);

            services.addProduct(category, tenSp, fileName, gia, giamGia);
        }

        // Sau khi thêm/sửa xong, chuyển hướng về Admin để tránh lặp dữ liệu khi Refresh trang
        response.sendRedirect("Admin");
    }
}