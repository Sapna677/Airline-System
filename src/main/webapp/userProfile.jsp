<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="java.sql.*, mypack.DatabaseUtil"%>
<%
    // Prevent browser back-button caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>

<!DOCTYPE html>
<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta charset="ISO-8859-1">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"
	integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg=="
	crossorigin="anonymous" referrerpolicy="no-referrer">
<title>User Profile</title>
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
			<a href="userDashboard.jsp"><i class="fas fa-arrow-left"></i> Back</a>
		</button>
	</div>

	<div class="page-container" style="padding-top: 40px; padding-bottom: 40px;">
		<main class="standalone-container" style="max-width: 1000px; margin: 40px auto;">
			<%
			String msg = request.getParameter("msg");
			if ("profileUpdated".equals(msg)) {
			%>
			<div style="background: rgba(16, 185, 129, 0.15); border: 1px solid #10b981; border-radius: var(--border-radius-md); padding: 15px; margin-bottom: 20px; color: #10b981; text-align: center; font-weight: 600;">
				<i class="fas fa-check-circle"></i> Profile updated successfully!
			</div>
			<%
			}
			if ("passwordUpdated".equals(msg)) {
			%>
			<div style="background: rgba(16, 185, 129, 0.15); border: 1px solid #10b981; border-radius: var(--border-radius-md); padding: 15px; margin-bottom: 20px; color: #10b981; text-align: center; font-weight: 600;">
				<i class="fas fa-check-circle"></i> Password changed successfully!
			</div>
			<%
			}
			if ("invalidOldPassword".equals(msg)) {
			%>
			<div style="background: rgba(239, 68, 68, 0.15); border: 1px solid #ef4444; border-radius: var(--border-radius-md); padding: 15px; margin-bottom: 20px; color: #ef4444; text-align: center; font-weight: 600;">
				<i class="fas fa-exclamation-circle"></i> Current password is incorrect!
			</div>
			<%
			}
			if ("passwordMismatch".equals(msg)) {
			%>
			<div style="background: rgba(239, 68, 68, 0.15); border: 1px solid #ef4444; border-radius: var(--border-radius-md); padding: 15px; margin-bottom: 20px; color: #ef4444; text-align: center; font-weight: 600;">
				<i class="fas fa-exclamation-circle"></i> New passwords do not match!
			</div>
			<%
			}
			%>
			<div class="profile-header">
				<img src="avatar.png" alt="User Avatar">
			<div>
				<h1>User Profile</h1>
				<p>Welcome User!</p>
			</div>
		</div>

		<table class="premium-table">
			<thead>
				<tr>
					<th>User ID</th>
					<th>Username</th>
					<th>Email</th>
					<th>Phone</th>
					<th>Address</th>
					<th>D.O.B</th>
					<th>User Type</th>
					<th>Actions</th>
				</tr>
			</thead>
			<tbody>
				<%
				Connection con = null;
				PreparedStatement pstmt = null;
				ResultSet rs = null;

				try {
					con = DatabaseUtil.getCon();
					String loggedInEmail = (String) session.getAttribute("email");
					if (loggedInEmail == null) {
						response.sendRedirect("login.jsp");
						return;
					}
					String query = "SELECT user_id, username, email, phone, address, dob, userType FROM users WHERE email = ?";
					pstmt = con.prepareStatement(query);
					pstmt.setString(1, loggedInEmail);
					rs = pstmt.executeQuery();

					while (rs.next()) {
						int userId = rs.getInt("user_id");
						String username = rs.getString("username");
						String email = rs.getString("email");
						String phone = rs.getString("phone");
						String address = rs.getString("address");
						Date dob = rs.getDate("dob");
						String userType = rs.getString("userType");
				%>
				<tr>
					<td><%=userId%></td>
					<td><%=username%></td>
					<td><%=email%></td>
					<td><%=phone%></td>
					<td><%=address%></td>
					<td><%=dob%></td>
					<td><%=userType%></td>
					<td><a href="editProfile.jsp" style="color: var(--accent-color); font-weight: bold;">Edit</a> | <a
						href="deleteUser.jsp?id=<%=userId%>" style="color: var(--danger-color); font-weight: bold;"
						onclick="return confirm('Are you sure you want to delete this user?')">Delete</a>
					</td>
				</tr>
				<%
				}
				rs.close();
				} catch (SQLException e) {
				e.printStackTrace();
				} finally {
				if (rs != null) {
				try {
					rs.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
				}
				if (pstmt != null) {
				try {
					pstmt.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
				}
				if (con != null) {
				try {
					con.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
				}
				}
				%>
			</tbody>
		</table>

		<div class="dashboard-actions" style="margin-top: 30px; justify-content: center; gap: 15px;">
			<a href="editProfile.jsp"><i class="fas fa-edit"></i> Edit Profile</a>
			<a href="changePassword.jsp"><i class="fas fa-key"></i> Change Password</a>
			<a href="logout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a>
		</div>
		</main>
	</div>

	<%@ include file="admin/footer.jsp"%>
</body>
</html>
