<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="mypack.DatabaseUtil"%>
<%
    // Prevent browser back-button caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // Validate active session
    String loggedInEmail = (String) session.getAttribute("email");
    if (loggedInEmail == null) {
        response.sendRedirect("login.jsp?msg=LoginRequired");
        return;
    }

    String cancelMsg = null;
    String cancelErr = null;

    // Handle cancellation action
    String action = request.getParameter("action");
    if ("cancel".equals(action)) {
        String bookingIdStr = request.getParameter("bookingId");
        if (bookingIdStr != null) {
            Connection con = null;
            PreparedStatement pstmt = null;
            try {
                con = DatabaseUtil.getCon();
                
                // Get user ID
                int userId = -1;
                String userQuery = "SELECT user_id FROM users WHERE email = ?";
                try (PreparedStatement uPstmt = con.prepareStatement(userQuery)) {
                    uPstmt.setString(1, loggedInEmail);
                    try (ResultSet uRs = uPstmt.executeQuery()) {
                        if (uRs.next()) {
                            userId = uRs.getInt("user_id");
                        }
                    }
                }
                
                if (userId != -1) {
                    // Update booking status to CANCELLED
                    String cancelQuery = "UPDATE bookings SET payment_id = 'CANCELLED' WHERE booking_id = ? AND user_id = ?";
                    pstmt = con.prepareStatement(cancelQuery);
                    pstmt.setInt(1, Integer.parseInt(bookingIdStr));
                    pstmt.setInt(2, userId);
                    int rows = pstmt.executeUpdate();
                    if (rows > 0) {
                        cancelMsg = "Booking cancelled successfully. Your refund has been initiated.";
                    } else {
                        cancelErr = "Error cancelling booking or unauthorized action.";
                    }
                }
            } catch (Exception e) {
                cancelErr = "Error: " + e.getMessage();
                e.printStackTrace();
            } finally {
                if (pstmt != null) try { pstmt.close(); } catch(Exception e){}
                if (con != null) try { con.close(); } catch(Exception e){}
            }
        }
    }

    // Fetch User Profile and Booking History
    Connection con = null;
    PreparedStatement uPstmt = null;
    PreparedStatement bPstmt = null;
    ResultSet uRs = null;
    ResultSet bRs = null;

    String username = "", firstName = "", lastName = "", phone = "", address = "", dob = "", usertype = "";
    int userId = -1;

    try {
        con = DatabaseUtil.getCon();
        
        // 1. Fetch User details
        String userSql = "SELECT user_id, username, firstName, lastName, phone, address, dob, usertype FROM users WHERE email = ?";
        uPstmt = con.prepareStatement(userSql);
        uPstmt.setString(1, loggedInEmail);
        uRs = uPstmt.executeQuery();
        if (uRs.next()) {
            userId = uRs.getInt("user_id");
            username = uRs.getString("username");
            firstName = uRs.getString("firstName");
            lastName = uRs.getString("lastName");
            phone = uRs.getString("phone");
            address = uRs.getString("address");
            Date d = uRs.getDate("dob");
            dob = d != null ? d.toString() : "Not Provided";
            usertype = uRs.getString("usertype");
            if ("1".equals(usertype)) {
                usertype = "Admin";
            } else {
                usertype = "Standard Passenger";
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="ISO-8859-1">
    <title>My Profile - SkyGlide Airways</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .profile-grid {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 30px;
            align-items: start;
            margin-top: 20px;
        }

        @media (max-width: 900px) {
            .profile-grid {
                grid-template-columns: 1fr;
            }
        }

        .info-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
            margin-bottom: 20px;
            text-align: left;
        }

        .info-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--text-secondary);
            font-weight: 700;
        }

        .info-value {
            font-size: 1.05rem;
            color: white;
            font-weight: 500;
        }

        .booking-card {
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid rgba(255, 255, 255, 0.06);
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 20px;
            transition: var(--transition-smooth);
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .booking-card:hover {
            transform: translateY(-3px);
            border-color: rgba(99, 102, 241, 0.2);
            background: rgba(255, 255, 255, 0.04);
        }

        .booking-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.06);
            padding-bottom: 10px;
        }

        .flight-badge {
            background: rgba(99, 102, 241, 0.15);
            border: 1px solid rgba(99, 102, 241, 0.3);
            color: #a5b4fc;
            padding: 4px 10px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 0.8rem;
        }

        .status-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-paid {
            background: rgba(16, 185, 129, 0.15);
            border: 1px solid rgba(16, 185, 129, 0.4);
            color: #34d399;
        }

        .status-pending {
            background: rgba(245, 158, 11, 0.15);
            border: 1px solid rgba(245, 158, 11, 0.4);
            color: #fbbf24;
        }

        .status-cancelled {
            background: rgba(239, 68, 68, 0.12);
            border: 1px solid rgba(239, 68, 68, 0.35);
            color: #f87171;
        }

        .route-info {
            display: flex;
            align-items: center;
            gap: 15px;
            font-size: 1.15rem;
            font-weight: 600;
        }

        .passenger-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 10px;
            font-size: 0.9rem;
            color: var(--text-secondary);
            background: rgba(0, 0, 0, 0.15);
            padding: 10px 15px;
            border-radius: 8px;
        }

        .card-actions {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
            margin-top: 5px;
        }

        .btn-card {
            padding: 8px 16px;
            font-size: 0.85rem;
            font-weight: 600;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: var(--transition-smooth);
        }

        .btn-print {
            background: rgba(16, 185, 129, 0.15);
            color: #34d399;
            border: 1px solid rgba(16, 185, 129, 0.3);
        }

        .btn-print:hover {
            background: #10b981;
            color: white;
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.25);
        }

        .btn-cancel {
            background: rgba(239, 68, 68, 0.1);
            color: #f87171;
            border: 1px solid rgba(239, 68, 68, 0.25);
        }

        .btn-cancel:hover {
            background: #ef4444;
            color: white;
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.25);
        }
    </style>
    <script>
        function confirmCancellation() {
            return confirm("Are you sure you want to cancel this flight booking? This action is permanent and your refund will be auto-processed.");
        }
    </script>
