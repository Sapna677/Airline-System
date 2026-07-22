<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="mypack.DatabaseUtil"%>
<%
    // Prevent back-caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    String searchVal = request.getParameter("searchVal");
    String departure = request.getParameter("departure");
    String arrival = request.getParameter("arrival");
    boolean isSearched = (searchVal != null && !searchVal.trim().isEmpty()) || (departure != null && !departure.trim().isEmpty() && arrival != null && !arrival.trim().isEmpty());

    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="ISO-8859-1">
    <title>Flight Status Tracker - SkyGlide Airways</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .search-container {
            display: flex;
            flex-direction: column;
            gap: 20px;
            margin-bottom: 30px;
        }
        .search-tab-header {
            display: flex;
            gap: 15px;
            margin-bottom: 10px;
            justify-content: center;
        }
        .tab-btn {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: var(--text-secondary);
            padding: 8px 18px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition-smooth);
        }
        .tab-btn.active {
            background: var(--accent-gradient);
            color: white;
            border-color: transparent;
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.35);
        }
        .search-form-group {
            display: flex;
            gap: 15px;
            align-items: flex-end;
            width: 100%;
        }
        @media (max-width: 768px) {
            .search-form-group {
                flex-direction: column;
                align-items: stretch;
            }
        }
        .status-pill {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            text-transform: uppercase;
        }
        .status-ontime {
            background: rgba(16, 185, 129, 0.15);
            border: 1px solid rgba(16, 185, 129, 0.4);
            color: #34d399;
        }
        .status-boarding {
            background: rgba(245, 158, 11, 0.15);
            border: 1px solid rgba(245, 158, 11, 0.4);
            color: #fbbf24;
        }
        .status-landed {
            background: rgba(99, 102, 241, 0.15);
            border: 1px solid rgba(99, 102, 241, 0.4);
            color: #a5b4fc;
        }
        .status-delayed {
            background: rgba(239, 68, 68, 0.15);
            border: 1px solid rgba(239, 68, 68, 0.4);
            color: #f87171;
        }
        .status-card {
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid rgba(255, 255, 255, 0.06);
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 15px;
            transition: var(--transition-smooth);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .status-card:hover {
            transform: translateY(-2px);
            border-color: rgba(99, 102, 241, 0.25);
            background: rgba(255, 255, 255, 0.04);
        }
        @media (max-width: 600px) {
            .status-card {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
        }
        .flight-main {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }
        .route-row {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.15rem;
            font-weight: 700;
        }
        .flight-meta {
            font-size: 0.85rem;
            color: var(--text-secondary);
        }
    </style>
    <script>
        function toggleSearchMode(mode) {
            const numForm = document.getElementById('search-num-form');
            const routeForm = document.getElementById('search-route-form');
            const numBtn = document.getElementById('tab-num');
            const routeBtn = document.getElementById('tab-route');

            if (mode === 'num') {
                numForm.style.display = 'block';
                routeForm.style.display = 'none';
                numBtn.classList.add('active');
                routeBtn.classList.remove('active');
            } else {
                numForm.style.display = 'none';
                routeForm.style.display = 'block';
                numBtn.classList.remove('active');
                routeBtn.classList.add('active');
            }
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
            <li><a href="flightStatus.jsp" class="active">Flight Status</a></li>
            <li><a href="baggageCalculator.jsp">Baggage</a></li>
            <li><a href="contact.jsp">Contact</a></li>
            <% if (session.getAttribute("email") != null) { %>
                <li><a href="profile.jsp"><i class="fas fa-user-circle"></i> Profile</a></li>
            <% } else { %>
                <li><a href="login.jsp">Login</a></li>
            <% } %>
        </ul>
    </nav>

    <div class="page-container" style="padding-top: 100px;">
        <main class="standalone-container" style="max-width: 850px; margin: 20px auto; padding: 30px;">
            <h1 style="text-align: center; margin-top: 0; font-size: 2.2rem; display: flex; align-items: center; justify-content: center; gap: 10px; margin-bottom: 25px;">
                <i class="fas fa-plane-departure" style="color: var(--accent-color);"></i> Live Flight Status Tracker
            </h1>

            <div class="glass-card" style="padding: 25px; margin-bottom: 30px;">
                <div class="search-tab-header">
                    <button id="tab-num" class="tab-btn <%= (departure == null) ? "active" : "" %>" onclick="toggleSearchMode('num')">
                        <i class="fas fa-search"></i> By Flight Number
                    </button>
                    <button id="tab-route" class="tab-btn <%= (departure != null) ? "active" : "" %>" onclick="toggleSearchMode('route')">
                        <i class="fas fa-exchange-alt"></i> By Route
                    </button>
                </div>

                <!-- Form Search By Flight Number -->
                <div id="search-num-form" style="display: <%= (departure == null) ? "block" : "none" %>;">
                    <form action="flightStatus.jsp" method="get" class="search-form-group" style="gap: 15px; margin: 0;">
                        <div style="flex: 2; text-align: left;">
                            <label for="searchVal" style="margin-bottom: 5px;">Enter Flight Number</label>
                            <input type="text" id="searchVal" name="searchVal" placeholder="e.g. SG102, SG105" value="<%= (searchVal != null) ? searchVal : "" %>" required>
                        </div>
                        <div style="flex: 1;">
                            <button type="submit" class="btn-primary" style="width: 100%; padding: 13px;"><i class="fas fa-search"></i> Check Status</button>
                        </div>
                    </form>
                </div>

                <!-- Form Search By Route -->
                <div id="search-route-form" style="display: <%= (departure != null) ? "block" : "none" %>;">
                    <form action="flightStatus.jsp" method="get" class="search-form-group" style="gap: 15px; margin: 0;">
                        <div style="flex: 1; text-align: left;">
                            <label for="departure" style="margin-bottom: 5px;">Departure Airport</label>
                            <input type="text" id="departure" name="departure" placeholder="e.g. Delhi" value="<%= (departure != null) ? departure : "" %>" required>
                        </div>
                        <div style="flex: 1; text-align: left;">
                            <label for="arrival" style="margin-bottom: 5px;">Arrival Airport</label>
                            <input type="text" id="arrival" name="arrival" placeholder="e.g. Patna" value="<%= (arrival != null) ? arrival : "" %>" required>
                        </div>
                        <div style="flex: 1;">
                            <button type="submit" class="btn-primary" style="width: 100%; padding: 13px;"><i class="fas fa-search"></i> Find Flights</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Search Results -->
            <% if (isSearched) { %>
                <div class="glass-card" style="padding: 25px;">
                    <h3 style="margin-top: 0; border-bottom: 1px solid rgba(255,255,255,0.08); padding-bottom: 12px; margin-bottom: 20px; text-align: left;">
                        <i class="fas fa-list-ul" style="color: #6366f1; margin-right: 6px;"></i> Active Search Results
                    </h3>

                    <div class="results-container">
                        <%
                            int resultsCount = 0;
                            try {
                                con = DatabaseUtil.getCon();
                                String query = "";
                                if (searchVal != null && !searchVal.trim().isEmpty()) {
                                    query = "SELECT flight_id, flight_number, departure, arrival, date, price FROM flights WHERE LOWER(flight_number) LIKE LOWER(?) ORDER BY date ASC";
                                    pstmt = con.prepareStatement(query);
                                    pstmt.setString(1, "%" + searchVal.trim() + "%");
                                } else {
                                    query = "SELECT flight_id, flight_number, departure, arrival, date, price FROM flights WHERE LOWER(departure) LIKE LOWER(?) AND LOWER(arrival) LIKE LOWER(?) ORDER BY date ASC";
                                    pstmt = con.prepareStatement(query);
                                    pstmt.setString(1, "%" + departure.trim() + "%");
                                    pstmt.setString(2, "%" + arrival.trim() + "%");
                                }

                                rs = pstmt.executeQuery();
                                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                String todayStr = sdf.format(new Date());

                                while (rs.next()) {
                                    resultsCount++;
                                    int fId = rs.getInt("flight_id");
                                    String fNum = rs.getString("flight_number");
                                    String dep = rs.getString("departure");
                                    String arr = rs.getString("arrival");
                                    String fDate = rs.getString("date");
                                    String price = rs.getString("price");

                                    // Determine status pill
                                    String statusText = "On Time";
                                    String statusClass = "status-ontime";
                                    String statusIcon = "fa-check-circle";

                                    int compare = fDate.compareTo(todayStr);
                                    if (compare < 0) {
                                        statusText = "Landed";
                                        statusClass = "status-landed";
                                        statusIcon = "fa-plane-arrival";
                                    } else if (compare == 0) {
                                        statusText = "Boarding";
                                        statusClass = "status-boarding";
                                        statusIcon = "fa-clock";
                                    } else {
                                        // Randomly simulate a slight delay for realism for 15% of future flights
                                        if (fId % 7 == 0) {
                                            statusText = "Delayed (20m)";
                                            statusClass = "status-delayed";
                                            statusIcon = "fa-exclamation-triangle";
                                        }
                                    }
                        %>
                                    <div class="status-card">
                                        <div class="flight-main">
                                            <div class="route-row">
                                                <span><%= dep %></span>
                                                <i class="fas fa-plane" style="color: #6366f1; font-size: 0.95rem; transform: rotate(45deg);"></i>
                                                <span><%= arr %></span>
                                            </div>
                                            <div class="flight-meta">
                                                <span>Flight: <strong><%= fNum %></strong></span> | 
                                                <span>Scheduled Date: <strong><%= fDate %></strong></span>
                                            </div>
                                        </div>

                                        <div style="display: flex; align-items: center; gap: 15px;">
                                            <span class="status-pill <%= statusClass %>">
                                                <i class="fas <%= statusIcon %>"></i> <%= statusText %>
                                            </span>
                                            
                                            <% if (compare >= 0) { %>
                                                <a href="searchFlights.jsp?departure=<%= dep %>&arrival=<%= arr %>" class="btn-primary" style="padding: 8px 16px; font-size: 0.8rem; text-decoration: none;">Book</a>
                                            <% } %>
                                        </div>
                                    </div>
                        <%
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            } finally {
                                if (rs != null) try { rs.close(); } catch(Exception e){}
                                if (pstmt != null) try { pstmt.close(); } catch(Exception e){}
                                if (con != null) try { con.close(); } catch(Exception e){}
                            }
                        %>

                        <% if (resultsCount == 0) { %>
                            <div style="text-align: center; padding: 30px 10px; color: var(--text-secondary);">
                                <i class="fas fa-plane-slash" style="font-size: 2.5rem; margin-bottom: 12px; opacity: 0.5;"></i>
                                <p style="margin: 0; font-size: 1rem;">No matching active flights found for your query.</p>
                            </div>
                        <% } %>
                    </div>
                </div>
            <% } else { %>
                <!-- Static Tracker Welcome Info -->
                <div class="glass-card" style="padding: 25px; text-align: left;">
                    <h3 style="margin-top: 0; color: white;"><i class="fas fa-info-circle" style="color: #6366f1; margin-right: 6px;"></i> How it works</h3>
                    <p style="color: var(--text-secondary); line-height: 1.6; margin-bottom: 0;">
                        Enter your flight number (e.g. <strong>SG102</strong>) or choose departure and destination routes to fetch real-time updates. The system tracks flight logs and updates boarding statuses dynamically to ensure you stay informed ahead of departure.
                    </p>
                </div>
            <% } %>
        </main>
    </div>
</body>
</html>
