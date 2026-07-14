<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<!DOCTYPE html>
<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta charset="ISO-8859-1">
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

<title>Contact Us</title>
<script src="js/theme.js"></script>
</head>
<body>
	<!-- Background video -->
	<video class="bg-video" autoplay loop muted>
		<source src="Air4.mp4" type="video/mp4">
		Your browser does not support the video tag.
	</video>
	<div class="bg-overlay"></div>

	<div class="btn-nav-floating">
		<button>
			<a href="index.jsp"><i class="fas fa-home"></i> Home</a>
		</button>
	</div>

	<div class="page-container">
		<main class="standalone-container" style="max-width: 1000px; margin-top: 40px; margin-bottom: 40px;">
			<div class="contact-grid">
				<div class="contact-info-panel">
					<h1>Contact Us</h1>
					<p>We are dedicated to providing the best booking experience. Reach out to our customer services 24/7 or write to us directly.</p>
					
					<ul style="margin: 25px 0 35px; display: flex; flex-direction: column; gap: 15px; list-style: none;">
						<li style="display: flex; align-items: center; gap: 15px; color: var(--text-secondary); font-size: 1.05rem;">
							<i class="fas fa-phone-alt" style="color: var(--accent-color); font-size: 1.2rem; width: 20px;"></i>
							<span>+91 6205709663</span>
						</li>
						<li style="display: flex; align-items: center; gap: 15px; color: var(--text-secondary); font-size: 1.05rem;">
							<i class="fas fa-phone-alt" style="color: var(--accent-color); font-size: 1.2rem; width: 20px;"></i>
							<span>+91 9939253236</span>
						</li>
						<li style="display: flex; align-items: center; gap: 15px; color: var(--text-secondary); font-size: 1.05rem;">
							<i class="fas fa-envelope" style="color: var(--accent-color); font-size: 1.2rem; width: 20px;"></i>
							<span>Skyglide121@gmail.com</span>
						</li>
						<li style="display: flex; align-items: center; gap: 15px; color: var(--text-secondary); font-size: 1.05rem;">
							<i class="fas fa-map-marker-alt" style="color: var(--accent-color); font-size: 1.2rem; width: 20px;"></i>
							<span>AB1 Blue Street, India, New Delhi</span>
						</li>
					</ul>
					
					<div class="socials">
						<a href="https://www.facebook.com/" class="s-link" target="_blank"><i class="fab fa-facebook-f"></i></a>
						<a href="https://www.twitter.com/" class="s-link" target="_blank"><i class="fab fa-twitter"></i></a>
						<a href="https://www.instagram.com/" class="s-link" target="_blank"><i class="fab fa-instagram"></i></a>
						<a href="https://www.linkedin.com/in/sapna-kumari-22536a307/" class="s-link" target="_blank"><i class="fab fa-linkedin-in"></i></a>
						<a href="https://www.whatsapp.com/" class="s-link" target="_blank"><i class="fab fa-whatsapp"></i></a>
					</div>
				</div>
				<div class="map-card">
					<iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d10169245.332449624!2d-19.645046149999974!3d51.5182443!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x48761b2a3fbb08a5%3A0xa0d599016699b7ff!2sTravel%20Center!5e0!3m2!1sfr!2suk!4v1704819178119!5m2!1sfr!2suk" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
				</div>
			</div>
		</main>

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
				<p>&copy; 2026 Our Airline. All rights reserved.</p>
			</div>
		</footer>
	</div>
</body>
</html>
</body>
</html>