package mypack;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.math.BigDecimal;
import java.util.Calendar;
import java.util.Date;
import java.net.URI;

public class DatabaseUtil {
    private static boolean isInitialized = false;
    private static long lastFlightCheckTime = 0;
    private static final Object flightLock = new Object();

    public static Connection getCon() {
        Connection con = null;
        try {
            Class.forName("org.postgresql.Driver");

            String dbUrl = System.getenv("JDBC_DATABASE_URL");
            String dbUser = System.getenv("DB_USER");
            String dbPassword = System.getenv("DB_PASSWORD");

            if (dbUser == null) {
                dbUser = System.getenv("DB_USERNAME");
            }

            if (dbUrl == null || dbUrl.isEmpty()) {
                dbUrl = System.getenv("DB_URL");
            }

            if (dbUrl == null || dbUrl.isEmpty()) {
                String envUrl = System.getenv("DATABASE_URL");
                if (envUrl != null && !envUrl.isEmpty() && (envUrl.startsWith("postgres://") || envUrl.startsWith("postgresql://"))) {
                    try {
                        URI uri = new URI(envUrl);
                        String userInfo = uri.getUserInfo();
                        if (userInfo != null && userInfo.contains(":")) {
                            String[] parts = userInfo.split(":", 2);
                            dbUser = parts[0];
                            dbPassword = parts.length > 1 ? parts[1] : "";
                        }
                        int port = uri.getPort() == -1 ? 5432 : uri.getPort();
                        dbUrl = "jdbc:postgresql://" + uri.getHost() + ":" + port + uri.getPath();
                        
                        // Cloud platforms like Render or Heroku require sslmode=require for connection
                        if (!dbUrl.contains("?")) {
                            dbUrl += "?sslmode=require";
                        } else {
                            dbUrl += "&sslmode=require";
                        }
                    } catch (Exception e) {
                        System.err.println("Error parsing DATABASE_URL: " + e.getMessage());
                    }
                }
            }

            if (dbUrl == null || dbUrl.isEmpty()) {
                // Fallback to local defaults
                dbUrl = "jdbc:postgresql://localhost:5432/airline";
                dbUser = "postgres";
                dbPassword = "Sqlsystem";
            }

            con = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
            
            // Check and populate dynamic flights
            initializeDatabase(con);
            
            // Periodically check and populate flights (once per hour max)
            long now = System.currentTimeMillis();
            if (now - lastFlightCheckTime > 3600000) { // 1 hour
                synchronized(flightLock) {
                    if (now - lastFlightCheckTime > 3600000) {
                        lastFlightCheckTime = now;
                        checkAndPopulateFlights(con);
                    }
                }
            }
            
        } catch (ClassNotFoundException e) {
            System.err.println("Database Driver not found: " + e.getMessage());
            throw new RuntimeException("Database Driver not found: " + e.getMessage(), e);
        } catch (SQLException e) {
            System.err.println("Failed to connect to the database: " + e.getMessage());
            throw new RuntimeException("Failed to connect to the database: " + e.getMessage(), e);
        }
        return con;
    }

    public static String hashPassword(String password) {
        try {
            java.security.MessageDigest digest = java.security.MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getBytes("UTF-8"));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }

