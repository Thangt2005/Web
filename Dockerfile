# 1. Dùng môi trường Tomcat 9 (Hỗ trợ tốt JSP)
FROM tomcat:9.0-jdk11-openjdk

# 2. Xóa các file mẫu mặc định của Tomcat cho sạch
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# 3. Copy TOÀN BỘ file trong folder hiện tại của anh vào server
# Dấu chấm (.) nghĩa là "tất cả file ở đây"
COPY . /usr/local/tomcat/webapps/ROOT

# 4. Mở cổng 8080
EXPOSE 8080

# 5. Chạy server
CMD ["catalina.sh", "run"]