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
System.out.println("=== SIGNUP OTP GENERATED ===");
System.out.println("Email: " + email);
System.out.println("OTP Code: " + otp);
System.out.println("============================");

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

boolean isSent = mypack.MailUtil.sendOTP(email, otp);

if (isSent) {
	response.sendRedirect("verifyOTP.jsp");
} else {
	// Fallback/Demo mode: If SMTP is not set up, pass the OTP in redirect parameter for easy testing
	response.sendRedirect("verifyOTP.jsp?msg=demoOtp&otp=" + otp);
}
%>
