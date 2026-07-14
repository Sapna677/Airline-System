<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="UTF-8">
    <title>Careers | SkyGlide Airways</title>
    <!-- FontAwesome & Style Sheets -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg==" crossorigin="anonymous" referrerpolicy="no-referrer">
    <link rel="stylesheet" href="css/style.css">
    
    <style>
        /* Modern Glassmorphic Careers Styling */
        .careers-header {
            margin-bottom: 40px;
            text-align: center;
        }
        
        .careers-header p {
            font-size: 1.1rem;
            color: var(--text-secondary);
            max-width: 700px;
            margin: 15px auto 0;
            line-height: 1.6;
        }

        /* Search and Filter Panel */
        .filter-panel {
            background: rgba(15, 23, 42, 0.4);
            border: 1px solid var(--card-border);
            border-radius: var(--border-radius-md);
            padding: 20px;
            margin-bottom: 30px;
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            align-items: center;
            justify-content: space-between;
            backdrop-filter: blur(8px);
        }

        .search-box-wrapper {
            position: relative;
            flex: 1;
            min-width: 280px;
        }

        .search-box-wrapper i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-secondary);
            font-size: 1rem;
        }

        .search-box-wrapper input {
            width: 100%;
            padding: 12px 16px 12px 45px;
            background: var(--input-bg);
            border: 1px solid var(--input-border);
            border-radius: var(--border-radius-md);
            color: white;
            font-size: 0.95rem;
            transition: var(--transition-smooth);
        }

        .search-box-wrapper input:focus {
            outline: none;
            border-color: var(--accent-color);
            box-shadow: 0 0 0 3px var(--input-focus);
            background: rgba(255, 255, 255, 0.08);
        }

        .filter-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn-filter {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--input-border);
            color: var(--text-secondary);
            padding: 10px 18px;
            border-radius: var(--border-radius-md);
            cursor: pointer;
            font-weight: 500;
            font-size: 0.9rem;
            transition: var(--transition-smooth);
        }

        .btn-filter:hover, .btn-filter.active {
            background: var(--accent-gradient);
            color: white;
            border-color: transparent;
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.3);
        }

        /* Jobs Grid and Cards */
        .jobs-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }

        .job-card {
            background: var(--card-bg);
            border: 1px solid var(--card-border);
            border-radius: var(--border-radius-lg);
            padding: 30px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: var(--transition-smooth);
            backdrop-filter: blur(16px);
            opacity: 0;
            transform: translateY(20px);
            animation: cardFadeIn 0.6s cubic-bezier(0.4, 0, 0.2, 1) forwards;
        }

        @keyframes cardFadeIn {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .job-card:hover {
            transform: translateY(-5px);
            border-color: rgba(99, 102, 241, 0.3);
            box-shadow: 0 15px 35px -10px rgba(99, 102, 241, 0.15), var(--shadow-premium);
        }

        .job-card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
            gap: 10px;
        }

        .job-dept-tag {
            background: rgba(99, 102, 241, 0.15);
            color: #a5b4fc;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            letter-spacing: 0.5px;
            border: 1px solid rgba(99, 102, 241, 0.2);
        }

        .job-location-tag {
            color: var(--text-secondary);
            font-size: 0.8rem;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .job-title {
            color: white;
            font-size: 1.35rem;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .job-description {
            color: var(--text-secondary);
            font-size: 0.95rem;
            line-height: 1.5;
            margin-bottom: 20px;
            flex-grow: 1;
        }

        .job-details-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid var(--card-border);
        }

        .job-meta-item {
            font-size: 0.85rem;
            color: var(--text-secondary);
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .job-meta-item i {
            color: var(--accent-color);
        }

        .btn-apply {
            width: 100%;
            background: var(--accent-gradient);
            border: none;
            padding: 12px 20px;
            border-radius: var(--border-radius-md);
            color: white;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition-smooth);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-apply:hover {
            background: var(--accent-gradient-hover);
            transform: scale(1.02);
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.4);
        }

        .btn-apply.applied-status {
            background: rgba(34, 197, 94, 0.15) !important;
            border: 1px solid rgba(34, 197, 94, 0.3) !important;
            color: #4ade80 !important;
            cursor: not-allowed;
            box-shadow: none !important;
            transform: none !important;
        }

        /* Modal Overlay & Content */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(11, 15, 25, 0.8);
            backdrop-filter: blur(12px);
            z-index: 2000;
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            pointer-events: none;
            transition: opacity 0.4s ease;
        }

        .modal-overlay.active {
            opacity: 1;
            pointer-events: auto;
        }

        .modal-container {
            background: var(--card-bg);
            border: 1px solid var(--card-border);
            border-radius: var(--border-radius-lg);
            width: 90%;
            max-width: 550px;
            max-height: 85vh;
            overflow-y: auto;
            padding: 35px;
            box-shadow: var(--shadow-premium);
            transform: translateY(30px) scale(0.95);
            transition: transform 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }

        .modal-overlay.active .modal-container {
            transform: translateY(0) scale(1);
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            border-bottom: 1px solid var(--card-border);
            padding-bottom: 15px;
        }

        .modal-header h3 {
            font-size: 1.5rem;
            font-weight: 700;
            color: white;
        }

        .btn-modal-close {
            background: transparent;
            border: none;
            color: var(--text-secondary);
            font-size: 1.4rem;
            cursor: pointer;
            transition: var(--transition-smooth);
        }

        .btn-modal-close:hover {
            color: white;
            transform: scale(1.1);
        }

        /* Form styling */
        .form-group {
            margin-bottom: 20px;
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

        .form-group input.error-input, .form-group textarea.error-input {
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

        /* Success screen styling */
        .modal-success-screen {
            text-align: center;
            padding: 20px 0;
            display: none;
        }

        .success-icon-wrapper {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: rgba(34, 197, 94, 0.15);
            border: 2px solid #22c55e;
            color: #22c55e;
            font-size: 2.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 25px;
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

        .modal-success-screen h4 {
            color: white;
            font-size: 1.6rem;
            font-weight: 700;
            margin-bottom: 12px;
        }

        .modal-success-screen p {
            color: var(--text-secondary);
            font-size: 1rem;
            line-height: 1.6;
            margin-bottom: 30px;
        }

        /* Light theme adjustments */
        body.light-theme .filter-panel {
            background: rgba(255, 255, 255, 0.6);
            border-color: rgba(0, 0, 0, 0.08);
        }

        body.light-theme .search-box-wrapper input {
            color: #1e293b;
            background: rgba(0, 0, 0, 0.03);
            border-color: rgba(0, 0, 0, 0.1);
        }
        
        body.light-theme .search-box-wrapper input:focus {
            background: white;
            border-color: #6366f1;
        }

        body.light-theme .btn-filter {
            background: rgba(0, 0, 0, 0.03);
            border-color: rgba(0, 0, 0, 0.1);
            color: #475569;
        }

        body.light-theme .btn-filter:hover, body.light-theme .btn-filter.active {
            color: white;
            border-color: transparent;
        }

        body.light-theme .job-title {
            color: #0f172a;
        }

        body.light-theme .job-dept-tag {
            background: rgba(99, 102, 241, 0.1);
            color: #4f46e5;
            border-color: rgba(99, 102, 241, 0.15);
        }

        body.light-theme .modal-header h3, 
        body.light-theme .modal-success-screen h4 {
            color: #0f172a;
        }

        body.light-theme .modal-overlay {
            background: rgba(255, 255, 255, 0.5);
        }

        /* No Jobs Found State */
        .no-jobs-found {
            text-align: center;
            padding: 50px 20px;
            color: var(--text-secondary);
            font-size: 1.2rem;
            display: none;
            flex-direction: column;
            align-items: center;
            gap: 15px;
        }

        .no-jobs-found i {
            font-size: 3rem;
            color: var(--text-secondary);
            opacity: 0.6;
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
            <div class="careers-header">
                <h2>Careers at SkyGlide</h2>
                <p>SkyGlide Airways is one of India's fastest-growing premium air carriers. Join our diverse, world-class team and let your career reach new heights. Explore our openings and apply today.</p>
            </div>

            <!-- Search and Filter Bar -->
            <div class="filter-panel">
                <div class="search-box-wrapper">
                    <i class="fas fa-search"></i>
                    <input type="text" id="jobSearchInput" placeholder="Search by job title, location, or keywords...">
                </div>
                <div class="filter-buttons">
                    <button class="btn-filter active" data-category="all">All Departments</button>
                    <button class="btn-filter" data-category="Flight Operations">Flight Operations</button>
                    <button class="btn-filter" data-category="Engineering & IT">Engineering & IT</button>
                    <button class="btn-filter" data-category="Ground Services">Ground Services</button>
                </div>
            </div>

            <!-- Jobs Display Grid -->
            <div class="jobs-grid" id="jobsGrid">
                <!-- Job cards will be populated dynamically by JavaScript -->
            </div>

            <!-- No Jobs State -->
            <div class="no-jobs-found" id="noJobsFound">
                <i class="fas fa-search-minus"></i>
                <p>No job positions match your filters or search terms.</p>
                <button class="btn-filter" id="resetFiltersBtn" style="margin-top: 10px;">Clear Filters</button>
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

    <!-- Application Modal -->
    <div class="modal-overlay" id="applyModalOverlay">
        <div class="modal-container">
            <!-- Modal Edit Form Screen -->
            <div id="modalFormScreen">
                <div class="modal-header">
                    <h3 id="modalJobTitle">Apply for Position</h3>
                    <button class="btn-modal-close" id="modalCloseBtn">&times;</button>
                </div>
                <form id="jobApplicationForm" novalidate>
                    <input type="hidden" id="appJobId" name="jobId">
                    <input type="hidden" id="appJobTitle" name="jobTitle">

                    <div class="form-group">
                        <label for="fullName">Full Name *</label>
                        <input type="text" id="fullName" placeholder="Enter your full name" required>
                        <div class="error-message" id="error-fullName">
                            <i class="fas fa-exclamation-circle"></i> Please enter your name (minimum 3 characters, alphabets only).
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="emailAddress">Email Address *</label>
                        <input type="email" id="emailAddress" placeholder="you@example.com" required>
                        <div class="error-message" id="error-emailAddress">
                            <i class="fas fa-exclamation-circle"></i> Please enter a valid email address.
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="phoneNumber">Phone Number *</label>
                        <input type="tel" id="phoneNumber" placeholder="10-digit mobile number" required>
                        <div class="error-message" id="error-phoneNumber">
                            <i class="fas fa-exclamation-circle"></i> Please enter a valid 10-digit phone number.
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="experienceYears">Total Work Experience *</label>
                        <select id="experienceYears" required>
                            <option value="" disabled selected>Select your experience</option>
                            <option value="Fresher">Fresher (0 - 1 Year)</option>
                            <option value="1-3 Years">1 - 3 Years</option>
                            <option value="3-5 Years">3 - 5 Years</option>
                            <option value="5+ Years">More than 5 Years</option>
                        </select>
                        <div class="error-message" id="error-experienceYears">
                            <i class="fas fa-exclamation-circle"></i> Please select your work experience.
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="resumeLink">Resume / CV Link (Google Drive, Dropbox, etc.) *</label>
                        <input type="url" id="resumeLink" placeholder="https://drive.google.com/..." required>
                        <div class="error-message" id="error-resumeLink">
                            <i class="fas fa-exclamation-circle"></i> Please enter a valid URL linking to your resume.
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="coverLetter">Why do you want to join SkyGlide Airways? *</label>
                        <textarea id="coverLetter" rows="4" placeholder="Tell us briefly about yourself and why you're a good fit..." required></textarea>
                        <div class="error-message" id="error-coverLetter">
                            <i class="fas fa-exclamation-circle"></i> Please tell us why you want to join (minimum 20 characters).
                        </div>
                    </div>

                    <button type="submit" class="btn-apply" style="margin-top: 15px;">
                        <i class="fas fa-paper-plane"></i> Submit Application
                    </button>
                </form>
            </div>

            <!-- Modal Success Screen -->
            <div id="modalSuccessScreen" class="modal-success-screen">
                <div class="success-icon-wrapper">
                    <i class="fas fa-check"></i>
                </div>
                <h4 id="successTitle">Application Received!</h4>
                <p id="successText">Thank you for applying. We will review your profile and contact you soon.</p>
                <button class="btn-apply" id="successCloseBtn" style="max-width: 200px; margin: 0 auto;">Done</button>
            </div>
        </div>
    </div>

    <!-- Script logic for filters and modal submission -->
    <script>
        const jobs = [
            {
                id: "cabin-crew",
                title: "Cabin Crew / Flight Attendant",
                department: "Flight Operations",
                location: "New Delhi (DEL)",
                type: "Full-Time",
                experience: "0-2 Years (Freshers)",
                salary: "₹4.5 - ₹6.0 LPA",
                description: "Ensure passenger safety, comfort, and exceptional service on board our domestic flights.",
                requirements: [
                    "Minimum qualification: 10+2 from a recognized board.",
                    "Age between 18 and 27 years with a pleasing personality.",
                    "Excellent communication skills in English and Hindi."
                ]
            },
            {
                id: "captain-a320",
                title: "Captain / Commander (A320)",
                department: "Flight Operations",
                location: "Mumbai (BOM)",
                type: "Full-Time",
                experience: "5+ Years",
                salary: "Best in Industry",
                description: "Command A320 aircraft safely and efficiently in compliance with company policies and aviation regulations.",
                requirements: [
                    "Valid Indian ATPL, Class I Medical, and RTR(A).",
                    "Minimum 2000 hours PIC on commercial aircraft.",
                    "A320 type rating is highly preferred."
                ]
            },
            {
                id: "ame-engineer",
                title: "Aircraft Maintenance Engineer (AME)",
                department: "Engineering & IT",
                location: "Bangalore (BLR)",
                type: "Full-Time",
                experience: "3+ Years",
                salary: "₹8.0 - ₹12.0 LPA",
                description: "Perform maintenance tasks, troubleshoot issues, and certify aircraft airworthiness.",
                requirements: [
                    "Valid DGCA AME License in Category B1.1 or B2.",
                    "At least 3 years certifying experience on A320/A321.",
                    "Deep understanding of CAR regulations."
                ]
            },
            {
                id: "web-dev",
                title: "Senior Java / Web Developer",
                department: "Engineering & IT",
                location: "Remote (India)",
                type: "Full-Time",
                experience: "4+ Years",
                salary: "₹12.0 - ₹18.0 LPA",
                description: "Develop and maintain our high-performance booking engines, APIs, and passenger web portal.",
                requirements: [
                    "B.Tech/MCA in Computer Science or related field.",
                    "Strong experience with Java, Spring Boot, JSP, Servlets, and SQL.",
                    "Familiarity with HTML5/CSS3/JavaScript responsive styling."
                ]
            },
            {
                id: "ground-ops",
                title: "Ground Operations Associate",
                department: "Ground Services",
                location: "Delhi (DEL)",
                type: "Full-Time",
                experience: "1-3 Years",
                salary: "₹3.5 - ₹5.0 LPA",
                description: "Coordinate passenger check-in, boarding, baggage handling, and ramp operations.",
                requirements: [
                    "Graduate degree in any discipline.",
                    "Strong interpersonal and problem-solving skills.",
                    "Ability to handle high-pressure environments."
                ]
            },
            {
                id: "customer-service",
                title: "Customer Support Executive",
                department: "Ground Services",
                location: "Mumbai (BOM)",
                type: "Full-Time",
                experience: "0-3 Years",
                salary: "₹3.0 - ₹4.5 LPA",
                description: "Provide support regarding ticketing, refunds, flight status, and booking updates.",
                requirements: [
                    "Graduate or Diploma holder.",
                    "Excellent telephonic etiquette and communication skills.",
                    "Comfortable with 24/7 rotational shifts."
                ]
            }
        ];

        // Track user's applied status
        function getAppliedJobs() {
            const list = localStorage.getItem('skyglide_applied_jobs');
            return list ? JSON.parse(list) : [];
        }

        function markJobAsApplied(jobId) {
            const list = getAppliedJobs();
            if (!list.includes(jobId)) {
                list.push(jobId);
                localStorage.setItem('skyglide_applied_jobs', JSON.stringify(list));
            }
        }

        // Generate UI cards
        function renderJobs() {
            const grid = document.getElementById('jobsGrid');
            const searchVal = document.getElementById('jobSearchInput').value.toLowerCase();
            const activeFilter = document.querySelector('.btn-filter.active').getAttribute('data-category');
            const appliedList = getAppliedJobs();
            
            grid.innerHTML = '';
            let count = 0;

            jobs.forEach(job => {
                const matchesSearch = job.title.toLowerCase().includes(searchVal) || 
                                      job.description.toLowerCase().includes(searchVal) ||
                                      job.location.toLowerCase().includes(searchVal);
                const matchesFilter = activeFilter === 'all' || job.department === activeFilter;

                if (matchesSearch && matchesFilter) {
                    count++;
                    const isApplied = appliedList.includes(job.id);
                    const card = document.createElement('div');
                    card.className = 'job-card';
                    card.style.animationDelay = `${count * 0.1}s`;

                    card.innerHTML = `
                        <div>
                            <div class="job-card-header">
                                <span class="job-dept-tag">\${job.department}</span>
                                <span class="job-location-tag"><i class="fas fa-map-marker-alt"></i> \${job.location}</span>
                            </div>
                            <h4 class="job-title">\${job.title}</h4>
                            <p class="job-description">\${job.description}</p>
                            <div class="job-details-meta">
                                <div class="job-meta-item"><i class="fas fa-clock"></i> \${job.type}</div>
                                <div class="job-meta-item"><i class="fas fa-briefcase"></i> \${job.experience}</div>
                                <div class="job-meta-item"><i class="fas fa-wallet"></i> \${job.salary}</div>
                            </div>
                            <div style="margin-bottom: 20px;">
                                <strong style="font-size: 0.85rem; color: white; display: block; margin-bottom: 8px;">Key Requirements:</strong>
                                <ul style="list-style-type: none; margin: 0; padding: 0;">
                                    \${job.requirements.map(req => `<li style="font-size: 0.85rem; color: var(--text-secondary); margin: 6px 0; display: flex; align-items: center; gap: 8px;"><i class="fas fa-check" style="color: #4f46e5; font-size: 0.75rem;"></i> \${req}</li>`).join('')}
                                </ul>
                            </div>
                        </div>
                        <button class="btn-apply \${isApplied ? 'applied-status' : ''}" 
                                onclick="openApplyModal('\${job.id}', '\${job.title.replace(/'/g, "\\'")}')" 
                                \${isApplied ? 'disabled' : ''}>
                            \${isApplied ? '<i class="fas fa-check-circle"></i> Applied' : '<i class="fas fa-paper-plane"></i> Apply Now'}
                        </button>
                    `;
                    grid.appendChild(card);
                }
            });

            const noJobs = document.getElementById('noJobsFound');
            if (count === 0) {
                noJobs.style.display = 'flex';
                grid.style.display = 'none';
            } else {
                noJobs.style.display = 'none';
                grid.style.display = 'grid';
            }
        }

        // Modal triggers
        const modalOverlay = document.getElementById('applyModalOverlay');
        const modalFormScreen = document.getElementById('modalFormScreen');
        const modalSuccessScreen = document.getElementById('modalSuccessScreen');

        function openApplyModal(jobId, jobTitle) {
            document.getElementById('appJobId').value = jobId;
            document.getElementById('appJobTitle').value = jobTitle;
            document.getElementById('modalJobTitle').innerText = `Apply for \${jobTitle}`;
            
            // Clear inputs and errors
            document.getElementById('jobApplicationForm').reset();
            document.querySelectorAll('.error-message').forEach(el => el.style.display = 'none');
            document.querySelectorAll('.error-input').forEach(el => el.classList.remove('error-input'));

            modalFormScreen.style.display = 'block';
            modalSuccessScreen.style.display = 'none';
            modalOverlay.classList.add('active');
        }

        function closeApplyModal() {
            modalOverlay.classList.remove('active');
        }

        // Search & Filter Events
        document.getElementById('jobSearchInput').addEventListener('input', renderJobs);

        document.querySelectorAll('.btn-filter').forEach(btn => {
            btn.addEventListener('click', (e) => {
                if (e.target.id === 'resetFiltersBtn') return; // ignore reset button click here
                document.querySelectorAll('.btn-filter').forEach(b => b.classList.remove('active'));
                e.target.classList.add('active');
                renderJobs();
            });
        });

        document.getElementById('resetFiltersBtn').addEventListener('click', () => {
            document.getElementById('jobSearchInput').value = '';
            document.querySelectorAll('.btn-filter').forEach(b => b.classList.remove('active'));
            document.querySelector('.btn-filter[data-category="all"]').classList.add('active');
            renderJobs();
        });

        document.getElementById('modalCloseBtn').addEventListener('click', closeApplyModal);
        document.getElementById('successCloseBtn').addEventListener('click', () => {
            closeApplyModal();
            renderJobs(); // refresh to show "Applied" badge
        });

        // Click outside modal to close
        modalOverlay.addEventListener('click', (e) => {
            if (e.target === modalOverlay) {
                closeApplyModal();
            }
        });

        // Form Validation & Submission
        document.getElementById('jobApplicationForm').addEventListener('submit', (e) => {
            e.preventDefault();

            let isValid = true;
            const nameEl = document.getElementById('fullName');
            const emailEl = document.getElementById('emailAddress');
            const phoneEl = document.getElementById('phoneNumber');
            const expEl = document.getElementById('experienceYears');
            const resumeEl = document.getElementById('resumeLink');
            const coverEl = document.getElementById('coverLetter');

            // Reset errors
            document.querySelectorAll('.error-message').forEach(el => el.style.display = 'none');
            document.querySelectorAll('.error-input').forEach(el => el.classList.remove('error-input'));

            // Name: min 3 chars, letters & spaces only
            const nameVal = nameEl.value.trim();
            const nameRegex = /^[a-zA-Z\s]{3,}$/;
            if (!nameRegex.test(nameVal)) {
                isValid = false;
                nameEl.classList.add('error-input');
                document.getElementById('error-fullName').style.display = 'flex';
            }

            // Email validation
            const emailVal = emailEl.value.trim();
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(emailVal)) {
                isValid = false;
                emailEl.classList.add('error-input');
                document.getElementById('error-emailAddress').style.display = 'flex';
            }

            // Phone: 10-digit validation
            const phoneVal = phoneEl.value.trim();
            const phoneRegex = /^\d{10}$/;
            if (!phoneRegex.test(phoneVal)) {
                isValid = false;
                phoneEl.classList.add('error-input');
                document.getElementById('error-phoneNumber').style.display = 'flex';
            }

            // Experience select validation
            if (!expEl.value) {
                isValid = false;
                expEl.classList.add('error-input');
                document.getElementById('error-experienceYears').style.display = 'flex';
            }

            // Resume Link validation
            const resumeVal = resumeEl.value.trim();
            const urlRegex = /^(https?:\/\/)?(www\.)?([a-zA-Z0-9]+(-?[a-zA-Z0-9]+)*\.)+[a-z]{2,}(:\d{1,5})?(\/[a-zA-Z0-9\-._~:\/?#\[\]@!$&'()*+,;=]*)?$/;
            if (!urlRegex.test(resumeVal)) {
                isValid = false;
                resumeEl.classList.add('error-input');
                document.getElementById('error-resumeLink').style.display = 'flex';
            }

            // Cover Letter: min 20 chars
            const coverVal = coverEl.value.trim();
            if (coverVal.length < 20) {
                isValid = false;
                coverEl.classList.add('error-input');
                document.getElementById('error-coverLetter').style.display = 'flex';
            }

            if (isValid) {
                const jobId = document.getElementById('appJobId').value;
                const jobTitle = document.getElementById('appJobTitle').value;

                // Save simulation to local storage
                markJobAsApplied(jobId);

                // Set success message
                document.getElementById('successTitle').innerText = 'Application Submitted!';
                document.getElementById('successText').innerHTML = `Excellent, <strong>\${nameVal}</strong>! Your application for the position of <strong>\${jobTitle}</strong> has been received successfully. Our hiring team will review your CV and contact you at <strong>\${emailVal}</strong> shortly.`;

                // Switch screen in modal
                modalFormScreen.style.display = 'none';
                modalSuccessScreen.style.display = 'block';
            }
        });

        // Initialize jobs display
        renderJobs();
    </script>
</body>
</html>
