package services;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

public class EmailService {
    private final String FROM_EMAIL = "23130304@st.hcmuaf.edu.vn";
    private final String PASSWORD = "rvup tozg nhvx kzfr"; // Mật khẩu ứng dụng 16 ký tự

    public boolean sendVerificationEmail(String toEmail, String token) {
        // Cấu hình Server Gmail
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        // Tạo phiên làm việc
        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Kích hoạt tài khoản của bạn");

            // Tạo link. Lưu ý: Nếu project bạn có tên, ví dụ localhost:8080/BanHang/Verify
            // thì phải sửa dòng dưới đây cho đúng đường dẫn.
            String link = "http://localhost:8080/Verify?token=" + token;

            String content = "<div style='font-family: Arial, sans-serif; padding: 20px;'>"
                    + "<h2>Xin chào!</h2>"
                    + "<p>Cảm ơn bạn đã đăng ký. Vui lòng bấm vào nút bên dưới để kích hoạt tài khoản:</p>"
                    + "<a href='" + link + "' style='background-color: #4CAF50; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;'>KÍCH HOẠT TÀI KHOẢN</a>"
                    + "<p>Hoặc truy cập link: " + link + "</p>"
                    + "<p>Link này chỉ có hiệu lực một lần.</p>"
                    + "</div>";

            message.setContent(content, "text/html; charset=UTF-8");

            Transport.send(message);
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }
}