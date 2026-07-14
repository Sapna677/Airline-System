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
<title>Update User</title>
<style type="text/css">
body {
	font-family: Arial, sans-serif;
	margin: 0;
	padding: 0;
	background: linear-gradient(to right, #f19a9a, #3d32ba);
	background-image: url('plane.jpg');
	background-size: cover;
	background-repeat: no-repeat;
	background-attachment: fixed;
	background-position: center;
}

nav {
	background: linear-gradient(45deg, #4aa1d8, #005dff, #c4d4db);
	overflow: hidden;
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 0px 20px;
}

nav ul {
	list-style-type: none;
	margin: 0;
	padding: 0;
	display: flex;
}

nav ul li {
	margin-left: 20px;
}

nav ul li a {
	display: block;
	color: #4c36b1;
	text-align: center;
	padding: 14px 16px;
	text-decoration: none;
}

nav ul li a:hover {
	background-color: gray;
	transition: 2s;
	border-radius: 20px;
	color: black;
}

.logo img {
	height: 50px;
	background: none;
}

h1 {
	text-align: center;
	color: white;
}

footer {
	text-align: center;
	padding: 10px;
	background: #4aa1d8;
	color: white;
}
</style>
<script src="../js/theme.js"></script>
</head>
<body>
	<nav>
		<div class="logo">
			<img alt="Airline Logo" src="../download.png">
		</div>
		<ul>
			<li><a href="adminDashboard.jsp">Home</a></li>
			<li><a href="manageFlights.jsp">Manage Flights</a></li>
			<li><a href="manageBookings.jsp">Manage Bookings</a></li>
			<li><a href="manageUsers.jsp">Manage Users</a></li>
			<li><a href="../logout.jsp">Logout</a></li>
		</ul>
	</nav>
	<h1>Update User</h1>
	<main>
		<%
		String userId = request.getParameter("user_id");
		String username = request.getParameter("username");
		String email = request.getParameter("email");
		String phone = request.getParameter("phone");
		String address = request.getParameter("address");
		String dob = request.getParameter("dob");
		String userType = request.getParameter("userType");

		Connection con = null;
		PreparedStatement pstmt = null;
		boolean updateSuccess = false;

		try {
			con = DatabaseUtil.getCon();
			String updateSQL = "UPDATE users SET username = ?, email = ?, phone = ?, address = ?, dob = ?, userType = ? WHERE user_id = ?";
			pstmt = con.prepareStatement(updateSQL);
			pstmt.setString(1, username);
			pstmt.setString(2, email);
			pstmt.setString(3, phone);
			pstmt.setString(4, address);
			pstmt.setDate(5, dob != null ? java.sql.Date.valueOf(dob) : null);
			pstmt.setString(6, userType);
			pstmt.setInt(7, Integer.parseInt(userId));

			int rowsAffected = pstmt.executeUpdate();
			updateSuccess = (rowsAffected > 0);
		%>
		<p style="text-align: center;">
			<%
			if (updateSuccess) {
			%>
			User details updated successfully. <a href="manageUsers.jsp">Back
				to Manage Users</a>
			<%
			} else {
			%>
			Error updating user details. Please try again. <a
				href="manageUsers.jsp">Back to Manage Users</a>
			<%
			}
			%>
		</p>
		<%
		} catch (SQLException e) {
		e.printStackTrace();
		} finally {
		if (pstmt != null) {
			try {
				pstmt.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		if (con != null) {
			try {
				con.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		}
		%>
	</main>
	<footer>
		<p>&copy; 2024 Airline Management System</p>
	</footer>
</body>
</html>
