package payroll.util;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {

        private static final String URL = "jdbc:postgresql://localhost:5432/employee_payroll_db";
        private static final String USER = "postgres";
        private static final String PASSWORD = "Postgres@123";

        static {
            try {

                Class.forName("org.postgresql.Driver");

            }
            catch (ClassNotFoundException e) {

                System.out.println("PostgreSQL Driver Not Found.");

                e.printStackTrace();
            }
        }
        public static Connection getConnection() throws SQLException {
            return DriverManager.getConnection(URL, USER, PASSWORD);

        }
}
