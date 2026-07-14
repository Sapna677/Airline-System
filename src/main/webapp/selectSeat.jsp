<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.HashSet"%>
<%@ page import="mypack.DatabaseUtil"%>
<%
    // Prevent browser back-button caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // Validate active session
    String loggedInUser = (String) session.getAttribute("email");
    if (loggedInUser == null) {
        response.sendRedirect("login.jsp?msg=LoginRequired");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="ISO-8859-1">
    <title>Select Seat - SkyGlide Airways</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .airplane-container {
            width: 100%;
            max-width: 480px;
            margin: 20px auto;
            background: rgba(15, 23, 42, 0.7);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 24px;
            padding: 25px;
            backdrop-filter: blur(12px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.4);
        }
        
        .cockpit {
            text-align: center;
            border-bottom: 2px dashed rgba(255, 255, 255, 0.15);
            padding-bottom: 15px;
            margin-bottom: 25px;
            font-weight: 600;
            color: var(--text-secondary);
            font-size: 0.9rem;
            letter-spacing: 2px;
            text-transform: uppercase;
        }

        .cabin-layout {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .seat-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 8px;
        }

        .row-num {
            width: 24px;
            text-align: center;
            font-weight: 600;
            color: var(--text-secondary);
            font-size: 0.85rem;
        }

        .seat-group {
            display: flex;
            gap: 8px;
        }

        .seat {
            width: 32px;
            height: 32px;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            font-weight: 500;
            transition: all 0.2s ease;
            user-select: none;
            box-sizing: border-box;
        }

        .seat-available {
            background: rgba(99, 102, 241, 0.1);
            border: 1px solid rgba(99, 102, 241, 0.4);
            color: #ffffff;
            cursor: pointer;
        }

        .seat-available:hover {
            background: rgba(99, 102, 241, 0.3);
            border-color: #6366f1;
            transform: scale(1.08);
        }

        .seat-occupied {
            background: rgba(239, 68, 68, 0.15);
            border: 1px solid rgba(239, 68, 68, 0.4);
            color: rgba(255, 255, 255, 0.3);
            cursor: not-allowed;
        }

        .seat-selected {
            background: #6366f1 !important;
            border-color: #6366f1 !important;
            color: #ffffff !important;
            box-shadow: 0 0 12px rgba(99, 102, 241, 0.6);
            transform: scale(1.08);
        }

        .aisle-space {
            width: 30px;
            display: flex;
            justify-content: center;
            color: rgba(255, 255, 255, 0.15);
            font-size: 0.75rem;
            font-weight: bold;
        }

        .seat-legend {
            display: flex;
            justify-content: space-around;
            margin-top: 25px;
            padding-top: 15px;
            border-top: 1px solid rgba(255, 255, 255, 0.08);
        }

        .legend-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.85rem;
            color: var(--text-secondary);
        }

        .legend-dot {
            width: 14px;
            height: 14px;
            border-radius: 4px;
        }

        .summary-box {
            margin-top: 25px;
            padding: 15px;
            background: rgba(255, 255, 255, 0.03);
            border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.05);
            text-align: center;
        }
    </style>
