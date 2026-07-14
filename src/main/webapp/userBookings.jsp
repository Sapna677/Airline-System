<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="mypack.DatabaseUtil"%>
<%
    // Prevent browser back-button caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta charset="ISO-8859-1">
<title>User Bookings</title>
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

</head>
<body>
	<!-- Background video -->
	<video class="bg-video" autoplay loop muted>
		<source src="Air4.mp4" type="video/mp4">
		Your browser does not support the video tag.
	</video>
	<div class="bg-overlay"></div>

	<div class="btn-nav-floating">
		<button>
			<a href="userDashboard.jsp"><i class="fas fa-arrow-left"></i> Back</a>
		</button>
	</div>

	<div class="page-container" style="padding-top: 40px; padding-bottom: 40px;">
		<main class="standalone-container" style="max-width: 1100px; margin: 40px auto;">
			<h1 class="signup-heading" style="text-align: center; margin-bottom: 25px;"><i class="fas fa-plane-departure"></i> My Bookings</h1>
			
			<table class="premium-table">
				<thead>
					<tr>
						<th>Booking ID</th>
						<th>Flight Number</th>
						<th>Passenger Name</th>
						<th>Booking Date</th>
						<th>Departure</th>
						<th>Arrival</th>
						<th>Seat Number</th>
						<th>Action</th>
					</tr>
				</thead>
				<tbody>
					<%
					String email = (String) session.getAttribute("email");
					if (email == null) {
						response.sendRedirect("login.jsp");
						return;
					}

					Connection conn = null;
					PreparedStatement pstmt = null;
					ResultSet rs = null;

					try {
						conn = DatabaseUtil.getCon();
						
						// Query current user's ID
						int userId = 1;
						String userQuery = "SELECT user_id FROM users WHERE email = ?";
						try (PreparedStatement uPstmt = conn.prepareStatement(userQuery)) {
							uPstmt.setString(1, email);
							try (ResultSet uRs = uPstmt.executeQuery()) {
								if (uRs.next()) {
									userId = uRs.getInt("user_id");
								}
							}
						}

						String query = "SELECT b.booking_id, b.flight_number, b.booking_date, b.departure, b.arrival, b.passenger_name, b.seat_number, u.username FROM bookings b JOIN users u ON b.user_id = u.user_id WHERE b.user_id = ?";
						pstmt = conn.prepareStatement(query);
						pstmt.setInt(1, userId);
						rs = pstmt.executeQuery();

						boolean hasBookings = false;
						while (rs.next()) {
							hasBookings = true;
							String bookingId = rs.getString("booking_id");
							String flightNumber = rs.getString("flight_number");
							String date = rs.getString("booking_date");
							String dep = rs.getString("departure");
							String ari = rs.getString("arrival");
							String passengerName = rs.getString("passenger_name");
							String seatNumber = rs.getString("seat_number");
							String username = rs.getString("username");
							
							if (passengerName == null || passengerName.trim().isEmpty()) {
								passengerName = (username != null && !username.trim().isEmpty()) ? username : "Primary Account User";
							}
							if (seatNumber == null || seatNumber.trim().isEmpty()) {
								seatNumber = "1A";
							}
					%>
					<tr>
						<td><%=bookingId%></td>
						<td><%=flightNumber%></td>
						<td style="font-weight: 600;"><%=passengerName%></td>
						<td><%=date%></td>
						<td><%=dep%></td>
						<td><%=ari%></td>
						<td><span style="background: rgba(99, 102, 241, 0.15); border: 1px solid rgba(99, 102, 241, 0.35); padding: 4px 10px; border-radius: 6px; font-weight: 600; color: #6366f1;"><%=seatNumber%></span></td>
						<td>
							<a href="downloadTicket.jsp?name=<%=java.net.URLEncoder.encode(passengerName, "UTF-8")%>&email=<%=java.net.URLEncoder.encode(email, "UTF-8")%>&flightNumber=<%=java.net.URLEncoder.encode(flightNumber, "UTF-8")%>&departure=<%=java.net.URLEncoder.encode(dep, "UTF-8")%>&arrival=<%=java.net.URLEncoder.encode(ari, "UTF-8")%>&seatNumber=<%=java.net.URLEncoder.encode(seatNumber, "UTF-8")%>&date=<%=java.net.URLEncoder.encode(date, "UTF-8")%>" 
							   style="color: #10b981; font-weight: bold; margin-right: 15px; display: inline-flex; align-items: center; gap: 6px; text-decoration: none;">
								<i class="fas fa-file-download"></i> Download Pass
							</a>
							<a href="cancelBooking.jsp?bookingId=<%=bookingId%>" 
							   style="color: #ef4444; font-weight: bold; display: inline-flex; align-items: center; gap: 6px; text-decoration: none;">
								<i class="fas fa-trash-alt"></i> Cancel
							</a>
						</td>
					</tr>
					<%
						}
						if (!hasBookings) {
					%>
					<tr>
						<td colspan="8" style="text-align: center;">No active bookings found.</td>
					</tr>
					<%
						}
					} catch (Exception e) {
						e.printStackTrace();
					%>
					<tr>
						<td colspan="8" style="text-align: center; color: var(--danger-color);">Error retrieving bookings: <%=e.getMessage()%></td>
					</tr>
					<%
					} finally {
						if (rs != null) rs.close();
						if (pstmt != null) pstmt.close();
						if (conn != null) conn.close();
					}
					%>
				</tbody>
			</table>
		</main>
	</div>
</body>
</html>
