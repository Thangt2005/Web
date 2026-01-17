package controller;

import model.Product;
import model.User;
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
        // --- 1. BẮT ĐẦU KIỂM TRA QUYỀN (SỬA LẠI CHO ĐÚNG KEY "USER") ---
        HttpSession session = request.getSession();

        // Lấy session ra dưới dạng Object (để tránh lỗi nếu lỡ là String Google)
        Object sessionObj = session.getAttribute("user");
        User auth = null;
        boolean isAdmin = false;

        // Chỉ cho phép vào nếu session là Object User VÀ có role = 1
        if (sessionObj != null && sessionObj instanceof User) {
            auth = (User) sessionObj;
            if (auth.getRole() == 1) {
                isAdmin = true;
            }
        }

        // Nếu không phải Admin -> Đuổi về Home
        if (!isAdmin) {
            response.sendRedirect("Home");
            return;
        }
        // --- KẾT THÚC KIỂM TRA QUYỀN ---

        String action = request.getParameter("action");
        String id = request.getParameter("id");
        String category = request.getParameter("category");
        String viewTable = request.getParameter("viewTable");

        // 2. XỬ LÝ XÓA SẢN PHẨM
        if ("delete".equals(action) && id != null && category != null) {
            services.deleteProduct(category, Integer.parseInt(id));
            response.sendRedirect("Admin" + (viewTable != null ? "?viewTable=" + viewTable : ""));
            return;
        }

        // 3. XỬ LÝ LẤY DỮ LIỆU ĐỂ SỬA
        if ("edit".equals(action) && id != null && category != null) {
            Product p = services.getProductById(category, Integer.parseInt(id));
            request.setAttribute("productEdit", p);
            request.setAttribute("categoryEdit", category);
        }

        // 4. LẤY DANH SÁCH HIỂN THỊ
        List<Product> list = List.of(); // Danh sách rỗng mặc định

        // Logic cũ của anh: getProductsByTable(viewTable, null)
        // Anh lưu ý: Nếu viewTable null (khi mới vào admin), anh có muốn load bảng nào mặc định không?
        // Ví dụ: Load bảng 'home_sanpham' mặc định
        if (viewTable == null) {
            viewTable = "home_sanpham";
        }

        if (!"all".equals(viewTable)) {
            list = services.getProductsByTable(viewTable, null);
        }

        // Gửi dữ liệu sang JSP
        request.setAttribute("productList", list);
        request.setAttribute("currentViewTable", viewTable);
        request.setAttribute("totalProducts", services.getTotalProducts());
        request.setAttribute("totalRevenue", services.getTotalRevenue());

        // Chuyển hướng đến file JSP Admin
        request.getRequestDispatcher("view/page_admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // --- KIỂM TRA QUYỀN (POST) ---
        HttpSession session = request.getSession();
        Object sessionObj = session.getAttribute("user"); // Sửa thành "user"

        boolean isAdmin = false;
        if (sessionObj != null && sessionObj instanceof User) {
            User u = (User) sessionObj;
            if (u.getRole() == 1) isAdmin = true;
        }

        if (!isAdmin) {
            response.sendRedirect("Home");
            return;
        }
        // ------------------------------

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("update".equals(action)) {
            // ... (Code update giữ nguyên) ...
            int id = Integer.parseInt(request.getParameter("id"));
            String category = request.getParameter("category");
            String tenSp = request.getParameter("ten_sp");
            double gia = Double.parseDouble(request.getParameter("gia"));
            int giamGia = Integer.parseInt(request.getParameter("giam_gia"));
            String oldImage = request.getParameter("old_image");

            Part filePart = request.getPart("hinh_anh");
            String fileName = filePart.getSubmittedFileName();

            if (fileName == null || fileName.isEmpty()) {
                fileName = oldImage;
            } else {
                String uploadPath = getServletContext().getRealPath("") + File.separator + "image_all";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir(); // Tạo thư mục nếu chưa có

                filePart.write(uploadPath + File.separator + fileName);
            }
            services.updateProduct(category, id, tenSp, fileName, gia, giamGia);

        } else {
            String category = request.getParameter("category");
            String tenSp = request.getParameter("ten_sp");
            String gia = request.getParameter("gia");
            String giamGia = request.getParameter("giam_gia");

            Part filePart = request.getPart("hinh_anh");
            String fileName = filePart.getSubmittedFileName();

            String uploadPath = getServletContext().getRealPath("") + File.separator + "image_all";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();

            filePart.write(uploadPath + File.separator + fileName);

            services.addProduct(category, tenSp, fileName, gia, giamGia);
        }

        response.sendRedirect("Admin");
    }
}