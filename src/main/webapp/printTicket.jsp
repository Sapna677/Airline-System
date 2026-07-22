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

    String bookingIdStr = request.getParameter("bookingId");
    if (bookingIdStr == null || bookingIdStr.trim().isEmpty()) {
        out.println("<h3>Invalid Booking ID</h3>");
        return;
    }

    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String flightNumber = "", departure = "", arrival = "", seatNumber = "", passengerName = "", email = "", price = "", bookingDateStr = "";
    try {
        con = DatabaseUtil.getCon();
        String sql = "SELECT b.flight_number, b.departure, b.arrival, b.booking_date, b.seat_number, b.passenger_name, u.email, f.price " +
                     "FROM bookings b " +
                     "JOIN users u ON b.user_id = u.user_id " +
                     "LEFT JOIN flights f ON b.flight_id = f.flight_id " +
                     "WHERE b.booking_id = ? AND u.email = ?";
        pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(bookingIdStr));
        pstmt.setString(2, loggedInEmail);
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            flightNumber = rs.getString("flight_number");
            departure = rs.getString("departure");
            arrival = rs.getString("arrival");
            Timestamp ts = rs.getTimestamp("booking_date");
            bookingDateStr = ts != null ? ts.toString().substring(0, 10) : "N/A";
            seatNumber = rs.getString("seat_number");
            passengerName = rs.getString("passenger_name");
            email = rs.getString("email");
            price = rs.getString("price");
            if (price == null) price = "5000"; // Fallback default
        } else {
            out.println("<h3>Unauthorized Access or Booking Not Found</h3>");
            return;
        }
    } catch (Exception e) {
        out.println("<h3>Error: " + e.getMessage() + "</h3>");
        e.printStackTrace();
        return;
    } finally {
        if (rs != null) try { rs.close(); } catch(Exception e){}
        if (pstmt != null) try { pstmt.close(); } catch(Exception e){}
        if (con != null) try { con.close(); } catch(Exception e){}
    }

    // Generate random PNR and Gate for boarding pass
    String pnr = "SG" + Math.random().toString(36).substr(2, 4).toUpperCase();
    String gate = "G" + (int)(Math.random() * 18 + 1);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Reprint Boarding Pass - SkyGlide Airways</title>
    <style>
        body {
            background-color: #f3f4f6;
            margin: 0;
            padding: 40px 20px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .ticket-container {
            width: 100%;
            max-width: 820px;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            padding: 20px;
            box-sizing: border-box;
        }
        .boarding-pass {
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            display: flex;
            width: 100%;
            background: #ffffff;
            box-shadow: 0 4px 10px rgba(0,0,0,0.02);
            overflow: hidden;
            box-sizing: border-box;
        }
        .main-pass {
            flex: 2;
            padding: 25px;
            border-right: 2px dashed #e5e7eb;
            box-sizing: border-box;
        }
        .stub-pass {
            flex: 1;
            padding: 25px;
            background: #fafafa;
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 2px solid #6366f1;
            padding-bottom: 12px;
            margin-bottom: 20px;
        }
        .header h1 {
            margin: 0;
            font-size: 1.3rem;
            color: #6366f1;
            font-weight: 800;
            letter-spacing: 1px;
        }
        .header span {
            font-size: 11px;
            background: #6366f1;
            color: white;
            padding: 3px 8px;
            border-radius: 4px;
            font-weight: bold;
            text-transform: uppercase;
        }
        .route-section {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
            margin-bottom: 25px;
        }
        .route-code {
            font-size: 24px;
            font-weight: 800;
            color: #111827;
        }
        .route-plane {
            font-size: 20px;
            color: #6366f1;
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
            font-size: 9px;
            color: #6b7280;
            text-transform: uppercase;
            font-weight: 600;
            letter-spacing: 0.5px;
        }
        .value {
            font-size: 14px;
            font-weight: 700;
            color: #111827;
            margin-top: 3px;
        }
        .highlight-row {
            background: #6366f1;
            color: white;
            display: flex;
            justify-content: space-around;
            padding: 10px;
            border-radius: 8px;
            margin-top: 15px;
        }
        .highlight-box {
            text-align: center;
        }
        .highlight-box .label {
            color: #e0e7ff;
            font-weight: 600;
        }
        .highlight-box .value {
            color: white;
            font-size: 16px;
            font-weight: bold;
        }
        .barcode {
            font-family: monospace;
            font-size: 1.25rem;
            letter-spacing: 3px;
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
            font-size: 12px;
            text-transform: uppercase;
            text-align: center;
        }
        .row {
            margin-bottom: 12px;
            display: flex;
            justify-content: space-between;
        }
        .row .label {
            font-size: 9px;
            color: #6b7280;
        }
        .row .value {
            font-size: 12px;
            font-weight: 700;
            color: #111827;
        }
        .print-btn-bar {
            margin-top: 20px;
            text-align: center;
        }
        .print-btn {
            background: #6366f1;
            color: white;
            border: none;
            padding: 10px 24px;
            font-size: 0.95rem;
            font-weight: 600;
            border-radius: 8px;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.25);
            transition: all 0.2s ease;
        }
        .print-btn:hover {
            background: #4f46e5;
        }
        @media print {
            body {
                background-color: white;
                padding: 0;
            }
            .print-btn-bar {
                display: none;
            }
            .ticket-container {
                box-shadow: none;
                padding: 0;
            }
        }
    </style>
