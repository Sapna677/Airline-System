<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="mypack.DatabaseUtil"%>
<!DOCTYPE html>
<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta charset="ISO-8859-1">
<title>Flight Results</title>
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
			<a href="searchFlights.jsp"><i class="fas fa-arrow-left"></i> Back</a>
		</button>
	</div>

	<div class="page-container">
		<main class="standalone-container" style="max-width: 1100px; margin-top: 40px; margin-bottom: 40px;">
			<h2>Flight Results</h2>
			<%
			String departure = request.getParameter("departure");
			String arrival = request.getParameter("arrival");
			String price = request.getParameter("price");
			String tripType = request.getParameter("tripType");
			boolean isRoundTrip = "round".equals(tripType);
			String sessionEmail = (String) session.getAttribute("email");
			
			java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("dd MMM yyyy");
			java.text.SimpleDateFormat timeFormat = new java.text.SimpleDateFormat("hh:mm a");
	
			if (departure != null && !departure.isEmpty() && arrival != null && !arrival.isEmpty()) {
				try (Connection con = DatabaseUtil.getCon()) {
					// 1. Fetch Outbound Flights
					String outboundQuery = "SELECT flight_id, flight_number, departure, arrival, date, price FROM flights WHERE departure = ? AND arrival = ?";
					if (price != null && !price.isEmpty()) {
						outboundQuery += " AND price = ?";
					}
					
					java.util.List<java.util.Map<String, Object>> outboundFlights = new java.util.ArrayList<>();
					try (PreparedStatement pstmt = con.prepareStatement(outboundQuery)) {
						pstmt.setString(1, departure);
						pstmt.setString(2, arrival);
						if (price != null && !price.isEmpty()) {
							pstmt.setString(3, price);
						}
						try (ResultSet rs = pstmt.executeQuery()) {
							while (rs.next()) {
								java.util.Map<String, Object> flight = new java.util.HashMap<>();
								flight.put("flight_id", rs.getInt("flight_id"));
								flight.put("flight_number", rs.getString("flight_number"));
								flight.put("departure", rs.getString("departure"));
								flight.put("arrival", rs.getString("arrival"));
								flight.put("date", rs.getTimestamp("date"));
								flight.put("price", rs.getString("price"));
								outboundFlights.add(flight);
							}
						}
					}

					// 2. Fetch Return Flights (if Round Trip)
					java.util.List<java.util.Map<String, Object>> returnFlights = new java.util.ArrayList<>();
					if (isRoundTrip) {
						String returnQuery = "SELECT flight_id, flight_number, departure, arrival, date, price FROM flights WHERE departure = ? AND arrival = ?";
						try (PreparedStatement pstmtReturn = con.prepareStatement(returnQuery)) {
							pstmtReturn.setString(1, arrival);
							pstmtReturn.setString(2, departure);
							try (ResultSet rsReturn = pstmtReturn.executeQuery()) {
								while (rsReturn.next()) {
									java.util.Map<String, Object> flight = new java.util.HashMap<>();
									flight.put("flight_id", rsReturn.getInt("flight_id"));
									flight.put("flight_number", rsReturn.getString("flight_number"));
									flight.put("departure", rsReturn.getString("departure"));
									flight.put("arrival", rsReturn.getString("arrival"));
									flight.put("date", rsReturn.getTimestamp("date"));
									flight.put("price", rsReturn.getString("price"));
									returnFlights.add(flight);
								}
							}
						}
					}
			%>

			<% if (isRoundTrip) { %>
				<!-- ROUND TRIP BOOKING FORM -->
				<form action="<%= sessionEmail != null ? "passengerDetails.jsp" : "login.jsp" %>" method="get" onsubmit="return validateRoundTrip()">
					<% if (sessionEmail == null) { %>
						<input type="hidden" name="msg" value="LoginRequired">
					<% } %>
					<input type="hidden" name="tripType" value="round">

					<!-- Outbound Table -->
					<h3 style="color: white; margin-top: 30px; display: flex; align-items: center; gap: 10px;">
						<i class="fas fa-plane-departure" style="color: #6366f1;"></i> 1. Select Outbound Flight: <%= departure %> &rarr; <%= arrival %>
					</h3>
					<div class="results-summary" style="margin-bottom: 15px; background: rgba(99, 102, 241, 0.1); border: 1px solid rgba(99, 102, 241, 0.25); padding: 10px 15px; border-radius: 8px;">
						<span style="color: white; font-weight: 600;"><%= outboundFlights.size() %> Outbound Flights Found</span>
					</div>
					<table class="premium-table">
						<thead>
							<tr>
								<th>Select</th>
								<th>Flight Number</th>
								<th>Departure</th>
								<th>Arrival</th>
								<th>Date</th>
								<th>Time</th>
								<th>Available Seats</th>
								<th>Price</th>
							</tr>
						</thead>
						<tbody>
							<%
							for (java.util.Map<String, Object> flight : outboundFlights) {
								int flightId = (Integer) flight.get("flight_id");
								String flightNumber = (String) flight.get("flight_number");
								Timestamp timestamp = (Timestamp) flight.get("date");
								String price1 = (String) flight.get("price");
								String formattedDate = timestamp != null ? dateFormat.format(timestamp) : "N/A";
								String formattedTime = timestamp != null ? timeFormat.format(timestamp) : "N/A";
								
								int availableSeats = 60;
								String countQuery = "SELECT COUNT(*) FROM bookings WHERE flight_id = ? AND seat_number IS NOT NULL";
								try (PreparedStatement countPstmt = con.prepareStatement(countQuery)) {
									countPstmt.setInt(1, flightId);
									try (ResultSet countRs = countPstmt.executeQuery()) {
										if (countRs.next()) {
											availableSeats = 60 - countRs.getInt(1);
										}
									}
								}
							%>
							<tr>
								<td>
									<% if (availableSeats > 0) { %>
										<input type="radio" name="flightId" value="<%= flightId %>" required style="width: 18px; height: 18px; cursor: pointer; accent-color: #6366f1;">
									<% } else { %>
										<span style="color: #ef4444; font-weight: 600;">Sold Out</span>
									<% } %>
								</td>
								<td><%= flightNumber %></td>
								<td><%= departure %></td>
								<td><%= arrival %></td>
								<td><%= formattedDate %></td>
								<td><%= formattedTime %></td>
								<td>
									<% if (availableSeats > 10) { %>
										<span style="color: #10b981; font-weight: 600;"><%= availableSeats %> / 60</span>
									<% } else if (availableSeats > 0) { %>
										<span style="color: #f59e0b; font-weight: 600;"><%= availableSeats %> / 60</span>
									<% } else { %>
										<span style="color: #ef4444; font-weight: 600;">Sold Out</span>
									<% } %>
								</td>
								<td><%= price1 %></td>
							</tr>
							<% } %>
							<% if (outboundFlights.isEmpty()) { %>
							<tr>
								<td colspan="8" style="text-align: center;">No outbound flights found.</td>
							</tr>
							<% } %>
						</tbody>
					</table>

					<!-- Return Table -->
					<h3 style="color: white; margin-top: 40px; display: flex; align-items: center; gap: 10px;">
						<i class="fas fa-plane-arrival" style="color: #10b981;"></i> 2. Select Return Flight: <%= arrival %> &rarr; <%= departure %>
					</h3>
					<div class="results-summary" style="margin-bottom: 15px; background: rgba(16, 185, 129, 0.1); border: 1px solid rgba(16, 185, 129, 0.25); padding: 10px 15px; border-radius: 8px;">
						<span style="color: white; font-weight: 600;"><%= returnFlights.size() %> Return Flights Found</span>
					</div>
					<table class="premium-table">
						<thead>
							<tr>
								<th>Select</th>
								<th>Flight Number</th>
								<th>Departure</th>
								<th>Arrival</th>
								<th>Date</th>
								<th>Time</th>
								<th>Available Seats</th>
								<th>Price</th>
							</tr>
						</thead>
						<tbody>
							<%
							for (java.util.Map<String, Object> flight : returnFlights) {
								int flightId = (Integer) flight.get("flight_id");
								String flightNumber = (String) flight.get("flight_number");
								Timestamp timestamp = (Timestamp) flight.get("date");
								String price1 = (String) flight.get("price");
								String formattedDate = timestamp != null ? dateFormat.format(timestamp) : "N/A";
								String formattedTime = timestamp != null ? timeFormat.format(timestamp) : "N/A";
								
								int availableSeats = 60;
								String countQuery = "SELECT COUNT(*) FROM bookings WHERE flight_id = ? AND seat_number IS NOT NULL";
								try (PreparedStatement countPstmt = con.prepareStatement(countQuery)) {
									countPstmt.setInt(1, flightId);
									try (ResultSet countRs = countPstmt.executeQuery()) {
										if (countRs.next()) {
											availableSeats = 60 - countRs.getInt(1);
										}
									}
								}
							%>
							<tr>
								<td>
									<% if (availableSeats > 0) { %>
										<input type="radio" name="returnFlightId" value="<%= flightId %>" required style="width: 18px; height: 18px; cursor: pointer; accent-color: #6366f1;">
									<% } else { %>
										<span style="color: #ef4444; font-weight: 600;">Sold Out</span>
									<% } %>
								</td>
								<td><%= flightNumber %></td>
								<td><%= arrival %></td>
								<td><%= departure %></td>
								<td><%= formattedDate %></td>
								<td><%= formattedTime %></td>
								<td>
									<% if (availableSeats > 10) { %>
										<span style="color: #10b981; font-weight: 600;"><%= availableSeats %> / 60</span>
									<% } else if (availableSeats > 0) { %>
										<span style="color: #f59e0b; font-weight: 600;"><%= availableSeats %> / 60</span>
									<% } else { %>
										<span style="color: #ef4444; font-weight: 600;">Sold Out</span>
									<% } %>
								</td>
								<td><%= price1 %></td>
							</tr>
							<% } %>
							<% if (returnFlights.isEmpty()) { %>
							<tr>
								<td colspan="8" style="text-align: center;">No return flights found.</td>
							</tr>
							<% } %>
						</tbody>
					</table>

					<!-- Proceed Button -->
					<% if (!outboundFlights.isEmpty() && !returnFlights.isEmpty()) { %>
						<div style="text-align: center; margin-top: 40px;">
							<input type="submit" class="btn-book-now" value="Proceed to Passenger Details" style="font-size: 1.1rem; padding: 14px 45px; border-radius: 8px; max-width: 320px; width: 100%;">
						</div>
					<% } %>
				</form>
				
				<script>
					function validateRoundTrip() {
						const outboundSelected = document.querySelector('input[name="flightId"]:checked');
						const returnSelected = document.querySelector('input[name="returnFlightId"]:checked');
						if (!outboundSelected || !returnSelected) {
							alert("Please select one Outbound Flight and one Return Flight to proceed!");
							return false;
						}
						return true;
					}
				</script>

			<% } else { %>
				<!-- ONE WAY BOOKING (ORIGINAL FLOW) -->
				<div class="results-summary" style="margin-bottom: 25px; background: rgba(99, 102, 241, 0.1); border: 1px solid rgba(99, 102, 241, 0.25); padding: 15px 20px; border-radius: 12px; display: flex; justify-content: space-between; align-items: center;">
					<span style="font-size: 1.15rem; font-weight: 600; color: white;">
						<i class="fas fa-plane-departure" style="color: #6366f1; margin-right: 8px;"></i>
						<%= departure %> &rarr; <%= arrival %>
					</span>
					<span style="background: #6366f1; color: white; padding: 6px 14px; border-radius: 20px; font-size: 0.9rem; font-weight: 600;">
						<%= outboundFlights.size() %> Flights Found
					</span>
				</div>
				
				<table class="premium-table">
					<thead>
						<tr>
							<th>Flight ID</th>
							<th>Flight Number</th>
							<th>Departure</th>
							<th>Arrival</th>
							<th>Date</th>
							<th>Time</th>
							<th>Available Seats</th>
							<th>Price</th>
							<th>Action</th>
						</tr>
					</thead>
					<tbody>
						<%
						boolean hasResults = !outboundFlights.isEmpty();
						for (java.util.Map<String, Object> flight : outboundFlights) {
							int flightId = (Integer) flight.get("flight_id");
							String flightNumber = (String) flight.get("flight_number");
							String flightDeparture = (String) flight.get("departure");
							String flightArrival = (String) flight.get("arrival");
							Timestamp timestamp = (Timestamp) flight.get("date");
							String price1 = (String) flight.get("price");
							
							String formattedDate = timestamp != null ? dateFormat.format(timestamp) : "N/A";
							String formattedTime = timestamp != null ? timeFormat.format(timestamp) : "N/A";
							
							int availableSeats = 60;
							String countQuery = "SELECT COUNT(*) FROM bookings WHERE flight_id = ? AND seat_number IS NOT NULL";
							try (PreparedStatement countPstmt = con.prepareStatement(countQuery)) {
								countPstmt.setInt(1, flightId);
								try (ResultSet countRs = countPstmt.executeQuery()) {
									if (countRs.next()) {
										availableSeats = 60 - countRs.getInt(1);
									}
								}
							}
						%>
						<tr>
							<td><%=flightId%></td>
							<td><%=flightNumber%></td>
							<td><%=flightDeparture%></td>
							<td><%=flightArrival%></td>
							<td><%=formattedDate%></td>
							<td><%=formattedTime%></td>
							<td>
								<% if (availableSeats > 10) { %>
									<span style="color: #10b981; font-weight: 600;"><%= availableSeats %> / 60</span>
								<% } else if (availableSeats > 0) { %>
									<span style="color: #f59e0b; font-weight: 600;"><%= availableSeats %> / 60 (Filling Fast!)</span>
								<% } else { %>
									<span style="color: #ef4444; font-weight: 600;">Sold Out</span>
								<% } %>
							</td>
							<td><%=price1%></td>
							<td>
								<% if (availableSeats > 0) { %>
									<% if (sessionEmail != null) { %>
										<form action="passengerDetails.jsp" method="get">
											<input type="hidden" name="tripType" value="oneWay">
											<input type="hidden" name="flightId" value="<%=flightId%>">
											<input type="hidden" name="flightNumber" value="<%=flightNumber%>"> 
											<input type="hidden" name="departure" value="<%=flightDeparture%>"> 
											<input type="hidden" name="arrival" value="<%=flightArrival%>">
											<input type="hidden" name="date" value="<%=timestamp != null ? timestamp.toString() : ""%>">
											<input type="hidden" name="price" value="<%=price1%>">
											<input type="submit" class="btn-book-now" value="Book Now!">
										</form>
									<% } else { %>
										<form action="login.jsp" method="get">
											<input type="hidden" name="msg" value="LoginRequired">
											<input type="submit" class="btn-book-now" value="Book Now!">
										</form>
									<% } %>
								<% } else { %>
									<button class="btn-book-now" style="background: #475569; cursor: not-allowed;" disabled>Full</button>
								<% } %>
							</td>
						</tr>
						<%
						}
						if (!hasResults) {
						%>
						<tr>
							<td colspan="9" style="text-align: center;">No flights found for the specified criteria.</td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>
			<% } %>
			<%
				}
			} else {
				out.println("<p style='color:red;'>Please provide valid departure and arrival parameters.</p>");
			}
			%>
		</main>
	</div>
</body>
</html>
