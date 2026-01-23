package context;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {
    private final String serverName = "localhost";
    private final String dbName = "db";
    private final String portNumber = "3306";
    private final String userID = "root";
    private final String password = "";

    public Connection getConnection() throws Exception {
        // Load driver MySQL
        Class.forName("com.mysql.cj.jdbc.Driver");

        String url = "jdbc:mysql://" + serverName + ":" + portNumber + "/" + dbName + "?useUnicode=true&characterEncoding=UTF-8";

        return DriverManager.getConnection(url, userID, password);
    }

    public static void main(String[] args) {
        try {
            System.out.println(new DBContext().getConnection());
            System.out.println("Kết nối thành công rồi anh Thắng ơi!");
        } catch (Exception e) {
            System.out.println("Kết nối thất bại: " + e.getMessage());
        }
    }
}