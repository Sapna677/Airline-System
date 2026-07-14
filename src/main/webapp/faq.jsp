<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="UTF-8">
    <title>Frequently Asked Questions | SkyGlide Airways</title>
    <!-- FontAwesome & Style Sheets -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg==" crossorigin="anonymous" referrerpolicy="no-referrer">
    <link rel="stylesheet" href="css/style.css">
    
    <style>
        .faq-header {
            margin-bottom: 40px;
            text-align: center;
        }

        .faq-header p {
            font-size: 1.1rem;
            color: var(--text-secondary);
            max-width: 650px;
            margin: 15px auto 0;
            line-height: 1.6;
        }

        /* Search input */
        .faq-search-wrapper {
            position: relative;
            max-width: 600px;
            margin: 0 auto 40px;
        }

        .faq-search-wrapper i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-secondary);
            font-size: 1.1rem;
        }

        .faq-search-wrapper input {
            width: 100%;
            padding: 14px 16px 14px 45px;
            background: var(--input-bg);
            border: 1px solid var(--input-border);
            border-radius: var(--border-radius-md);
            color: white;
            font-size: 1rem;
            transition: var(--transition-smooth);
        }

        .faq-search-wrapper input:focus {
            outline: none;
            border-color: var(--accent-color);
            box-shadow: 0 0 0 3px var(--input-focus);
            background: rgba(255, 255, 255, 0.08);
        }

        /* FAQ Categories */
        .faq-section {
            margin-bottom: 35px;
        }

        .faq-section h3 {
            color: white;
            font-size: 1.4rem;
            margin-bottom: 20px;
            font-weight: 700;
            border-left: 4px solid var(--accent-color);
            padding-left: 12px;
            display: inline-block;
        }

        /* Accordion Styling */
        .faq-container {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .faq-item {
            background: rgba(15, 23, 42, 0.4);
            border: 1px solid var(--card-border);
            border-radius: var(--border-radius-md);
            overflow: hidden;
            backdrop-filter: blur(8px);
            transition: var(--transition-smooth);
        }

        .faq-item:hover {
            border-color: rgba(99, 102, 241, 0.25);
            background: rgba(15, 23, 42, 0.55);
        }

        .faq-question {
            width: 100%;
            background: transparent;
            border: none;
            padding: 18px 25px;
            text-align: left;
            color: white;
            font-size: 1.05rem;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            font-family: inherit;
        }

        .faq-question i.chevron-icon {
            font-size: 0.9rem;
            color: var(--text-secondary);
            transition: transform 0.3s ease;
        }

        .faq-answer {
            max-height: 0;
            opacity: 0;
            overflow: hidden;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            padding: 0 25px;
            color: var(--text-secondary);
            font-size: 0.95rem;
            line-height: 1.6;
        }

        .faq-answer p {
            margin-bottom: 18px;
        }

        /* Active Accordion State */
        .faq-item.active {
            border-color: var(--accent-color);
            box-shadow: 0 4px 20px -5px rgba(99, 102, 241, 0.1);
        }

        .faq-item.active .faq-question {
            color: #a5b4fc;
        }

        .faq-item.active .faq-question i.chevron-icon {
            transform: rotate(180deg);
            color: #a5b4fc;
        }

        .faq-item.active .faq-answer {
            max-height: 250px; /* arbitrary height limit for transition */
            opacity: 1;
            padding: 5px 25px 20px;
        }

        /* Light theme adjustments */
        body.light-theme .faq-search-wrapper input {
            color: #1e293b;
            background: rgba(0, 0, 0, 0.03);
            border-color: rgba(0, 0, 0, 0.1);
        }
        
        body.light-theme .faq-search-wrapper input:focus {
            background: white;
            border-color: #6366f1;
        }

        body.light-theme .faq-section h3 {
            color: #0f172a;
        }

        body.light-theme .faq-item {
            background: rgba(255, 255, 255, 0.7);
            border-color: rgba(0, 0, 0, 0.08);
        }

        body.light-theme .faq-item:hover {
            background: white;
        }

        body.light-theme .faq-question {
            color: #1e293b;
        }

        body.light-theme .faq-item.active .faq-question {
            color: #4f46e5;
        }

        body.light-theme .faq-item.active {
            border-color: #6366f1;
        }

        .no-results {
            text-align: center;
            padding: 40px;
            color: var(--text-secondary);
            font-size: 1.15rem;
            display: none;
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
        <main class="standalone-container" style="max-width: 900px; margin-top: 40px; margin-bottom: 40px;">
            <div class="faq-header">
                <h2>Frequently Asked Questions</h2>
                <p>Have questions about booking tickets, luggage limits, refunds, or check-ins? Find quick answers categorized below or search keywords.</p>
            </div>

            <!-- FAQ Search Bar -->
            <div class="faq-search-wrapper">
                <i class="fas fa-search"></i>
                <input type="text" id="faqSearch" placeholder="Search for questions (e.g. refund, baggage, PNR)...">
            </div>

            <!-- FAQ Categories and Items -->
            <div id="faqContent">
                <!-- Section 1: Bookings -->
                <div class="faq-section">
                    <h3>Booking & Seat Selection</h3>
                    <div class="faq-container">
                        <div class="faq-item">
                            <button class="faq-question">
                                How do I select my seat for a flight?
                                <i class="fas fa-chevron-down chevron-icon"></i>
                            </button>
                            <div class="faq-answer">
                                <p>You can select your preferred seat during the flight booking flow. Once you've entered passenger details, the interactive seat layout will load. Alternatively, you can select or modify your seat post-purchase under your User Dashboard.</p>
                            </div>
                        </div>

                        <div class="faq-item">
                            <button class="faq-question">
                                Can I reserve tickets without immediate payment?
                                <i class="fas fa-chevron-down chevron-icon"></i>
                            </button>
                            <div class="faq-answer">
                                <p>No, our airline booking engine requires full payment processing during the checkout flow to confirm flight bookings and lock in current ticket prices.</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Section 2: Baggage -->
                <div class="faq-section">
                    <h3>Baggage Rules & Check-In</h3>
                    <div class="faq-container">
                        <div class="faq-item">
                            <button class="faq-question">
                                What is the baggage allowance for domestic flights?
                                <i class="fas fa-chevron-down chevron-icon"></i>
                            </button>
                            <div class="faq-answer">
                                <p>SkyGlide allows passengers 15kg of check-in baggage and 7kg of cabin baggage at no extra charge. You can review detailed regulations on our Policies page.</p>
                            </div>
                        </div>

                        <div class="faq-item">
                            <button class="faq-question">
                                How early should I check in at the airport?
                                <i class="fas fa-chevron-down chevron-icon"></i>
                            </button>
                            <div class="faq-answer">
                                <p>We recommend arriving at the airport at least 2 hours before scheduled departure times for domestic flights, and 3 hours prior for international services.</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Section 3: Refunds & Cancellations -->
                <div class="faq-section">
                    <h3>Refunds & Cancellations</h3>
                    <div class="faq-container">
                        <div class="faq-item">
                            <button class="faq-question">
                                How do I cancel my booking and get a refund?
                                <i class="fas fa-chevron-down chevron-icon"></i>
                            </button>
                            <div class="faq-answer">
                                <p>You can cancel bookings easily from your User Dashboard by clicking 'Cancel Reservation'. Refund balances will be calculated according to our Cancellation Policy timeline and returned to your original payment method.</p>
                            </div>
                        </div>

                        <div class="faq-item">
                            <button class="faq-question">
                                How long does it take to process flight refunds?
                                <i class="fas fa-chevron-down chevron-icon"></i>
                            </button>
                            <div class="faq-answer">
                                <p>Once cancellation is confirmed, refunds are processed immediately. The funds will typically appear in your source bank account within 5 to 7 business days.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Zero State Search -->
            <div class="no-results" id="noFaqResults">
                <i class="fas fa-folder-open" style="font-size: 2.5rem; opacity: 0.6; display: block; margin-bottom: 15px;"></i>
                No questions matched your search criteria.
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
        // Accordion toggle
        document.querySelectorAll('.faq-question').forEach(btn => {
            btn.addEventListener('click', () => {
                const item = btn.parentElement;
                
                // Toggle active class on clicked item
                const isActive = item.classList.contains('active');
                
                // Close other active items
                document.querySelectorAll('.faq-item').forEach(i => i.classList.remove('active'));
                
                if (!isActive) {
                    item.classList.add('active');
                }
            });
        });

        // Instant search filter
        const searchInput = document.getElementById('faqSearch');
        searchInput.addEventListener('input', () => {
            const filter = searchInput.value.toLowerCase();
            const items = document.querySelectorAll('.faq-item');
            let visibleCount = 0;

            items.forEach(item => {
                const qText = item.querySelector('.faq-question').innerText.toLowerCase();
                const aText = item.querySelector('.faq-answer').innerText.toLowerCase();
                
                if (qText.includes(filter) || aText.includes(filter)) {
                    item.style.display = 'block';
                    visibleCount++;
                } else {
                    item.style.display = 'none';
                    item.classList.remove('active'); // collapse if hidden
                }
            });

            // Handle FAQ categories headings hiding if all items in category are hidden
            document.querySelectorAll('.faq-section').forEach(sec => {
                const totalItems = sec.querySelectorAll('.faq-item');
                let visibleInSec = 0;
                totalItems.forEach(i => {
                    if (i.style.display !== 'none') visibleInSec++;
                });

                if (visibleInSec === 0) {
                    sec.style.display = 'none';
                } else {
                    sec.style.display = 'block';
                }
            });

            const zeroState = document.getElementById('noFaqResults');
            if (visibleCount === 0) {
                zeroState.style.display = 'block';
            } else {
                zeroState.style.display = 'none';
            }
        });
    </script>
</body>
</html>
