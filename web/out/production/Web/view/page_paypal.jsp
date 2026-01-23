<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh toán PayPal</title>
    <style>
        body { background: #f4f4f4; font-family: Arial, sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .container { background: white; padding: 40px; border-radius: 10px; box-shadow: 0 0 20px rgba(0,0,0,0.1); text-align: center; width: 400px; }
        .logo { width: 150px; margin-bottom: 20px; }
        .order-info { margin-bottom: 30px; font-size: 18px; color: #333; }
        .price { font-size: 32px; font-weight: bold; color: #2c3e50; margin: 10px 0 30px 0; }
    </style>
</head>
<body>

<div class="container">
    <img src="https://upload.wikimedia.org/wikipedia/commons/b/b5/PayPal.svg" alt="PayPal Logo" class="logo">

    <div class="order-info">
        Đơn hàng #<%= request.getAttribute("orderId") %>
    </div>

    <div class="price">
        $<%= request.getAttribute("totalUSD") %>
    </div>

    <div id="paypal-button-container"></div>

    <p style="margin-top: 20px; font-size: 14px; color: #888;">
        <a href="<%=request.getContextPath()%>/Home" style="text-decoration: none; color: #555;">« Hủy và quay lại</a>
    </p>
</div>

<script src="https://www.paypal.com/sdk/js?client-id=AXq6LZlaV0FZSJImQmBQ6des9torAXmokad0iQ-G_y1anGhga38nAyFIm1psC90-lHNjvoQg0u5tkL__&currency=USD"></script>

<script>
    // Lấy giá trị tiền từ Server Java truyền sang
    var totalAmount = '<%= request.getAttribute("totalUSD") %>';
    var orderId = '<%= request.getAttribute("orderId") %>';

    // Kiểm tra xem có tiền chưa, nếu chưa có thì gán mặc định để test tránh lỗi
    if (!totalAmount || totalAmount === 'null') {
        totalAmount = '1.00';
    }

    paypal.Buttons({
        // 1. Cấu hình giao dịch
        createOrder: function(data, actions) {
            return actions.order.create({
                purchase_units: [{
                    amount: {
                        value: totalAmount // Số tiền đơn hàng
                    }
                }]
            });
        },

        // 2. Xử lý khi khách thanh toán thành công
        onApprove: function(data, actions) {
            return actions.order.capture().then(function(details) {
                console.log('Giao dịch thành công: ' + details.payer.name.given_name);

                alert("Thanh toán thành công! Đang xử lý đơn hàng...");

                // Chuyển hướng về Controller PaymentSuccess để cập nhật Database
                window.location.href = "PaymentSuccess?orderId=" + orderId;
            });
        },

        // 3. Xử lý khi có lỗi
        onError: function(err) {
            console.error(err);
            alert('Có lỗi xảy ra khi thanh toán PayPal!');
        }
    }).render('#paypal-button-container');
</script>
</body>
</html>