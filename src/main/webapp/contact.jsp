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
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY=" crossorigin=""/>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js" integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin=""></script>
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
				<div class="map-card" style="padding: 0; overflow: hidden; position: relative;">
					<div id="airport-map" style="width: 100%; height: 100%; min-height: 450px;"></div>
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

	<script>
	document.addEventListener('DOMContentLoaded', () => {
		// Initialize the map centered on India (geographical center)
		const map = L.map('airport-map', {
			scrollWheelZoom: false // Disable zoom on scroll for better page navigation
		}).setView([20.5937, 78.9629], 5);

		// Use a premium Dark Matter tile layer to match our dark theme
		L.tileLayer('https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png', {
			attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors &copy; <a href="https://carto.com/attributions">CARTO</a>',
			subdomains: 'abcd',
			maxZoom: 20
		}).addTo(map);

		// List of major airports in India with names, codes, coordinates, and Google Maps search links
		const airports = [
			{ name: "Indira Gandhi International Airport", code: "DEL", city: "New Delhi", state: "Delhi", lat: 28.5562, lng: 77.1000, link: "https://www.google.com/maps/search/?api=1&query=Indira+Gandhi+International+Airport+Delhi" },
			{ name: "Chhatrapati Shivaji Maharaj International Airport", code: "BOM", city: "Mumbai", state: "Maharashtra", lat: 19.0896, lng: 72.8656, link: "https://www.google.com/maps/search/?api=1&query=Chhatrapati+Shivaji+Maharaj+International+Airport+Mumbai" },
			{ name: "Kempegowda International Airport", code: "BLR", city: "Bengaluru", state: "Karnataka", lat: 13.1986, lng: 77.7066, link: "https://www.google.com/maps/search/?api=1&query=Kempegowda+International+Airport+Bengaluru" },
			{ name: "Netaji Subhash Chandra Bose International Airport", code: "CCU", city: "Kolkata", state: "West Bengal", lat: 22.6547, lng: 88.4467, link: "https://www.google.com/maps/search/?api=1&query=Netaji+Subhash+Chandra+Bose+International+Airport+Kolkata" },
			{ name: "Chennai International Airport", code: "MAA", city: "Chennai", state: "Tamil Nadu", lat: 12.9941, lng: 80.1709, link: "https://www.google.com/maps/search/?api=1&query=Chennai+International+Airport" },
			{ name: "Rajiv Gandhi International Airport", code: "HYD", city: "Hyderabad", state: "Telangana", lat: 17.2403, lng: 78.4294, link: "https://www.google.com/maps/search/?api=1&query=Rajiv+Gandhi+International+Airport+Hyderabad" },
			{ name: "Jayprakash Narayan Airport", code: "PAT", city: "Patna", state: "Bihar", lat: 25.5913, lng: 85.0880, link: "https://www.google.com/maps/search/?api=1&query=Jayprakash+Narayan+Airport+Patna" },
			{ name: "Pune Airport", code: "PNQ", city: "Pune", state: "Maharashtra", lat: 18.5822, lng: 73.9197, link: "https://www.google.com/maps/search/?api=1&query=Pune+Airport" },
			{ name: "Goa International Airport", code: "GOI", city: "Dabolim", state: "Goa", lat: 15.3808, lng: 73.8314, link: "https://www.google.com/maps/search/?api=1&query=Goa+International+Airport" },
			{ name: "Jaipur International Airport", code: "JAI", city: "Jaipur", state: "Rajasthan", lat: 26.8242, lng: 75.8122, link: "https://www.google.com/maps/search/?api=1&query=Jaipur+International+Airport" },
			{ name: "Sardar Vallabhbhai Patel International Airport", code: "AMD", city: "Ahmedabad", state: "Gujarat", lat: 23.0772, lng: 72.6347, link: "https://www.google.com/maps/search/?api=1&query=Sardar+Vallabhbhai+Patel+International+Airport" },
			{ name: "Cochin International Airport", code: "COK", city: "Kochi", state: "Kerala", lat: 10.1520, lng: 76.4018, link: "https://www.google.com/maps/search/?api=1&query=Cochin+International+Airport" },
			{ name: "Chaudhary Charan Singh International Airport", code: "LKO", city: "Lucknow", state: "Uttar Pradesh", lat: 26.7606, lng: 80.8893, link: "https://www.google.com/maps/search/?api=1&query=Chaudhary+Charan+Singh+International+Airport" },
			{ name: "Sri Guru Ram Dass Jee International Airport", code: "ATQ", city: "Amritsar", state: "Punjab", lat: 31.7096, lng: 74.7997, link: "https://www.google.com/maps/search/?api=1&query=Sri+Guru+Ram+Dass+Jee+International+Airport" },
			{ name: "Biju Patnaik International Airport", code: "BBI", city: "Bhubaneswar", state: "Odisha", lat: 20.2444, lng: 85.8178, link: "https://www.google.com/maps/search/?api=1&query=Biju+Patnaik+International+Airport" }
		];

		// Custom interactive plane marker icon
		const planeIcon = L.divIcon({
			html: `<div style="background: linear-gradient(135deg, #6366f1, #4f46e5); color: white; border-radius: 50%; width: 32px; height: 32px; display: flex; align-items: center; justify-content: center; border: 2px solid white; box-shadow: 0 4px 12px rgba(99, 102, 241, 0.45); cursor: pointer; transition: all 0.2s ease;">
					<i class="fas fa-plane" style="transform: rotate(-45deg); font-size: 13px;"></i>
				   </div>`,
			className: 'custom-plane-marker',
			iconSize: [32, 32],
			iconAnchor: [16, 16],
			popupAnchor: [0, -16]
		});

		// Add markers to map with beautiful styled popup details
		airports.forEach(airport => {
			const marker = L.marker([airport.lat, airport.lng], { icon: planeIcon }).addTo(map);
			
			const popupHTML = `
				<div style="font-family: 'Outfit', sans-serif; padding: 6px; color: #0f172a; min-width: 190px; text-align: left;">
					<h4 style="margin: 0 0 6px 0; color: #4f46e5; font-size: 0.95rem; font-weight: 700; line-height: 1.3;">${airport.name}</h4>
					<p style="margin: 0 0 4px 0; font-size: 0.8rem; color: #64748b;"><strong style="color: #475569;">IATA Code:</strong> ${airport.code}</p>
					<p style="margin: 0 0 10px 0; font-size: 0.8rem; color: #64748b;"><strong style="color: #475569;">State/City:</strong> ${airport.city}, ${airport.state}</p>
					<a href="${airport.link}" target="_blank" style="display: block; text-align: center; background: linear-gradient(135deg, #6366f1, #4f46e5); color: white; text-decoration: none; padding: 7px 12px; border-radius: 6px; font-size: 0.75rem; font-weight: 600; box-shadow: 0 3px 8px rgba(99, 102, 241, 0.25); transition: all 0.2s ease;">
						<i class="fas fa-map-marked-alt" style="margin-right: 4px;"></i> View on Google Maps
					</a>
				</div>
			`;
			marker.bindPopup(popupHTML);
		});
	});
	</script>
</body>
</html>