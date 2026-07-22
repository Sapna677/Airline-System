<%@ page import="java.sql.*"%>
<%@ page import="java.io.*"%>
<%@ page import="mypack.DatabaseUtil"%>
<!-- Assuming DatabaseUtil is in mypack package -->
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" isELIgnored="true"%>
<!DOCTYPE html>
<html>
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

	<div class="page-container" style="justify-content: center; align-items: center; min-height: 100vh;">
		<div class="glass-card" style="max-width: 550px;">

    <%
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String paymentMode = request.getParameter("paymentMode");
    String cardNumber = request.getParameter("cardNumber");
    String expiry = request.getParameter("expiry");
    String cvv = request.getParameter("cvv");
    String flightNumber = request.getParameter("flightNumber");
    String price = request.getParameter("price");
    String departure = request.getParameter("departure");
    String arrival = request.getParameter("arrival");
    String seatNumber = request.getParameter("seatNumber");
    String flightId = request.getParameter("flightId");

    if (seatNumber == null || seatNumber.isEmpty()) {
        seatNumber = "1A";
    }

    Connection con = null;
    PreparedStatement pstmt = null;
    String errorMessage = "";
    java.util.List<java.util.Map<String, String>> passengerList = new java.util.ArrayList<>();

    try {
        con = DatabaseUtil.getCon();

        // Database fallback query for flight details if parameters are null/empty
        if (flightNumber == null || flightNumber.isEmpty() || departure == null || departure.isEmpty() || price == null || price.isEmpty()) {
            try {
                int tempUserId = 1;
                String sessionEmail = (String) session.getAttribute("email");
                if (sessionEmail != null) {
                    String uQuery = "SELECT user_id FROM users WHERE email = ?";
                    try (PreparedStatement uPstmt = con.prepareStatement(uQuery)) {
                        uPstmt.setString(1, sessionEmail);
                        try (ResultSet uRs = uPstmt.executeQuery()) {
                            if (uRs.next()) {
                                tempUserId = uRs.getInt("user_id");
                            }
                        }
                    }
                }
                
                String bQuery = "SELECT flight_number, departure, arrival, seat_number FROM bookings WHERE user_id = ? ORDER BY booking_id DESC LIMIT 1";
                try (PreparedStatement bPstmt = con.prepareStatement(bQuery)) {
                    bPstmt.setInt(1, tempUserId);
                    try (ResultSet bRs = bPstmt.executeQuery()) {
                        if (bRs.next()) {
                            flightNumber = bRs.getString("flight_number");
                            departure = bRs.getString("departure");
                            arrival = bRs.getString("arrival");
                            seatNumber = bRs.getString("seat_number");
                        }
                    }
                }
                
                if (flightNumber != null) {
                    String fQuery = "SELECT price FROM flights WHERE flight_number = ? LIMIT 1";
                    try (PreparedStatement fPstmt = con.prepareStatement(fQuery)) {
                        fPstmt.setString(1, flightNumber);
                        try (ResultSet fRs = fPstmt.executeQuery()) {
                            if (fRs.next()) {
                                price = fRs.getString("price");
                            }
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        String sql = "INSERT INTO payments (name, email, paymentMode, cardNumber, expiry, cvv) VALUES (?, ?, ?, ?, ?, ?)";

        pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        pstmt.setString(1, name);
        pstmt.setString(2, email);
        pstmt.setString(3, paymentMode);
        pstmt.setString(4, cardNumber);
        pstmt.setString(5, expiry);
        pstmt.setString(6, cvv);
        
        request.setAttribute("name", name);
        request.setAttribute("email", email);
        request.setAttribute("paymentMode", paymentMode);
        request.setAttribute("cardNumber", cardNumber);
        request.setAttribute("expiry", expiry);
        request.setAttribute("cvv", cvv);
        

        int rowsInserted = pstmt.executeUpdate();
        int paymentId = 1;

        if (rowsInserted > 0) {
            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    paymentId = generatedKeys.getInt(1);
                }
            }

            // Update pending booking to link with paymentId
            int tempUserId = 1;
            String sessionEmail = (String) session.getAttribute("email");
            if (sessionEmail != null) {
                String uQuery = "SELECT user_id FROM users WHERE email = ?";
                try (PreparedStatement uPstmt = con.prepareStatement(uQuery)) {
                    uPstmt.setString(1, sessionEmail);
                    try (ResultSet uRs = uPstmt.executeQuery()) {
                        if (uRs.next()) {
                            tempUserId = uRs.getInt("user_id");
                        }
                    }
                }
            }
            
            String updateSql = "UPDATE bookings SET payment_id = ? WHERE user_id = ? AND payment_id = 'PENDING'";
            try (PreparedStatement updatePstmt = con.prepareStatement(updateSql)) {
                updatePstmt.setString(1, String.valueOf(paymentId));
                updatePstmt.setInt(2, tempUserId);
                updatePstmt.executeUpdate();
            }

            // Retrieve all booked passengers under this payment
            String selectBookings = "SELECT passenger_name, seat_number FROM bookings WHERE payment_id = ?";
            try (PreparedStatement selectPstmt = con.prepareStatement(selectBookings)) {
                selectPstmt.setString(1, String.valueOf(paymentId));
                try (ResultSet selectRs = selectPstmt.executeQuery()) {
                    while (selectRs.next()) {
                        java.util.Map<String, String> pMap = new java.util.HashMap<>();
                        String pName = selectRs.getString("passenger_name");
                        String pSeat = selectRs.getString("seat_number");
                        pMap.put("name", pName != null ? pName : name);
                        pMap.put("seat", pSeat != null ? pSeat : "1A");
                        passengerList.add(pMap);
                    }
                }
            }
            if (passengerList.isEmpty()) {
                java.util.Map<String, String> pMap = new java.util.HashMap<>();
                pMap.put("name", name);
                pMap.put("seat", seatNumber);
                passengerList.add(pMap);
            }

            // Retrieve flight date from flight table
            String flightDate = "N/A";
            if (flightId != null && !flightId.isEmpty()) {
                try (PreparedStatement fPstmt = con.prepareStatement("SELECT date FROM flights WHERE flight_id = ?")) {
                    fPstmt.setInt(1, Integer.parseInt(flightId));
                    try (ResultSet fRs = fPstmt.executeQuery()) {
                        if (fRs.next()) {
                            flightDate = fRs.getTimestamp("date").toString();
                        }
                    }
                }
            }

            // Send confirmation email
            mypack.MailUtil.sendTicket(email, name, flightNumber, departure, arrival, flightDate, price, seatNumber);
    %>
    <div style="text-align: center; padding: 20px 0;">
        <i class="fas fa-check-circle" style="font-size: 4.5rem; color: #10b981; margin-bottom: 20px; display: block; filter: drop-shadow(0 0 10px rgba(16,185,129,0.3));"></i>
        <h3 style="font-size: 1.6rem; font-weight: 700; color: white; margin-bottom: 10px;">Payment Confirmed!</h3>
        <p style="color: var(--text-secondary); margin-bottom: 20px; font-size: 0.95rem;">
            Thank you. Your flight booking has been successfully processed and ticketed.
        </p>

        <!-- Simulated bill button and back to dashboard buttons -->
        <div style="display: flex; flex-direction: column; gap: 15px; margin-top: 25px; width: 100%;">
            <div style="display: flex; gap: 15px; width: 100%;">
                <button class="btn-primary" onclick="generateBill('<%=email%>', '<%=flightNumber%>', '<%=price%>', '<%=departure%>', '<%=arrival%>')" style="flex: 1;">
                    <i class="fas fa-file-invoice"></i> View Boarding Pass
                </button>
                <a href="downloadTicket.jsp?name=<%=java.net.URLEncoder.encode(name, "UTF-8")%>&email=<%=email%>&flightNumber=<%=flightNumber%>&price=<%=price%>&departure=<%=departure%>&arrival=<%=arrival%>&seatNumber=<%=seatNumber%>&date=<%=java.net.URLEncoder.encode(flightDate, "UTF-8")%>" class="btn-primary" style="flex: 1; display: inline-flex; align-items: center; justify-content: center; text-decoration: none; background: #10b981; border-color: #10b981;" target="_blank">
                    <i class="fas fa-file-pdf"></i> Download PDF Ticket
                </a>
            </div>
            <a href="userDashboard.jsp" class="btn-primary" style="width: 100%; display: inline-flex; align-items: center; justify-content: center; text-decoration: none; background: rgba(255,255,255,0.08); border: 1px solid var(--card-border); color: white;">
                <i class="fas fa-tachometer-alt"></i> Back to Dashboard
            </a>
        </div>
    </div>
    <%
    } else {
        errorMessage = "Payment failed. Please try again.";
    }

    } catch (Exception e) {
        errorMessage = "Error: " + e.getMessage();
    } finally {
        try {
            if (pstmt != null)
                pstmt.close();
            if (con != null)
                con.close();
        } catch (SQLException e) {
            errorMessage = "Error closing resources: " + e.getMessage();
        }
    }

    if (!errorMessage.isEmpty()) {
    %>
    <div style="text-align: center; padding: 20px 0; color: var(--danger-color);">
        <i class="fas fa-times-circle" style="font-size: 4rem; margin-bottom: 15px; display: block;"></i>
        <p style="font-weight: 600;"><%=errorMessage%></p>
    </div>
    <%
    }
    %>

<script>
    const passengerList = [
        <% for (int i = 0; i < passengerList.size(); i++) {
            java.util.Map<String, String> p = passengerList.get(i); %>
            {
                name: "<%= p.get("name").replace("\"", "\\\"") %>",
                seat: "<%= p.get("seat") %>"
            }<%= i < passengerList.size() - 1 ? "," : "" %>
        <% } %>
    ];

    function generateBill(email, flightNumber, price, departure, arrival) {
        var billWindow = window.open('', '', 'width=800,height=600');
        var currentDate = new Date().toLocaleDateString('en-US', {
            year: 'numeric',
            month: 'short',
            day: 'numeric'
        });

        var billContent = `
            <!DOCTYPE html>
            <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>SkyGlide Airways Boarding Pass</title>
                <style>
                    * {
                        -webkit-print-color-adjust: exact !important;
                        print-color-adjust: exact !important;
                    }
                    body {
                        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                        padding: 20px;
                        background: #f3f4f6;
                        color: #1f2937;
                    }
                    .ticket-container {
                        display: flex;
                        flex-direction: column;
                        gap: 30px;
                    }
                    .boarding-pass {
                        background: white;
                        border: 2px solid #6366f1;
                        border-radius: 12px;
                        max-width: 760px;
                        margin: auto;
                        box-shadow: 0 10px 25px rgba(0,0,0,0.1);
                        display: flex;
                        position: relative;
                        page-break-after: always;
                        overflow: hidden;
                    }
                    .main-pass {
                        padding: 25px;
                        width: 70%;
                        border-right: 2px dashed #6366f1;
                    }
                    .stub-pass {
                        padding: 25px;
                        width: 30%;
                        background: rgba(99, 102, 241, 0.05) !important;
                        display: flex;
                        flex-direction: column;
                        justify-content: space-between;
                    }
                    .header {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        background: #6366f1 !important;
                        color: white !important;
                        padding: 12px 25px;
                        margin: -25px -25px 20px -25px;
                    }
                    .header h1 {
                        margin: 0;
                        font-size: 20px;
                        font-weight: 800;
                        letter-spacing: 1px;
                        color: white !important;
                    }
                    .header span {
                        font-size: 11px;
                        text-transform: uppercase;
                        letter-spacing: 2px;
                        background: #ff9900 !important;
                        color: white !important;
                        padding: 3px 8px;
                        border-radius: 4px;
                        font-weight: bold;
                    }
                    .route-section {
                        display: flex;
                        align-items: center;
                        gap: 20px;
                        margin-bottom: 25px;
                    }
                    .route-code {
                        font-size: 2.2rem;
                        font-weight: 800;
                        color: #6366f1;
                    }
                    .route-plane {
                        font-size: 1.5rem;
                        color: #ff9900;
                    }
                    .info-grid {
                        display: grid;
                        grid-template-columns: 1fr 1fr;
                        gap: 15px;
                        margin-bottom: 20px;
                    }
                    .info-box {
                        display: flex;
                        flex-direction: column;
                    }
                    .label {
                        font-size: 10px;
                        color: #6b7280;
                        text-transform: uppercase;
                        font-weight: 600;
                        letter-spacing: 0.5px;
                    }
                    .value {
                        font-size: 15px;
                        font-weight: 700;
                        color: #111827;
                        margin-top: 3px;
                    }
                    .highlight-row {
                        background: #6366f1 !important;
                        color: white !important;
                        display: flex;
                        justify-content: space-around;
                        padding: 10px;
                        border-radius: 8px;
                        margin-top: 15px;
                        border: 1px solid #6366f1;
                    }
                    .highlight-box {
                        text-align: center;
                    }
                    .highlight-box .label {
                        color: #e0e7ff !important;
                        font-weight: 600;
                    }
                    .highlight-box .value {
                        color: white !important;
                        font-size: 18px;
                        font-weight: bold;
                    }
                    .barcode {
                        font-family: monospace;
                        font-size: 1.5rem;
                        letter-spacing: 4px;
                        text-align: center;
                        margin-top: 25px;
                        color: #111827;
                    }
                    .stub-header {
                        border-bottom: 1px solid #ddd;
                        padding-bottom: 10px;
                        margin-bottom: 15px;
                        font-weight: 800;
                        color: #6366f1;
                        font-size: 14px;
                        text-transform: uppercase;
                        text-align: center;
                    }
                </style>
            <script src="js/theme.js"><\/script>
</head>
            <body>
                <div class="ticket-container">
        `;

        passengerList.forEach((passenger, index) => {
            var pnr = "SG" + Math.random().toString(36).substr(2, 4).toUpperCase();
            var gate = "G" + Math.floor(Math.random() * 18 + 1);

            billContent += `
                <div class="boarding-pass">
                    <!-- Main coupon -->
                    <div class="main-pass">
                        <div class="header">
                            <h1>SKYGLIDE AIRWAYS</h1>
                            <span>Boarding Pass</span>
                        </div>
                        
                        <div class="route-section">
                            <span class="route-code">${departure.toUpperCase()}</span>
                            <span class="route-plane">&#9992;</span>
                            <span class="route-code">${arrival.toUpperCase()}</span>
                        </div>

                        <div class="info-grid">
                            <div class="info-box">
                                <span class="label">Passenger Name</span>
                                <span class="value">${passenger.name.toUpperCase()}</span>
                            </div>
                            <div class="info-box">
                                <span class="label">Email Contact</span>
                                <span class="value">${email}</span>
                            </div>
                            <div class="info-box">
                                <span class="label">Date</span>
                                <span class="value">${currentDate}</span>
                            </div>
                            <div class="info-box">
                                <span class="label">Booking Status</span>
                                <span class="value" style="color: #10b981;">PAID</span>
                            </div>
                        </div>

                        <div class="highlight-row">
                            <div class="highlight-box">
                                <span class="label">Flight</span>
                                <span class="value">${flightNumber}</span>
                            </div>
                            <div class="highlight-box">
                                <span class="label">Gate</span>
                                <span class="value">${gate}</span>
                            </div>
                            <div class="highlight-box">
                                <span class="label">Seat</span>
                                <span class="value">${passenger.seat}</span>
                            </div>
                            <div class="highlight-box">
                                <span class="label">PNR Number</span>
                                <span class="value">${pnr}</span>
                            </div>
                        </div>

                        <div class="barcode">
                            || |||| ||| | ||| |||| | ||| || ||| |||| || ||
                            <div style="font-size: 10px; letter-spacing: 0px; margin-top: 3px;">PNR REFERENCE: ${pnr}</div>
                        </div>
                    </div>

                    <!-- Stub coupon -->
                    <div class="stub-pass">
                        <div>
                            <div class="stub-header">Passenger Coupon</div>
                            <div class="row" style="margin-bottom: 12px;">
                                <div class="label">Passenger</div>
                                <div class="value" style="font-size: 13px;">${passenger.name.toUpperCase()}</div>
                            </div>
                            <div class="row" style="margin-bottom: 12px;">
                                <div class="label">Flight / Seat</div>
                                <div class="value">${flightNumber} / ${passenger.seat}</div>
                            </div>
                            <div class="row" style="margin-bottom: 12px;">
                                <div class="label">Gate</div>
                                <div class="value">${gate}</div>
                            </div>
                            <div class="row" style="margin-bottom: 12px;">
                                <div class="label">From / To</div>
                                <div class="value" style="font-size: 12px;">${departure.substring(0,3).toUpperCase()} &rarr; ${arrival.substring(0,3).toUpperCase()}</div>
                            </div>
                            <div class="row" style="margin-bottom: 12px;">
                                <div class="label">Total Paid</div>
                                <div class="value" style="color: #6366f1;">INR ${price}</div>
                            </div>
                        </div>
                        <div style="text-align: center; border-top: 1px dashed #ddd; padding-top: 15px; font-size: 9px; color: #6b7280; font-weight: 600;">
                            Have a Pleasant Flight!<br>
                            SkyGlide Airways
                        </div>
                    </div>
                </div>
            `;
        });

        billContent += `
                </div>
            </body>
            </html>
        `;

        billWindow.document.write(billContent);
        billWindow.document.close();
        billWindow.print();
    }
</script>
	</div>
	</div>
</body>
</html>