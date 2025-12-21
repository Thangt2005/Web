/* * File: js/main.js
 * Chức năng: Xử lý logic giỏ hàng và thông báo
 */

// 1. Hàm được gọi khi ấn nút "Thêm vào giỏ"
function themVaoGioHang(productId) {
    // Chuyển hướng sang trang xử lý ngầm (kèm ID sản phẩm)
    // Server xử lý xong sẽ tự đá về lại trang chủ
    window.location.href = "process_cart.jsp?id=" + productId;
}

// 2. Hàm tự chạy khi trang web tải xong (để kiểm tra thông báo từ Server)
document.addEventListener("DOMContentLoaded", function() {
    // Lấy các tham số trên thanh địa chỉ (VD: ?status=success)
    const urlParams = new URLSearchParams(window.location.search);
    const status = urlParams.get('status');

    // Nếu Server báo thành công
    if (status === 'success') {
        Swal.fire({
            title: 'Thành công!',
            text: 'Sản phẩm đã được thêm vào giỏ hàng.',
            icon: 'success',
            timer: 2000,            // Tự tắt sau 2 giây
            showConfirmButton: false
        });

        // (Tùy chọn) Xóa chữ ?status=success trên thanh địa chỉ cho đẹp
        // Giúp khi F5 lại trang không bị hiện thông báo lần nữa
        const newUrl = window.location.pathname;
        window.history.replaceState(null, null, newUrl);
    } 
    
    // Nếu Server báo lỗi
    else if (status === 'error') {
        Swal.fire({
            title: 'Lỗi!',
            text: 'Không thể thêm vào giỏ hàng. Vui lòng thử lại.',
            icon: 'error'
        });
    }
});