<script src="js/theme.js"></script>
</head>
<body>
    <nav>
        <div class="logo">
            <img alt="Airline Logo" src="download.png">
        </div>
        <ul>
            <li><a href="index.jsp">Home</a></li>
            <li><a href="searchFlights.jsp">Search Flights</a></li>
            <li><a href="contact.jsp">Contact</a></li>
            <li><a href="about.jsp">About</a></li>
        </ul>
    </nav>

    <div class="page-container" style="padding-top: 100px;">
        <main class="standalone-container" style="max-width: 600px; margin: 20px auto; padding: 25px;">
            <h1 style="text-align: center; font-size: 2rem; margin-bottom: 5px;">Select Your Seat</h1>
            <p style="text-align: center; color: var(--text-secondary); margin-bottom: 25px;">Flight: <%= request.getParameter("flightNumber") %> | Route: <%= request.getParameter("departure") %> &rarr; <%= request.getParameter("arrival") %></p>

            <%
                // Force JSP Recompilation timestamp: 1783965760
                String flightId = request.getParameter("flightId");
                String flightNumber = request.getParameter("flightNumber");
                String departure = request.getParameter("departure");
                String arrival = request.getParameter("arrival");
                String date = request.getParameter("date");
                String price = request.getParameter("price");
                String tripType = request.getParameter("tripType");
                String returnFlightId = request.getParameter("returnFlightId");
                String returnFlightNumber = request.getParameter("returnFlightNumber");
                String returnPrice = request.getParameter("returnPrice");
                String returnDateStr = request.getParameter("returnDate");
                String returnDeparture = request.getParameter("returnDeparture");
                String returnArrival = request.getParameter("returnArrival");
                boolean isRound = "round".equals(tripType);

                String[] passengerNames = request.getParameterValues("passengerName");
                String[] passengerAges = request.getParameterValues("passengerAge");
                String[] passengerGenders = request.getParameterValues("passengerGender");

                if (passengerNames == null || passengerNames.length == 0) {
                    passengerNames = new String[]{"Primary Passenger"};
                    passengerAges = new String[]{"30"};
                    passengerGenders = new String[]{"Male"};
                }
                int numPassengers = passengerNames.length;

                HashSet<String> bookedSeats = new HashSet<String>();
                HashSet<String> bookedSeatsReturn = new HashSet<String>();
                if (flightId != null) {
                    Connection con = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;
                    try {
                        con = DatabaseUtil.getCon();
                        pstmt = con.prepareStatement("SELECT seat_number FROM bookings WHERE flight_id = ? AND seat_number IS NOT NULL");
                        pstmt.setInt(1, Integer.parseInt(flightId));
                        rs = pstmt.executeQuery();
                        while (rs.next()) {
                            String sn = rs.getString("seat_number");
                            if (sn != null) {
                                bookedSeats.add(sn.trim().toUpperCase());
                            }
                        }
                        rs.close();
                        pstmt.close();
                        
                        if (isRound && returnFlightId != null) {
                            pstmt = con.prepareStatement("SELECT seat_number FROM bookings WHERE flight_id = ? AND seat_number IS NOT NULL");
                            pstmt.setInt(1, Integer.parseInt(returnFlightId));
                            rs = pstmt.executeQuery();
                            while (rs.next()) {
                                String sn = rs.getString("seat_number");
                                if (sn != null) {
                                    bookedSeatsReturn.add(sn.trim().toUpperCase());
                                }
                            }
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (rs != null) try { rs.close(); } catch(Exception e){}
                        if (pstmt != null) try { pstmt.close(); } catch(Exception e){}
                        if (con != null) try { con.close(); } catch(Exception e){}
                    }
                }
            %>

            <!-- Passengers List and Seat Assignment -->
            <div class="passenger-seat-list" style="margin-bottom: 25px; padding: 20px; background: rgba(255,255,255,0.03); border-radius: 16px; border: 1px solid rgba(255,255,255,0.06);">
                <h4 style="margin-top: 0; color: #6366f1; margin-bottom: 15px; font-size: 1.15rem; display: flex; align-items: center; gap: 8px;">
                    <i class="fas fa-users"></i> Passenger Seat Assignment
                </h4>
                <% for (int k = 0; k < numPassengers; k++) { %>
                <div style="padding: 12px 0; border-bottom: 1px solid rgba(255,255,255,0.05); font-size: 0.95rem; display: flex; flex-direction: column; gap: 5px;">
                    <div><%= k+1 %>. <strong><%= passengerNames[k] %></strong> (<%= passengerGenders[k] %>, <%= passengerAges[k] %>)</div>
                    <div style="display: flex; gap: 20px; font-size: 0.85rem; padding-left: 15px;">
                        <span>Outbound Seat: <span id="passenger-seat-outbound-<%= k %>" style="color: #f59e0b; font-weight: bold; font-family: 'Outfit', sans-serif;">Not Selected</span></span>
                        <% if (isRound) { %>
                            <span>Return Seat: <span id="passenger-seat-return-<%= k %>" style="color: #f59e0b; font-weight: bold; font-family: 'Outfit', sans-serif;">Not Selected</span></span>
                        <% } %>
                    </div>
                </div>
                <% } %>
            </div>

            <!-- Outbound Flight Cabin Selection -->
            <div class="airplane-container" style="margin-bottom: 30px;">
                <h3 style="text-align: center; color: white; margin-top: 0; font-size: 1.1rem; text-transform: uppercase; letter-spacing: 1.1px; font-weight: 700; margin-bottom: 15px;">
                    <i class="fas fa-plane-departure" style="color: #6366f1; margin-right: 6px;"></i> Outbound Cabin (<%= departure %> &rarr; <%= arrival %>)
                </h3>
                <div class="cockpit"><i class="fa-solid fa-plane"></i> Cabin Front</div>
                <div class="cabin-layout">
                    <%
                        String[] seatLetters = {"A", "B", "C", "D", "E", "F"};
                        for (int i = 1; i <= 10; i++) {
                    %>
                    <div class="seat-row">
                        <div class="row-num"><%= i %></div>
                        <div class="seat-group">
                            <%
                                for (int j = 0; j < 3; j++) {
                                    String seatId = i + seatLetters[j];
                                    boolean isBooked = bookedSeats.contains(seatId);
                            %>
                            <div class="seat <%= isBooked ? "seat-occupied" : "seat-available" %>" 
                                 data-seat-id="<%= seatId %>" 
                                 data-cabin-type="outbound"
                                 onclick="selectSeat(this, <%= isBooked %>, 'outbound')">
                                <%= seatLetters[j] %>
                            </div>
                            <% } %>
                        </div>
                        <div class="aisle-space">||</div>
                        <div class="seat-group">
                            <%
                                for (int j = 3; j < 6; j++) {
                                    String seatId = i + seatLetters[j];
                                    boolean isBooked = bookedSeats.contains(seatId);
                            %>
                            <div class="seat <%= isBooked ? "seat-occupied" : "seat-available" %>" 
                                 data-seat-id="<%= seatId %>" 
                                 data-cabin-type="outbound"
                                 onclick="selectSeat(this, <%= isBooked %>, 'outbound')">
                                <%= seatLetters[j] %>
                            </div>
                            <% } %>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>

            <!-- Return Flight Cabin Selection -->
            <% if (isRound) { %>
            <div class="airplane-container" style="margin-bottom: 30px;">
                <h3 style="text-align: center; color: white; margin-top: 0; font-size: 1.1rem; text-transform: uppercase; letter-spacing: 1.1px; font-weight: 700; margin-bottom: 15px;">
                    <i class="fas fa-plane-arrival" style="color: #10b981; margin-right: 6px;"></i> Return Cabin (<%= arrival %> &rarr; <%= departure %>)
                </h3>
                <div class="cockpit" style="background: rgba(16, 185, 129, 0.15); border-color: rgba(16, 185, 129, 0.35);"><i class="fa-solid fa-plane"></i> Cabin Front</div>
                <div class="cabin-layout">
                    <%
                        for (int i = 1; i <= 10; i++) {
                    %>
                    <div class="seat-row">
                        <div class="row-num"><%= i %></div>
                        <div class="seat-group">
                            <%
                                for (int j = 0; j < 3; j++) {
                                    String seatId = i + seatLetters[j];
                                    boolean isBooked = bookedSeatsReturn.contains(seatId);
                            %>
                            <div class="seat <%= isBooked ? "seat-occupied" : "seat-available" %>" 
                                 data-seat-id="<%= seatId %>" 
                                 data-cabin-type="return"
                                 onclick="selectSeat(this, <%= isBooked %>, 'return')">
                                <%= seatLetters[j] %>
                            </div>
                            <% } %>
                        </div>
                        <div class="aisle-space">||</div>
                        <div class="seat-group">
                            <%
                                for (int j = 3; j < 6; j++) {
                                    String seatId = i + seatLetters[j];
                                    boolean isBooked = bookedSeatsReturn.contains(seatId);
                            %>
                            <div class="seat <%= isBooked ? "seat-occupied" : "seat-available" %>" 
                                 data-seat-id="<%= seatId %>" 
                                 data-cabin-type="return"
                                 onclick="selectSeat(this, <%= isBooked %>, 'return')">
                                <%= seatLetters[j] %>
                            </div>
                            <% } %>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
            <% } %>

            <div class="seat-legend">
                <div class="legend-item">
                    <div class="legend-dot" style="background: rgba(255, 255, 255, 0.05); border: 1px solid rgba(255, 255, 255, 0.25);"></div>
                    <span>Available</span>
                </div>
                <div class="legend-item">
                    <div class="legend-dot" style="background: rgba(239, 68, 68, 0.15); border: 1px solid rgba(239, 68, 68, 0.45);"></div>
                    <span>Occupied</span>
                </div>
                <div class="legend-item">
                    <div class="legend-dot" style="background: #6366f1;"></div>
                    <span>Selected</span>
                </div>
            </div>

            <div class="summary-box" style="margin-bottom: 25px; padding: 15px; background: rgba(255,255,255,0.02); border-radius: 12px; border: 1px solid rgba(255,255,255,0.05); text-align: center;">
                <p style="font-weight: 500; font-size: 1.02rem; margin: 4px 0;">Outbound Seats: <span id="selected-seat-badge" style="color: #10b981; font-weight: bold;">None</span></p>
                <% if (isRound) { %>
                    <p style="font-weight: 500; font-size: 1.02rem; margin: 4px 0;">Return Seats: <span id="selected-seat-badge-return" style="color: #10b981; font-weight: bold;">None</span></p>
                <% } %>
            </div>

            <form id="seat-form" action="booking.jsp" method="post" onsubmit="return validateSelection()">
                <input type="hidden" name="tripType" value="<%= tripType %>">
                <input type="hidden" name="flightId" value="<%= flightId %>">
                <input type="hidden" name="flightNumber" value="<%= flightNumber %>">
                <input type="hidden" name="departure" value="<%= departure %>">
                <input type="hidden" name="arrival" value="<%= arrival %>">
                <input type="hidden" name="date" value="<%= date %>">
                <input type="hidden" name="price" value="<%= price %>">
                <% if (isRound) { %>
                    <input type="hidden" name="returnFlightId" value="<%= returnFlightId %>">
                    <input type="hidden" name="returnFlightNumber" value="<%= returnFlightNumber %>">
                    <input type="hidden" name="returnDeparture" value="<%= returnDeparture %>">
                    <input type="hidden" name="returnArrival" value="<%= returnArrival %>">
                    <input type="hidden" name="returnDate" value="<%= returnDateStr %>">
                    <input type="hidden" name="returnPrice" value="<%= returnPrice %>">
                <% } %>
                <div id="form-inputs-container"></div>
                
                <input type="submit" value="Confirm Seats & Book" class="btn-primary" style="width: 100%; margin-top: 15px;">
            </form>

            <div style="text-align: center; margin-top: 15px;">
                <a href="searchFlights.jsp" class="back-link" style="padding: 6px 12px; font-size: 0.85rem;"><i class="fa-solid fa-arrow-left"></i> Change Flight</a>
            </div>
        </main>
    </div>

    <script>
        const passengerNames = [
            <% for (int k = 0; k < numPassengers; k++) { %>
                "<%= passengerNames[k] != null ? passengerNames[k].replace("\"", "\\\"") : "Passenger " + (k+1) %>"<%= k < numPassengers - 1 ? "," : "" %>
            <% } %>
        ];
        const passengerAges = [
            <% for (int k = 0; k < numPassengers; k++) { %>
                "<%= passengerAges[k] != null ? passengerAges[k] : "30" %>"<%= k < numPassengers - 1 ? "," : "" %>
            <% } %>
        ];
        const passengerGenders = [
            <% for (int k = 0; k < numPassengers; k++) { %>
                "<%= passengerGenders[k] != null ? passengerGenders[k] : "Male" %>"<%= k < numPassengers - 1 ? "," : "" %>
            <% } %>
        ];
        const numPassengers = <%= numPassengers %>;
        const isRound = <%= isRound %>;
        let selectedSeatsOutbound = [];
        let selectedSeatsReturn = [];

        function selectSeat(element, isBooked, cabinType) {
            if (isBooked) return;

            const seatId = element.getAttribute('data-seat-id');
            const targetArray = (cabinType === 'outbound') ? selectedSeatsOutbound : selectedSeatsReturn;
            const index = targetArray.indexOf(seatId);

            if (index > -1) {
                targetArray.splice(index, 1);
                element.classList.remove('seat-selected');
            } else {
                if (targetArray.length >= numPassengers) {
                    alert("You have already selected " + numPassengers + " seats for the " + cabinType + " flight. To change, deselect a seat first.");
                    return;
                }
                targetArray.push(seatId);
                element.classList.add('seat-selected');
            }

            // Update labels
            for (let i = 0; i < numPassengers; i++) {
                if (cabinType === 'outbound') {
                    const badge = document.getElementById('passenger-seat-outbound-' + i);
                    if (selectedSeatsOutbound[i]) {
                        badge.textContent = "Seat " + selectedSeatsOutbound[i];
                        badge.style.color = "#10b981";
                    } else {
                        badge.textContent = "Not Selected";
                        badge.style.color = "#f59e0b";
                    }
                } else {
                    const badge = document.getElementById('passenger-seat-return-' + i);
                    if (selectedSeatsReturn[i]) {
                        badge.textContent = "Seat " + selectedSeatsReturn[i];
                        badge.style.color = "#10b981";
                    } else {
                        badge.textContent = "Not Selected";
                        badge.style.color = "#f59e0b";
                    }
                }
            }

            // Update badge at the bottom
            if (cabinType === 'outbound') {
                document.getElementById('selected-seat-badge').textContent = selectedSeatsOutbound.join(', ') || 'None';
            } else {
                document.getElementById('selected-seat-badge-return').textContent = selectedSeatsReturn.join(', ') || 'None';
            }
            
            // Re-generate hidden form fields
            const formInputsContainer = document.getElementById('form-inputs-container');
            formInputsContainer.innerHTML = '';
            for (let i = 0; i < numPassengers; i++) {
                const sOut = selectedSeatsOutbound[i] || "";
                const sRet = selectedSeatsReturn[i] || "";
                formInputsContainer.innerHTML += 
                    '<input type="hidden" name="passengerName" value="' + passengerNames[i] + '">' +
                    '<input type="hidden" name="passengerAge" value="' + passengerAges[i] + '">' +
                    '<input type="hidden" name="passengerGender" value="' + passengerGenders[i] + '">' +
                    '<input type="hidden" name="passengerSeat" value="' + sOut + '">' +
                    '<input type="hidden" name="passengerReturnSeat" value="' + sRet + '">';
            }
        }

        function validateSelection() {
            if (selectedSeatsOutbound.length < numPassengers) {
                alert("Please select Outbound seats for all " + numPassengers + " passengers!");
                return false;
            }
            if (isRound && selectedSeatsReturn.length < numPassengers) {
                alert("Please select Return seats for all " + numPassengers + " passengers!");
                return false;
            }
            return true;
        }
    </script>
</body>
</html>
