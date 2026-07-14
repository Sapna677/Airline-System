<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="UTF-8">
    <title>Terms of Service | SkyGlide Airways</title>
    <!-- FontAwesome & Style Sheets -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg==" crossorigin="anonymous" referrerpolicy="no-referrer">
    <link rel="stylesheet" href="css/style.css">
    
    <style>
        .terms-header {
            margin-bottom: 40px;
            text-align: center;
        }

        .terms-header p {
            font-size: 1.1rem;
            color: var(--text-secondary);
            max-width: 650px;
            margin: 15px auto 0;
            line-height: 1.6;
        }

        /* Two column layout for terms and outline */
        .terms-layout {
            display: grid;
            grid-template-columns: 240px 1fr;
            gap: 40px;
            position: relative;
        }

        @media (max-width: 768px) {
            .terms-layout {
                grid-template-columns: 1fr;
            }
            .terms-sidebar {
                position: relative !important;
                top: 0 !important;
                max-height: none !important;
                margin-bottom: 20px;
            }
        }

        /* Floating Sidebar */
        .terms-sidebar {
            position: sticky;
            top: 100px;
            height: fit-content;
            max-height: 75vh;
            overflow-y: auto;
            border-right: 1px solid var(--card-border);
            padding-right: 15px;
        }

        .terms-sidebar h4 {
            color: white;
            font-size: 1.05rem;
            font-weight: 700;
            margin-bottom: 20px;
            letter-spacing: 0.5px;
        }

        .terms-nav {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .terms-nav li a {
            color: var(--text-secondary);
            text-decoration: none;
            font-size: 0.95rem;
            font-weight: 500;
            transition: var(--transition-smooth);
            display: block;
            padding: 4px 0;
        }

        .terms-nav li a:hover {
            color: white;
        }

        .terms-nav li.active a {
            color: #a5b4fc;
            font-weight: 600;
            border-left: 2px solid var(--accent-color);
            padding-left: 10px;
            margin-left: -10px;
        }

        /* Terms content */
        .terms-content {
            scroll-behavior: smooth;
        }

        .terms-section-block {
            margin-bottom: 45px;
            border-bottom: 1px solid var(--card-border);
            padding-bottom: 25px;
        }

        .terms-section-block:last-child {
            border-bottom: none;
        }

        .terms-section-block h3 {
            color: white;
            font-size: 1.4rem;
            font-weight: 700;
            margin-bottom: 18px;
            scroll-margin-top: 100px; /* offset for sticky nav scrolling */
        }

        .terms-section-block p, 
        .terms-section-block ul li {
            color: var(--text-secondary);
            font-size: 1rem;
            line-height: 1.6;
            margin-bottom: 15px;
        }

        .terms-section-block ul {
            list-style-type: square;
            margin-left: 20px;
            margin-bottom: 20px;
        }

        .terms-section-block ul li {
            margin-bottom: 10px;
        }

        /* Light theme adjustments */
        body.light-theme .terms-sidebar {
            border-right-color: rgba(0, 0, 0, 0.08);
        }

        body.light-theme .terms-sidebar h4,
        body.light-theme .terms-section-block h3 {
            color: #0f172a;
        }

        body.light-theme .terms-nav li.active a {
            color: #4f46e5;
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
        <main class="standalone-container" style="max-width: 1100px; margin-top: 40px; margin-bottom: 40px;">
            <div class="terms-header">
                <h2>Terms of Service</h2>
                <p>Welcome to SkyGlide Airways. Please review our carrier terms, carriage agreements, and ticket contracts guiding passenger transport.</p>
            </div>

            <div class="terms-layout">
                <!-- Outline Sidebar -->
                <aside class="terms-sidebar">
                    <h4>Document Outline</h4>
                    <ul class="terms-nav" id="termsNav">
                        <li class="active"><a href="#intro">1. Agreement to Terms</a></li>
                        <li><a href="#booking">2. Ticket Booking & PNR</a></li>
                        <li><a href="#fares">3. Fares, Taxes & Fees</a></li>
                        <li><a href="#checkin">4. Airport Check-In Rules</a></li>
                        <li><a href="#carriage">5. Refusal of Carriage</a></li>
                        <li><a href="#liability">6. Liability Limitations</a></li>
                    </ul>
                </aside>

                <!-- Document Content -->
                <div class="terms-content">
                    <!-- Section 1 -->
                    <section class="terms-section-block" id="intro">
                        <h3>1. Agreement to Terms</h3>
                        <p>By accessing this booking application, completing flight reservations, or boarding flights operated by SkyGlide Airways, you agree to comply with and be bound by these Conditions of Carriage and Terms of Service.</p>
                        <p>These terms govern passenger rights, baggage specifications, refund requests, and liability guidelines during flight carriage. If you do not accept these terms, you must not use our online flight booking engines.</p>
                    </section>

                    <!-- Section 2 -->
                    <section class="terms-section-block" id="booking">
                        <h3>2. Ticket Booking & PNR</h3>
                        <p>A confirmed reservation is generated only upon complete transaction authorization and issuance of a unique Passenger Name Record (PNR). Ticket reservations without payment hold status are not supported.</p>
                        <p>Passengers must ensure that names entered during booking correspond exactly with names on passport or national identification documents. Typographical alterations requested after PNR generation may incur clerical correction fees.</p>
                    </section>

                    <!-- Section 3 -->
                    <section class="terms-section-block" id="fares">
                        <h3>3. Fares, Taxes & Fees</h3>
                        <p>SkyGlide ticket fares cover basic transport from the scheduled origin airport to the scheduled arrival airport. Fares do not include ground shuttle services or ancillary provisions unless specified.</p>
                        <p>Any additional government taxes, surcharge levies, or airport development fees (ADF) added post-booking by aviation regulators will be billed to the passenger and must be paid before boarding clearance is provided.</p>
                    </section>

                    <!-- Section 4 -->
                    <section class="terms-section-block" id="checkin">
                        <h3>4. Airport Check-In Rules</h3>
                        <p>Check-in desks for domestic flights close exactly 45 minutes prior to scheduled departures. Passengers failing to complete check-in requirements within the window will be classified as No-Shows.</p>
                        <p>Boarding gates close 25 minutes prior to departures. It is the passenger's liability to present valid boarding passes, identification credentials, and secure required travel clearances at boarding gates.</p>
                    </section>

                    <!-- Section 5 -->
                    <section class="terms-section-block" id="carriage">
                        <h3>5. Refusal of Carriage</h3>
                        <p>SkyGlide reserves the right to refuse passenger transport under safety regulations in cases where:</p>
                        <ul>
                            <li>The passenger's conduct or physical status endangers flight crew safety or other flyers.</li>
                            <li>The passenger has failed to comply with airline security briefings or airport staff commands.</li>
                            <li>The passenger does not present valid identity verifications or travel documents.</li>
                        </ul>
                    </section>

                    <!-- Section 6 -->
                    <section class="terms-section-block" id="liability">
                        <h3>6. Liability Limitations</h3>
                        <p>Carriage hereunder is subject to the rules and limitations established by India's Carriage by Air Act, 1972, and standard international conventions (e.g. Warsaw Convention/Montreal Convention) where applicable.</p>
                        <p>SkyGlide Airways is not liable for minor delays, cancellations triggered by severe weather conditions, airspace blocks, or air traffic control instructions.</p>
                    </section>
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
        // Outline dynamic highlight using IntersectionObserver
        const observerOptions = {
            root: null,
            rootMargin: '-10% 0px -70% 0px', // focused area of screen
            threshold: 0
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const id = entry.target.getAttribute('id');
                    
                    // Remove active from all sidebar links
                    document.querySelectorAll('#termsNav li').forEach(li => {
                        li.classList.remove('active');
                    });

                    // Add active to current section link
                    const targetLink = document.querySelector(`#termsNav li a[href="#\${id}"]`);
                    if (targetLink) {
                        targetLink.parentElement.classList.add('active');
                    }
                }
            });
        }, observerOptions);

        // Observe all terms sections
        document.querySelectorAll('.terms-section-block').forEach(sec => {
            observer.observe(sec);
        });

        // Smooth scroll fallback
        document.querySelectorAll('#termsNav li a').forEach(link => {
            link.addEventListener('click', (e) => {
                e.preventDefault();
                const targetId = link.getAttribute('href').substring(1);
                const targetSec = document.getElementById(targetId);
                
                if (targetSec) {
                    targetSec.scrollIntoView({ behavior: 'smooth' });
                }
            });
        });
    </script>
</body>
</html>
