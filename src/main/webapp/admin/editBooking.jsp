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
    <title>Edit Booking</title>
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
        form {
            width: 60%;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
        }
        input[type="text"], input[type="number"], input[type="date"] {
            width: calc(100% - 22px);
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #45a049;
        }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <h1>Edit Booking</h1>

    <%
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String bookingId = request.getParameter("id");
    String userId = "";
    String flightId = "";
    String bookingDate = "";

    // Fetch booking details
    if (bookingId != null) {
        try {
            con = DatabaseUtil.getCon();
            String sql = "SELECT user_id, flight_id, booking_date FROM bookings WHERE booking_id = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(bookingId));
            rs = pstmt.executeQuery();

            if (rs.next()) {
                userId = rs.getString("user_id");
                flightId = rs.getString("flight_id");
                bookingDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(rs.getDate("booking_date"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<p>Error retrieving booking details. Please try again.</p>");
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    // Update booking details
    if (request.getMethod().equalsIgnoreCase("POST")) {
        userId = request.getParameter("userId");
        flightId = request.getParameter("flightId");
        bookingDate = request.getParameter("bookingDate");

        try {
            con = DatabaseUtil.getCon();
            String updateSql = "UPDATE bookings SET user_id = ?, flight_id = ?, booking_date = ? WHERE booking_id = ?";
            pstmt = con.prepareStatement(updateSql);
            pstmt.setInt(1, Integer.parseInt(userId));
            pstmt.setInt(2, Integer.parseInt(flightId));
            pstmt.setDate(3, java.sql.Date.valueOf(bookingDate));
            pstmt.setInt(4, Integer.parseInt(bookingId));
            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                out.println("<p>Booking updated successfully!</p>");
            } else {
                out.println("<p>Error updating booking. Please try again.</p>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<p>Error updating booking. Please try again.</p>");
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
    %>

    <form action="editBooking.jsp?id=<%= bookingId %>" method="post">
        <label for="userId">User ID:</label>
        <input type="number" name="userId" value="<%= userId %>" required>

        <label for="flightId">Flight ID:</label>
        <input type="number" name="flightId" value="<%= flightId %>" required>

        <label for="bookingDate">Booking Date:</label>
        <input type="date" name="bookingDate" value="<%= bookingDate %>" required>

        <input type="submit" value="Update Booking">
    </form>

    <a href="viewAllBookings.jsp" class="back-link">Back to View All Bookings</a>
</body>
</html>
