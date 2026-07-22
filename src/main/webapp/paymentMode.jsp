<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="java.sql.*, mypack.DatabaseUtil" isELIgnored="true"%>
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

String flightId = request.getParameter("flight_id");
String flightNumber = request.getParameter("flight_number");
String departure = request.getParameter("departure");
String arrival = request.getParameter("arrival");
String price = request.getParameter("price");
String seatNumber = request.getParameter("seatNumber");

if (price == null || price.isEmpty()) {
	price = "1000"; // default fallback
}

String defaultName = "";
String defaultEmail = email;

try (Connection con = DatabaseUtil.getCon();
     PreparedStatement pstmt = con.prepareStatement("SELECT username FROM users WHERE email = ?")) {
	pstmt.setString(1, email);
	try (ResultSet rs = pstmt.executeQuery()) {
		if (rs.next()) {
			defaultName = rs.getString("username");
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}
%>
<!DOCTYPE html>
<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta charset="ISO-8859-1">
<title>Payment Checkout</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"
	integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg=="
	crossorigin="anonymous" referrerpolicy="no-referrer">
<link rel="stylesheet" href="css/style.css">
<style>
.tab-content {
	display: none;
}
.tab-content.active {
	display: block !important;
}
</style>
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
	<!-- Background video -->
	<video class="bg-video" autoplay loop muted>
		<source src="Air4.mp4" type="video/mp4">
		Your browser does not support the video tag.
	</video>
	<div class="bg-overlay"></div>

	<div class="btn-nav-floating">
		<button>
			<a href="searchFlights.jsp"><i class="fas fa-arrow-left"></i> Cancel</a>
		</button>
	</div>

	<div class="page-container" style="justify-content: center; align-items: center; min-height: 100vh; padding: 40px 15px;">
		<div class="glass-card" style="max-width: 600px; width: 100%;">
			<h2 style="margin-bottom: 10px; font-weight: 700;"><i class="fas fa-shield-alt"></i> Secure Checkout</h2>
			<p style="color: var(--text-secondary); margin-bottom: 25px; font-size: 0.95rem;">Please review your flight and select a payment option.</p>

			<!-- Flight Ticket Summary -->
			<div style="background: rgba(255, 255, 255, 0.04); border: 1px dashed var(--card-border); border-radius: var(--border-radius-md); padding: 20px; margin-bottom: 25px; text-align: left;">
				<div style="display: flex; justify-content: space-between; margin-bottom: 10px; font-size: 0.9rem; color: var(--text-secondary);">
					<span>Flight Number</span>
					<span style="color: white; font-weight: 600;"><%=flightNumber%></span>
				</div>
				<div style="display: flex; justify-content: space-between; margin-bottom: 10px; font-size: 0.9rem; color: var(--text-secondary);">
					<span>Route</span>
					<span style="color: white; font-weight: 600;"><%=departure%> &rarr; <%=arrival%></span>
				</div>
				<div style="display: flex; justify-content: space-between; margin-bottom: 10px; font-size: 0.9rem; color: var(--text-secondary);">
					<span>Seat Number</span>
					<span style="color: #10b981; font-weight: 600;"><%=seatNumber != null ? seatNumber : "Not Selected"%></span>
				</div>
				
				<!-- Promo Code Box -->
				<div style="border-top: 1px solid rgba(255,255,255,0.08); padding-top: 15px; margin-top: 10px; margin-bottom: 10px;">
					<label style="font-size: 0.85rem; color: var(--text-secondary); display: block; margin-bottom: 5px;">Apply Promo Code (FLY500 / FLY1000):</label>
					<div style="display: flex; gap: 10px;">
						<input type="text" id="promoInput" placeholder="Enter Promo Code" style="flex: 1; padding: 8px 12px; font-size: 0.9rem; margin-bottom: 0; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); border-radius: 6px; color: white;">
						<button type="button" onclick="applyPromoCode()" style="padding: 8px 15px; background: #6366f1; border: none; border-radius: 6px; color: white; font-weight: bold; cursor: pointer; font-size: 0.9rem; font-family: 'Outfit';">Apply</button>
					</div>
					<div id="promoMessage" style="font-size: 0.85rem; margin-top: 8px; font-weight: 500;"></div>
				</div>

				<div style="border-top: 1px solid rgba(255,255,255,0.08); padding-top: 10px; margin-top: 10px; display: flex; justify-content: space-between; font-size: 1.1rem;">
					<span style="font-weight: 600; color: white;">Total Price</span>
					<span style="font-weight: 700; color: #f59e0b;" id="displayedPrice">INR <%=price%></span>
				</div>
			</div>

			<!-- Checkout Tabs -->
			<div class="checkout-tabs">
				<button class="checkout-tab active" id="tab-card" onclick="switchTab('card')">
					<i class="fas fa-credit-card"></i> Card Payment
				</button>
				<button class="checkout-tab" id="tab-qr" onclick="switchTab('qr')">
					<i class="fas fa-qrcode"></i> UPI QR Code
				</button>
			</div>

			<!-- Main Payment Form -->
			<form id="paymentForm" action="PaymentProcess.jsp" method="post" style="display: flex; flex-direction: column; width: 100%;">
				<!-- Hidden variables needed by processing page -->
				<input type="hidden" name="flightId" value="<%=flightId%>">
				<input type="hidden" name="flightNumber" value="<%=flightNumber%>">
				<input type="hidden" name="departure" value="<%=departure%>">
				<input type="hidden" name="arrival" value="<%=arrival%>">
				<input type="hidden" name="price" id="finalPriceInput" value="<%=price%>">
				<input type="hidden" name="paymentMode" id="paymentMode" value="card">
				<input type="hidden" name="seatNumber" value="<%=seatNumber%>">

				<!-- User Contact Fields -->
				<div style="text-align: left; margin-bottom: 15px;">
					<label for="name">Billing Name</label>
					<input type="text" id="name" name="name" value="<%=defaultName%>" required placeholder="Enter billing name">
				</div>
				<div style="text-align: left; margin-bottom: 20px;">
					<label for="email">Billing Email</label>
					<input type="email" id="email" name="email" value="<%=defaultEmail%>" required placeholder="Enter billing email">
				</div>

				<!-- TAB CONTENT: Card Payment -->
				<div class="tab-content active" id="content-card">
					<div style="text-align: left; margin-bottom: 15px;">
						<label for="cardNumber">Card Number</label>
						<input type="text" id="cardNumber" name="cardNumber" pattern="\d{13,19}" title="Card number must be between 13 and 19 digits" required placeholder="Card number (16 digits)">
					</div>
					<div style="display: flex; gap: 15px; width: 100%; text-align: left;">
						<div style="flex: 1; margin-bottom: 15px;">
							<label for="expiry">Expiry (MM/YY)</label>
							<input type="text" id="expiry" name="expiry" pattern="(0[1-9]|1[0-2])/\d{2}" placeholder="MM/YY" required>
						</div>
						<div style="flex: 1; margin-bottom: 15px;">
							<label for="cvv">CVV</label>
							<input type="password" id="cvv" name="cvv" pattern="\d{3}" maxlength="3" title="CVV must be 3 digits" required placeholder="000">
						</div>
					</div>
					<input type="submit" id="cardPayBtn" value="Pay INR <%=price%>" style="width: 100%; margin-top: 10px;">
				</div>

				<!-- TAB CONTENT: UPI QR Code -->
				<div class="tab-content" id="content-qr" style="text-align: center;">
					<div class="qr-timer">
						<i class="fas fa-clock animate-pulse"></i> QR expires in: <span id="timer-display">05:00</span>
					</div>
					
					<div style="margin: 5px 0; display: flex; justify-content: center;">
						<div style="background: #0d0d0d; padding: 15px; border-radius: var(--border-radius-md); box-shadow: 0 0 25px rgba(99, 102, 241, 0.2); max-width: 320px; border: 3px solid #6366f1;">
							<img id="qrCodeImg" src="qr_payment.jpg" alt="Payment QR Code" style="width: 100%; border-radius: var(--border-radius-sm); display: block;">
						</div>
					</div>

					<p style="font-size: 0.85rem; color: var(--text-secondary); margin-bottom: 25px;">
						Scan this QR code using any UPI App (Google Pay, PhonePe, Paytm, BHIM) to complete checkout.
					</p>

					<!-- Simulate successful click (P2P free transactions) -->
					<button type="button" class="btn-primary" onclick="simulateQRPayment()" style="width: 100%;">
						<i class="fas fa-check-circle"></i> Simulate Successful Payment (Free)
					</button>
				</div>
			</form>

			<%
			String error = request.getAttribute("error") != null ? request.getAttribute("error").toString() : null;
			if (error != null && !error.isEmpty()) {
			%>
			<div class="error" style="margin-top: 20px;">
				<p><%=error%></p>
			</div>
			<%
			}
			%>
		</div>
	</div>

	<script>
		let basePrice = parseFloat("<%= (price != null) ? price.replace("INR", "").replace(",", "").trim() : "1000" %>");
		let discount = 0;
		let promoApplied = false;

		function updateQRCode(amount) {
			try {
				const upiUrl = `upi://pay?pa=sapnakri039@gmail.com&pn=SkyGlide%20Airways&am=${amount}&cu=INR`;
				const qrApiUrl = `https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=${encodeURIComponent(upiUrl)}`;
				const qrImg = document.getElementById('qrCodeImg');
				if (qrImg) {
					qrImg.src = qrApiUrl;
					console.log("QR Code updated for amount: INR " + amount);
				}
			} catch (e) {
				console.error("Error generating dynamic QR code: ", e);
			}
		}

		function applyPromoCode() {
			const promoInput = document.getElementById('promoInput').value.trim().toUpperCase();
			const messageDiv = document.getElementById('promoMessage');
			const displayPriceSpan = document.getElementById('displayedPrice');
			const cardPayBtn = document.getElementById('cardPayBtn');

			if (promoApplied) {
				messageDiv.style.color = '#ef4444';
				messageDiv.textContent = "A promo code has already been applied!";
				return;
			}

			if (promoInput === 'FLY500') {
				discount = 500;
				promoApplied = true;
			} else if (promoInput === 'FLY1000') {
				discount = 1000;
				promoApplied = true;
			} else {
				messageDiv.style.color = '#ef4444';
				messageDiv.textContent = "Invalid Promo Code!";
				return;
			}

			let finalPrice = basePrice - discount;
			if (finalPrice < 0) finalPrice = 0;

			// Update prices
			displayPriceSpan.textContent = "INR " + finalPrice;
			document.getElementById('finalPriceInput').value = finalPrice;
			cardPayBtn.value = "Pay INR " + finalPrice;

			messageDiv.style.color = '#10b981';
			messageDiv.textContent = `Promo code applied! ₹${discount} discount added.`;

			// Update the dynamic QR code immediately with the discounted price
			updateQRCode(finalPrice);
		}

		function switchTab(tabName) {
			document.querySelectorAll('.checkout-tab').forEach(tab => tab.classList.remove('active'));
			document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));
			
			if (tabName === 'card') {
				document.getElementById('tab-card').classList.add('active');
				document.getElementById('content-card').classList.add('active');
				document.getElementById('paymentMode').value = 'card';
				
				// Enable card fields validation
				document.getElementById('cardNumber').setAttribute('required', 'required');
				document.getElementById('expiry').setAttribute('required', 'required');
				document.getElementById('cvv').setAttribute('required', 'required');
			} else if (tabName === 'qr') {
				document.getElementById('tab-qr').classList.add('active');
				document.getElementById('content-qr').classList.add('active');
				document.getElementById('paymentMode').value = 'UPI_QR';
				
				// Disable card fields validation since we submit simulated dummy values
				document.getElementById('cardNumber').removeAttribute('required');
				document.getElementById('expiry').removeAttribute('required');
				document.getElementById('cvv').removeAttribute('required');
				
				// Update QR code with the current price (with or without discount)
				const currentPrice = document.getElementById('finalPriceInput').value || basePrice;
				updateQRCode(currentPrice);

				startTimer();
			}
		}

		let timerInterval;
		function startTimer() {
			try {
				const timerDisplay = document.getElementById('timer-display');
				if (!timerDisplay) return;

				if (timerInterval) {
					clearInterval(timerInterval);
				}

				let duration = 300; // 5 minutes
				
				const tick = () => {
					let minutes = Math.floor(duration / 60);
					let seconds = duration % 60;
					seconds = seconds < 10 ? '0' + seconds : seconds;
					timerDisplay.textContent = `${minutes}:${seconds}`;
					if (duration <= 0) {
						clearInterval(timerInterval);
						timerDisplay.textContent = "Expired";
					}
					duration--;
				};

				tick(); // Run immediately so there's no blank 1-second delay
				timerInterval = setInterval(tick, 1000);
			} catch (e) {
				console.error("Error in startTimer: ", e);
			}
		}

		function simulateQRPayment() {
			// Fill dummy values for card fields to satisfy backend schema inserts
			document.getElementById('cardNumber').value = '9999999999999999';
			document.getElementById('expiry').value = '12/99';
			document.getElementById('cvv').value = '999';
			
			// Submit form
			document.getElementById('paymentForm').submit();
		}

		// Initialize default QR Code on load
		document.addEventListener('DOMContentLoaded', () => {
			updateQRCode(basePrice);
		});
	</script>
</body>
</html>
