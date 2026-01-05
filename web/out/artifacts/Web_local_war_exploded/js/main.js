function themVaoGioHang(productId) {
    console.log("Gửi ID " + productId + " tới Servlet Cart");
    window.location.href = "Cart?id=" + productId;
}

function muaNgay(id) {
    window.location.href = "Cart?id=" + id;
}

function selectSuggest(name) {
    document.getElementById("searchInput").value = name;
    document.getElementById("suggestionBox").style.display = "none";
    document.getElementById("searchForm").submit();
}

// 2. CÁC LOGIC CHẠY KHI TRANG TẢI XONG
document.addEventListener("DOMContentLoaded", function() {
    // Xử lý thông báo SweetAlert2
    const urlParams = new URLSearchParams(window.location.search);
    const status = urlParams.get('status');

    if (status === 'success') {
        Swal.fire({ title: 'Thành công!', text: 'Sản phẩm đã được thêm.', icon: 'success', timer: 2000, showConfirmButton: false });
        window.history.replaceState(null, null, window.location.pathname);
    }

    // Xử lý gợi ý tìm kiếm
    const searchInput = document.getElementById("searchInput");
    const suggestionBox = document.getElementById("suggestionBox");

    if (searchInput) {
        searchInput.addEventListener("keyup", function() {
            let keyword = this.value.trim();
            if (keyword.length === 0) {
                suggestionBox.style.display = "none";
                return;
            }
            fetch("SearchSuggest?keyword=" + encodeURIComponent(keyword))
                .then(response => response.text())
                .then(data => {
                    if (data.trim().length > 0) {
                        suggestionBox.innerHTML = data;
                        suggestionBox.style.display = "block";
                    } else {
                        suggestionBox.style.display = "none";
                    }
                });
        });
    }
});