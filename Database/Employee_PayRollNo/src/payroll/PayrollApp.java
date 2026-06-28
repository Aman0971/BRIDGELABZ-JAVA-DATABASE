package payroll;

import payroll.model.Employee;
import payroll.model.User;
import payroll.util.DBUtil;
import payroll.util.HashUtil;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Scanner;

public class PayrollApp {

    private static User currentUser = null;

    private static final Scanner scanner = new Scanner(System.in);

    private static final List<String> AVAILABLE_PROFILES =
            Arrays.asList(
                    "ellipse-1.png",
                    "ellipse-2.png",
                    "ellipse-3.png",
                    "ellipse-4.png"
            );
    public static void main(String[] args) {

        System.out.println(" EMPLOYEE PAYROLL JDBC APPLICATION");
        System.out.println("======================================");

        while (true) {
            if (currentUser == null) {
                showAnonymousMenu();
            }
            else {
                if (currentUser.getRole().equalsIgnoreCase("ADMIN")) {
                    showAdminMenu();
                }
                else {
                    showUserMenu();
                }
            }
        }
    }
    private static void showAnonymousMenu() {

        System.out.println("\n========= MENU =========");

        System.out.println("1. Login");
        System.out.println("2. Register");
        System.out.println("3. Exit");
        System.out.print("Choose Option : ");

        String choice = scanner.nextLine();

        switch (choice) {

            case "1":
                login();
                break;

            case "2":
                register();
                break;

            case "3":
                System.out.println("Thank You.");
                System.exit(0);
                break;

            default:
                System.out.println("Invalid Choice.");

        }

    }
    private static void showAdminMenu() {

        System.out.println("\n=========== ADMIN PANEL ===========");

        System.out.println("Welcome : " + currentUser.getUsername());
        System.out.println();
        System.out.println("1. Add Employee");

        System.out.println("2. View All Employees");

        System.out.println("3. Edit Employee");

        System.out.println("4. Delete Employee");

        System.out.println("5. Department Payroll");

        System.out.println("6. View Audit Logs");

        System.out.println("7. Logout");

        System.out.print("Choose Option : ");

        String choice = scanner.nextLine();
        switch (choice) {

            case "1":
                addEmployee();
                break;

            case "2":
                viewAllEmployees();
                break;

            case "3":
                editEmployee();
                break;

            case "4":
                deleteEmployee();
                break;

            case "5":

                getDeptPayroll();
                break;

            case "6":
                viewAuditLogs();
                break;

            case "7":
                logout();
                break;

            default:
                System.out.println("Invalid Choice.");
        }
    }
    private static void showUserMenu() {

        System.out.println("\n=========== USER PANEL ===========");

        System.out.println("Welcome : " + currentUser.getUsername());

        System.out.println();

        System.out.println("1. View My Details");

        System.out.println("2. Logout");

        System.out.print("Choose Option : ");

        String choice = scanner.nextLine();
        switch (choice) {

            case "1":
                viewMyDetails();
                break;

            case "2":
                logout();
                break;

            default:
                System.out.println("Invalid Choice.");
        }
    }
    private static void register() {

        System.out.print("Username : ");
        String username = scanner.nextLine();

        System.out.print("Password : ");
        String password = scanner.nextLine();

        System.out.print("Email : ");
        String email = scanner.nextLine();

        System.out.print("Role (ADMIN/USER) : ");
        String role = scanner.nextLine().toUpperCase();

        if (!role.equals("ADMIN") && !role.equals("USER")) {

            System.out.println("Invalid Role.");
            return;
        }
        String hash = HashUtil.hashPassword(password);

        String sql = "INSERT INTO users(username,password,email,role) VALUES(?,?,?,?)";

        try (
                Connection conn = DBUtil.getConnection();

                PreparedStatement ps =
                        conn.prepareStatement(sql)
        ) {

            ps.setString(1, username);
            ps.setString(2, hash);
            ps.setString(3, email);
            ps.setString(4, role);
            ps.executeUpdate();
            System.out.println("Registration Successful.");
        }
        catch (SQLException e) {
            System.out.println("Registration Failed.");
            e.printStackTrace();
        }
    }
    private static void login() {

        System.out.print("Username : ");
        String username = scanner.nextLine();

        System.out.print("Password : ");
        String password = scanner.nextLine();

        String hash = HashUtil.hashPassword(password);
        String sql = "SELECT * FROM users WHERE username=?";
        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement ps =
                        conn.prepareStatement(sql)

        )
        {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                if (hash.equals(rs.getString("password"))) {
                    currentUser = new User(

                            rs.getInt("id"),
                            rs.getString("username"),
                            rs.getString("password"),
                            rs.getString("email"),
                            rs.getString("role")
                    );
                    System.out.println("Login Successful.");
                }
                else {
                    System.out.println("Wrong Password.");
                }
            }
            else {
                System.out.println("User Not Found.");
            }
        }
        catch (SQLException e) {
            e.printStackTrace();
        }
    }
    private static void addEmployee() {

        System.out.println("\n========== ADD EMPLOYEE ==========");

        System.out.print("Employee Name : ");
        String name = scanner.nextLine();

        System.out.println("\nAvailable Profiles");

        for (int i = 0; i < AVAILABLE_PROFILES.size(); i++) {

            System.out.println((i + 1) + ". " + AVAILABLE_PROFILES.get(i));
        }

        System.out.print("Choose Profile (1-4): ");

        int profileChoice = getIntInput();

        if (profileChoice < 1 || profileChoice > AVAILABLE_PROFILES.size()) {

            System.out.println("Invalid Profile.");

            return;
        }

        String profileImage = AVAILABLE_PROFILES.get(profileChoice - 1);

        System.out.print("Gender (Male/Female): ");
        String gender = scanner.nextLine();

        System.out.print("Departments (comma separated): ");
        String[] departments = scanner.nextLine().split(",");

        System.out.print("Salary: ");
        BigDecimal salary = getDecimalInput();

        System.out.print("Start Date (yyyy-mm-dd): ");
        LocalDate startDate = LocalDate.parse(scanner.nextLine());

        System.out.print("Notes: ");
        String notes = scanner.nextLine();

        String employeeSql =
                "INSERT INTO employees(name, profile_image, gender, salary, start_date, notes, created_by) VALUES(?,?,?,?,?,?,?)";

        String departmentSql =
                "INSERT INTO employee_departments(employee_id, department) VALUES(?,?)";

        try (Connection conn = DBUtil.getConnection()) {

            conn.setAutoCommit(false);

            try (PreparedStatement empStmt =
                         conn.prepareStatement(employeeSql, Statement.RETURN_GENERATED_KEYS);

                 PreparedStatement deptStmt =
                         conn.prepareStatement(departmentSql)) {

                empStmt.setString(1, name);
                empStmt.setString(2, profileImage);
                empStmt.setString(3, gender);
                empStmt.setBigDecimal(4, salary);
                empStmt.setDate(5, Date.valueOf(startDate));
                empStmt.setString(6, notes);
                empStmt.setInt(7, currentUser.getId());

                empStmt.executeUpdate();

                ResultSet rs = empStmt.getGeneratedKeys();

                int employeeId = 0;

                if (rs.next()) {
                    employeeId = rs.getInt(1);
                }

                for (String dept : departments) {

                    deptStmt.setInt(1, employeeId);

                    deptStmt.setString(2, dept.trim());

                    deptStmt.addBatch();
                }
                deptStmt.executeBatch();

                conn.commit();

                System.out.println("\nEmployee Added Successfully.");

            } catch (SQLException e) {
                conn.rollback();

                System.out.println("Transaction Rolled Back.");

                throw e;
            }

        } catch (Exception e) {

            e.printStackTrace();

        }
    }
    private static void viewAllEmployees() {

        System.out.println("\n========== ALL EMPLOYEES ==========\n");

        String sql =
                """
                SELECT
                    e.id,
                    e.name,
                    e.profile_image,
                    e.gender,
                    STRING_AGG(ed.department, ', ') AS departments,
                    e.salary,
                    e.start_date,
                    e.notes
                FROM employees e
                LEFT JOIN employee_departments ed
                    ON e.id = ed.employee_id
                GROUP BY
                    e.id,
                    e.name,
                    e.profile_image,
                    e.gender,
                    e.salary,
                    e.start_date,
                    e.notes
                ORDER BY e.id
                """;

        try (
                Connection conn = DBUtil.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)
        ) {
            while (rs.next()) {

                System.out.println("----------------------------------------");
                System.out.println("ID           : " + rs.getInt("id"));
                System.out.println("Name         : " + rs.getString("name"));
                System.out.println("Profile      : " + rs.getString("profile_image"));
                System.out.println("Gender       : " + rs.getString("gender"));
                System.out.println("Departments  : " + rs.getString("departments"));
                System.out.println("Salary       : " + rs.getBigDecimal("salary"));
                System.out.println("Start Date   : " + rs.getDate("start_date"));
                System.out.println("Notes        : " + rs.getString("notes"));
            }
        }
        catch (SQLException e) {
            e.printStackTrace();

        }
    }
    private static void editEmployee() {

        System.out.println("\n========== EDIT EMPLOYEE ==========");

        System.out.print("Enter Employee ID : ");
        int id = getIntInput();

        String checkSql = "SELECT * FROM employees WHERE id = ?";

        String updateSql =
                """
                UPDATE employees
                SET
                    name = ?,
                    profile_image = ?,
                    gender = ?,
                    salary = ?,
                    start_date = ?,
                    notes = ?
                WHERE id = ?
                """;

        try (
                Connection conn = DBUtil.getConnection();

                PreparedStatement checkStmt =
                        conn.prepareStatement(checkSql);

                PreparedStatement updateStmt =
                        conn.prepareStatement(updateSql)
        ) {

            checkStmt.setInt(1, id);

            ResultSet rs = checkStmt.executeQuery();

            if (!rs.next()) {

                System.out.println("Employee Not Found.");

                return;
            }

            System.out.print("New Name : ");
            String name = scanner.nextLine();

            System.out.print("New Profile Image : ");
            String profileImage = scanner.nextLine();

            System.out.print("New Gender : ");
            String gender = scanner.nextLine();

            System.out.print("New Salary : ");
            BigDecimal salary = getDecimalInput();

            System.out.print("New Start Date (yyyy-mm-dd) : ");
            LocalDate startDate = LocalDate.parse(scanner.nextLine());

            System.out.print("New Notes : ");
            String notes = scanner.nextLine();

            updateStmt.setString(1, name);
            updateStmt.setString(2, profileImage);
            updateStmt.setString(3, gender);
            updateStmt.setBigDecimal(4, salary);
            updateStmt.setDate(5, Date.valueOf(startDate));
            updateStmt.setString(6, notes);
            updateStmt.setInt(7, id);

            int rows = updateStmt.executeUpdate();

            if (rows > 0) {
                System.out.println("Employee Updated Successfully.");

            } else {

                System.out.println("Update Failed.");

            }

        }

        catch (SQLException e) {

            e.printStackTrace();

        }

    }
    private static void deleteEmployee() {

        System.out.println("\n========== DELETE EMPLOYEE ==========");
        System.out.print("Enter Employee ID : ");

        int id = getIntInput();

        String sql = "DELETE FROM employees WHERE id = ?";

        try (
                Connection conn = DBUtil.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)

        ) {

            ps.setInt(1, id);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                System.out.println("Employee Deleted Successfully.");
            }
            else {
                System.out.println("Employee Not Found.");

            }
        }
        catch (SQLException e) {
            e.printStackTrace();
        }
    }
    private static void getDeptPayroll() {

        System.out.println("\n========== DEPARTMENT PAYROLL ==========");
        System.out.print("Enter Department Name : ");

        String department = scanner.nextLine();

        String sql = "{ ? = call get_total_payroll_by_dept(?) }";

        try (
                Connection conn = DBUtil.getConnection();

                CallableStatement cs = conn.prepareCall(sql)
        ) {

            cs.registerOutParameter(1, Types.NUMERIC);
            cs.setString(2, department);
            cs.execute();
            BigDecimal totalSalary = cs.getBigDecimal(1);

            System.out.println("--------------------------------");

            System.out.println("Department : " + department);

            System.out.println("Total Payroll : " + totalSalary);

        }
        catch (SQLException e) {
            e.printStackTrace();
        }

    }
    private static void viewAuditLogs() {

        System.out.println("\n========== AUDIT LOGS ==========\n");

        String sql =
                """
                SELECT *
                FROM payroll_audit
                ORDER BY changed_at DESC
                """;

        try (
                Connection conn = DBUtil.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)
        ) {

            while (rs.next()) {

                System.out.println("-----------------------------------------");

                System.out.println("Log ID       : " + rs.getInt("id"));
                System.out.println("Employee ID  : " + rs.getInt("employee_id"));
                System.out.println("Action       : " + rs.getString("action_type"));
                System.out.println("Old Salary   : " + rs.getBigDecimal("old_salary"));
                System.out.println("New Salary   : " + rs.getBigDecimal("new_salary"));
                System.out.println("Changed By   : " + rs.getString("changed_by"));
                System.out.println("Changed At   : " + rs.getTimestamp("changed_at"));
            }
        }
        catch (SQLException e) {
            e.printStackTrace();

        }

    }
    private static void viewMyDetails() {

        System.out.println("\n========== MY DETAILS ==========\n");

        String sql =
                """
                SELECT
                    e.id,
                    e.name,
                    e.gender,
                    STRING_AGG(d.department, ', ') AS departments,
                    e.salary,
                    e.start_date,
                    e.notes
                FROM employees e
    
                LEFT JOIN employee_departments d
                ON e.id = d.employee_id
    
                INNER JOIN users u
                ON e.created_by = u.id
    
                WHERE u.email = ?
    
                GROUP BY
                    e.id,
                    e.name,
                    e.gender,
                    e.salary,
                    e.start_date,
                    e.notes
                ORDER BY e.id
                """;

        try (
                Connection conn = DBUtil.getConnection();

                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, currentUser.getEmail());

            ResultSet rs = ps.executeQuery();

            boolean found = false;

            while (rs.next()) {

                found = true;

                System.out.println("----------------------------------------");

                System.out.println("ID   : " + rs.getInt("id"));

                System.out.println("Name  : " + rs.getString("name"));
                System.out.println("Gender  : " + rs.getString("gender"));
                System.out.println("Departments : " + rs.getString("departments"));
                System.out.println("Salary  : " + rs.getBigDecimal("salary"));
                System.out.println("Start Date  : " + rs.getDate("start_date"));
                System.out.println("Notes  : " + rs.getString("notes"));
            }
            if (!found) {
                System.out.println("No Employee Details Found.");
            }
        }
        catch (SQLException e) {
            e.printStackTrace();

        }

    }
    private static void logout() {
        currentUser = null;
        System.out.println("Logout Successful.");
    }
    private static int getIntInput() {
        while (true) {
            try {
                return Integer.parseInt(scanner.nextLine());

            } catch (NumberFormatException e) {

                System.out.print("Invalid input. Enter a valid integer: ");
            }
        }
    }
    private static BigDecimal getDecimalInput() {
        while (true) {
            try {
                return new BigDecimal(scanner.nextLine());
            }
            catch (NumberFormatException e) {
                System.out.print("Invalid input. Enter a valid decimal number: ");
            }
        }
    }
}
