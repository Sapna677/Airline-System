<%@ page import="mypack.DatabaseUtil"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.Properties"%>
<%@ page import="javax.mail.*"%>
<%@ page import="javax.mail.internet.*"%>
<%
String name = request.getParameter("username");
String password = request.getParameter("password");
String email = request.getParameter("email");
String first = request.getParameter("firstName");
String last = request.getParameter("lastName");
String mobile = request.getParameter("phone");
String address = request.getParameter("address");
String dob = request.getParameter("dob");
String type = request.getParameter("usertype");

if (name == null || password == null || email == null) {
	response.sendRedirect("signUp.jsp");
	return;
}

// Generate a 6-digit OTP
String otp = String.valueOf(100000 + new java.util.Random().nextInt(900000));

// Store registration details in session temporarily
session.setAttribute("signup_username", name);
session.setAttribute("signup_password", password);
session.setAttribute("signup_email", email);
session.setAttribute("signup_firstName", first);
session.setAttribute("signup_lastName", last);
session.setAttribute("signup_phone", mobile);
session.setAttribute("signup_address", address);
session.setAttribute("signup_dob", dob);
session.setAttribute("signup_usertype", type);
session.setAttribute("signup_otp", otp);

// Read SMTP credentials from environment variables with fallbacks
String from = System.getenv("SMTP_USER");
String pass = System.getenv("SMTP_PASSWORD");
if (from == null || from.trim().isEmpty()) {
	from = "sapnakumri670@gmail.com"; 
}
if (pass == null || pass.trim().isEmpty()) {
	pass = "ocuvvfgqypkcbwup"; 
}
String host = "smtp.gmail.com";

Properties properties = new Properties();
properties.put("mail.smtp.host", host);
properties.put("mail.smtp.port", "587");
properties.put("mail.smtp.auth", "true");
properties.put("mail.smtp.starttls.enable", "true");
properties.put("mail.smtp.ssl.protocols", "TLSv1.2");

Session mailSession = Session.getInstance(properties, new javax.mail.Authenticator() {
    @Override
    protected PasswordAuthentication getPasswordAuthentication() {
        return new PasswordAuthentication(from, pass);
    }
});

boolean isSent = false;
try {
    MimeMessage message = new MimeMessage(mailSession);
    message.setFrom(new InternetAddress(from, "SkyGlide Airways"));
    message.addRecipient(Message.RecipientType.TO, new InternetAddress(email));
    message.setSubject("Airlines Registration OTP Verification");
    
    String htmlContent = "<div style='font-family: Arial, sans-serif; padding: 20px; max-width: 600px; margin: auto; border: 1px solid #ddd; border-radius: 8px;'>"
            + "<h2 style='color: #6366f1; text-align: center;'>Welcome to Our Airline!</h2>"
            + "<p>Thank you for starting your registration. To verify your email address, please use the following One-Time Password (OTP):</p>"
            + "<div style='text-align: center; margin: 30px 0;'>"
            + "  <span style='background-color: #f3f4f6; color: #6366f1; font-size: 2rem; font-weight: bold; padding: 10px 20px; border-radius: 6px; letter-spacing: 4px; border: 1px dashed #6366f1;'>" + otp + "</span>"
            + "</div>"
            + "<p style='color: #ef4444; font-weight: bold; text-align: center;'>This OTP is valid for 10 minutes. Please do not share it with anyone.</p>"
            + "<hr style='border: none; border-top: 1px solid #eee; margin-top: 30px;'>"
            + "<p style='font-size: 0.8rem; color: #9ca3af; text-align: center;'>This is an automated email. Please do not reply directly.</p>"
            + "</div>";
            
    message.setContent(htmlContent, "text/html; charset=utf-8");
    Transport.send(message);
    isSent = true;
} catch (Exception e) {
    e.printStackTrace();
    session.setAttribute("smtp_error", e.toString());
}

if (isSent) {
	response.sendRedirect("verifyOTP.jsp");
} else {
	// Fallback/Demo mode: If SMTP is not set up, pass the OTP in redirect parameter for easy testing
	response.sendRedirect("verifyOTP.jsp?msg=demoOtp&otp=" + otp);
}
%>
