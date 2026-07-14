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
<html lang="en">
<head>
<meta charset="ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Dashboard - Airlines</title>
<!-- Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<!-- Font Awesome Icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style type="text/css">
:root {
	--primary: #6366f1;
	--primary-hover: #4f46e5;
	--success: #10b981;
	--warning: #f59e0b;
	--danger: #ef4444;
	--info: #06b6d4;
	--bg-dark: rgba(15, 23, 42, 0.85);
	--card-bg: rgba(30, 41, 59, 0.7);
	--card-border: rgba(255, 255, 255, 0.08);
	--text-main: #f8fafc;
	--text-muted: #94a3b8;
}

* {
	box-sizing: border-box;
	margin: 0;
	padding: 0;
}

body {
	font-family: 'Outfit', sans-serif;
	color: var(--text-main);
	background-image: url('plane.jpg');
	background-size: cover;
	background-repeat: no-repeat;
	background-attachment: fixed;
	background-position: center;
	min-height: 100vh;
	overflow-x: hidden;
}

/* Glassmorphism Overlay */
.overlay {
	background: linear-gradient(135deg, rgba(15, 23, 42, 0.8), rgba(88, 28, 135, 0.4));
	min-height: 100vh;
	width: 100%;
	padding-bottom: 50px;
	overflow-x: hidden;
}

/* Nav Bar Styling */
nav {
	background: rgba(15, 23, 42, 0.6);
	backdrop-filter: blur(12px);
	-webkit-backdrop-filter: blur(12px);
	border-bottom: 1px solid var(--card-border);
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 10px 40px;
	position: sticky;
	top: 0;
	z-index: 100;
}

nav .logo img {
	height: 45px;
	filter: drop-shadow(0 0 8px rgba(99, 102, 241, 0.5));
}

nav ul {
	list-style: none;
	display: flex;
	align-items: center;
	gap: 15px;
}

nav ul li a {
	color: var(--text-main);
	text-decoration: none;
	padding: 10px 20px;
	font-weight: 500;
	font-size: 0.95rem;
	border-radius: 8px;
	transition: all 0.3s ease;
	display: flex;
	align-items: center;
	gap: 8px;
}

nav ul li a:hover {
	background: rgba(255, 255, 255, 0.1);
	color: var(--primary);
	box-shadow: 0 0 15px rgba(99, 102, 241, 0.2);
}

nav ul li a.active {
	background: var(--primary);
	box-shadow: 0 0 15px rgba(99, 102, 241, 0.4);
}

/* Responsive Media Queries */
@media (max-width: 768px) {
	nav {
		flex-direction: column;
		gap: 15px;
		padding: 15px 20px;
		text-align: center;
	}
	nav ul {
		flex-wrap: wrap;
		justify-content: center;
		width: 100%;
		gap: 8px;
	}
	nav ul li a {
		padding: 8px 12px;
		font-size: 0.85rem;
	}
	.hero h1 {
		font-size: 2rem;
	}
	.hero p {
		font-size: 0.95rem;
	}
}

/* Hero Section */
.hero {
	text-align: center;
	padding: 40px 20px 20px;
}

