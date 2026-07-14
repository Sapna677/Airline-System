<style>
footer {
    background: rgba(15, 23, 42, 0.7);
    backdrop-filter: blur(12px);
    -webkit-backdrop-filter: blur(12px);
    border-top: 1px solid rgba(255, 255, 255, 0.08);
    padding: 40px 20px 20px;
    margin-top: 50px;
    font-family: 'Outfit', Arial, sans-serif;
    color: #f8fafc;
}

.footer-content {
    max-width: 1200px;
    margin: 0 auto;
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 30px;
    padding-bottom: 30px;
}

.footer-section h3 {
    font-size: 1.1rem;
    font-weight: 600;
    color: #f8fafc;
    margin-bottom: 20px;
    position: relative;
}

.footer-section h3::after {
    content: '';
    position: absolute;
    left: 0;
    bottom: -6px;
    width: 35px;
    height: 2px;
    background: #6366f1;
    border-radius: 2px;
}

.footer-section ul {
    list-style: none;
    padding: 0;
    margin: 0;
}

.footer-section ul li {
    margin-bottom: 12px;
}

.footer-section ul li a {
    color: #94a3b8;
    text-decoration: none;
    font-size: 0.9rem;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    transition: all 0.3s ease;
}

.footer-section ul li a i {
    font-size: 0.85rem;
    transition: transform 0.3s ease;
}

.footer-section ul li a:hover {
    color: #6366f1;
    transform: translateX(3px);
}

.footer-section ul li a:hover i {
    transform: scale(1.1);
}

.footer-bottom {
    max-width: 1200px;
    margin: 0 auto;
    border-top: 1px solid rgba(255, 255, 255, 0.05);
    padding-top: 20px;
    text-align: center;
}

.footer-bottom p {
    font-size: 0.85rem;
    color: #64748b;
}

@media (max-width: 480px) {
    .footer-content {
        grid-template-columns: 1fr;
        gap: 25px;
        text-align: center;
    }
    .footer-section h3::after {
        left: 50%;
        transform: translateX(-50%);
    }
    .footer-section ul li a {
        justify-content: center;
    }
}

/* Premium Navigation Bar Override for all admin pages */
nav {
    background: rgba(15, 23, 42, 0.6) !important;
    backdrop-filter: blur(12px) !important;
    -webkit-backdrop-filter: blur(12px) !important;
    border-bottom: 1px solid rgba(255, 255, 255, 0.08) !important;
    display: flex !important;
    justify-content: space-between !important;
    align-items: center !important;
    padding: 10px 40px !important;
    position: sticky !important;
    top: 0 !important;
    z-index: 100 !important;
    height: auto !important;
    box-sizing: border-box !important;
    width: 100% !important;
}

nav .logo img {
    height: 45px !important;
    background: none !important;
}

nav ul {
    list-style: none !important;
    display: flex !important;
    align-items: center !important;
    gap: 15px !important;
    margin: 0 !important;
    padding: 0 !important;
}

nav ul li {
    margin-left: 0 !important;
}

nav ul li a {
    color: #f8fafc !important;
    text-decoration: none !important;
    padding: 10px 20px !important;
    font-weight: 500 !important;
    font-size: 0.95rem !important;
    border-radius: 8px !important;
    transition: all 0.3s ease !important;
    display: flex !important;
    align-items: center !important;
    gap: 8px !important;
}

nav ul li a:hover {
    background: rgba(255, 255, 255, 0.1) !important;
    color: #6366f1 !important;
    box-shadow: 0 0 15px rgba(99, 102, 241, 0.2) !important;
}

/* Responsive Navigation for Mobile */
@media (max-width: 768px) {
    nav {
        flex-direction: column !important;
        gap: 15px !important;
        padding: 15px 20px !important;
        text-align: center !important;
    }
    nav ul {
        flex-wrap: wrap !important;
        justify-content: center !important;
        width: 100% !important;
        gap: 8px !important;
    }
    nav ul li a {
        padding: 8px 12px !important;
        font-size: 0.85rem !important;
    }
}

/* Premium Responsive Table Styles */
.table-container {
    width: 90% !important;
    max-width: 1200px !important;
    margin: 30px auto !important;
    overflow-x: auto !important;
    -webkit-overflow-scrolling: touch !important;
    border-radius: 16px !important;
    border: 1px solid rgba(255, 255, 255, 0.08) !important;
    background: rgba(30, 41, 59, 0.7) !important;
    backdrop-filter: blur(12px) !important;
    -webkit-backdrop-filter: blur(12px) !important;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3) !important;
    box-sizing: border-box !important;
}

table {
    width: 100% !important;
    border-collapse: collapse !important;
    margin: 0 !important;
    color: #f8fafc !important;
    background: transparent !important;
}

th, td {
    padding: 14px 16px !important;
    text-align: center !important;
    border: none !important;
    border-bottom: 1px solid rgba(255, 255, 255, 0.05) !important;
    white-space: nowrap !important;
}

th {
    background-color: rgba(99, 102, 241, 0.15) !important;
    color: #6366f1 !important;
    font-weight: 600 !important;
    text-transform: uppercase !important;
    font-size: 0.85rem !important;
    letter-spacing: 0.5px !important;
}

td {
    font-size: 0.9rem !important;
    color: #cbd5e1 !important;
}

tr:hover {
    background: rgba(255, 255, 255, 0.02) !important;
}

td a {
    color: #6366f1 !important;
    text-decoration: none !important;
    font-weight: 500 !important;
    transition: all 0.3s ease !important;
}

td a:hover {
    color: #4f46e5 !important;
    text-decoration: underline !important;
}

