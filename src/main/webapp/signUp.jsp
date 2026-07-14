<!DOCTYPE html>
<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" href="logo.png">

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

<title>SignUp</title>
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
			<a href="login.jsp"><i class="fas fa-arrow-left"></i> Login</a>
		</button>
	</div>

	<div class="page-container" style="justify-content: center; align-items: center; padding-top: 40px; padding-bottom: 40px;">
		<div class="glass-card" style="max-width: 550px;">
			<h1 class="signup-heading">SignUp Page</h1>
			<form action="signUpAction.jsp" method="post">
				<label for="username">Username</label>
				<input type="text" id="username" name="username" placeholder="Enter your UserName" required>
				
				<label for="password">Password</label>
				<input type="password" id="password" name="password" placeholder="Enter your password" required>
				
				<label for="email">Email</label>
				<input type="email" id="email" name="email" placeholder="Enter your email" required>
				
				<label for="firstName">First Name</label>
				<input type="text" id="firstName" name="firstName" placeholder="Enter your FirstName" required>
				
				<label for="lastName">Last Name</label>
				<input type="text" id="lastName" name="lastName" placeholder="Enter your LastName" required>
				
				<label for="phone">Phone Number</label>
				<input type="tel" id="phone" name="phone" placeholder="Enter your Phone Number" required>
				
				<label for="address">Address</label>
				<input type="text" id="address" name="address" placeholder="Enter your Address" required>
				
				<label for="dob">Date of Birth</label>
				<input type="date" id="dob" name="dob" placeholder="Enter your D.O.B" required>
				
				<label for="usertype">User Type</label>
				<input type="text" id="usertype" name="usertype" placeholder="Enter User Type" required>
				
				<input type="submit" value="SignUp">
			</form>
			
			<div class="card-footer-links">
				<a href="login.jsp">Already have an account? Login</a>
			</div>
			
			<%
			String msg = request.getParameter("msg");
			if ("NotExixts".equals(msg)) {
			%>
			<p style="color: #ef4444; margin-top: 15px; text-align: center; font-weight: 600;">Incorrect Username or Password</p>
			<%
			}
			if ("Invalid".equals(msg)) {
			%>
			<p style="color: #ef4444; margin-top: 15px; text-align: center; font-weight: 600;">Something Went Wrong! Try Again!</p>
			<%
			}
			%>
		</div>
	</div>
</body>
</html>
