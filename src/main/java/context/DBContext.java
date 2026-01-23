package context;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBContext {
    public Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");

        String url = "jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8";
        return DriverManager.getConnection(url, "root", "");
    }
}