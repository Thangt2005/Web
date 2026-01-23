<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đặt hàng thành công</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/homeStyle.css" />
    <style>
        .success-box { max-width: 600px; margin: 100px auto; text-align: center; padding: 40px; border: 1px solid #ddd; border-radius: 10px; background: #fff; }
        .success-icon { font-size: 60px; color: #28a745; margin-bottom: 20px; }
        .btn-home { display: inline-block; margin-top: 20px; padding: 10px 25px; background: #d70018; color: #fff; text-decoration: none; border-radius: 5px; }
    </style>
</head>
<body>
<div class="success-box">
    <div class="success-icon">✔</div>
    <h2>ĐẶT HÀNG THÀNH CÔNG!</h2>
    <p>Cảm ơn bạn đã tin tưởng. Đơn hàng của bạn đang được hệ thống xử lý.</p>
    <p>Mã đơn hàng: <strong>${param.id}</strong></p>
    <a href="${pageContext.request.contextPath}/Home" class="btn-home">Quay lại trang chủ</a>
</div>
</body>
</html>