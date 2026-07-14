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
<title>Edit Flight</title>
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
	<h1>Edit Flight</h1>

	<%
	// Retrieve flight_id from the request parameter
	int flightId = Integer.parseInt(request.getParameter("id"));
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	String flightNumber = "";
	String departure = "";
	String arrival = "";
	String date = "";

	try {
		con = DatabaseUtil.getCon();
		pstmt = con.prepareStatement("SELECT flight_number, departure, arrival, date FROM flights WHERE flight_id = ?");
		pstmt.setInt(1, flightId);
		rs = pstmt.executeQuery();

		if (rs.next()) {
			flightNumber = rs.getString("flight_number");
			departure = rs.getString("departure");
			arrival = rs.getString("arrival");
			date = rs.getString("date").replace(" ", "T");
		}
	} catch (SQLException e) {
		e.printStackTrace();
		out.println("<p class='message'>Error retrieving flight details. Please try again.</p>");
	} finally {
		if (rs != null)
			try {
		rs.close();
			} catch (SQLException e) {
		e.printStackTrace();
			}
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

	<form action="editFlight.jsp?id=<%=flightId%>" method="post">
		<label for="flightNumber">Flight Number:</label> <input type="number"
			name="flightNumber" value="<%=flightNumber%>" required><br>

		<label for="departure">Departure:</label> <input type="text"
			name="departure" value="<%=departure%>" required><br> <label
			for="arrival">Arrival:</label> <input type="text" name="arrival"
			value="<%=arrival%>" required><br> <label for="date">Flight
			Date and Time:</label> <input type="datetime-local" name="date"
			value="<%=date%>" required><br> <input type="submit"
			value="Update Flight"> <a href="manageFlights.jsp"
			style="text-decoration: none;"> <input type="button" value="Back"
			style="cursor: pointer;">
		</a>


	</form>

	<%
	if (request.getMethod().equalsIgnoreCase("POST")) {
		String updatedFlightNumber = request.getParameter("flightNumber");
		String updatedDeparture = request.getParameter("departure");
		String updatedArrival = request.getParameter("arrival");
		String updatedDateStr = request.getParameter("date");

		// Convert the date string to a SQL timestamp
		Timestamp updatedDate = Timestamp.valueOf(updatedDateStr.replace("T", " ") + ":00");

		try {
			con = DatabaseUtil.getCon();
			pstmt = con.prepareStatement(
			"UPDATE flights SET flight_number = ?, departure = ?, arrival = ?, date = ? WHERE flight_id = ?");
			pstmt.setString(1, updatedFlightNumber);
			pstmt.setString(2, updatedDeparture);
			pstmt.setString(3, updatedArrival);
			pstmt.setTimestamp(4, updatedDate);
			pstmt.setInt(5, flightId);
			pstmt.executeUpdate();
			out.println("<p class='message'>Flight updated successfully!</p>");
		} catch (SQLException e) {
			e.printStackTrace();
			out.println("<p class='message'>Error updating flight. Please try again.</p>");
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
