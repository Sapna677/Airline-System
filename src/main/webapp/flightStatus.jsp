<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="mypack.DatabaseUtil"%>
<!DOCTYPE html>
<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="ISO-8859-1">
    <title>Flight Status - SkyGlide Airways</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .status-badge {
            padding: 5px 10px;
            border-radius: 6px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
        }
        .status-ontime {
            background: rgba(16, 185, 129, 0.15);
            color: #10b981;
            border: 1px solid rgba(16, 185, 129, 0.3);
        }
        .status-delayed {
            background: rgba(245, 158, 11, 0.15);
            color: #f59e0b;
            border: 1px solid rgba(245, 158, 11, 0.3);
        }
        .status-arrived {
            background: rgba(99, 102, 241, 0.15);
            color: #6366f1;
            border: 1px solid rgba(99, 102, 241, 0.3);
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
        <main class="standalone-container" style="max-width: 900px; margin: 20px auto; padding: 25px;">
            <h1 style="text-align: center; font-size: 2.2rem; margin-bottom: 5px;"><i class="fa-solid fa-signal"></i> Flight Status Board</h1>
            <p style="text-align: center; color: var(--text-secondary); margin-bottom: 30px;">Track real-time flight status and departure updates.</p>

            <form action="flightStatus.jsp" method="get" style="display: flex; gap: 15px; margin-bottom: 30px; max-width: 600px; padding: 15px; background: rgba(255, 255, 255, 0.02); border-radius: 12px; border: 1px solid rgba(255, 255, 255, 0.05);">
                <div style="flex: 2; text-align: left;">
                    <label for="flightNumber" style="font-size: 0.85rem; margin-bottom: 5px; display: block; color: var(--text-secondary);">Flight Number</label>
                    <input type="text" id="flightNumber" name="flightNumber" placeholder="e.g. 101" style="width: 100%; padding: 10px; margin-bottom: 0; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); border-radius: 6px; color: white;">
                </div>
                <div style="flex: 1; display: flex; align-items: flex-end;">
                    <input type="submit" value="Search Status" class="btn-primary" style="width: 100%; padding: 11px; margin-top: 0;">
                </div>
            </form>

            <%
                String flightNumber = request.getParameter("flightNumber");
                Connection con = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;

                try {
                    con = DatabaseUtil.getCon();
                    String query = "SELECT flight_id, flight_number, departure, arrival, date, price FROM flights";
                    if (flightNumber != null && !flightNumber.trim().isEmpty()) {
                        query += " WHERE flight_number = ?";
                        pstmt = con.prepareStatement(query);
                        pstmt.setString(1, flightNumber.trim());
                    } else {
                        pstmt = con.prepareStatement(query);
                    }

                    rs = pstmt.executeQuery();
            %>
            <div class="table-container" style="width: 100% !important; margin: 0 auto !important;">
                <table class="premium-table">
                    <thead>
                        <tr>
                            <th>Flight ID</th>
                            <th>Flight Number</th>
                            <th>Departure</th>
                            <th>Arrival</th>
                            <th>Scheduled Time</th>
                            <th>Real-Time Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            boolean hasFlights = false;
                            long now = System.currentTimeMillis();
                            while (rs.next()) {
                                hasFlights = true;
                                int fid = rs.getInt("flight_id");
                                String fnum = rs.getString("flight_number");
                                String dep = rs.getString("departure");
                                String arr = rs.getString("arrival");
                                Timestamp fdate = rs.getTimestamp("date");

                                // Determine Status
                                String statusStr = "On-Time";
                                String badgeClass = "status-ontime";
                                
                                if (fdate != null) {
                                    long ftime = fdate.getTime();
                                    if (ftime < now) {
                                        statusStr = "Arrived";
                                        badgeClass = "status-arrived";
                                    } else if (ftime - now < 7200000) { // within 2 hours
                                        statusStr = "Boarding";
                                        badgeClass = "status-delayed";
                                    } else if (fid % 5 == 0) { // simulate some delays
                                        statusStr = "Delayed (20m)";
                                        badgeClass = "status-delayed";
                                    }
                                }
                        %>
                        <tr>
                            <td><%= fid %></td>
                            <td>Flight #<%= fnum %></td>
                            <td><%= dep %></td>
                            <td><%= arr %></td>
                            <td><%= fdate != null ? fdate.toString() : "N/A" %></td>
                            <td>
                                <span class="status-badge <%= badgeClass %>"><%= statusStr %></span>
                            </td>
                        </tr>
                        <%
                            }
                            if (!hasFlights) {
                        %>
                        <tr>
                            <td colspan="6" style="padding: 30px; text-align: center; color: var(--text-secondary);">No flights matching search query.</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <%
                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<p style='color: #ef4444;'>Error loading flight status: " + e.getMessage() + "</p>");
                } finally {
                    if (rs != null) try { rs.close(); } catch(Exception e){}
                    if (pstmt != null) try { pstmt.close(); } catch(Exception e){}
                    if (con != null) try { con.close(); } catch(Exception e){}
                }
            %>
        </main>
    </div>
</body>
</html>
