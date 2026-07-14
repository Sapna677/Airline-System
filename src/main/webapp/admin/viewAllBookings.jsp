<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="mypack.DatabaseUtil"%>
<%
    // Prevent browser back-button caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // Validate active Admin session
    String loggedInEmail = (String) session.getAttribute("email");
    if (loggedInEmail == null || !"admin@gmail.com".equals(loggedInEmail)) {
        response.sendRedirect("../login.jsp?msg=LoginRequired");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="ISO-8859-1">
    <title>View All Bookings</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background: #f5f5f5;
        }
        h1 {
            text-align: center;
            color: #333;
        }
        table {
            width: 90%;
            margin: 20px auto;
            border-collapse: collapse;
            background: white;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 12px;
            text-align: center;
        }
        th {
            background-color: #4CAF50;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        a {
            text-decoration: none;
            color: #4CAF50;
        }
        a:hover {
            text-decoration: underline;
        }
        .action-links a {
            margin: 0 5px;
        }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
        }
    </style>
<script src="../js/theme.js"></script>
</head>
<body>
    <h1>View All Bookings</h1>

    <%
    Connection con = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        con = DatabaseUtil.getCon();
        stmt = con.createStatement();
        rs = stmt.executeQuery("SELECT booking_id, user_id, flight_id, booking_date FROM bookings");
    %>
    <div class="table-container"><table>
        <thead>
            <tr>
                <th>Booking ID</th>
                <th>User ID</th>
                <th>Flight ID</th>
                <th>Booking Date</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <%
            while (rs.next()) {
                int bookingId = rs.getInt("booking_id");
                int userId = rs.getInt("user_id");
                int flightId = rs.getInt("flight_id");
                Date bookingDate = rs.getDate("booking_date");
                String formattedDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(bookingDate);
            %>
            <tr>
                <td><%= bookingId %></td>
                <td><%= userId %></td>
                <td><%= flightId %></td>
                <td><%= formattedDate %></td>
                <td class="action-links">
                    <a href="editBooking.jsp?id=<%= bookingId %>">Edit</a> |
                    <a href="deleteBooking.jsp?id=<%= bookingId %>" onclick="return confirm('Are you sure you want to delete this booking?')">Delete</a>
                </td>
            </tr>
            <%
            }
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<p>Error retrieving bookings. Please try again.</p>");
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        %>
        </tbody>
    </table></div>
    <a href="addBooking.jsp" class="back-link">Add New Booking</a>
    <a href="adminDashboard.jsp" class="back-link">Back to Admin Dashboard</a>
</body>
</html>
