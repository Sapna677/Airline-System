<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
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
<title>Delete Flight</title>
<style>
/* Add some styling */
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

p.message {
	text-align: center;
	color: #333;
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
	<h1>Delete Flight</h1>

	<%
	String message = "";

	// Retrieve flight_id from the request parameter
	int flightId = Integer.parseInt(request.getParameter("id"));

	Connection con = null;
	PreparedStatement pstmt = null;

	try {
		con = DatabaseUtil.getCon();
		pstmt = con.prepareStatement("DELETE FROM flights WHERE flight_id = ?");
		pstmt.setInt(1, flightId);

		int rowsAffected = pstmt.executeUpdate();

		if (rowsAffected > 0) {
			message = "Flight deleted successfully!";
		} else {
			message = "Flight not found or could not be deleted.";
		}
	} catch (SQLException e) {
		e.printStackTrace();
		message = "Error deleting flight. Please try again.";
	} finally {
		if (pstmt != null)
			try {
		pstmt.close();
			} catch (SQLException e) {
		e.printStackTrace();
			}
		if (con != null)
			try {
		con.close();
			} catch (SQLException e) {
		e.printStackTrace();
			}
	}
	%>

	<p class="message"><%=message%></p>
	<a href="manageFlights.jsp" class="back-link">Back to Manage
		Flights</a>
</body>
</html>
