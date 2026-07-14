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
<title>Add Flight</title>
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

form {
	width: 300px;
	margin: 0 auto;
	padding: 20px;
	background: white;
	border-radius: 8px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

label {
	display: block;
	margin-bottom: 8px;
	color: #555;
}

input[type="text"], input[type="number"], input[type="datetime-local"],
	input[type="submit"] {
	width: 100%;
	padding: 8px;
	margin-bottom: 10px;
	border: 1px solid #ddd;
	border-radius: 4px;
}

input[type="submit"] {
	background-color: #4CAF50;
	color: white;
	border: none;
	cursor: pointer;
}

input[type="submit"]:hover {
	background-color: #45a049;
}

p.message {
	text-align: center;
	color: #333;
}
</style>
<script src="../js/theme.js"></script>
</head>
<body>
	<h1>Add New Flight</h1>
	<form action="addFlight.jsp" method="post">
		<label for="flightNumber">Flight Number:</label> <input type="number"
			name="flightNumber" required><br> <label for="departure">Departure:</label>
		<input type="text" name="departure" required><br> <label
			for="arrival">Arrival:</label> <input type="text" name="arrival"
			required><br> <label for="date">Flight Date and
			Time:</label> <input type="datetime-local" name="date" required><br>
		<label for="price">Ticket Price:</label> <input
			type="text" name="price" required><br> <input
			type="submit" value="Add Flight"> <a href="manageFlights.jsp"
			style="text-decoration: none;"> <input type="button" value="Back"
			style="cursor: pointer;">
		</a>
	</form>

	<%
	if (request.getMethod().equalsIgnoreCase("POST")) {
		int flightNumber = Integer.parseInt(request.getParameter("flightNumber"));
		String departure = request.getParameter("departure");
		String arrival = request.getParameter("arrival");
		String dateStr = request.getParameter("date");
		String price = request.getParameter("price");

		// Convert the date string to a SQL timestamp
		Timestamp date = Timestamp.valueOf(dateStr.replace("T", " ") + ":00");

		Connection con = null;
		PreparedStatement pstmt = null;

		try {
			con = DatabaseUtil.getCon();
			pstmt = con
			.prepareStatement("INSERT INTO flights (flight_number, departure, arrival, date,price) VALUES (?, ?, ?, ?,?)");
			pstmt.setInt(1, flightNumber);
			pstmt.setString(2, departure);
			pstmt.setString(3, arrival);
			pstmt.setTimestamp(4, date);
			pstmt.setString(5, price);
			pstmt.executeUpdate();
			out.println("<p class='message'>Flight added successfully!</p>");
		} catch (SQLException e) {
			e.printStackTrace();
			out.println("<p class='message'>Error adding flight. Please try again.</p>");
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
	}
	%>
</body>
</html>
