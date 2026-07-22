<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="mypack.DatabaseUtil"%>
<!DOCTYPE html>
<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta charset="ISO-8859-1">
<title>Available Flights</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"
	integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg=="
	crossorigin="anonymous" referrerpolicy="no-referrer">
<link rel="stylesheet" href="css/style.css">
<script>
document.addEventListener('DOMContentLoaded', () => {
    // Dynamically inject FontAwesome if not already present
    if (!document.querySelector('link[href*="font-awesome"]') && !document.querySelector('link[href*="all.min.css"]')) {
        const faLink = document.createElement('link');
        faLink.rel = 'stylesheet';
        faLink.href = 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css';
        document.head.appendChild(faLink);
    }

    // 1. Theme Toggle Logic
    const savedTheme = localStorage.getItem('theme') || 'dark';
    if (savedTheme === 'light') {
        document.body.classList.add('light-theme');
    }

    // Create floating theme toggle button
    const toggleBtn = document.createElement('button');
    toggleBtn.id = 'theme-toggle-btn';
    toggleBtn.innerHTML = savedTheme === 'light' ? '<i class="fas fa-moon"></i>' : '<i class="fas fa-sun"></i>';
    toggleBtn.title = 'Switch Theme';
    
    // Style the toggle button dynamically
    toggleBtn.style.cssText = `
        position: fixed;
        bottom: 25px;
        right: 25px;
        width: 50px;
        height: 50px;
        border-radius: 50%;
        background: linear-gradient(135deg, #6366f1, #4f46e5);
        color: white;
        border: 2px solid rgba(255, 255, 255, 0.25);
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.3rem;
        box-shadow: 0 8px 30px rgba(0, 0, 0, 0.35);
        z-index: 99999;
        transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    `;

    // Hover effects
    toggleBtn.addEventListener('mouseenter', () => {
        toggleBtn.style.transform = 'scale(1.1) translateY(-3px)';
        toggleBtn.style.boxShadow = '0 12px 35px rgba(99, 102, 241, 0.45)';
    });
    toggleBtn.addEventListener('mouseleave', () => {
        toggleBtn.style.transform = 'scale(1) translateY(0)';
        toggleBtn.style.boxShadow = '0 8px 30px rgba(0, 0, 0, 0.35)';
    });

    // Toggle action
    toggleBtn.addEventListener('click', () => {
        const isLight = document.body.classList.toggle('light-theme');
        localStorage.setItem('theme', isLight ? 'light' : 'dark');
        toggleBtn.innerHTML = isLight ? '<i class="fas fa-moon"></i>' : '<i class="fas fa-sun"></i>';
        
        // Minor click scale bump animation
        toggleBtn.style.transform = 'scale(0.9)';
        setTimeout(() => {
            toggleBtn.style.transform = 'scale(1)';
        }, 100);
    });

    document.body.appendChild(toggleBtn);

    // 2. Dynamic Branding: SkyGlide Airways
    const logoDiv = document.querySelector('nav .logo');
    if (logoDiv && !logoDiv.querySelector('.logo-text')) {
        // Wrap logo in a flex container for alignment
        logoDiv.style.display = 'flex';
        logoDiv.style.alignItems = 'center';
        logoDiv.style.gap = '10px';

        const logoText = document.createElement('span');
        logoText.className = 'logo-text';
        logoText.innerHTML = 'SkyGlide <span style="font-weight: 400; font-size: 0.85rem; letter-spacing: 2px; opacity: 0.8; color: #ff9900;">AIRWAYS</span>';
        logoText.style.cssText = `
            font-weight: 800;
            font-size: 1.4rem;
            color: var(--text-primary);
            letter-spacing: 1px;
            font-family: 'Outfit', sans-serif;
            transition: var(--transition-smooth);
        `;
        logoDiv.appendChild(logoText);
    }
});
</script>

<script src="js/theme.js"></script>
</head>
<body>
	<!-- Background video -->
	<video class="bg-video" autoplay loop muted>
		<source src="Air4.mp4" type="video/mp4">
		Your browser does not support the video tag.
	</video>
	<div class="bg-overlay"></div>

	<nav>
		<div class="logo">
			<img alt="Airline Logo" src="download.png">
		</div>
		<ul>
			<li><a href="index.jsp">Home</a></li>
			<li><a href="searchFlights.jsp">Search Flights</a></li>
			<li><a href="flightStatus.jsp">Flight Status</a></li>
			<li><a href="baggageCalculator.jsp">Baggage</a></li>
			<li><a href="contact.jsp">Contact</a></li>
			<% if (session.getAttribute("email") != null) { %>
				<li><a href="profile.jsp"><i class="fas fa-user-circle"></i> Profile</a></li>
			<% } else { %>
				<li><a href="login.jsp">Login</a></li>
				<li><a href="signUp.jsp">Signup</a></li>
			<% } %>
		</ul>
	</nav>

	<div class="page-container">
		<main class="standalone-container" style="max-width: 1100px; margin-top: 40px; margin-bottom: 40px;">
	<h1>Available Flights</h1>
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
		<table class="premium-table">
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
				boolean hasResults = false;
				while (rs.next()) {
					hasResults = true;
					int flightId = rs.getInt("flight_id");
					String flightNumber = rs.getString("flight_number");
					String flightDeparture = rs.getString("departure");
					String flightArrival = rs.getString("arrival");
					String flightDate = rs.getString("date");
					String price = rs.getString("price");
				%>
				<tr>
					<td><%=flightId%></td>
					<td><%=flightNumber%></td>
					<td><%=flightDeparture%></td>
					<td><%=flightArrival%></td>
					<td><%=flightDate%></td>
					<td><%=price%></td>
					<td>
						<form action="selectSeat.jsp" method="post">
							<input type="hidden" name="flightId" value="<%=flightId%>">
							<input type="hidden" name="flightNumber" value="<%=flightNumber%>"> 
							<input type="hidden" name="departure" value="<%=flightDeparture%>"> 
							<input type="hidden" name="arrival" value="<%=flightArrival%>">
							<input type="hidden" name="date" value="<%=flightDate%>">
							<input type="hidden" name="price" value="<%=price%>">
							<input type="submit" class="btn-book-now" value="Book Now!">
						</form>
					</td>
				</tr>
				<%
				}
				if (!hasResults) {
				%>
				<tr>
					<td colspan="6" style="text-align: center;">No flights found
						for the specified criteria.</td>
				</tr>
				<%
				}
				%>
				<%
				rs.close();
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
		</table>
	</main>
	<%@ include file="admin/footer.jsp"%>
</body>
</html>
