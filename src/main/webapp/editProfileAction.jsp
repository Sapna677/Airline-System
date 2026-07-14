<%@ page import="mypack.DatabaseUtil"%>
<%@ page import="java.sql.*"%>
<%
String email = (String) session.getAttribute("email");
if (email == null) {
	response.sendRedirect("login.jsp");
	return;
}

String username = request.getParameter("username");
String firstName = request.getParameter("firstName");
String lastName = request.getParameter("lastName");
String phone = request.getParameter("phone");
String address = request.getParameter("address");
String dob = request.getParameter("dob");

if (username == null || firstName == null || lastName == null || phone == null || address == null || dob == null) {
	response.sendRedirect("editProfile.jsp?error=true");
	return;
}

Connection con = null;
PreparedStatement ps = null;

try {
	con = DatabaseUtil.getCon();
	String sql = "UPDATE users SET username = ?, firstName = ?, lastName = ?, phone = ?, address = ?, dob = ? WHERE email = ?";
	ps = con.prepareStatement(sql);
	ps.setString(1, username);
	ps.setString(2, firstName);
	ps.setString(3, lastName);
	ps.setString(4, phone);
	ps.setString(5, address);
	ps.setDate(6, java.sql.Date.valueOf(dob));
	ps.setString(7, email);

	int rowsUpdated = ps.executeUpdate();
	if (rowsUpdated > 0) {
		response.sendRedirect("userProfile.jsp?msg=profileUpdated");
	} else {
		response.sendRedirect("editProfile.jsp?error=true");
	}
} catch (Exception e) {
	e.printStackTrace();
	response.sendRedirect("editProfile.jsp?error=true");
} finally {
	try {
		if (ps != null) ps.close();
		if (con != null) con.close();
	} catch (SQLException e) {
		e.printStackTrace();
	}
}
%>