/* Headings */
h1, h2 {
    color: #f8fafc !important;
    font-family: 'Outfit', sans-serif !important;
    margin-top: 30px !important;
    margin-bottom: 20px !important;
    text-shadow: 0 2px 10px rgba(0,0,0,0.3) !important;
}

/* Action forms / standalones container styling */
.back-link {
    display: inline-block !important;
    margin: 15px auto !important;
    color: #f8fafc !important;
    background: rgba(99, 102, 241, 0.2) !important;
    border: 1px solid rgba(99, 102, 241, 0.4) !important;
    padding: 8px 16px !important;
    border-radius: 8px !important;
    text-decoration: none !important;
    transition: all 0.3s ease !important;
}
.back-link:hover {
    background: #6366f1 !important;
    color: #ffffff !important;
    box-shadow: 0 0 15px rgba(99, 102, 241, 0.3) !important;
}

/* Responsive Form styling for admin pages */
form {
    width: 90% !important;
    max-width: 450px !important;
    margin: 30px auto !important;
    padding: 30px 24px !important;
    background: rgba(30, 41, 59, 0.7) !important;
    backdrop-filter: blur(12px) !important;
    -webkit-backdrop-filter: blur(12px) !important;
    border: 1px solid rgba(255, 255, 255, 0.08) !important;
    border-radius: 16px !important;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3) !important;
    color: #f8fafc !important;
    box-sizing: border-box !important;
}

form label {
    display: block !important;
    margin-bottom: 8px !important;
    color: #94a3b8 !important;
    font-size: 0.9rem !important;
    font-weight: 500 !important;
}

form input[type="text"], 
form input[type="number"], 
form input[type="datetime-local"], 
form select {
    width: 100% !important;
    padding: 12px 16px !important;
    margin-bottom: 20px !important;
    background: rgba(255, 255, 255, 0.05) !important;
    border: 1px solid rgba(255, 255, 255, 0.1) !important;
    border-radius: 8px !important;
    color: #ffffff !important;
    font-family: 'Outfit', sans-serif !important;
    font-size: 0.95rem !important;
    transition: all 0.3s ease !important;
    box-sizing: border-box !important;
}

form input[type="text"]:focus, 
form input[type="number"]:focus, 
form input[type="datetime-local"]:focus, 
form select:focus {
    border-color: #6366f1 !important;
    background: rgba(255, 255, 255, 0.08) !important;
    outline: none !important;
    box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.25) !important;
}

form input[type="submit"], 
form input[type="button"], 
form button {
    width: 100% !important;
    padding: 12px !important;
    margin-top: 10px !important;
    background: linear-gradient(135deg, #6366f1, #4f46e5) !important;
    color: #ffffff !important;
    font-weight: 600 !important;
    border: none !important;
    border-radius: 8px !important;
    cursor: pointer !important;
    font-family: 'Outfit', sans-serif !important;
    font-size: 1rem !important;
    transition: all 0.3s ease !important;
}

form input[type="submit"]:hover, 
form button:hover {
    background: linear-gradient(135deg, #4f46e5, #4338ca) !important;
    box-shadow: 0 0 15px rgba(99, 102, 241, 0.3) !important;
}

form input[type="button"] {
    background: rgba(255, 255, 255, 0.08) !important;
    border: 1px solid rgba(255, 255, 255, 0.1) !important;
    color: #f8fafc !important;
}

form input[type="button"]:hover {
    background: rgba(255, 255, 255, 0.15) !important;
}

/* Force body styling theme across all admin pages */
body {
    background: linear-gradient(135deg, rgba(15, 23, 42, 0.85), rgba(88, 28, 135, 0.45)), url('plane.jpg') !important;
    background-size: cover !important;
    background-repeat: no-repeat !important;
    background-attachment: fixed !important;
    background-position: center !important;
    font-family: 'Outfit', sans-serif !important;
    color: #f8fafc !important;
    margin: 0 !important;
    padding: 0 !important;
    overflow-x: hidden !important;
    min-height: 100vh !important;
}
</style>

<footer>
    <div class="footer-content">
        <div class="footer-section">
            <h3>About Us</h3>
            <ul>
                <li><a href="<%=request.getContextPath()%>/about.jsp"><i class="fas fa-info-circle"></i> Company Info</a></li>
                <li><a href="<%=request.getContextPath()%>/careers.jsp"><i class="fas fa-briefcase"></i> Careers</a></li>
                <li><a href="<%=request.getContextPath()%>/news.jsp"><i class="fas fa-newspaper"></i> News</a></li>
            </ul>
        </div>
        <div class="footer-section">
            <h3>Contact Us</h3>
            <ul>
                <li><a href="<%=request.getContextPath()%>/contact.jsp"><i class="fas fa-phone-alt"></i> Customer Service</a></li>
                <li><a href="<%=request.getContextPath()%>/feedback.jsp"><i class="fas fa-comments"></i> Feedback</a></li>
                <li><a href="<%=request.getContextPath()%>/support.jsp"><i class="fas fa-life-ring"></i> Support</a></li>
            </ul>
        </div>
        <div class="footer-section">
            <h3>Help</h3>
            <ul>
                <li><a href="<%=request.getContextPath()%>/faq.jsp"><i class="fas fa-question-circle"></i> FAQ</a></li>
                <li><a href="<%=request.getContextPath()%>/policies.jsp"><i class="fas fa-file-alt"></i> Policies</a></li>
                <li><a href="<%=request.getContextPath()%>/terms.jsp"><i class="fas fa-file-contract"></i> Terms of Service</a></li>
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
        <p>&copy; 2026 Our Airline. All rights reserved.</p>
    </div>
</footer>
