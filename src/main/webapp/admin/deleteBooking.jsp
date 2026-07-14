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
    <title>Delete Booking</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background: #f5f5f5;
            text-align: center;
        }
        h1 {
            color: #333;
        }
        p {
            font-size: 18px;
            color: #555;
        }
        a {
            text-decoration: none;
            color: #4CAF50;
            font-size: 18px;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <%
    Connection con = null;
    PreparedStatement pstmt = null;
    String bookingId = request.getParameter("id");

    if (bookingId != null) {
        try {
            con = DatabaseUtil.getCon();
            String sql = "DELETE FROM bookings WHERE booking_id = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(bookingId));
            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                out.println("<h1>Booking Deleted Successfully</h1>");
                out.println("<p>The booking with ID " + bookingId + " has been deleted.</p>");
            } else {
                out.println("<h1>Error</h1>");
                out.println("<p>There was a problem deleting the booking. Please try again.</p>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<h1>Error</h1>");
            out.println("<p>There was a problem deleting the booking. Please try again.</p>");
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    } else {
        out.println("<h1>Error</h1>");
        out.println("<p>No booking ID provided.</p>");
    }
    %>

    <a href="viewAllBookings.jsp">Back to View All Bookings</a>
</body>
</html>