</head>
<body>
    <!-- Background video -->
    <video class="bg-video" autoplay loop muted>
        <source src="Air4.mp4" type="video/mp4">
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
            <li><a href="profile.jsp" class="active"><i class="fas fa-user-circle"></i> Profile</a></li>
            <li><a href="logout.jsp" style="color: #f87171;"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </nav>

    <div class="page-container" style="padding-top: 100px;">
        <main class="standalone-container" style="max-width: 1050px; margin: 20px auto; padding: 30px;">
            
            <h1 style="margin-top: 0; font-size: 2.2rem; display: flex; align-items: center; gap: 12px; margin-bottom: 20px;">
                <i class="fas fa-id-card" style="color: var(--accent-color);"></i> My Account Dashboard
            </h1>

            <% if (cancelMsg != null) { %>
                <div style="background: rgba(16, 185, 129, 0.15); border: 1px solid rgba(16, 185, 129, 0.4); color: #34d399; padding: 12px 20px; border-radius: 12px; margin-bottom: 20px; text-align: left; font-weight: 500;">
                    <i class="fas fa-check-circle" style="margin-right: 8px;"></i> <%= cancelMsg %>
                </div>
            <% } %>

            <% if (cancelErr != null) { %>
                <div style="background: rgba(239, 68, 68, 0.15); border: 1px solid rgba(239, 68, 68, 0.4); color: #f87171; padding: 12px 20px; border-radius: 12px; margin-bottom: 20px; text-align: left; font-weight: 500;">
                    <i class="fas fa-exclamation-circle" style="margin-right: 8px;"></i> <%= cancelErr %>
                </div>
            <% } %>

            <div class="profile-grid">
                <!-- User Profile Column -->
                <div class="glass-card" style="padding: 25px; margin: 0;">
                    <div style="text-align: center; margin-bottom: 25px;">
                        <div style="width: 80px; height: 80px; background: linear-gradient(135deg, #6366f1, #4f46e5); color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 2rem; margin: 0 auto 15px auto; box-shadow: 0 5px 15px rgba(99, 102, 241, 0.4);">
                            <i class="fas fa-user"></i>
                        </div>
                        <h2 style="margin: 0; font-size: 1.3rem;"><%= firstName %> <%= lastName %></h2>
                        <span style="font-size: 0.8rem; color: var(--text-secondary); background: rgba(255,255,255,0.06); padding: 3px 10px; border-radius: 20px; margin-top: 5px; display: inline-block;"><%= usertype %></span>
                    </div>

                    <div class="info-group">
                        <span class="info-label">Username</span>
                        <span class="info-value"><%= username %></span>
                    </div>
                    <div class="info-group">
                        <span class="info-label">Email Address</span>
                        <span class="info-value"><%= loggedInEmail %></span>
                    </div>
                    <div class="info-group">
                        <span class="info-label">Phone Number</span>
                        <span class="info-value"><%= phone %></span>
                    </div>
                    <div class="info-group">
                        <span class="info-label">Residency Address</span>
                        <span class="info-value"><%= address %></span>
                    </div>
                    <div class="info-group">
                        <span class="info-label">Date of Birth</span>
                        <span class="info-value"><%= dob %></span>
                    </div>
                </div>

                <!-- Bookings Column -->
                <div class="glass-card" style="padding: 25px; margin: 0;">
                    <h3 style="margin-top: 0; border-bottom: 1px solid rgba(255, 255, 255, 0.08); padding-bottom: 12px; margin-bottom: 20px; display: flex; align-items: center; justify-content: space-between;">
                        <span><i class="fas fa-ticket-alt" style="color: #6366f1; margin-right: 6px;"></i> Booking Records</span>
                        <span style="font-size: 0.8rem; background: rgba(255, 255, 255, 0.06); padding: 3px 12px; border-radius: 20px; font-weight: 500;" id="booking-count">Loading...</span>
                    </h3>

                    <div class="bookings-container">
                        <%
                            int bookingsCount = 0;
                            if (userId != -1) {
                                String bookingSql = "SELECT booking_id, flight_id, flight_number, departure, arrival, booking_date, seat_number, passenger_name, passenger_age, passenger_gender, payment_id FROM bookings WHERE user_id = ? ORDER BY booking_id DESC";
                                try {
                                    bPstmt = con.prepareStatement(bookingSql);
                                    bPstmt.setInt(1, userId);
                                    bRs = bPstmt.executeQuery();
                                    
                                    while (bRs.next()) {
                                        bookingsCount++;
                                        int bId = bRs.getInt("booking_id");
                                        String fNum = bRs.getString("flight_number");
                                        String dep = bRs.getString("departure");
                                        String arr = bRs.getString("arrival");
                                        Timestamp bDate = bRs.getTimestamp("booking_date");
                                        String seat = bRs.getString("seat_number");
                                        String pName = bRs.getString("passenger_name");
                                        int pAge = bRs.getInt("passenger_age");
                                        String pGen = bRs.getString("passenger_gender");
                                        String status = bRs.getString("payment_id");
                                        
                                        String badgeClass = "status-pending";
                                        if ("PAID".equalsIgnoreCase(status)) {
                                            badgeClass = "status-paid";
                                        } else if ("CANCELLED".equalsIgnoreCase(status)) {
                                            badgeClass = "status-cancelled";
                                        }
                        %>
                                    <div class="booking-card">
                                        <div class="booking-header">
                                            <span class="flight-badge"><i class="fas fa-plane"></i> Flight <%= fNum %></span>
                                            <span class="status-badge <%= badgeClass %>"><%= status %></span>
                                        </div>
                                        <div class="route-info">
                                            <span><%= dep %></span>
                                            <i class="fas fa-long-arrow-alt-right" style="color: #6366f1;"></i>
                                            <span><%= arr %></span>
                                        </div>
                                        <div class="passenger-details">
                                            <div><strong>Passenger:</strong> <%= pName %></div>
                                            <div><strong>Age/Gender:</strong> <%= pAge %> yrs, <%= pGen %></div>
                                            <div><strong>Assigned Seat:</strong> <span style="color: #fbbf24; font-weight: bold;"><%= seat %></span></div>
                                            <div><strong>Booking Date:</strong> <%= bDate != null ? bDate.toString().substring(0, 16) : "N/A" %></div>
                                        </div>
                                        <div class="card-actions">
                                            <% if ("PAID".equalsIgnoreCase(status)) { %>
                                                <a href="printTicket.jsp?bookingId=<%= bId %>" target="_blank" class="btn-card btn-print">
                                                    <i class="fas fa-print"></i> Boarding Pass
                                                </a>
                                                <form action="profile.jsp" method="post" onsubmit="return confirmCancellation()" style="margin: 0; width: auto; display: inline;">
                                                    <input type="hidden" name="action" value="cancel">
                                                    <input type="hidden" name="bookingId" value="<%= bId %>">
                                                    <button type="submit" class="btn-card btn-cancel">
                                                        <i class="fas fa-times-circle"></i> Cancel Booking
                                                    </button>
                                                </form>
                                            <% } else if ("PENDING".equalsIgnoreCase(status)) { %>
                                                <form action="profile.jsp" method="post" onsubmit="return confirmCancellation()" style="margin: 0; width: auto; display: inline;">
                                                    <input type="hidden" name="action" value="cancel">
                                                    <input type="hidden" name="bookingId" value="<%= bId %>">
                                                    <button type="submit" class="btn-card btn-cancel">
                                                        <i class="fas fa-trash-alt"></i> Delete Order
                                                    </button>
                                                </form>
                                            <% } else { %>
                                                <span style="color: var(--text-secondary); font-size: 0.85rem; font-style: italic;"><i class="fas fa-info-circle"></i> Booking inactive</span>
                                            <% } %>
                                        </div>
                                    </div>
                        <%
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    if (bRs != null) try { bRs.close(); } catch(Exception e){}
                                    if (bPstmt != null) try { bPstmt.close(); } catch(Exception e){}
                                }
                            }
                        %>
                        
                        <% if (bookingsCount == 0) { %>
                            <div style="text-align: center; padding: 40px 20px; color: var(--text-secondary);">
                                <i class="fas fa-calendar-times" style="font-size: 3rem; margin-bottom: 15px; opacity: 0.5;"></i>
                                <p style="margin: 0; font-size: 1.1rem;">You don't have any bookings yet.</p>
                                <a href="index.jsp" class="btn-primary" style="display: inline-block; margin-top: 15px; text-decoration: none; padding: 10px 20px;">Book Flight Now</a>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script>
        // Update total booking counts badge
        document.getElementById('booking-count').textContent = '<%= bookingsCount %> records';
    </script>
</body>
</html>
<%
    // Cleanup resources
    if (uRs != null) try { uRs.close(); } catch(Exception e){}
    if (uPstmt != null) try { uPstmt.close(); } catch(Exception e){}
    if (con != null) try { con.close(); } catch(Exception e){}
%>
