<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="mypack.DatabaseUtil"%>
<%
    // Prevent browser back-button caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    String loggedInUserEmail = (String) session.getAttribute("email");
    if (loggedInUserEmail == null) {
        response.sendRedirect("login.jsp?msg=LoginRequired");
        return;
    }

    String flightId = request.getParameter("flightId");
    String returnFlightId = request.getParameter("returnFlightId");
    String tripType = request.getParameter("tripType");
    boolean isRound = "round".equals(tripType);

    String flightNumber = "";
    String departure = "";
    String arrival = "";
    String dateStr = "";
    String price = "";

    String returnFlightNumber = "";
    String returnDeparture = "";
    String returnArrival = "";
    String returnDateStr = "";
    String returnPrice = "";

    if (flightId != null) {
        try (Connection con = DatabaseUtil.getCon()) {
            String sql = "SELECT flight_number, departure, arrival, date, price FROM flights WHERE flight_id = ?";
            try (PreparedStatement pstmt = con.prepareStatement(sql)) {
                pstmt.setInt(1, Integer.parseInt(flightId));
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        flightNumber = rs.getString("flight_number");
                        departure = rs.getString("departure");
                        arrival = rs.getString("arrival");
                        Timestamp timestamp = rs.getTimestamp("date");
                        dateStr = timestamp != null ? timestamp.toString() : "";
                        price = rs.getString("price");
                    }
                }
            }
            
            if (isRound && returnFlightId != null) {
                try (PreparedStatement pstmt = con.prepareStatement(sql)) {
                    pstmt.setInt(1, Integer.parseInt(returnFlightId));
                    try (ResultSet rs = pstmt.executeQuery()) {
                        if (rs.next()) {
                            returnFlightNumber = rs.getString("flight_number");
                            returnDeparture = rs.getString("departure");
                            returnArrival = rs.getString("arrival");
                            Timestamp timestamp = rs.getTimestamp("date");
                            returnDateStr = timestamp != null ? timestamp.toString() : "";
                            returnPrice = rs.getString("price");
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta charset="ISO-8859-1">
	<title>Passenger Details - SkyGlide Airways</title>
	<link rel="stylesheet"
		href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"
		integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg=="
		crossorigin="anonymous" referrerpolicy="no-referrer">
	<link rel="stylesheet" href="css/style.css">
	<style>
		.passenger-input-group {
			border: 1px solid rgba(255, 255, 255, 0.08);
			background: rgba(255, 255, 255, 0.02);
			border-radius: 12px;
			padding: 20px;
			margin-bottom: 20px;
		}
		
		.passenger-title {
			font-size: 1.1rem;
			font-weight: 700;
			color: #6366f1;
			margin-bottom: 15px;
			display: flex;
			align-items: center;
			gap: 8px;
		}

		.form-row {
			display: grid;
			grid-template-columns: 2fr 1fr 1fr;
			gap: 15px;
		}

		@media (max-width: 600px) {
			.form-row {
				grid-template-columns: 1fr;
				gap: 10px;
			}
		}

		select.form-control {
			width: 100%;
			padding: 12px 16px;
			border-radius: 8px;
			background: rgba(15, 23, 42, 0.6);
			border: 1px solid rgba(255, 255, 255, 0.15);
			color: white;
			outline: none;
			box-sizing: border-box;
			font-size: 0.95rem;
		}

		select.form-control option {
			background: #0f172a;
			color: white;
		}
	</style>
</head>
<body>
	<!-- Background video -->
	<video class="bg-video" autoplay loop muted>
		<source src="Air4.mp4" type="video/mp4">
		Your browser does not support the video tag.
	</video>
	<div class="bg-overlay"></div>

	<div class="btn-nav-floating">
		<button onclick="history.back()">
			<a><i class="fas fa-arrow-left"></i> Back</a>
		</button>
	</div>

	<div class="page-container" style="justify-content: center; align-items: center; min-height: 100vh; padding: 40px 20px;">
		<div class="glass-card" style="max-width: 650px; width: 100%;">
			<h3 style="margin-bottom: 10px;">Passenger Information</h3>
			<p style="color: var(--text-secondary); margin-bottom: 25px;">
				Outbound Flight: <%= flightNumber %> (<%= departure %> &rarr; <%= arrival %>)
				<% if (isRound) { %>
					<br>Return Flight: <%= returnFlightNumber %> (<%= returnDeparture %> &rarr; <%= returnArrival %>)
				<% } %>
			</p>
			
			<div style="margin-bottom: 25px;">
				<label for="passengerCount" style="margin-bottom: 8px; display: block;">Number of Passengers</label>
				<select id="passengerCount" class="form-control" onchange="generatePassengerForms(this.value)">
					<option value="1">1 Passenger</option>
					<option value="2">2 Passengers</option>
					<option value="3">3 Passengers</option>
					<option value="4">4 Passengers</option>
					<option value="5">5 Passengers</option>
				</select>
			</div>

			<form action="selectSeat.jsp" method="get" id="passengers-form">
				<!-- Hidden flight parameters -->
				<input type="hidden" name="tripType" value="<%= tripType %>">
				<input type="hidden" name="flightId" value="<%= flightId %>">
				<input type="hidden" name="flightNumber" value="<%= flightNumber %>">
				<input type="hidden" name="departure" value="<%= departure %>">
				<input type="hidden" name="arrival" value="<%= arrival %>">
				<input type="hidden" name="date" value="<%= dateStr %>">
				<input type="hidden" name="price" value="<%= price %>">
				<% if (isRound) { %>
					<input type="hidden" name="returnFlightId" value="<%= returnFlightId %>">
					<input type="hidden" name="returnFlightNumber" value="<%= returnFlightNumber %>">
					<input type="hidden" name="returnDeparture" value="<%= returnDeparture %>">
					<input type="hidden" name="returnArrival" value="<%= returnArrival %>">
					<input type="hidden" name="returnDate" value="<%= returnDateStr %>">
					<input type="hidden" name="returnPrice" value="<%= returnPrice %>">
				<% } %>

				<!-- Container for dynamic passenger fields -->
				<div id="passenger-forms-container"></div>

				<input type="submit" value="Proceed to Seat Selection" class="btn-primary" style="width: 100%; margin-top: 10px;">
			</form>
		</div>
	</div>

	<script>
		function generatePassengerForms(count) {
			const container = document.getElementById('passenger-forms-container');
			container.innerHTML = ''; // Clear previous fields
			
			for (let i = 1; i <= count; i++) {
				const group = document.createElement('div');
				group.className = 'passenger-input-group';
				
				group.innerHTML = `
					<div class="passenger-title">
						<i class="fas fa-user-friends"></i> Passenger #${i}
					</div>
					<div class="form-row">
						<div>
							<label style="font-size: 0.85rem; margin-bottom: 5px; display:block;">Full Name</label>
							<input type="text" name="passengerName" placeholder="Enter full name" required style="width:100%; box-sizing:border-box;">
						</div>
						<div>
							<label style="font-size: 0.85rem; margin-bottom: 5px; display:block;">Age</label>
							<input type="number" name="passengerAge" placeholder="Age" min="1" max="120" required style="width:100%; box-sizing:border-box;">
						</div>
						<div>
							<label style="font-size: 0.85rem; margin-bottom: 5px; display:block;">Gender</label>
							<select name="passengerGender" class="form-control" required style="padding:10px;">
								<option value="Male">Male</option>
								<option value="Female">Female</option>
								<option value="Other">Other</option>
							</select>
						</div>
					</div>
				`;
				container.appendChild(group);
			}
		}

		// Initial load for 1 passenger
		document.addEventListener('DOMContentLoaded', () => {
			generatePassengerForms(1);
		});
	</script>
</body>
</html>
