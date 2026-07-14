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
<title>Manage Flights</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
<style type="text/css">
.btn-add-flight {
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

.btn-add-flight:hover {
	transform: translateY(-2px);
	box-shadow: 0 6px 20px rgba(99, 102, 241, 0.5);
	background: linear-gradient(135deg, #4f46e5, #4338ca);
	border-color: rgba(255, 255, 255, 0.3);
	color: white;
}

.btn-add-flight:active {
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

h1, h2 {
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
	<h1>Manage Flights</h1>
	<main>
		<%
		Connection con = null;
		Statement stmt = null;
		ResultSet rs = null;

		try {
			con = DatabaseUtil.getCon();
			stmt = con.createStatement();

			rs = stmt.executeQuery("SELECT flight_id, flight_number, departure, arrival, date,price FROM flights");
		%>
		<div class="table-container"><table>
			<thead>
				<tr>
					<th>Flight ID</th>
					<th>Flight Number</th>
					<th>Departure</th>
					<th>Arrival</th>
					<th>Date</th>
					<th>Price</th>
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
					Date date = rs.getDate("date");
					String price = rs.getString("price");
				%>
				<tr>
					<td><%=flightId%></td>
					<td><%=flightNumber%></td>
					<td><%=departure%></td>
					<td><%=arrival%></td>
					<td><%=date%></td>
					<td><%=price%></td>
					<td><a href="editFlight.jsp?id=<%=flightId%>">Edit</a> | <a
						href="deleteFlight.jsp?id=<%=flightId%>"
						onclick="return confirm('Are you sure you want to delete this flight?')">Delete</a>
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
			<a href="addFlight.jsp" class="btn-add-flight">
				<i class="fas fa-plus" style="margin-right: 6px;"></i> Add New Flight
			</a>
		</p>
	</main>
	<%@ include file="footer.jsp"%>
</body>
</html>
