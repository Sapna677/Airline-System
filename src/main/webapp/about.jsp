<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"
	integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg=="
	crossorigin="anonymous" referrerpolicy="no-referrer">
<link rel="stylesheet" href="css/style.css">
<script>
document.addEventListener('DOMContentLoaded', () => {
    // Dynamically inject FontAwesome if not already present
    if (!document.querySelector('link[href*="font-awesome"]') && !document.querySelector('link[href*="all.min.css"]')) {
        const faLink = document.createElement('link');
        faLink.rel = 'stylesheet';
        faLink.href = 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css';
        document.head.appendChild(faLink);
    }

    // 1. Theme Toggle Logic
    const savedTheme = localStorage.getItem('theme') || 'dark';
    if (savedTheme === 'light') {
        document.body.classList.add('light-theme');
    }

    // Create floating theme toggle button
    const toggleBtn = document.createElement('button');
    toggleBtn.id = 'theme-toggle-btn';
    toggleBtn.innerHTML = savedTheme === 'light' ? '<i class="fas fa-moon"></i>' : '<i class="fas fa-sun"></i>';
    toggleBtn.title = 'Switch Theme';
    
    // Style the toggle button dynamically
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

    // Hover effects
    toggleBtn.addEventListener('mouseenter', () => {
        toggleBtn.style.transform = 'scale(1.1) translateY(-3px)';
        toggleBtn.style.boxShadow = '0 12px 35px rgba(99, 102, 241, 0.45)';
    });
    toggleBtn.addEventListener('mouseleave', () => {
        toggleBtn.style.transform = 'scale(1) translateY(0)';
        toggleBtn.style.boxShadow = '0 8px 30px rgba(0, 0, 0, 0.35)';
    });

    // Toggle action
    toggleBtn.addEventListener('click', () => {
        const isLight = document.body.classList.toggle('light-theme');
        localStorage.setItem('theme', isLight ? 'light' : 'dark');
        toggleBtn.innerHTML = isLight ? '<i class="fas fa-moon"></i>' : '<i class="fas fa-sun"></i>';
        
        // Minor click scale bump animation
        toggleBtn.style.transform = 'scale(0.9)';
        setTimeout(() => {
            toggleBtn.style.transform = 'scale(1)';
        }, 100);
    });

    document.body.appendChild(toggleBtn);

    // 2. Dynamic Branding: SkyGlide Airways
    const logoDiv = document.querySelector('nav .logo');
    if (logoDiv && !logoDiv.querySelector('.logo-text')) {
        // Wrap logo in a flex container for alignment
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
	<!-- Background image overlay -->
	<div style="position: fixed; top: 0; left: 0; min-width: 100%; min-height: 100%; z-index: -2; background: url('al2.jpg') no-repeat center fixed; background-size: cover;"></div>
	<div class="bg-overlay"></div>

	<header class="standalone-header">
		<h1>About Us</h1>
		<nav>
			<ul>
				<li><a href="index.jsp">Home</a></li>
				<li><a href="searchFlights.jsp">Search Flights</a></li>
				<li><a href="flightStatus.jsp">Flight Status</a></li>
				<li><a href="baggageCalculator.jsp">Baggage</a></li>
				<li><a href="contact.jsp">Contact</a></li>
				<% if (session.getAttribute("email") != null) { %>
					<li><a href="profile.jsp"><i class="fas fa-user-circle"></i> Profile</a></li>
				<% } else { %>
					<li><a href="login.jsp">Login</a></li>
					<li><a href="signUp.jsp">Signup</a></li>
				<% } %>
			</ul>
		</nav>
	</header>

	<main class="standalone-container">
		<section>
			<h2>Welcome to Your Airline</h2>
			<p>At Your Airline, we are committed to providing our passengers
				with an exceptional flying experience. Established in 2000, we have
				been connecting people and places with our extensive network of
				domestic and international flights.</p>
		</section>

		<section>
			<h2>Our Mission</h2>
			<p>Our mission is to ensure safety, comfort, and reliability for
				all our passengers while delivering outstanding customer service.</p>
		</section>

		<section>
			<h2>Our Services</h2>
			<ul>
				<li>On-time flight departures and arrivals</li>
				<li>In-flight entertainment and dining options</li>
				<li>Loyalty programs and frequent flyer benefits</li>
				<li>Customer support available 24/7</li>
			</ul>
		</section>

		<section>
			<h2>Contact Us</h2>
			<p>
				For inquiries, feel free to reach us at <a
					href="mailto:support@yourairline.com" style="color: var(--accent-color); font-weight: 600;">support@yourairline.com</a>
				or call us at (123) 456-7890.
			</p>
		</section>
	</main>

	<footer>
		<div class="footer-bottom">
			<p>&copy; 2026 Your Airline. All rights reserved.</p>
		</div>
	</footer>
</body>

</html>
