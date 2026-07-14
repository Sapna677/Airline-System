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
    <title>View All Flights</title>
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
    <h1>View All Flights</h1>

    <%
    Connection con = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        con = DatabaseUtil.getCon();
        stmt = con.createStatement();
        rs = stmt.executeQuery("SELECT flight_id, flight_number, departure, arrival, date FROM flights");
    %>
    <div class="table-container"><table>
        <thead>
            <tr>
                <th>Flight ID</th>
                <th>Flight Number</th>
                <th>Departure</th>
                <th>Arrival</th>
                <th>Date</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <%
            while (rs.next()) {
                int flightId = rs.getInt("flight_id");
                String flightNumber = rs.getString("flight_number");
                String departure = rs.getString("departure");
                String arrival = rs.getString("arrival");
                Timestamp date = rs.getTimestamp("date");
                String formattedDate = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date);
            %>
            <tr>
                <td><%= flightId %></td>
                <td><%= flightNumber %></td>
                <td><%= departure %></td>
                <td><%= arrival %></td>
                <td><%= formattedDate %></td>
                <td class="action-links">
                    <a href="editFlight.jsp?id=<%= flightId %>">Edit</a> |
                    <a href="deleteFlight.jsp?id=<%= flightId %>" onclick="return confirm('Are you sure you want to delete this flight?')">Delete</a>
                </td>
            </tr>
            <%
            }
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<p>Error retrieving flights. Please try again.</p>");
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        %>
        </tbody>
    </table></div>
    <a href="addFlight.jsp" class="back-link">Add New Flight</a>
    <a href="adminDashboard.jsp" class="back-link">Back to Admin Dashboard</a>
</body>
</html>
