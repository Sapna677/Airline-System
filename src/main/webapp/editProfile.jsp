<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="java.sql.*, mypack.DatabaseUtil"%>
<!DOCTYPE html>
<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta charset="ISO-8859-1">
<title>Edit Profile</title>
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

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"
	integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg=="
	crossorigin="anonymous" referrerpolicy="no-referrer">
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
			<a href="userProfile.jsp"><i class="fas fa-arrow-left"></i> Back</a>
		</button>
	</div>

	<%
    // Prevent browser back-button caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

	String email = (String) session.getAttribute("email");
	if (email == null) {
		response.sendRedirect("login.jsp");
		return;
	}

	String username = "";
	String firstName = "";
	String lastName = "";
	String phone = "";
	String address = "";
	String dob = "";

	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	try {
		con = DatabaseUtil.getCon();
		String query = "SELECT username, firstName, lastName, phone, address, dob FROM users WHERE email = ?";
		pstmt = con.prepareStatement(query);
		pstmt.setString(1, email);
		rs = pstmt.executeQuery();

		if (rs.next()) {
			username = rs.getString("username");
			firstName = rs.getString("firstName");
			if (firstName == null) firstName = "";
			lastName = rs.getString("lastName");
			if (lastName == null) lastName = "";
			phone = rs.getString("phone");
			if (phone == null) phone = "";
			address = rs.getString("address");
			if (address == null) address = "";
			Date dobDate = rs.getDate("dob");
			if (dobDate != null) {
				dob = dobDate.toString();
			}
		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		if (rs != null) rs.close();
		if (pstmt != null) pstmt.close();
		if (con != null) con.close();
	}
	%>

	<div class="page-container" style="padding-top: 50px; padding-bottom: 50px;">
		<main class="standalone-container" style="max-width: 550px; margin: auto;">
			<h1 class="signup-heading" style="text-align: center; margin-bottom: 25px;"><i class="fas fa-user-edit"></i> Edit Profile</h1>
			
			<%
			String error = request.getParameter("error");
			if (error != null) {
			%>
			<div style="background: rgba(239, 68, 68, 0.15); border: 1px solid #ef4444; border-radius: var(--border-radius-md); padding: 12px; margin-bottom: 20px; color: #ef4444; text-align: center; font-size: 0.9rem; font-weight: 600;">
				<i class="fas fa-exclamation-circle"></i> Error updating profile. Please try again.
			</div>
			<%
			}
			%>

			<form action="editProfileAction.jsp" method="post" class="signup-form-grid" style="display: flex; flex-direction: column; gap: 15px;">
				
				<div class="input-group">
					<label for="email"><i class="fas fa-envelope"></i> Email Address (Cannot Change)</label>
					<input type="email" id="email" value="<%=email%>" disabled style="background: rgba(255,255,255,0.05); color: rgba(255,255,255,0.4); cursor: not-allowed;">
				</div>

				<div class="input-group">
					<label for="username"><i class="fas fa-user"></i> Username</label>
					<input type="text" id="username" name="username" value="<%=username%>" required placeholder="Enter username">
				</div>

				<div style="display: flex; gap: 15px;">
					<div class="input-group" style="flex: 1;">
						<label for="firstName"><i class="fas fa-id-card"></i> First Name</label>
						<input type="text" id="firstName" name="firstName" value="<%=firstName%>" required placeholder="First Name">
					</div>
					<div class="input-group" style="flex: 1;">
						<label for="lastName"><i class="fas fa-id-card"></i> Last Name</label>
						<input type="text" id="lastName" name="lastName" value="<%=lastName%>" required placeholder="Last Name">
					</div>
				</div>

				<div class="input-group">
					<label for="phone"><i class="fas fa-phone"></i> Phone Number</label>
					<input type="tel" id="phone" name="phone" value="<%=phone%>" required placeholder="Enter phone number">
				</div>

				<div class="input-group">
					<label for="address"><i class="fas fa-map-marker-alt"></i> Address</label>
					<input type="text" id="address" name="address" value="<%=address%>" required placeholder="Enter address">
				</div>

				<div class="input-group">
					<label for="dob"><i class="fas fa-calendar-alt"></i> Date of Birth</label>
					<input type="date" id="dob" name="dob" value="<%=dob%>" required>
				</div>

				<button type="submit" class="btn-primary" style="margin-top: 15px; width: 100%;">
					<i class="fas fa-save"></i> Save Changes
				</button>
			</form>
		</main>
	</div>
</body>
</html>