    private static synchronized void initializeDatabase(Connection con) {
        if (isInitialized) return;
        isInitialized = true;
        
        // 0. Automatically create tables if they do not exist (critical for fresh cloud databases like Render)
        try (Statement stmt = con.createStatement()) {
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS users (" +
                               "    user_id SERIAL PRIMARY KEY," +
                               "    username VARCHAR(255) NOT NULL," +
                               "    password VARCHAR(255) NOT NULL," +
                               "    email VARCHAR(255) NOT NULL UNIQUE," +
                               "    firstName VARCHAR(255)," +
                               "    lastName VARCHAR(255)," +
                               "    phone VARCHAR(50)," +
                               "    address VARCHAR(255)," +
                               "    dob DATE," +
                               "    usertype VARCHAR(50) DEFAULT 'user'" +
                               ")");

            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS flights (" +
                               "    flight_id SERIAL PRIMARY KEY," +
                               "    flight_number VARCHAR(50) NOT NULL," +
                               "    departure VARCHAR(255) NOT NULL," +
                               "    arrival VARCHAR(255) NOT NULL," +
                               "    date TIMESTAMP NOT NULL," +
                               "    price VARCHAR(50) NOT NULL" +
                               ")");

            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS payments (" +
                               "    payment_id SERIAL PRIMARY KEY," +
                               "    name VARCHAR(255) NOT NULL," +
                               "    email VARCHAR(255) NOT NULL," +
                               "    paymentMode VARCHAR(50) NOT NULL," +
                               "    cardNumber VARCHAR(50)," +
                               "    expiry VARCHAR(10)," +
                               "    cvv VARCHAR(5)" +
                               ")");

            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS bookings (" +
                               "    booking_id SERIAL PRIMARY KEY," +
                               "    flight_id INT NOT NULL," +
                               "    flight_number VARCHAR(50) NOT NULL," +
                               "    departure VARCHAR(255) NOT NULL," +
                               "    arrival VARCHAR(255) NOT NULL," +
                               "    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                               "    user_id INT NOT NULL," +
                               "    payment_id VARCHAR(50) DEFAULT 'PENDING'," +
                               "    seat_number VARCHAR(50)," +
                               "    passenger_name VARCHAR(255)," +
                               "    passenger_age INT," +
                               "    passenger_gender VARCHAR(50)," +
                               "    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE" +
                               ")");
            System.out.println("All schema tables verified/created successfully.");
        } catch (Exception e) {
            System.err.println("Database schema creation warning: " + e.getMessage());
        }

        // 1. Schema migration: convert user_id to auto-incrementing sequence
        try (Statement stmt = con.createStatement()) {
            stmt.executeUpdate("CREATE SEQUENCE IF NOT EXISTS users_user_id_seq");
            stmt.executeUpdate("ALTER TABLE users ALTER COLUMN user_id SET DEFAULT nextval('users_user_id_seq')");
            stmt.executeUpdate("ALTER SEQUENCE users_user_id_seq OWNED BY users.user_id");
            try (ResultSet rs = stmt.executeQuery("SELECT setval('users_user_id_seq', COALESCE((SELECT MAX(user_id) FROM users), 0) + 1, false)")) {
                if (rs.next()) {}
            }
        } catch (Exception e) {
            System.err.println("Migration warning (user_id sequence): " + e.getMessage());
        }

        // Schema migration: ensure bookings table has passenger details columns
        try (Statement stmt = con.createStatement()) {
            stmt.executeUpdate("ALTER TABLE bookings ADD COLUMN IF NOT EXISTS passenger_name VARCHAR(255)");
            stmt.executeUpdate("ALTER TABLE bookings ADD COLUMN IF NOT EXISTS passenger_age INT");
            stmt.executeUpdate("ALTER TABLE bookings ADD COLUMN IF NOT EXISTS passenger_gender VARCHAR(50)");
            System.out.println("Bookings table passenger columns checked/added successfully.");
        } catch (Exception e) {
            System.err.println("Migration warning (bookings columns): " + e.getMessage());
        }

        // 2. Hash migration: update sapna12 password hash to SHA-256
        try (PreparedStatement uPstmt = con.prepareStatement(
                "UPDATE users SET password = ? WHERE email = ? AND password = ?")) {
            uPstmt.setString(1, hashPassword("12345"));
            uPstmt.setString(2, "sapnakri039@gmail.com");
            uPstmt.setString(3, "2ca0033"); // old hashCode hash
            int rows = uPstmt.executeUpdate();
            if (rows > 0) {
                System.out.println("Migrated existing user 'sapna12' password hash to SHA-256 successfully.");
            }
        } catch (Exception e) {
            System.err.println("Migration warning (user password hash): " + e.getMessage());
        }

        // 3. Dynamic flight scheduler initialization
        checkAndPopulateFlights(con);
    }

    private static void checkAndPopulateFlights(Connection con) {
        try {
            int flightCount = 0;
            try (PreparedStatement pstmt = con.prepareStatement("SELECT COUNT(*) FROM flights WHERE date >= CURRENT_DATE")) {
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        flightCount = rs.getInt(1);
                    }
                }
            }
            
