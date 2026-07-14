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
<title>Edit User</title>
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

form {
	width: 60%;
	margin: 20px auto;
	background: white;
	padding: 20px;
	border-radius: 8px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

h1 {
	text-align: center;
	color: white;
}

label {
	display: block;
	margin: 10px 0 5px;
}

input[type="text"], input[type="email"], input[type="tel"], input[type="date"],
	select {
	width: 100%;
	padding: 8px;
	margin-bottom: 10px;
	border: 1px solid #ddd;
	border-radius: 4px;
}

button {
	background-color: #4aa1d8;
	color: white;
	border: none;
	padding: 10px 20px;
	border-radius: 4px;
	cursor: pointer;
}

button:hover {
	background-color: #005dff;
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
	<h1>Edit User</h1>
	<main>
		<%
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String userId = request.getParameter("id");
		String username = "";
		String email = "";
		String phone = "";
		String address = "";
		Date dob = null;
		String userType = "";

		try {
			con = DatabaseUtil.getCon();
			pstmt = con.prepareStatement("SELECT username, email, phone, address, dob, userType FROM users WHERE user_id = ?");
			pstmt.setInt(1, Integer.parseInt(userId));
			rs = pstmt.executeQuery();

			if (rs.next()) {
				username = rs.getString("username");
				email = rs.getString("email");
				phone = rs.getString("phone");
				address = rs.getString("address");
				dob = rs.getDate("dob");
				userType = rs.getString("userType");
			}
		%>
		<form action="updateUser.jsp" method="post">
			<input type="hidden" name="user_id" value="<%=userId%>"> <label
				for="username">Username:</label> <input type="text" id="username"
				name="username" value="<%=username%>" required> <label
				for="email">Email:</label> <input type="email" id="email"
				name="email" value="<%=email%>" required> <label for="phone">Phone:</label>
			<input type="tel" id="phone" name="phone" value="<%=phone%>" required>

			<label for="address">Address:</label> <input type="text" id="address"
				name="address" value="<%=address%>" required> <label
				for="dob">Date of Birth:</label> <input type="date" id="dob"
				name="dob"
				value="<%=dob != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(dob) : ""%>"
				required> <label for="userType">User Type:</label> <select
				id="userType" name="userType" required>
				<option value="Admin"
					<%="Admin".equals(userType) ? "selected" : ""%>>Admin</option>
				<option value="User"
					<%="User".equals(userType) ? "selected" : ""%>>User</option>
			</select>

			<button type="submit">Update User</button>
		</form>
		<%
		rs.close();
		pstmt.close();
		con.close();
		} catch (SQLException e) {
		e.printStackTrace();
		} finally {
		if (rs != null) {
			try {
				rs.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
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
	<%@ include file="footer.jsp" %>
</body>
</html>
