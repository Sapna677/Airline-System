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
<title>Manage Users</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
<style type="text/css">
.btn-add-user {
	display: inline-block;
	background: linear-gradient(135deg, #6366f1, #4f46e5);
	color: white;
	padding: 12px 28px;
	border-radius: 8px;
	font-weight: 600;
	text-decoration: none;
	box-shadow: 0 4px 15px rgba(99, 102, 241, 0.35);
	border: 1px solid rgba(255, 255, 255, 0.15);
	transition: all 0.3s cubic-bezier(0.165, 0.84, 0.44, 1);
	font-size: 0.95rem;
	letter-spacing: 0.5px;
}

.btn-add-user:hover {
	transform: translateY(-2px);
	box-shadow: 0 6px 20px rgba(99, 102, 241, 0.5);
	background: linear-gradient(135deg, #4f46e5, #4338ca);
	border-color: rgba(255, 255, 255, 0.3);
	color: white;
}

.btn-add-user:active {
	transform: translateY(0);
	box-shadow: 0 4px 10px rgba(99, 102, 241, 0.3);
}

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
	background-color: #4aa1d8;
	color: white;
}

footer {
	text-align: center;
	padding: 10px;
	background: #4aa1d8;
	color: white;
	margin: 95px 0px 0px 0px;
}
</style>
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
	<h1>Manage Users</h1>
	<main>
		<%
		Connection con = null;
		Statement stmt = null;
		ResultSet rs = null;

		try {
			con = DatabaseUtil.getCon();
			stmt = con.createStatement();

			rs = stmt.executeQuery("SELECT user_id, username, email, phone, address, dob, userType FROM users");
		%>
		<div class="table-container"><table>
			<thead>
				<tr>
					<th>User ID</th>
					<th>Username</th>
					<th>Email</th>
					<th>Phone</th>
					<th>Address</th>
					<th>D.O.B</th>
					<th>User Type</th>
					<th>Actions</th>
				</tr>
			</thead>
			<tbody>
				<%
				while (rs.next()) {
					int userId = rs.getInt("user_id");
					String username = rs.getString("username");
					String email = rs.getString("email");
					String phone = rs.getString("phone");
					String address = rs.getString("address");
					Date dob = rs.getDate("dob"); // Use Date type for DOB
					String userType = rs.getString("userType"); // Rename status to userType
				%>
				<tr>
					<td><%=userId%></td>
					<td><%=username%></td>
					<td><%=email%></td>
					<td><%=phone%></td>
					<td><%=address%></td>
					<td><%=dob%></td>
					<td><%=userType%></td>
					<td><a href="editUser.jsp?id=<%=userId%>">Edit</a> | <a
						href="deleteUser.jsp?id=<%=userId%>"
						onclick="return confirm('Are you sure you want to delete this user?')">Delete</a>
					</td>
				</tr>
				<%
				}
				rs.close();
				} catch (SQLException e) {
				e.printStackTrace(); // Log exception details
				} finally {
				if (rs != null) {
				try {
					rs.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
				}
				if (stmt != null) {
				try {
					stmt.close();
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
			</tbody>
		</table></div>
		<p style="text-align: center; margin-top: 30px; margin-bottom: 30px;">
			<a href="..\signUp.jsp" class="btn-add-user">
				<i class="fas fa-user-plus" style="margin-right: 6px;"></i> Add New User
			</a>
		</p>
	</main>
	<%@ include file="footer.jsp" %>
</body>
</html>
