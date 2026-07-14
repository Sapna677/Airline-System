<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="mypack.DatabaseUtil"%>
<!DOCTYPE html>
<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta charset="ISO-8859-1">
<title>Cancel Booking</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"
	integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg=="
	crossorigin="anonymous" referrerpolicy="no-referrer">
<style>
body {
	font-family: Arial, sans-serif;
	background-color: #f4f4f4;
	padding: 20px;
}

.message {
	font-size: 20px;
	margin: 20px 0;
}

.success {
	color: green;
}

.error {
	color: red;
}
</style>
<script src="js/theme.js"></script>
</head>
<body>
	<h1>Cancel Booking</h1>
	<%
	String bookingId = request.getParameter("bookingId");
	Connection conn = null;
	PreparedStatement pstmt = null;

	if (bookingId != null && !bookingId.isEmpty()) {
		try {
			conn = DatabaseUtil.getCon();
			String query = "DELETE FROM bookings WHERE booking_id = ?";
			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, Integer.parseInt(bookingId));

			int rowsAffected = pstmt.executeUpdate();

			if (rowsAffected > 0) {
	%>
	<p class="message success">
		Booking with ID
		<%=bookingId%>
		has been successfully canceled.
	</p>
	<a href="userBookings.jsp">Back to My Bookings</a>
	<%
	} else {
	%>
	<p class="message error">
		Error: Booking ID
		<%=bookingId%>
		not found or could not be canceled.
	</p>
	<a href="userBookings.jsp">Back to My Bookings</a>
	<%
	}
	} catch (Exception e) {
	e.printStackTrace();
	%>
	<p class="message error">An error occurred while canceling the
		booking. Please try again later.</p>
	<a href="userBookings.jsp">Back to My Bookings</a>
	<%
	} finally {
	if (pstmt != null)
		try {
			pstmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	if (conn != null)
		try {
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	} else {
	%>
	<p class="message error">Invalid booking ID. Please try again.</p>
	<a href="userBookings.jsp">Back to My Bookings</a>
	<%
	}
	%>
</body>
</html>
