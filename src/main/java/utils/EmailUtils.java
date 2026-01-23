package utils;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

public class EmailUtils {
    // 1. Điền Email Gmail của bạn (người gửi)
    private static final String SENDER_EMAIL = "nguyenvanthanh1sao@gmail.com";

    // 2. Điền Mật khẩu ứng dụng (KHÔNG PHẢI mật khẩu đăng nhập Gmail)
    // Cách lấy: Vào Google Account > Bảo mật > Xác minh 2 bước > Mật khẩu ứng dụng
    private static final String APP_PASSWORD = "lyhwyzlmogffpsbu";

    public static void sendEmail(String toEmail, String subject, String body) throws MessagingException {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2"); // Fix lỗi bảo mật mới của Google

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, APP_PASSWORD);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(SENDER_EMAIL));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject(subject);
        message.setContent(body, "text/html; charset=UTF-8"); // Gửi định dạng HTML

        Transport.send(message);
    }
}