<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%
    // Prevent caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="ISO-8859-1">
    <title>Baggage Allowance & Excess Fee Calculator - SkyGlide Airways</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .calculator-grid {
            display: grid;
            grid-template-columns: 1.2fr 0.8fr;
            gap: 30px;
            align-items: start;
        }
        @media (max-width: 900px) {
            .calculator-grid {
                grid-template-columns: 1fr;
            }
        }
        .slider-group {
            margin-bottom: 25px;
            text-align: left;
        }
        .slider-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        .slider-label {
            font-size: 0.95rem;
            font-weight: 700;
            color: white;
        }
        .slider-val {
            font-size: 1.15rem;
            font-weight: 800;
            color: #6366f1;
            font-family: 'Outfit', sans-serif;
        }
        input[type="range"] {
            width: 100%;
            height: 8px;
            border-radius: 4px;
            background: rgba(255, 255, 255, 0.1);
            outline: none;
            -webkit-appearance: none;
            cursor: pointer;
        }
        input[type="range"]::-webkit-slider-thumb {
            -webkit-appearance: none;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            background: linear-gradient(135deg, #6366f1, #4f46e5);
            border: 2px solid white;
            box-shadow: 0 2px 6px rgba(99, 102, 241, 0.4);
            transition: transform 0.1s ease;
        }
        input[type="range"]::-webkit-slider-thumb:hover {
            transform: scale(1.2);
        }
        .class-selector {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
            margin-bottom: 25px;
        }
        .class-card-btn {
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid rgba(255, 255, 255, 0.06);
            border-radius: 12px;
            padding: 15px 10px;
            cursor: pointer;
            text-align: center;
            transition: var(--transition-smooth);
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
        }
        .class-card-btn i {
            font-size: 1.4rem;
            color: var(--text-secondary);
            transition: var(--transition-smooth);
        }
        .class-card-btn span {
            font-size: 0.85rem;
            font-weight: 700;
            color: var(--text-secondary);
        }
        .class-card-btn.active {
            background: rgba(99, 102, 241, 0.15);
            border-color: #6366f1;
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.15);
        }
        .class-card-btn.active i {
            color: #a5b4fc;
            transform: scale(1.1);
        }
        .class-card-btn.active span {
            color: white;
        }
        .summary-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            font-size: 0.95rem;
        }
        .summary-row:last-child {
            border-bottom: none;
            padding-top: 15px;
            font-weight: 800;
            font-size: 1.2rem;
            color: white;
        }
        .charge-badge {
            background: rgba(239, 68, 68, 0.15);
            border: 1px solid rgba(239, 68, 68, 0.35);
            color: #f87171;
            padding: 2px 8px;
            border-radius: 6px;
            font-size: 0.8rem;
            font-weight: bold;
        }
        .allowance-info {
            background: rgba(16, 185, 129, 0.08);
            border: 1px solid rgba(16, 185, 129, 0.2);
            padding: 15px;
            border-radius: 12px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
            color: #34d399;
            font-size: 0.9rem;
            font-weight: 500;
        }
    </style>
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
            <li><a href="baggageCalculator.jsp" class="active">Baggage</a></li>
            <li><a href="contact.jsp">Contact</a></li>
            <% if (session.getAttribute("email") != null) { %>
                <li><a href="profile.jsp"><i class="fas fa-user-circle"></i> Profile</a></li>
            <% } else { %>
                <li><a href="login.jsp">Login</a></li>
            <% } %>
        </ul>
    </nav>

    <div class="page-container" style="padding-top: 100px;">
        <main class="standalone-container" style="max-width: 950px; margin: 20px auto; padding: 30px;">
            
            <h1 style="text-align: center; margin-top: 0; font-size: 2.2rem; display: flex; align-items: center; justify-content: center; gap: 12px; margin-bottom: 25px;">
                <i class="fas fa-suitcase-rolling" style="color: var(--accent-color);"></i> Baggage Allowance & Excess Fee Calculator
            </h1>

            <div class="calculator-grid">
                <!-- Inputs Section -->
                <div class="glass-card" style="padding: 25px; margin: 0;">
                    <h3 style="margin-top: 0; margin-bottom: 20px; text-align: left; color: white;">
                        <i class="fas fa-sliders-h" style="color: #6366f1; margin-right: 6px;"></i> Configure Weight Inputs
                    </h3>

                    <!-- Select Class -->
                    <div style="text-align: left; margin-bottom: 10px;">
                        <label style="margin-bottom: 8px;">Select Travel Class</label>
                    </div>
                    <div class="class-selector">
                        <button type="button" id="btn-eco" class="class-card-btn active" onclick="selectClass('economy')">
                            <i class="fas fa-chair"></i>
                            <span>Economy</span>
                        </button>
                        <button type="button" id="btn-biz" class="class-card-btn" onclick="selectClass('business')">
                            <i class="fas fa-briefcase"></i>
                            <span>Business</span>
                        </button>
                        <button type="button" id="btn-first" class="class-card-btn" onclick="selectClass('first')">
                            <i class="fas fa-crown"></i>
                            <span>First Class</span>
                        </button>
                    </div>

                    <!-- Allowance Display Banner -->
                    <div id="allowance-banner" class="allowance-info">
                        <i class="fas fa-check-circle" style="font-size: 1.25rem;"></i>
                        <span id="allowance-text">Economy Allowance: 15kg Check-in | 7kg Cabin</span>
                    </div>

                    <!-- Check-in Weight Slider -->
                    <div class="slider-group">
                        <div class="slider-header">
                            <span class="slider-label"><i class="fas fa-luggage-cart" style="margin-right: 5px; color: #a5b4fc;"></i> Check-in Baggage</span>
                            <span id="val-checkin" class="slider-val">15 kg</span>
                        </div>
                        <input type="range" id="input-checkin" min="0" max="60" value="15" oninput="calculateExcess()">
                    </div>

                    <!-- Cabin Weight Slider -->
                    <div class="slider-group">
                        <div class="slider-header">
                            <span class="slider-label"><i class="fas fa-suitcase" style="margin-right: 5px; color: #a5b4fc;"></i> Cabin Baggage (Handbag)</span>
                            <span id="val-cabin" class="slider-val">7 kg</span>
                        </div>
                        <input type="range" id="input-cabin" min="0" max="25" value="7" oninput="calculateExcess()">
                    </div>
                </div>

                <!-- Summary Section -->
                <div class="glass-card" style="padding: 25px; margin: 0; background: rgba(15, 23, 42, 0.85);">
                    <h3 style="margin-top: 0; margin-bottom: 20px; text-align: left; color: white;">
                        <i class="fas fa-receipt" style="color: #10b981; margin-right: 6px;"></i> Fee Summary
                    </h3>

                    <div class="summary-row">
                        <span style="color: var(--text-secondary);">Travel Class</span>
                        <span id="summary-class" style="color: white; font-weight: bold; text-transform: capitalize;">Economy</span>
                    </div>

                    <!-- Checkin summary -->
                    <div class="summary-row">
                        <span style="color: var(--text-secondary);">Check-in Weight</span>
                        <span id="summary-checkin">15 kg</span>
                    </div>
                    <div class="summary-row">
                        <span style="color: var(--text-secondary);">Check-in Allowance</span>
                        <span id="summary-checkin-allow">15 kg</span>
                    </div>
                    <div class="summary-row">
                        <span style="color: var(--text-secondary);">Excess Check-in</span>
                        <span id="summary-checkin-excess">0 kg</span>
                    </div>
                    <div class="summary-row">
                        <span style="color: var(--text-secondary);">Check-in Rate</span>
                        <span id="summary-checkin-rate">INR 450 / kg</span>
                    </div>

                    <!-- Cabin summary -->
                    <div class="summary-row" style="margin-top: 15px; border-top: 1px dashed rgba(255,255,255,0.06); padding-top: 15px;">
                        <span style="color: var(--text-secondary);">Cabin Weight</span>
                        <span id="summary-cabin">7 kg</span>
                    </div>
                    <div class="summary-row">
                        <span style="color: var(--text-secondary);">Cabin Allowance</span>
                        <span id="summary-cabin-allow">7 kg</span>
                    </div>
                    <div class="summary-row">
                        <span style="color: var(--text-secondary);">Excess Cabin</span>
                        <span id="summary-cabin-excess">0 kg</span>
                    </div>
                    <div class="summary-row">
                        <span style="color: var(--text-secondary);">Cabin Rate</span>
                        <span id="summary-cabin-rate">INR 550 / kg</span>
                    </div>

                    <!-- Totals -->
                    <div class="summary-row" style="margin-top: 20px; border-top: 2px solid rgba(255,255,255,0.15); padding-top: 15px;">
                        <span>Total Excess Fee</span>
                        <span id="summary-total" style="color: #fbbf24; font-size: 1.4rem;">INR 0</span>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script>
        // Configuration parameters
        const config = {
            economy: { checkinAllow: 15, cabinAllow: 7, checkinRate: 450, cabinRate: 550 },
            business: { checkinAllow: 25, cabinAllow: 9, checkinRate: 600, cabinRate: 700 },
            first: { checkinAllow: 35, cabinAllow: 12, checkinRate: 800, cabinRate: 900 }
        };

        let activeClass = 'economy';

        function selectClass(className) {
            activeClass = className;
            
            // Toggle active classes on buttons
            document.getElementById('btn-eco').classList.remove('active');
            document.getElementById('btn-biz').classList.remove('active');
            document.getElementById('btn-first').classList.remove('active');

            if (className === 'economy') {
                document.getElementById('btn-eco').classList.add('active');
            } else if (className === 'business') {
                document.getElementById('btn-biz').classList.add('active');
            } else {
                document.getElementById('btn-first').classList.add('active');
            }

            // Update allowances banner text
            const allow = config[activeClass];
            document.getElementById('allowance-text').textContent = 
                `${className.charAt(0).toUpperCase() + className.slice(1)} Allowance: ${allow.checkinAllow}kg Check-in | ${allow.cabinAllow}kg Cabin`;

            // Reset sliders to default allowances
            document.getElementById('input-checkin').value = allow.checkinAllow;
            document.getElementById('input-cabin').value = allow.cabinAllow;

            calculateExcess();
        }

        function calculateExcess() {
            const checkinVal = parseInt(document.getElementById('input-checkin').value);
            const cabinVal = parseInt(document.getElementById('input-cabin').value);
            const allow = config[activeClass];

            // Update range labels
            document.getElementById('val-checkin').textContent = `${checkinVal} kg`;
            document.getElementById('val-cabin').textContent = `${cabinVal} kg`;

            // Compute excess
            const checkinExcess = Math.max(0, checkinVal - allow.checkinAllow);
            const cabinExcess = Math.max(0, cabinVal - allow.cabinAllow);

            // Compute charges
            const checkinCharge = checkinExcess * allow.checkinRate;
            const cabinCharge = cabinExcess * allow.cabinRate;
            const totalCharge = checkinCharge + cabinCharge;

            // Update summary cards
            document.getElementById('summary-class').textContent = activeClass;
            document.getElementById('summary-checkin').textContent = `${checkinVal} kg`;
            document.getElementById('summary-checkin-allow').textContent = `${allow.checkinAllow} kg`;
            document.getElementById('summary-checkin-excess').innerHTML = checkinExcess > 0 ? `<span class="charge-badge">+${checkinExcess} kg</span>` : `0 kg`;
            document.getElementById('summary-checkin-rate').textContent = `INR ${allow.checkinRate} / kg`;

            document.getElementById('summary-cabin').textContent = `${cabinVal} kg`;
            document.getElementById('summary-cabin-allow').textContent = `${allow.cabinAllow} kg`;
            document.getElementById('summary-cabin-excess').innerHTML = cabinExcess > 0 ? `<span class="charge-badge">+${cabinExcess} kg</span>` : `0 kg`;
            document.getElementById('summary-cabin-rate').textContent = `INR ${allow.cabinRate} / kg`;

            document.getElementById('summary-total').textContent = `INR ${totalCharge}`;
        }

        // Initialize calculations
        window.addEventListener('load', () => {
            calculateExcess();
        });
    </script>
</body>
</html>
