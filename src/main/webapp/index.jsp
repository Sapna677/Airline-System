<!DOCTYPE html>
<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta charset="ISO-8859-1">
<title>Airline Home Page</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"
	integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg=="
	crossorigin="anonymous" referrerpolicy="no-referrer">
<link rel="stylesheet" href="css/style.css">
<script>
document.addEventListener('DOMContentLoaded', () => {
    
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
function toggleReturnDate(isRound) {
    const returnDiv = document.getElementById('returnDateDiv');
    const returnInput = document.getElementById('returnDate');
    if (isRound) {
        returnDiv.style.display = 'block';
        returnInput.setAttribute('required', 'required');
    } else {
        returnDiv.style.display = 'none';
        returnInput.removeAttribute('required');
        returnInput.value = '';
    }
}
</script>

<script src="js/theme.js"></script>
</head>
<body>

	<video class="bg-video" autoplay loop muted>
		<source src="Air4.mp4" type="video/mp4">
		Your browser does not support the video tag.
	</video>
	<div class="bg-overlay"></div>

	<nav>
		<div class="logo">
			<img alt="Airline Logo" src="download.png">
		</div>
		<ul>
			<li><a href="login.jsp">Login</a></li>
			<li><a href="signUp.jsp">Signup</a></li>
			<li><a href="searchFlights.jsp">Search Flights</a></li>
			<li><a href="flightStatus.jsp">Flight Status</a></li>
			<li><a href="contact.jsp">Contact</a></li>
			<li><a href="about.jsp">About</a></li>
		</ul>
	</nav>

	<div class="page-container">
		<div class="hero-section">
			<h1>Indian Airline Best Way To find a great deal in this year</h1>
			<h5 class="subtitle">We do the right to get best offer to you
				,best and cheap flight,let us to know what you need exactly that's
				best chalange for us</h5>
		</div>

		<div class="glass-card" style="margin: 0 auto 40px; max-width: 550px;">
			<h3>Search Flights</h3>
			<form action="flightResults.jsp" method="get">
				<div style="display: flex; gap: 20px; margin-bottom: 15px;">
					<label style="display: inline-flex; align-items: center; gap: 8px; cursor: pointer; color: white; font-weight: 500;">
						<input type="radio" name="tripType" value="oneWay" checked onclick="toggleReturnDate(false)"> One Way
					</label>
					<label style="display: inline-flex; align-items: center; gap: 8px; cursor: pointer; color: white; font-weight: 500;">
						<input type="radio" name="tripType" value="round" onclick="toggleReturnDate(true)"> Round Trip
					</label>
				</div>

				<label for="departure">Departure:</label>
				<input type="text" id="departure" name="departure" required>
				
				<label for="arrival">Arrival:</label>
				<input type="text" id="arrival" name="arrival" required>

				<div id="returnDateDiv" style="display: none; margin-bottom: 15px;">
					<label for="returnDate">Return Date:</label>
					<input type="date" id="returnDate" name="returnDate" style="width: 100%; box-sizing: border-box; background: rgba(15, 23, 42, 0.6); border: 1px solid rgba(255,255,255,0.15); color: white; padding: 12px 16px; border-radius: 8px; outline: none;">
				</div>
				
				<input type="submit" value="Search Flights">
			</form>
		</div>

		<section id="destinations" class="destinations">
			<h2>Popular Destinations</h2>
			<div class="destination-list">
				<button class="icon-scroll" onclick="scrollLeftDest()">
					<i class="fas fa-angle-left"></i>
				</button>
				<div class="cover">
					<div class="scroll-images" id="scrollContainer">
						<div class="child">
							<img class="child-img" src="destination1.jpg" alt="Destination 1">
							<span class="destination-name">Delhi</span>
						</div>
						<div class="child">
							<img class="child-img" src="destination2.jpg" alt="Destination 2">
							<span class="destination-name">Mumbai</span>
						</div>
						<div class="child">
							<img class="child-img" src="destination6.jpg" alt="Destination 3">
							<span class="destination-name">Chennai</span>
						</div>
						<div class="child">
							<img class="child-img" src="destination4.jpg" alt="Destination 4">
							<span class="destination-name">Kolkata</span>
						</div>
						<div class="child">
							<img class="child-img" src="destination8.jpg" alt="Destination 5">
							<span class="destination-name">Goa</span>
						</div>
						<div class="child">
							<img class="child-img" src="destination3.jpg" alt="Destination 6">
							<span class="destination-name">Bangalore</span>
						</div>
						<div class="child">
							<img class="child-img" src="destination7.jpg" alt="Destination 7">
							<span class="destination-name">Hyderabad</span>
						</div>
						<div class="child">
							<img class="child-img" src="destination5.jpg" alt="Destination 8">
							<span class="destination-name">Jaipur</span>
						</div>
					</div>
				</div>
				<button class="icon-scroll" onclick="scrollRightDest()">
					<i class="fas fa-angle-right"></i>
				</button>
			</div>
		</section>

		<section class="about-landing" id="about">
			<div class="container">
				<div class="grid">
					<div class="image-wrapper">
						<img src="about.png" alt="Easy travel">
					</div>
					<div class="content-wrapper">
						<h2>Easy way to go to your next destination</h2>
						<p>A destination can be a place that tourists visit for
							leisure or business, and can be a city, region, or country.
							Destinations can stand out for their natural features, such as beaches, mountains, or
							volcanoes. History: Destinations with a fascinating history can
							be attractive to visitors.</p>
						<ul class="bullets">
							<li>
								<i class="fa fa-chevron-circle-right"></i>
								<p>Activities are what the tourists perform for fun and amusement. For example,
								boating, scuba diving, canoeing, camel riding, and visiting a place.</p>
							</li>
							<li>
								<i class="fa fa-chevron-circle-right"></i>
								<p>India is a multi-center destination where each Indian state or region
								offers different culture, nature, and culinary experience.</p>
							</li>
						</ul>
						<div class="app-badges">
							<a href="https://play.google.com/store/search?q=flight&c=apps" target="_blank">
								<img src="google-play.png" alt="Google Play Store">
							</a>
							<a href="https://apps.apple.com/us/search?term=flight" target="_blank">
								<img src="app-store.png" alt="App Store">
							</a>
						</div>
					</div>
				</div>
			</div>
		</section>

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
		function scrollLeftDest() {
			document.getElementById('scrollContainer').scrollBy({
				left : -200,
				behavior : 'smooth'
			});
		}

		function scrollRightDest() {
			document.getElementById('scrollContainer').scrollBy({
				left : 200,
				behavior : 'smooth'
			});
		}
	</script>
</body>
</html>