</head>
<body>
    <div class="ticket-container">
        <div class="boarding-pass">
            <!-- Main Coupon -->
            <div class="main-pass">
                <div class="header">
                    <h1>SKYGLIDE AIRWAYS</h1>
                    <span>Boarding Pass</span>
                </div>
                
                <div class="route-section">
                    <span class="route-code"><%= departure.substring(0,3).toUpperCase() %></span>
                    <span class="route-plane">&#9992;</span>
                    <span class="route-code"><%= arrival.substring(0,3).toUpperCase() %></span>
                </div>

                <div class="info-grid">
                    <div class="info-box">
                        <span class="label">Passenger Name</span>
                        <span class="value"><%= passengerName.toUpperCase() %></span>
                    </div>
                    <div class="info-box">
                        <span class="label">Email Contact</span>
                        <span class="value"><%= email %></span>
                    </div>
                    <div class="info-box">
                        <span class="label">Date</span>
                        <span class="value"><%= bookingDateStr %></span>
                    </div>
                    <div class="info-box">
                        <span class="label">Booking Status</span>
                        <span class="value" style="color: #10b981;">PAID</span>
                    </div>
                </div>

                <div class="highlight-row">
                    <div class="highlight-box">
                        <span class="label">Flight</span>
                        <span class="value"><%= flightNumber %></span>
                    </div>
                    <div class="highlight-box">
                        <span class="label">Gate</span>
                        <span class="value"><%= gate %></span>
                    </div>
                    <div class="highlight-box">
                        <span class="label">Seat</span>
                        <span class="value"><%= seatNumber %></span>
                    </div>
                    <div class="highlight-box">
                        <span class="label">PNR Number</span>
                        <span class="value"><%= pnr %></span>
                    </div>
                </div>

                <div class="barcode">
                    || |||| ||| | ||| |||| | ||| || ||| |||| || ||
                    <div style="font-size: 10px; letter-spacing: 0px; margin-top: 3px;">PNR REFERENCE: <%= pnr %></div>
                </div>
            </div>

            <!-- Stub Coupon -->
            <div class="stub-pass">
                <div>
                    <div class="stub-header">Passenger Coupon</div>
                    <div class="row">
                        <span class="label">Passenger</span>
                        <span class="value"><%= passengerName.toUpperCase() %></span>
                    </div>
                    <div class="row">
                        <span class="label">Flight / Seat</span>
                        <span class="value"><%= flightNumber %> / <%= seatNumber %></span>
                    </div>
                    <div class="row">
                        <span class="label">Gate</span>
                        <span class="value"><%= gate %></span>
                    </div>
                    <div class="row">
                        <span class="label">From / To</span>
                        <span class="value"><%= departure.substring(0,3).toUpperCase() %> &rarr; <%= arrival.substring(0,3).toUpperCase() %></span>
                    </div>
                    <div class="row">
                        <span class="label">Total Paid</span>
                        <span class="value" style="color: #6366f1;">INR <%= price %></span>
                    </div>
                </div>
                <div style="text-align: center; border-top: 1px dashed #ddd; padding-top: 15px; font-size: 9px; color: #6b7280; font-weight: 600;">
                    Have a Pleasant Flight!<br>
                    SkyGlide Airways
                </div>
            </div>
        </div>
        
        <div class="print-btn-bar">
            <button class="print-btn" onclick="window.print()"><i class="fas fa-print"></i> Print Boarding Pass</button>
        </div>
    </div>

    <script>
        // Trigger print dialog on load
        window.addEventListener('load', () => {
            setTimeout(() => {
                window.print();
            }, 600);
        });
    </script>
</body>
</html>
