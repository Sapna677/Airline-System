<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="mypack.DatabaseUtil"%>
<!DOCTYPE html>
<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="ISO-8859-1">
    <title>Booking Confirmation</title>
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

    <div class="page-container" style="justify-content: center; align-items: center; min-height: 100vh;">
        <div class="glass-card" style="text-align: center; max-width: 550px;">
            <h2 style="margin-bottom: 20px; color: white;">Booking Ticket</h2>
            <%
                String flightId = request.getParameter("flightId");
                String flightNumber = request.getParameter("flightNumber");
                String departure = request.getParameter("departure");
                String arrival = request.getParameter("arrival");
                String date = request.getParameter("date");
                String price = request.getParameter("price");
                
                String tripType = request.getParameter("tripType");
                String returnFlightId = request.getParameter("returnFlightId");
                String returnFlightNumber = request.getParameter("returnFlightNumber");
                String returnDeparture = request.getParameter("returnDeparture");
                String returnArrival = request.getParameter("returnArrival");
                String returnPrice = request.getParameter("returnPrice");
                boolean isRound = "round".equals(tripType);

                String[] passengerNames = request.getParameterValues("passengerName");
                String[] passengerAges = request.getParameterValues("passengerAge");
                String[] passengerGenders = request.getParameterValues("passengerGender");
                String[] passengerSeats = request.getParameterValues("passengerSeat");
                String[] passengerReturnSeats = request.getParameterValues("passengerReturnSeat");

                String loggedInEmail = (String) session.getAttribute("email");
                if (loggedInEmail == null) {
                    response.sendRedirect("login.jsp");
                    return;
                }

                if (flightId != null && flightNumber != null && passengerNames != null && passengerNames.length > 0) {
                    
                    Connection con = null;
                    PreparedStatement pstmt = null;

                    try {
                        con = DatabaseUtil.getCon();
                        
                        int userId = 1;
                        String userQuery = "SELECT user_id FROM users WHERE email = ?";
                        try (PreparedStatement uPstmt = con.prepareStatement(userQuery)) {
                            uPstmt.setString(1, loggedInEmail);
                            try (ResultSet uRs = uPstmt.executeQuery()) {
                                  if (uRs.next()) {
                                      userId = uRs.getInt("user_id");
                                  }
                            }
                        }

                        // Insert each passenger booking (dual inserts for outbound + return if Round-Trip)
                        String insertQuery = "INSERT INTO bookings (flight_id, flight_number, departure, arrival, booking_date, user_id, payment_id, seat_number, passenger_name, passenger_age, passenger_gender) VALUES (?, ?, ?, ?, NOW(), ?, ?, ?, ?, ?, ?)";
                        pstmt = con.prepareStatement(insertQuery);
                        
                        int rowsInserted = 0;
                        int expectedRows = isRound ? passengerNames.length * 2 : passengerNames.length;
                        
                        for (int i = 0; i < passengerNames.length; i++) {
                            int age = 30;
                            if (passengerAges != null && i < passengerAges.length && passengerAges[i] != null && !passengerAges[i].trim().isEmpty()) {
                                try {
                                    age = Integer.parseInt(passengerAges[i].trim());
                                } catch (NumberFormatException e) {
                                    // Fallback to default age
                                }
                            }
                            
                            // 1. Outbound Flight Insert
                            pstmt.setInt(1, Integer.parseInt(flightId));
                            pstmt.setString(2, flightNumber);
                            pstmt.setString(3, departure);
                            pstmt.setString(4, arrival);
                            pstmt.setInt(5, userId); 
                            pstmt.setString(6, "PENDING");
                            pstmt.setString(7, passengerSeats[i]);
                            pstmt.setString(8, passengerNames[i]);
                            pstmt.setInt(9, age);
                            pstmt.setString(10, passengerGenders[i]);
                            rowsInserted += pstmt.executeUpdate();
                            
                            // 2. Return Flight Insert
                            if (isRound && returnFlightId != null) {
                                pstmt.setInt(1, Integer.parseInt(returnFlightId));
                                pstmt.setString(2, returnFlightNumber);
                                pstmt.setString(3, returnDeparture);
                                pstmt.setString(4, returnArrival);
                                pstmt.setInt(5, userId); 
                                pstmt.setString(6, "PENDING");
                                pstmt.setString(7, passengerReturnSeats[i]);
                                pstmt.setString(8, passengerNames[i]);
                                pstmt.setInt(9, age);
                                pstmt.setString(10, passengerGenders[i]);
                                rowsInserted += pstmt.executeUpdate();
                            }
                        }

                        if (rowsInserted == expectedRows) {
                            double singlePrice = Double.parseDouble(price);
                            double totalOutboundPrice = singlePrice * passengerNames.length;
                            double totalReturnPrice = 0.0;
                            if (isRound && returnPrice != null) {
                                totalReturnPrice = Double.parseDouble(returnPrice) * passengerNames.length;
                            }
                            double totalPrice = totalOutboundPrice + totalReturnPrice;
                            
                            String seatsJoined = "";
                            if (passengerSeats != null) {
                                seatsJoined = String.join(", ", passengerSeats);
                            }
                            if (isRound && passengerReturnSeats != null) {
                                seatsJoined = "Outbound: " + seatsJoined + " | Return: " + String.join(", ", passengerReturnSeats);
                            }
                            
                            out.println("<p style='font-size: 1.15rem; color: #10b981; font-weight: 600; margin-bottom: 25px;'><i class='fas fa-check-circle'></i> Bookings successfully created for " + passengerNames.length + " passenger(s)!</p>");
                            out.println("<p style='color: white; margin-bottom: 20px;'><strong>Outbound Seats:</strong> " + String.join(", ", passengerSeats) + (isRound ? "<br><strong>Return Seats:</strong> " + String.join(", ", passengerReturnSeats) : "") + "</p>");
                            out.println("<div class='dashboard-actions' style='margin-top: 20px;'>");
                            out.println("<a href='paymentMode.jsp?departure=" + departure + "&arrival=" + arrival + "&flight_id=" + flightId + "&flight_number=" + flightNumber + "&price=" + totalPrice + "&seatNumber=" + java.net.URLEncoder.encode(seatsJoined, "UTF-8") + "' class='btn-primary' style='display: inline-block;'>Proceed to Payment</a>");
                            out.println("</div>");
                        } else {
                            out.println("<p style='color: #ef4444;'>Failed to create bookings. Please try again.</p>");
                        }

                    } catch (SQLException e) {
                        e.printStackTrace();
                        out.println("<p style='color: #ef4444;'>Error occurred while creating booking: " + e.getMessage() + "</p>");
                    } finally {
                        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
                        if (con != null) try { con.close(); } catch (SQLException ignore) {}
                    }
                } else {
                    out.println("<p style='color: #ef4444;'>No flight or passenger selected. Please go back and try again.</p>");
                }
            %>
            <div class="card-footer-links" style="margin-top: 30px;">
                <a href="searchFlights.jsp"><i class="fas fa-search"></i> Back to Search</a>
            </div>
        </div>
    </div>
</body>
</html>