            // Generate flights if there are fewer than 100 flights scheduled for today/future
            if (flightCount < 100) {
                populateFlights(con);
            }
        } catch (Exception e) {
            System.err.println("Error check/populate flights: " + e.getMessage());
        }
    }
    
    private static void populateFlights(Connection con) throws SQLException {
        // Define templates: {flight_number, departure, arrival, hour, minute, price}
        Object[][] templates = {
            {"101", "Delhi", "Mumbai", 8, 0, 4500.00},
            {"102", "Mumbai", "Delhi", 12, 0, 4800.00},
            {"103", "Bangalore", "Delhi", 15, 30, 5200.00},
            {"104", "Delhi", "Bangalore", 19, 45, 5500.00},
            {"105", "Kolkata", "Mumbai", 10, 15, 6000.00},
            
            // Patna Flights
            {"201", "Delhi", "Patna", 8, 30, 4200.00},
            {"202", "Patna", "Delhi", 11, 0, 4100.00},
            {"203", "Mumbai", "Patna", 7, 0, 5800.00},
            {"204", "Patna", "Mumbai", 10, 15, 5600.00},
            {"205", "Bangalore", "Patna", 14, 0, 6200.00},
            {"206", "Patna", "Bangalore", 17, 30, 6400.00},
            {"207", "Kolkata", "Patna", 9, 0, 3500.00},
            {"208", "Patna", "Kolkata", 11, 30, 3400.00},
            
            // Other States Flights
            {"301", "Pune", "Delhi", 6, 30, 4900.00},
            {"302", "Delhi", "Pune", 9, 45, 5000.00},
            {"303", "Chennai", "Delhi", 13, 15, 5400.00},
            {"304", "Delhi", "Chennai", 16, 45, 5600.00},
            {"305", "Hyderabad", "Delhi", 11, 0, 4600.00},
            {"306", "Delhi", "Hyderabad", 14, 15, 4800.00},
            {"307", "Jaipur", "Delhi", 8, 0, 2500.00},
            {"308", "Delhi", "Jaipur", 10, 0, 2600.00},
            {"309", "Goa", "Mumbai", 16, 0, 3800.00},
            {"310", "Mumbai", "Goa", 18, 30, 3900.00}
        };
        
        Calendar cal = Calendar.getInstance();
        String insertSQL = "INSERT INTO flights (flight_number, departure, arrival, date, price) " +
                           "SELECT ?, ?, ?, ?, ? WHERE NOT EXISTS (" +
                           "    SELECT 1 FROM flights WHERE flight_number = ? AND date = ?" +
                           ")";
                           
        try (PreparedStatement pstmt = con.prepareStatement(insertSQL)) {
            // Populate for 9 days: Today (0) through next 8 days (8)
            for (int dayOffset = 0; dayOffset <= 8; dayOffset++) {
                for (Object[] template : templates) {
                    String flightNum = (String) template[0];
                    String dep = (String) template[1];
                    String arr = (String) template[2];
                    int hour = (Integer) template[3];
                    int min = (Integer) template[4];
                    double price = (Double) template[5];
                    
                    cal.setTime(new Date());
                    cal.add(Calendar.DATE, dayOffset);
                    cal.set(Calendar.HOUR_OF_DAY, hour);
                    cal.set(Calendar.MINUTE, min);
                    cal.set(Calendar.SECOND, 0);
                    cal.set(Calendar.MILLISECOND, 0);
                    
                    java.sql.Timestamp flightTimestamp = new java.sql.Timestamp(cal.getTimeInMillis());
                    
                    pstmt.setString(1, flightNum);
                    pstmt.setString(2, dep);
                    pstmt.setString(3, arr);
                    pstmt.setTimestamp(4, flightTimestamp);
                    pstmt.setBigDecimal(5, new BigDecimal(price));
                    
                    pstmt.setString(6, flightNum);
                    pstmt.setTimestamp(7, flightTimestamp);
                    
                    pstmt.addBatch();
                }
            }
            pstmt.executeBatch();
            System.out.println("Dynamic flights populated successfully.");
        }
    }
}