.hero h1 {
	font-size: 2.5rem;
	font-weight: 700;
	background: linear-gradient(to right, #ffffff, #a5b4fc);
	-webkit-background-clip: text;
	-webkit-text-fill-color: transparent;
	margin-bottom: 10px;
}

.hero p {
	font-size: 1.1rem;
	color: var(--text-muted);
}

/* Main Content Container */
.container {
	max-width: 1300px;
	margin: 0 auto;
	padding: 0 20px;
}

/* Stats Cards Grid */
.stats-grid {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
	gap: 20px;
	margin-top: 30px;
}

.stat-card {
	background: var(--card-bg);
	border: 1px solid var(--card-border);
	backdrop-filter: blur(12px);
	-webkit-backdrop-filter: blur(12px);
	border-radius: 16px;
	padding: 24px;
	display: flex;
	align-items: center;
	justify-content: space-between;
	transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.stat-card:hover {
	transform: translateY(-5px);
	box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3), 0 0 15px rgba(99, 102, 241, 0.1);
	border-color: rgba(99, 102, 241, 0.3);
}

.stat-info h3 {
	font-size: 0.9rem;
	color: var(--text-muted);
	text-transform: uppercase;
	letter-spacing: 1px;
	margin-bottom: 8px;
}

.stat-info p {
	font-size: 2rem;
	font-weight: 700;
	color: var(--text-main);
}

.stat-icon {
	width: 55px;
	height: 55px;
	border-radius: 12px;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 1.5rem;
}

.icon-flights { background: rgba(99, 102, 241, 0.15); color: var(--primary); }
.icon-bookings { background: rgba(16, 185, 129, 0.15); color: var(--success); }
.icon-users { background: rgba(6, 182, 212, 0.15); color: var(--info); }
.icon-revenue { background: rgba(245, 158, 11, 0.15); color: var(--warning); }

/* Charts Section */
.charts-grid {
	display: grid;
	grid-template-columns: 2fr 1.2fr;
	gap: 25px;
	margin-top: 30px;
}

@media (max-width: 992px) {
	.charts-grid {
		grid-template-columns: 1fr;
	}
}

.chart-card {
	background: var(--card-bg);
	border: 1px solid var(--card-border);
	backdrop-filter: blur(12px);
	-webkit-backdrop-filter: blur(12px);
	border-radius: 16px;
	padding: 24px;
}

.chart-card h2 {
	font-size: 1.2rem;
	font-weight: 600;
	margin-bottom: 20px;
	display: flex;
	align-items: center;
	gap: 10px;
}

.chart-card h2 i {
	color: var(--primary);
}

.chart-container {
	position: relative;
	width: 100%;
	height: 320px;
}

</style>
<script src="../js/theme.js"></script>
</head>
<body>
	<div class="overlay">
		<!-- Navigation -->
		<nav>
			<div class="logo">
				<img alt="Airline Logo" src="../download.png">
			</div>
			<ul>
				<li><a href="adminDashboard.jsp" class="active"><i class="fa-solid fa-house"></i> Home</a></li>
				<li><a href="manageFlights.jsp"><i class="fa-solid fa-plane"></i> Manage Flights</a></li>
				<li><a href="manageBookings.jsp"><i class="fa-solid fa-ticket"></i> Manage Bookings</a></li>
				<li><a href="manageUsers.jsp"><i class="fa-solid fa-users"></i> Manage Users</a></li>
				<li><a href="../logout.jsp"><i class="fa-solid fa-right-from-bracket"></i> Logout</a></li>
			</ul>
		</nav>

		<!-- Welcome / Hero -->
		<section class="hero">
			<h1>Airlines Admin Portal</h1>
			<p>Real-time operations, analytics and system overview dashboard.</p>
		</section>

		<!-- Database and Query Section -->
		<%
		int totalFlights = 0;
		int totalBookings = 0;
		int totalUsers = 0;
		double totalRevenue = 0.0;
		String adminName = "Admin"; 

		Connection con = null;
		Statement stmt = null;
		ResultSet rs = null;

		String monthsDataJson = "[]";
		String bookingsCountJson = "[]";
		String destinationsJson = "[]";
		String revenueJson = "[]";

		try {
			con = DatabaseUtil.getCon();
			stmt = con.createStatement();

			// 1. Total Flights Count
			rs = stmt.executeQuery("SELECT COUNT(*) FROM flights");
			if (rs.next()) {
				totalFlights = rs.getInt(1);
			}
			rs.close();

			// 2. Total Bookings Count
			rs = stmt.executeQuery("SELECT COUNT(*) FROM bookings");
			if (rs.next()) {
				totalBookings = rs.getInt(1);
			}
			rs.close();

			// 3. Total Users Count
			rs = stmt.executeQuery("SELECT COUNT(*) FROM users");
			if (rs.next()) {
				totalUsers = rs.getInt(1);
			}
			rs.close();

			// 4. Total Revenue Calculation (Sum price of bookings joined with flights)
			rs = stmt.executeQuery("SELECT SUM(CAST(f.price AS DECIMAL(10,2))) FROM bookings b JOIN flights f ON b.flight_id = f.flight_id");
			if (rs.next()) {
				totalRevenue = rs.getDouble(1);
			}
			rs.close();

			// 5. Fetch Monthly Bookings for Line Chart
			StringBuilder monthsData = new StringBuilder("[");
			StringBuilder bookingsCountData = new StringBuilder("[");
			rs = stmt.executeQuery("SELECT TO_CHAR(booking_date, 'Mon YYYY') AS month, COUNT(*) AS count FROM bookings GROUP BY TO_CHAR(booking_date, 'YYYY-MM'), TO_CHAR(booking_date, 'Mon YYYY') ORDER BY TO_CHAR(booking_date, 'YYYY-MM')");
			boolean first = true;
			while (rs.next()) {
				if (!first) {
					monthsData.append(",");
					bookingsCountData.append(",");
				}
				monthsData.append("\"").append(rs.getString("month")).append("\"");
				bookingsCountData.append(rs.getInt("count"));
				first = false;
			}
			monthsData.append("]");
			bookingsCountData.append("]");
			monthsDataJson = monthsData.toString();
			bookingsCountJson = bookingsCountData.toString();
			rs.close();

			// 6. Fetch Revenue by Destination for Doughnut Chart
			StringBuilder destinationsData = new StringBuilder("[");
			StringBuilder revenueData = new StringBuilder("[");
			rs = stmt.executeQuery("SELECT f.arrival AS dest, SUM(CAST(f.price AS DECIMAL(10,2))) AS rev FROM bookings b JOIN flights f ON b.flight_id = f.flight_id GROUP BY f.arrival");
			first = true;
			while (rs.next()) {
				if (!first) {
					destinationsData.append(",");
					revenueData.append(",");
				}
				destinationsData.append("\"").append(rs.getString("dest")).append("\"");
				revenueData.append(rs.getDouble("rev"));
				first = false;
			}
			destinationsData.append("]");
			revenueData.append("]");
			destinationsJson = destinationsData.toString();
			revenueJson = revenueData.toString();
			rs.close();

		} catch (Exception e) {
			e.printStackTrace(); 
		} finally {
			if (rs != null) { try { rs.close(); } catch (SQLException e) { e.printStackTrace(); } }
			if (stmt != null) { try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); } }
			if (con != null) { try { con.close(); } catch (SQLException e) { e.printStackTrace(); } }
		}
		%>

		<!-- Main content -->
		<div class="container">
			<!-- Statistics Cards -->
			<div class="stats-grid">
				<!-- Flights Card -->
				<div class="stat-card">
					<div class="stat-info">
						<h3>Total Flights</h3>
						<p><%=totalFlights%></p>
					</div>
					<div class="stat-icon icon-flights">
						<i class="fa-solid fa-plane-departure"></i>
					</div>
				</div>

				<!-- Bookings Card -->
				<div class="stat-card">
					<div class="stat-info">
						<h3>Total Bookings</h3>
						<p><%=totalBookings%></p>
					</div>
					<div class="stat-icon icon-bookings">
						<i class="fa-solid fa-ticket"></i>
					</div>
				</div>

				<!-- Users Card -->
				<div class="stat-card">
					<div class="stat-info">
						<h3>Total Users</h3>
						<p><%=totalUsers%></p>
					</div>
					<div class="stat-icon icon-users">
						<i class="fa-solid fa-user-group"></i>
					</div>
				</div>

				<!-- Revenue Card -->
				<div class="stat-card">
					<div class="stat-info">
						<h3>Total Revenue</h3>
						<p>&#8377; <%=String.format("%,.2f", totalRevenue)%></p>
					</div>
					<div class="stat-icon icon-revenue">
						<i class="fa-solid fa-indian-rupee-sign"></i>
					</div>
				</div>
			</div>

			<!-- Charts -->
			<div class="charts-grid">
				<!-- Line Chart Card -->
				<div class="chart-card">
					<h2><i class="fa-solid fa-chart-line"></i> Monthly Booking Volume</h2>
					<div class="chart-container">
						<canvas id="bookingsTrendChart"></canvas>
					</div>
				</div>

				<!-- Doughnut Chart Card -->
				<div class="chart-card">
					<h2><i class="fa-solid fa-chart-pie"></i> Revenue by Route</h2>
					<div class="chart-container">
						<canvas id="revenueDestChart"></canvas>
					</div>
				</div>
			</div>
		</div>
	</div>

	<%@ include file="footer.jsp"%>

	<!-- Chart.js Script Logic -->
	<script>
		// Data from JSP Expression
		const months = <%=monthsDataJson%>;
		const bookingCounts = <%=bookingsCountJson%>;
		
		const destinations = <%=destinationsJson%>;
		const revenues = <%=revenueJson%>;

		// 1. Line Chart: Booking Trend
		const bookingsCtx = document.getElementById('bookingsTrendChart').getContext('2d');
		
		// Gradient fill for line
		const indigoGradient = bookingsCtx.createLinearGradient(0, 0, 0, 300);
		indigoGradient.addColorStop(0, 'rgba(99, 102, 241, 0.4)');
		indigoGradient.addColorStop(1, 'rgba(99, 102, 241, 0.0)');

		new Chart(bookingsCtx, {
			type: 'line',
			data: {
				labels: months.length > 0 ? months : ['No Data'],
				datasets: [{
					label: 'Bookings Count',
					data: bookingCounts.length > 0 ? bookingCounts : [0],
					borderColor: '#6366f1',
					borderWidth: 3,
					backgroundColor: indigoGradient,
					fill: true,
					tension: 0.4,
					pointBackgroundColor: '#6366f1',
					pointRadius: 4,
					pointHoverRadius: 6
				}]
			},
			options: {
				responsive: true,
				maintainAspectRatio: false,
				plugins: {
					legend: {
						display: false
					},
					tooltip: {
						backgroundColor: '#1e293b',
						titleColor: '#f8fafc',
						bodyColor: '#f8fafc',
						borderColor: '#334155',
						borderWidth: 1
					}
				},
				scales: {
					x: {
						grid: {
							color: 'rgba(255, 255, 255, 0.05)'
						},
						ticks: {
							color: '#94a3b8'
						}
					},
					y: {
						grid: {
							color: 'rgba(255, 255, 255, 0.05)'
						},
						ticks: {
							color: '#94a3b8',
							stepSize: 1,
							precision: 0
						}
					}
				}
			}
		});

		// 2. Doughnut Chart: Revenue distribution
		const revenueCtx = document.getElementById('revenueDestChart').getContext('2d');
		
		new Chart(revenueCtx, {
			type: 'doughnut',
			data: {
				labels: destinations.length > 0 ? destinations : ['No Bookings'],
				datasets: [{
					data: revenues.length > 0 ? revenues : [0],
					backgroundColor: [
						'#6366f1', // Indigo
						'#10b981', // Emerald
						'#06b6d4', // Cyan
						'#f59e0b', // Amber
						'#ec4899', // Pink
						'#a855f7'  // Purple
					],
					borderWidth: 1,
					borderColor: '#1e293b'
				}]
			},
			options: {
				responsive: true,
				maintainAspectRatio: false,
				plugins: {
					legend: {
						position: 'bottom',
						labels: {
							color: '#f8fafc',
							boxWidth: 12,
							font: {
								family: 'Outfit'
							}
						}
					},
					tooltip: {
						callbacks: {
							label: function(context) {
								let label = context.label || '';
								if (label) {
									label += ': ';
								}
								if (context.parsed !== null) {
									label += '₹ ' + context.parsed.toLocaleString();
								}
								return label;
							}
						},
						backgroundColor: '#1e293b',
						titleColor: '#f8fafc',
						bodyColor: '#f8fafc'
					}
				},
				cutout: '70%'
			}
		});
	</script>
</body>
</html>
