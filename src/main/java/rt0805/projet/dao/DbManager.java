package rt0805.projet.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DbManager {
    private static String URL = "jdbc:mysql://localhost:3306/projet0805";
    private static String USER = "root";
    private static String PASSWORD = "";

    public static Connection getConnection() {
        try {
            return DriverManager.getConnection(URL, USER , PASSWORD);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public static int closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                return -1;
            }
        }
        return 0;
    }
}
