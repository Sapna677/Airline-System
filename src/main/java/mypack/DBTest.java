package mypack;

import java.sql.*;

public class DBTest {
    public static void main(String[] args) {
        try (Connection con = DatabaseUtil.getCon()) {
            System.out.println("Users in Database:");
            try (Statement stmt = con.createStatement(); ResultSet rs = stmt.executeQuery("SELECT user_id, email, password FROM users")) {
                while (rs.next()) {
                    System.out.println("- Email: " + rs.getString("email") + ", Password: " + rs.getString("password"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
