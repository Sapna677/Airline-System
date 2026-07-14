<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="UTF-8">
    <title>Passenger Feedback | SkyGlide Airways</title>
    <!-- FontAwesome & Style Sheets -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg==" crossorigin="anonymous" referrerpolicy="no-referrer">
    <link rel="stylesheet" href="css/style.css">
    
    <style>
        .feedback-header {
            margin-bottom: 35px;
            text-align: center;
        }

        .feedback-header p {
            font-size: 1.1rem;
            color: var(--text-secondary);
            max-width: 650px;
            margin: 15px auto 0;
            line-height: 1.6;
        }

        /* 5-Star Rating Widget */
        .rating-wrapper {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-bottom: 25px;
            padding: 15px;
            background: rgba(255, 255, 255, 0.03);
            border-radius: var(--border-radius-md);
            border: 1px solid var(--card-border);
        }

        .rating-wrapper label {
            font-size: 0.95rem;
            color: var(--text-secondary);
            margin-bottom: 10px;
            font-weight: 600;
        }

        .star-rating {
            display: flex;
            flex-direction: row-reverse;
            justify-content: center;
            gap: 8px;
        }

        .star-rating input {
            display: none;
        }

        .star-rating label {
            font-size: 2.2rem;
            color: rgba(255, 255, 255, 0.15);
            cursor: pointer;
            transition: var(--transition-smooth);
            margin: 0;
        }

        /* Hover & Checked Golden Star Effects */
        .star-rating label:hover,
        .star-rating label:hover ~ label,
        .star-rating input:checked ~ label {
            color: #fbbf24;
            text-shadow: 0 0 10px rgba(251, 191, 36, 0.4);
        }

        .char-counter {
            text-align: right;
            font-size: 0.8rem;
            color: var(--text-secondary);
            margin-top: 5px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        @media (max-width: 600px) {
            .form-row {
                grid-template-columns: 1fr;
                gap: 0;
            }
        }

        /* Form validation styles */
        .form-group {
            margin-bottom: 22px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: var(--text-secondary);
            font-size: 0.9rem;
            font-weight: 500;
        }

        .form-group input, .form-group select, .form-group textarea {
            width: 100%;
            padding: 12px 16px;
            background: var(--input-bg);
            border: 1px solid var(--input-border);
            border-radius: var(--border-radius-md);
            color: white;
            font-size: 0.95rem;
            font-family: inherit;
            transition: var(--transition-smooth);
        }

        .form-group input:focus, .form-group select:focus, .form-group textarea:focus {
            outline: none;
            border-color: var(--accent-color);
            box-shadow: 0 0 0 3px var(--input-focus);
            background: rgba(255, 255, 255, 0.08);
        }

        .form-group input.error-input, 
        .form-group select.error-input, 
        .form-group textarea.error-input {
            border-color: #ef4444 !important;
            box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.25) !important;
        }

        .error-message {
            color: #f87171;
            font-size: 0.8rem;
            margin-top: 5px;
            display: none;
            align-items: center;
            gap: 5px;
        }

        /* Success screen */
        .success-panel {
            text-align: center;
            padding: 40px 20px;
            display: none;
        }

        .success-icon-wrapper {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            background: rgba(34, 197, 94, 0.15);
            border: 2px solid #22c55e;
            color: #22c55e;
            font-size: 3rem;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 30px;
            animation: pulseSuccess 2s infinite;
        }

        @keyframes pulseSuccess {
            0% {
                box-shadow: 0 0 0 0 rgba(34, 197, 94, 0.4);
            }
            70% {
                box-shadow: 0 0 0 15px rgba(34, 197, 94, 0);
            }
            100% {
                box-shadow: 0 0 0 0 rgba(34, 197, 94, 0);
            }
        }

        .success-panel h3 {
            color: white;
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 15px;
        }

        .success-panel p {
            color: var(--text-secondary);
            font-size: 1.1rem;
            line-height: 1.6;
            margin-bottom: 35px;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }

        /* Light theme adjustments */
        body.light-theme .rating-wrapper {
            background: rgba(0, 0, 0, 0.02);
            border-color: rgba(0, 0, 0, 0.08);
        }

        body.light-theme .success-panel h3 {
            color: #0f172a;
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
        <main class="standalone-container" style="max-width: 800px; margin-top: 40px; margin-bottom: 40px;">
            <!-- Form Section -->
            <div id="feedbackFormSection">
                <div class="feedback-header">
                    <h2>Passenger Feedback</h2>
                    <p>We value your travel experience. Please share your rating, compliments, or concerns below to help us fly better together.</p>
                </div>

                <form id="passengerFeedbackForm" novalidate>
                    <!-- Star Rating -->
                    <div class="rating-wrapper">
                        <label>Your Overall Rating *</label>
                        <div class="star-rating">
                            <input type="radio" id="star5" name="rating" value="5">
                            <label for="star5" title="5 stars"><i class="fas fa-star"></i></label>
                            <input type="radio" id="star4" name="rating" value="4">
                            <label for="star4" title="4 stars"><i class="fas fa-star"></i></label>
                            <input type="radio" id="star3" name="rating" value="3">
                            <label for="star3" title="3 stars"><i class="fas fa-star"></i></label>
                            <input type="radio" id="star2" name="rating" value="2">
                            <label for="star2" title="2 stars"><i class="fas fa-star"></i></label>
                            <input type="radio" id="star1" name="rating" value="1">
                            <label for="star1" title="1 star"><i class="fas fa-star"></i></label>
                        </div>
                        <div class="error-message" id="error-rating" style="margin-top: 10px;">
                            <i class="fas fa-exclamation-circle"></i> Please select a rating score.
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="fullName">Full Name *</label>
                            <input type="text" id="fullName" placeholder="Enter your name" required>
                            <div class="error-message" id="error-fullName">
                                <i class="fas fa-exclamation-circle"></i> Name must be at least 3 characters.
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="emailAddress">Email Address *</label>
                            <input type="email" id="emailAddress" placeholder="you@example.com" required>
                            <div class="error-message" id="error-emailAddress">
                                <i class="fas fa-exclamation-circle"></i> Please enter a valid email address.
                            </div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="flightNum">Flight Number (e.g. 101) *</label>
                            <input type="text" id="flightNum" placeholder="Flight number on your ticket" required>
                            <div class="error-message" id="error-flightNum">
                                <i class="fas fa-exclamation-circle"></i> Enter a valid numeric flight number.
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="feedbackDept">Feedback Category *</label>
                            <select id="feedbackDept" required>
                                <option value="" disabled selected>Select category</option>
                                <option value="In-Flight Cabin Crew">In-Flight Service</option>
                                <option value="Baggage Handling">Baggage & Cargo</option>
                                <option value="Online Flight Booking">Booking & App Engine</option>
                                <option value="Meals & Beverage">In-flight Meals</option>
                                <option value="General Service">General Inquiry / Compliment</option>
                            </select>
                            <div class="error-message" id="error-feedbackDept">
                                <i class="fas fa-exclamation-circle"></i> Please select a feedback category.
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="feedbackMessage">Your Feedback Message *</label>
                        <textarea id="feedbackMessage" rows="5" maxlength="500" placeholder="Type your experience details here (max 500 characters)..." required></textarea>
                        <div class="char-counter"><span id="charCount">500</span> characters remaining</div>
                        <div class="error-message" id="error-feedbackMessage">
                            <i class="fas fa-exclamation-circle"></i> Message must be between 10 and 500 characters.
                        </div>
                    </div>

                    <button type="submit" class="btn-apply" style="margin-top: 10px;">
                        <i class="fas fa-paper-plane"></i> Submit Feedback
                    </button>
                </form>
            </div>

            <!-- Success Section -->
            <div id="feedbackSuccessSection" class="success-panel">
                <div class="success-icon-wrapper">
                    <i class="fas fa-check"></i>
                </div>
                <h3>Feedback Submitted Successfully!</h3>
                <p id="feedbackSuccessMessage">Thank you for taking the time to share your feedback. We appreciate your valuable suggestions.</p>
                <div style="padding: 15px; border-radius: var(--border-radius-md); background: rgba(255, 255, 255, 0.04); display: inline-block; border: 1px solid var(--card-border); margin-bottom: 30px;">
                    <span style="color: var(--text-secondary); font-size: 0.9rem;">Reference Ticket:</span>
                    <strong style="color: white; font-size: 1.1rem; letter-spacing: 1px; margin-left: 8px;" id="feedbackRefCode">SF-849204</strong>
                </div>
                <div>
                    <a href="index.jsp" class="btn-apply" style="max-width: 220px; margin: 0 auto; text-decoration: none;">
                        <i class="fas fa-home"></i> Back to Homepage
                    </a>
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
        const messageTextarea = document.getElementById('feedbackMessage');
        const charCounter = document.getElementById('charCount');

        // Character counter
        messageTextarea.addEventListener('input', () => {
            const currentLength = messageTextarea.value.length;
            const remaining = 500 - currentLength;
            charCounter.innerText = remaining;
        });

        // Form Validation & Submission
        document.getElementById('passengerFeedbackForm').addEventListener('submit', (e) => {
            e.preventDefault();

            let isValid = true;
            const nameEl = document.getElementById('fullName');
            const emailEl = document.getElementById('emailAddress');
            const flightEl = document.getElementById('flightNum');
            const catEl = document.getElementById('feedbackDept');
            const msgEl = document.getElementById('feedbackMessage');

            // Rating select check
            const checkedRating = document.querySelector('input[name="rating"]:checked');
            const ratingErr = document.getElementById('error-rating');
            if (!checkedRating) {
                isValid = false;
                ratingErr.style.display = 'flex';
            } else {
                ratingErr.style.display = 'none';
            }

            // Reset inputs & errors
            document.querySelectorAll('.error-message:not(#error-rating)').forEach(el => el.style.display = 'none');
            document.querySelectorAll('.error-input').forEach(el => el.classList.remove('error-input'));

            // Name: min 3 chars
            if (nameEl.value.trim().length < 3) {
                isValid = false;
                nameEl.classList.add('error-input');
                document.getElementById('error-fullName').style.display = 'flex';
            }

            // Email
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(emailEl.value.trim())) {
                isValid = false;
                emailEl.classList.add('error-input');
                document.getElementById('error-emailAddress').style.display = 'flex';
            }

            // Flight Number: digits only
            const flightRegex = /^\d+$/;
            if (!flightRegex.test(flightEl.value.trim())) {
                isValid = false;
                flightEl.classList.add('error-input');
                document.getElementById('error-flightNum').style.display = 'flex';
            }

            // Category select
            if (!catEl.value) {
                isValid = false;
                catEl.classList.add('error-input');
                document.getElementById('error-feedbackDept').style.display = 'flex';
            }

            // Message: min 10 chars
            if (msgEl.value.trim().length < 10) {
                isValid = false;
                msgEl.classList.add('error-input');
                document.getElementById('error-feedbackMessage').style.display = 'flex';
            }

            if (isValid) {
                // Generate simulated case ID
                const randomId = 'FB-' + Math.floor(100000 + Math.random() * 900000);
                document.getElementById('feedbackRefCode').innerText = randomId;
                
                const nameVal = nameEl.value.trim();
                const ratingVal = checkedRating.value;

                document.getElementById('feedbackSuccessMessage').innerHTML = `Dear <strong>\${nameVal}</strong>, we have received your feedback rating of <strong>\${ratingVal} Stars</strong>. Your inputs are logged under reference number <strong>\${randomId}</strong>. We constantly strive to improve our services based on your reports.`;

                // Switch section display
                document.getElementById('feedbackFormSection').style.display = 'none';
                document.getElementById('feedbackSuccessSection').style.display = 'block';
            }
        });
    </script>
</body>
</html>
