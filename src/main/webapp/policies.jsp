<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="UTF-8">
    <title>Policies | SkyGlide Airways</title>
    <!-- FontAwesome & Style Sheets -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg==" crossorigin="anonymous" referrerpolicy="no-referrer">
    <link rel="stylesheet" href="css/style.css">
    
    <style>
        .policies-header {
            margin-bottom: 40px;
            text-align: center;
        }

        .policies-header p {
            font-size: 1.1rem;
            color: var(--text-secondary);
            max-width: 650px;
            margin: 15px auto 0;
            line-height: 1.6;
        }

        /* Tabs Interface */
        .policy-tabs {
            display: flex;
            border-bottom: 1px solid var(--card-border);
            margin-bottom: 30px;
            gap: 15px;
            overflow-x: auto;
            padding-bottom: 5px;
        }

        .tab-btn {
            background: transparent;
            border: none;
            color: var(--text-secondary);
            font-size: 1.05rem;
            font-weight: 600;
            padding: 12px 20px;
            cursor: pointer;
            transition: var(--transition-smooth);
            border-bottom: 2px solid transparent;
            white-space: nowrap;
            font-family: inherit;
        }

        .tab-btn:hover {
            color: white;
        }

        .tab-btn.active {
            color: #a5b4fc;
            border-bottom-color: var(--accent-color);
        }

        /* Policy Contents panels */
        .policy-panel {
            display: none;
            opacity: 0;
            transform: translateY(10px);
            transition: all 0.4s ease;
        }

        .policy-panel.active {
            display: block;
            opacity: 1;
            transform: translateY(0);
        }

        .policy-panel h3 {
            color: white;
            font-size: 1.5rem;
            margin-bottom: 20px;
            font-weight: 700;
        }

        /* Policy Tables */
        .policy-table {
            width: 100%;
            border-collapse: collapse;
            margin: 25px 0;
            font-size: 0.95rem;
        }

        .policy-table th, .policy-table td {
            padding: 14px 18px;
            text-align: left;
            border-bottom: 1px solid var(--card-border);
        }

        .policy-table th {
            background: rgba(255, 255, 255, 0.04);
            color: white;
            font-weight: 700;
        }

        .policy-table td {
            color: var(--text-secondary);
        }

        .policy-table tr:hover {
            background: rgba(255, 255, 255, 0.02);
        }

        .policy-card {
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid var(--card-border);
            border-radius: var(--border-radius-md);
            padding: 22px;
            margin-bottom: 20px;
        }

        .policy-card h4 {
            color: white;
            font-size: 1.1rem;
            margin-bottom: 10px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .policy-card h4 i {
            color: var(--accent-color);
        }

        .policy-card p {
            color: var(--text-secondary);
            font-size: 0.95rem;
            margin: 0;
            line-height: 1.5;
        }

        /* Light theme adjustments */
        body.light-theme .tab-btn.active {
            color: #4f46e5;
        }

        body.light-theme .policy-panel h3, 
        body.light-theme .policy-card h4,
        body.light-theme .policy-table th {
            color: #0f172a;
        }

        body.light-theme .policy-table th {
            background: rgba(0, 0, 0, 0.04);
        }

        body.light-theme .policy-card {
            background: rgba(0, 0, 0, 0.015);
        }
    </style>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            // Theme toggle script injection
            if (!document.querySelector('link[href*="font-awesome"]') && !document.querySelector('link[href*="all.min.css"]')) {
                const faLink = document.createElement('link');
                faLink.rel = 'stylesheet';
                faLink.href = 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css';
                document.head.appendChild(faLink);
            }

            const savedTheme = localStorage.getItem('theme') || 'dark';
            if (savedTheme === 'light') {
                document.body.classList.add('light-theme');
            }

            const toggleBtn = document.createElement('button');
            toggleBtn.id = 'theme-toggle-btn';
            toggleBtn.innerHTML = savedTheme === 'light' ? '<i class="fas fa-moon"></i>' : '<i class="fas fa-sun"></i>';
            toggleBtn.title = 'Switch Theme';
            
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

            toggleBtn.addEventListener('mouseenter', () => {
                toggleBtn.style.transform = 'scale(1.1) translateY(-3px)';
                toggleBtn.style.boxShadow = '0 12px 35px rgba(99, 102, 241, 0.45)';
            });
            toggleBtn.addEventListener('mouseleave', () => {
                toggleBtn.style.transform = 'scale(1) translateY(0)';
                toggleBtn.style.boxShadow = '0 8px 30px rgba(0, 0, 0, 0.35)';
            });

            toggleBtn.addEventListener('click', () => {
                const isLight = document.body.classList.toggle('light-theme');
                localStorage.setItem('theme', isLight ? 'light' : 'dark');
                toggleBtn.innerHTML = isLight ? '<i class="fas fa-moon"></i>' : '<i class="fas fa-sun"></i>';
                toggleBtn.style.transform = 'scale(0.9)';
                setTimeout(() => {
                    toggleBtn.style.transform = 'scale(1)';
                }, 100);
            });

            document.body.appendChild(toggleBtn);

            // Dynamic Branding: SkyGlide Airways
            const logoDiv = document.querySelector('nav .logo');
            if (logoDiv && !logoDiv.querySelector('.logo-text')) {
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
    <!-- Background overlay -->
    <div style="position: fixed; top: 0; left: 0; min-width: 100%; min-height: 100%; z-index: -2; background: url('al2.jpg') no-repeat center fixed; background-size: cover;"></div>
    <div class="bg-overlay" style="position: fixed; top: 0; left: 0; min-width: 100%; min-height: 100%; z-index: -1; background: rgba(15, 23, 42, 0.85); backdrop-filter: blur(2px);"></div>

    <!-- Header Navigation -->
    <nav>
        <div class="logo">
            <img alt="Airline Logo" src="download.png">
        </div>
        <ul>
            <li><a href="index.jsp">Home</a></li>
            <li><a href="searchFlights.jsp">Search Flights</a></li>
            <li><a href="flightStatus.jsp">Flight Status</a></li>
            <li><a href="contact.jsp">Contact</a></li>
            <li><a href="about.jsp">About</a></li>
        </ul>
    </nav>

    <!-- Page Container -->
    <div class="page-container">
        <main class="standalone-container" style="max-width: 950px; margin-top: 40px; margin-bottom: 40px;">
            <div class="policies-header">
                <h2>Airline Corporate Policies</h2>
                <p>Learn about SkyGlide Airways' guidelines regarding baggage limits, flight cancellation rules, and how we safeguard customer privacy.</p>
            </div>

            <!-- Tabs buttons -->
            <div class="policy-tabs">
                <button class="tab-btn active" data-tab="baggage">Baggage Allowance</button>
                <button class="tab-btn" data-tab="cancellation">Cancellation & Refund</button>
                <button class="tab-btn" data-tab="privacy">Privacy & Security</button>
            </div>

            <!-- Tab 1: Baggage Policy -->
            <div class="policy-panel active" id="tab-baggage">
                <h3>Baggage Rules & Charge Rates</h3>
                <p>SkyGlide Airways has set standard baggage limitations to ensure the safety and balance configurations of our narrow-body fleet.</p>
                
                <table class="policy-table">
                    <thead>
                        <tr>
                            <th>Baggage Category</th>
                            <th>Weight Allowance</th>
                            <th>Dimension Limits</th>
                            <th>Excess Fee Rate</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Cabin / Hand Baggage</td>
                            <td>7 kg (1 Unit)</td>
                            <td>55cm x 35cm x 25cm</td>
                            <td>Not Permitted (Must Check-In)</td>
                        </tr>
                        <tr>
                            <td>Checked Baggage</td>
                            <td>15 kg (1 Piece)</td>
                            <td>H+W+L not exceeding 158cm</td>
                            <td>₹550 per Kilogram</td>
                        </tr>
                        <tr>
                            <td>Infant Baggage</td>
                            <td>7 kg (Checked)</td>
                            <td>Standard small piece</td>
                            <td>Standard rates apply</td>
                        </tr>
                    </tbody>
                </table>

                <div class="policy-card">
                    <h4><i class="fas fa-info-circle"></i> Special Luggage Notice</h4>
                    <p>Sporting kits, musical instruments, and oversized gear exceeding 158 cm total dimensions must be pre-declared at booking or customer desk and are subject to flat handling charges of ₹2,500 per item.</p>
                </div>
            </div>

            <!-- Tab 2: Cancellation Policy -->
            <div class="policy-panel" id="tab-cancellation">
                <h3>Flight Cancellations & Refunds Matrix</h3>
                <p>Refunds are calculated based on the timestamp of your request relative to your flight's scheduled departure time.</p>

                <table class="policy-table">
                    <thead>
                        <tr>
                            <th>Cancellation Request Time</th>
                            <th>Cancellation Deductions</th>
                            <th>Refundable Portion</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>More than 72 hours prior</td>
                            <td>Flat fee of ₹1,500</td>
                            <td>Remaining ticket fare refunded</td>
                        </tr>
                        <tr>
                            <td>24 to 72 hours prior</td>
                            <td>Flat fee of ₹2,500</td>
                            <td>Remaining ticket fare refunded</td>
                        </tr>
                        <tr>
                            <td>2 to 24 hours prior</td>
                            <td>Fee of ₹3,500 or 50% fare (whichever is higher)</td>
                            <td>Tax portion + remaining refunded</td>
                        </tr>
                        <tr>
                            <td>Less than 2 hours (No Show)</td>
                            <td>100% of Ticket Fare</td>
                            <td>Government Taxes portion only</td>
                        </tr>
                    </tbody>
                </table>

                <div class="policy-card">
                    <h4><i class="fas fa-history"></i> Auto-Refund Mechanism</h4>
                    <p>In case of flight delays exceeding 4 hours or complete cancellations initiated by SkyGlide Airways due to weather or operational grounds, a 100% refund of fares will be credited to the original booking account without fees, or alternative flights will be allocated free of cost.</p>
                </div>
            </div>

            <!-- Tab 3: Privacy Policy -->
            <div class="policy-panel" id="tab-privacy">
                <h3>Privacy Statement & Data Safety</h3>
                <p>We are dedicated to safeguarding passenger personal details and billing credentials in accordance with Indian information technology acts.</p>
                
                <div class="support-info-cards" style="margin-top: 20px;">
                    <div class="policy-card">
                        <h4><i class="fas fa-shield-alt"></i> Secure Payments</h4>
                        <p>We do not store complete debit/credit card CVVs or net banking credentials in our main servers. Transactions are routed securely through PCI-DSS compliant token gateways.</p>
                    </div>

                    <div class="policy-card">
                        <h4><i class="fas fa-database"></i> Data Collection Limit</h4>
                        <p>Passenger information (such as names, emails, phone numbers, and addresses) is used strictly for generating flight tickets, boarding passes, refund updates, and booking confirmations.</p>
                    </div>

                    <div class="policy-card">
                        <h4><i class="fas fa-lock"></i> Account Encryptions</h4>
                        <p>Passwords stored in our databases are protected using cryptographic hashing algorithms, preventing data leakages even in cases of unauthorized system penetrations.</p>
                    </div>
                </div>
            </div>
        </main>

        <!-- Footer -->
        <footer>
            <div class="footer-content">
                <div class="footer-section">
                    <h3>About Us</h3>
                    <ul>
                        <li><a href="about.jsp"><i class="fas fa-info-circle"></i> Company Info</a></li>
                        <li><a href="careers.jsp"><i class="fas fa-briefcase"></i> Careers</a></li>
                        <li><a href="news.jsp"><i class="fas fa-newspaper"></i> News</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h3>Contact Us</h3>
                    <ul>
                        <li><a href="contact.jsp"><i class="fas fa-phone-alt"></i> Customer Service</a></li>
                        <li><a href="feedback.jsp"><i class="fas fa-comments"></i> Feedback</a></li>
                        <li><a href="support.jsp"><i class="fas fa-life-ring"></i> Support</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h3>Help</h3>
                    <ul>
                        <li><a href="faq.jsp"><i class="fas fa-question-circle"></i> FAQ</a></li>
                        <li><a href="policies.jsp"><i class="fas fa-file-alt"></i> Policies</a></li>
                        <li><a href="terms.jsp"><i class="fas fa-file-contract"></i> Terms of Service</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h3>Follow Us</h3>
                    <ul>
                        <li><a href="https://www.facebook.com/"><i class="fab fa-facebook"></i> Facebook</a></li>
                        <li><a href="https://www.twitter.com/"><i class="fab fa-twitter"></i> Twitter</a></li>
                        <li><a href="https://www.instagram.com/_moodie.____"><i class="fab fa-instagram"></i> Instagram</a></li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2026 SkyGlide Airways. All rights reserved.</p>
            </div>
        </footer>
    </div>

    <!-- Script Logic -->
    <script>
        document.querySelectorAll('.tab-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                // Remove active classes
                document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
                document.querySelectorAll('.policy-panel').forEach(p => p.classList.remove('active'));

                // Set active to clicked tab
                btn.classList.add('active');
                const tabId = btn.getAttribute('data-tab');
                document.getElementById(`tab-\${tabId}`).classList.add('active');
            });
        });
    </script>
</body>
</html>
