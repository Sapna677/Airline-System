<%@ page import="mypack.DatabaseUtil"%>
<%@ page import="java.sql.*"%>
<%
String email = (String) session.getAttribute("email");
if (email == null) {
	response.sendRedirect("login.jsp");
	return;
}

String oldPassword = request.getParameter("oldPassword");
String newPassword = request.getParameter("newPassword");
String confirmPassword = request.getParameter("confirmPassword");

if (oldPassword == null || newPassword == null || confirmPassword == null) {
	response.sendRedirect("changePassword.jsp");
	return;
}

if (!newPassword.equals(confirmPassword)) {
	response.sendRedirect("userProfile.jsp?msg=passwordMismatch");
	return;
}

String hashedOld = DatabaseUtil.hashPassword(oldPassword);
String hashedNew = DatabaseUtil.hashPassword(newPassword);

Connection con = null;
PreparedStatement pstmtSelect = null;
PreparedStatement pstmtUpdate = null;
ResultSet rs = null;

try {
	con = DatabaseUtil.getCon();
	
	// Verify current password
	String selectQuery = "SELECT password FROM users WHERE email = ? AND password = ?";
	pstmtSelect = con.prepareStatement(selectQuery);
	pstmtSelect.setString(1, email);
	pstmtSelect.setString(2, hashedOld);
	rs = pstmtSelect.executeQuery();

	if (rs.next()) {
		// Matches, update password
		String updateQuery = "UPDATE users SET password = ? WHERE email = ?";
		pstmtUpdate = con.prepareStatement(updateQuery);
		pstmtUpdate.setString(1, hashedNew);
		pstmtUpdate.setString(2, email);
		int rows = pstmtUpdate.executeUpdate();
		
		if (rows > 0) {
			response.sendRedirect("userProfile.jsp?msg=passwordUpdated");
		} else {
			response.sendRedirect("userProfile.jsp?msg=error");
		}
	} else {
		// Old password incorrect
		response.sendRedirect("userProfile.jsp?msg=invalidOldPassword");
	}
} catch (Exception e) {
	e.printStackTrace();
	response.sendRedirect("userProfile.jsp?msg=error");
} finally {
	try {
		if (rs != null) rs.close();
		if (pstmtSelect != null) pstmtSelect.close();
		if (pstmtUpdate != null) pstmtUpdate.close();
		if (con != null) con.close();
	} catch (SQLException e) {
		e.printStackTrace();
	}
}
%>
