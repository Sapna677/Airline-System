<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="UTF-8">
    <title>Customer Support | SkyGlide Airways</title>
    <!-- FontAwesome & Style Sheets -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg==" crossorigin="anonymous" referrerpolicy="no-referrer">
    <link rel="stylesheet" href="css/style.css">
    
    <style>
        .support-header {
            margin-bottom: 40px;
            text-align: center;
        }

        .support-header p {
            font-size: 1.1rem;
            color: var(--text-secondary);
            max-width: 650px;
            margin: 15px auto 0;
            line-height: 1.6;
        }

        .support-grid {
            display: grid;
            grid-template-columns: 1fr 1.5fr;
            gap: 30px;
            margin-bottom: 40px;
        }

        @media (max-width: 768px) {
            .support-grid {
                grid-template-columns: 1fr;
            }
        }

        /* Contact Details Panels */
        .support-info-cards {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .info-card {
            background: rgba(15, 23, 42, 0.4);
            border: 1px solid var(--card-border);
            border-radius: var(--border-radius-md);
            padding: 22px;
            display: flex;
            align-items: flex-start;
            gap: 15px;
            backdrop-filter: blur(8px);
            transition: var(--transition-smooth);
        }

        .info-card:hover {
            border-color: rgba(99, 102, 241, 0.2);
            transform: translateY(-2px);
        }

        .info-card i {
            font-size: 1.4rem;
            color: var(--accent-color);
            background: rgba(99, 102, 241, 0.1);
            width: 45px;
            height: 45px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .info-card h4 {
            color: white;
            font-size: 1.1rem;
            margin-bottom: 5px;
            font-weight: 700;
        }

        .info-card p {
            color: var(--text-secondary);
            font-size: 0.95rem;
            margin: 0;
            line-height: 1.4;
        }

        /* Ticket Form container */
        .ticket-form-panel {
            background: var(--card-bg);
            border: 1px solid var(--card-border);
            border-radius: var(--border-radius-lg);
            padding: 30px;
            backdrop-filter: blur(16px);
            box-shadow: var(--shadow-premium);
        }

        .ticket-form-panel h3 {
            color: white;
            font-size: 1.4rem;
            margin-bottom: 20px;
            font-weight: 700;
            border-bottom: 1px solid var(--card-border);
            padding-bottom: 10px;
        }

        /* Form validation styles */
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

        /* Chatbot Widget Floating Button */
        .chat-widget-btn {
            position: fixed;
            bottom: 25px;
            left: 25px;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            border: 2px solid rgba(255, 255, 255, 0.2);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.6rem;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.35);
            z-index: 10000;
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }

        .chat-widget-btn:hover {
            transform: scale(1.1) rotate(5deg);
            box-shadow: 0 12px 35px rgba(16, 185, 129, 0.45);
        }

        /* Chatbot Mini-Window */
        .chat-window {
            position: fixed;
            bottom: 95px;
            left: 25px;
            width: 360px;
            height: 480px;
            background: var(--card-bg);
            border: 1px solid var(--card-border);
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-premium);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            z-index: 10000;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            transform: translateY(30px) scale(0.9);
            opacity: 0;
            pointer-events: none;
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }

        .chat-window.active {
            transform: translateY(0) scale(1);
            opacity: 1;
            pointer-events: auto;
        }

        .chat-header {
            background: linear-gradient(135deg, #10b981, #059669);
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: white;
        }

        .chat-header h4 {
            font-size: 1.05rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 0;
        }

        .chat-header-status {
            width: 8px;
            height: 8px;
            background: #4ade80;
            border-radius: 50%;
            display: inline-block;
        }

        .chat-close-btn {
            background: transparent;
            border: none;
            color: white;
            font-size: 1.2rem;
            cursor: pointer;
            opacity: 0.8;
            transition: var(--transition-smooth);
        }

        .chat-close-btn:hover {
            opacity: 1;
            transform: scale(1.1);
        }

        .chat-messages {
            flex-grow: 1;
            padding: 20px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 15px;
            background: rgba(11, 15, 25, 0.5);
        }

        .msg-bubble {
            max-width: 80%;
            padding: 10px 14px;
            border-radius: var(--border-radius-md);
            font-size: 0.9rem;
            line-height: 1.45;
        }

        .msg-bubble.bot {
            background: rgba(255, 255, 255, 0.06);
            color: var(--text-primary);
            align-self: flex-start;
            border: 1px solid var(--card-border);
            border-bottom-left-radius: 2px;
        }

        .msg-bubble.user {
            background: linear-gradient(135deg, #6366f1, #4f46e5);
            color: white;
            align-self: flex-end;
            border-bottom-right-radius: 2px;
        }

        .chat-input-panel {
            padding: 12px;
            border-top: 1px solid var(--card-border);
            display: flex;
            gap: 10px;
            background: var(--card-bg);
        }

        .chat-input-panel input {
            flex-grow: 1;
            padding: 10px 14px;
            background: var(--input-bg);
            border: 1px solid var(--input-border);
            border-radius: var(--border-radius-md);
            color: white;
            font-size: 0.9rem;
            outline: none;
        }

        .chat-send-btn {
            background: linear-gradient(135deg, #10b981, #059669);
            border: none;
            color: white;
            width: 40px;
            height: 40px;
            border-radius: var(--border-radius-md);
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: var(--transition-smooth);
        }

        .chat-send-btn:hover {
            transform: scale(1.05);
        }

        /* Success ticket state */
        .ticket-success-screen {
            text-align: center;
            padding: 30px 10px;
            display: none;
        }

        .success-tick {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            background: rgba(34, 197, 94, 0.15);
            border: 2px solid #22c55e;
            color: #22c55e;
            font-size: 2.2rem;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
        }

        /* Light theme adjustments */
        body.light-theme .info-card {
            background: rgba(255, 255, 255, 0.7);
            border-color: rgba(0, 0, 0, 0.08);
        }

        body.light-theme .info-card h4 {
            color: #0f172a;
        }

        body.light-theme .ticket-form-panel h3, 
        body.light-theme .ticket-success-screen h4 {
            color: #0f172a;
        }

        body.light-theme .msg-bubble.bot {
            background: rgba(0, 0, 0, 0.04);
            border-color: rgba(0, 0, 0, 0.08);
            color: #1e293b;
        }

        body.light-theme .chat-messages {
            background: rgba(255, 255, 255, 0.6);
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
            <div class="support-header">
                <h2>SkyGlide Support Center</h2>
                <p>Welcome to our passenger support center. Submit a query ticket, contact our helpdesk, or consult our live assistant below.</p>
            </div>

            <div class="support-grid">
                <!-- Support Contact Cards -->
                <div class="support-info-cards">
                    <div class="info-card">
                        <i class="fas fa-phone-alt"></i>
                        <div>
                            <h4>Support Helplines</h4>
                            <p>+91 6205709663</p>
                            <p>+91 9939253236 (Toll-Free)</p>
                        </div>
                    </div>

                    <div class="info-card">
                        <i class="fas fa-envelope"></i>
                        <div>
                            <h4>Support Email</h4>
                            <p>Skyglide121@gmail.com</p>
                            <p>refunds@skyglide.com</p>
                        </div>
                    </div>

                    <div class="info-card">
                        <i class="fas fa-map-marker-alt"></i>
                        <div>
                            <h4>Corporate Head Office</h4>
                            <p>AB1 Blue Street, Connaught Place</p>
                            <p>New Delhi, 110001, India</p>
                        </div>
                    </div>
                </div>

                <!-- Submit Ticket Panel -->
                <div class="ticket-form-panel">
                    <div id="ticketFormSection">
                        <h3>Create Support Ticket</h3>
                        <form id="supportTicketForm" novalidate>
                            <div class="form-group">
                                <label for="ticketName">Full Name *</label>
                                <input type="text" id="ticketName" placeholder="Your name" required>
                                <div class="error-message" id="error-ticketName">
                                    <i class="fas fa-exclamation-circle"></i> Name must be at least 3 characters.
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="ticketEmail">Email Address *</label>
                                <input type="email" id="ticketEmail" placeholder="yourname@gmail.com" required>
                                <div class="error-message" id="error-ticketEmail">
                                    <i class="fas fa-exclamation-circle"></i> Please enter a valid email address.
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="ticketCategory">Query Category *</label>
                                <select id="ticketCategory" required>
                                    <option value="" disabled selected>Select category</option>
                                    <option value="Refund & Cancellation">Refund & Cancellation</option>
                                    <option value="Baggage / Extra Weight">Baggage / Extra Weight</option>
                                    <option value="Seat Assignment">Seat Assignment</option>
                                    <option value="Payment Processing">Payment / Billing</option>
                                    <option value="General Travel Info">General Flight Query</option>
                                </select>
                                <div class="error-message" id="error-ticketCategory">
                                    <i class="fas fa-exclamation-circle"></i> Please select a ticket category.
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="ticketSubject">Subject *</label>
                                <input type="text" id="ticketSubject" placeholder="Brief summary of issue" required>
                                <div class="error-message" id="error-ticketSubject">
                                    <i class="fas fa-exclamation-circle"></i> Subject must be at least 5 characters.
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="ticketDetails">Details of the Query *</label>
                                <textarea id="ticketDetails" rows="4" placeholder="Detail your situation (flight numbers, dates, issue details)..." required></textarea>
                                <div class="error-message" id="error-ticketDetails">
                                    <i class="fas fa-exclamation-circle"></i> Please provide query details (minimum 15 characters).
                                </div>
                            </div>

                            <button type="submit" class="btn-apply">
                                <i class="fas fa-ticket-alt"></i> Generate Support Ticket
                            </button>
                        </form>
                    </div>

                    <!-- Ticket success screen -->
                    <div id="ticketSuccessSection" class="ticket-success-screen">
                        <div class="success-tick">
                            <i class="fas fa-check"></i>
                        </div>
                        <h4 style="font-size: 1.5rem; font-weight: 700; margin-bottom: 12px; color: white;">Support Ticket Generated!</h4>
                        <p id="ticketSuccessMessage" style="color: var(--text-secondary); margin-bottom: 25px; line-height: 1.5;">Ticket successfully submitted.</p>
                        <div style="padding: 12px 20px; background: rgba(255, 255, 255, 0.04); border: 1px solid var(--card-border); border-radius: var(--border-radius-md); display: inline-block; margin-bottom: 25px;">
                            <span style="font-size: 0.85rem; color: var(--text-secondary);">Ticket Case ID:</span>
                            <strong style="font-size: 1.1rem; color: #10b981; letter-spacing: 1px; margin-left: 8px;" id="ticketRefId">SG-98242</strong>
                        </div>
                        <div>
                            <button class="btn-apply" onclick="resetTicketForm()" style="max-width: 220px; margin: 0 auto;">Submit Another Request</button>
                        </div>
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

    <!-- Live Chatbot floating button and screen -->
    <button class="chat-widget-btn" id="openChatBtn" title="Chat with SkyGlide Support">
        <i class="fas fa-comments"></i>
    </button>

    <div class="chat-window" id="chatWindow">
        <div class="chat-header">
            <h4><span class="chat-header-status"></span> SkyGlide Assistant</h4>
            <button class="chat-close-btn" id="closeChatBtn">&times;</button>
        </div>
        <div class="chat-messages" id="chatMessages">
            <div class="msg-bubble bot">
                Hello! I am your SkyGlide digital travel helper. Ask me about **baggage**, **cancellations**, **refunds**, or **tickets**.
            </div>
        </div>
        <div class="chat-input-panel">
            <input type="text" id="chatInput" placeholder="Ask support details...">
            <button class="chat-send-btn" id="chatSendBtn"><i class="fas fa-paper-plane"></i></button>
        </div>
    </div>

    <script>
        // Chatbot logic
        const openChatBtn = document.getElementById('openChatBtn');
        const closeChatBtn = document.getElementById('closeChatBtn');
        const chatWindow = document.getElementById('chatWindow');
        const chatInput = document.getElementById('chatInput');
        const chatSendBtn = document.getElementById('chatSendBtn');
        const chatMessages = document.getElementById('chatMessages');

        openChatBtn.addEventListener('click', () => {
            chatWindow.classList.add('active');
            chatInput.focus();
        });

        closeChatBtn.addEventListener('click', () => {
            chatWindow.classList.remove('active');
        });

        function appendMessage(sender, text) {
            const bubble = document.createElement('div');
            bubble.className = `msg-bubble \${sender}`;
            bubble.innerText = text;
            chatMessages.appendChild(bubble);
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }

        function handleChatResponse(userText) {
            const text = userText.toLowerCase();
            let botText = "Thank you for contacting SkyGlide Support. We are reviewing your question and an agent will assist you shortly.";

            if (text.includes('baggage') || text.includes('luggage') || text.includes('weight')) {
                botText = "SkyGlide allows 15kg of check-in baggage and 7kg of cabin baggage for free on standard domestic flights. Additional weight options can be purchased under booking details.";
            } else if (text.includes('cancel') || text.includes('cancellation') || text.includes('reschedule')) {
                botText = "For flight cancellations, charges are based on the timeframe before departure. You can check the full details on our policies page or use 'Cancel Booking' inside your dashboard.";
            } else if (text.includes('refund')) {
                botText = "Once cancellation is confirmed, refunds are processed back to the original source mode of payment within 5 to 7 business banking days.";
            } else if (text.includes('ticket') || text.includes('pnr') || text.includes('download')) {
                botText = "You can download your tickets instantly from your dashboard or click 'Download Ticket' at the footer page by inserting your generated PNR code.";
            } else if (text.includes('payment') || text.includes('failed') || text.includes('money')) {
                botText = "If your payment failed but funds were debited, they will be auto-released back to your card within 48 hours. Please check your generated ticket state under 'Dashboard'.";
            }

            setTimeout(() => {
                appendMessage('bot', botText);
            }, 800);
        }

        function triggerUserSend() {
            const val = chatInput.value.trim();
            if (!val) return;

            appendMessage('user', val);
            chatInput.value = '';
            handleChatResponse(val);
        }

        chatSendBtn.addEventListener('click', triggerUserSend);
        chatInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                triggerUserSend();
            }
        });

        // Support Form ticket validations
        document.getElementById('supportTicketForm').addEventListener('submit', (e) => {
            e.preventDefault();

            let isValid = true;
            const nameEl = document.getElementById('ticketName');
            const emailEl = document.getElementById('ticketEmail');
            const catEl = document.getElementById('ticketCategory');
            const subEl = document.getElementById('ticketSubject');
            const detEl = document.getElementById('ticketDetails');

            // Reset errors
            document.querySelectorAll('.error-message').forEach(el => el.style.display = 'none');
            document.querySelectorAll('.error-input').forEach(el => el.classList.remove('error-input'));

            // Name
            if (nameEl.value.trim().length < 3) {
                isValid = false;
                nameEl.classList.add('error-input');
                document.getElementById('error-ticketName').style.display = 'flex';
            }

            // Email
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(emailEl.value.trim())) {
                isValid = false;
                emailEl.classList.add('error-input');
                document.getElementById('error-ticketEmail').style.display = 'flex';
            }

            // Category select
            if (!catEl.value) {
                isValid = false;
                catEl.classList.add('error-input');
                document.getElementById('error-ticketCategory').style.display = 'flex';
            }

            // Subject: min 5 chars
            if (subEl.value.trim().length < 5) {
                isValid = false;
                subEl.classList.add('error-input');
                document.getElementById('error-ticketSubject').style.display = 'flex';
            }

            // Details: min 15 chars
            if (detEl.value.trim().length < 15) {
                isValid = false;
                detEl.classList.add('error-input');
                document.getElementById('error-ticketDetails').style.display = 'flex';
            }

            if (isValid) {
                const randomTicketId = 'SG-' + Math.floor(10000 + Math.random() * 90000);
                document.getElementById('ticketRefId').innerText = randomTicketId;

                const nameVal = nameEl.value.trim();
                const subVal = subEl.value.trim();
                const catVal = catEl.value;

                document.getElementById('ticketSuccessMessage').innerHTML = `Thank you, <strong>\${nameVal}</strong>. We have logged a ticket for <strong>\${catVal}</strong> regarding <em>"\${subVal}"</em>. We will address this within 24 hours.`;

                document.getElementById('ticketFormSection').style.display = 'none';
                document.getElementById('ticketSuccessSection').style.display = 'block';
            }
        });

        function resetTicketForm() {
            document.getElementById('supportTicketForm').reset();
            document.getElementById('ticketFormSection').style.display = 'block';
            document.getElementById('ticketSuccessSection').style.display = 'none';
        }
    </script>
</body>
</html>
