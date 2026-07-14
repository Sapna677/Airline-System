<%@ page import="mypack.DatabaseUtil"%>
<%@ page import="java.sql.*"%>
<%
String email = request.getParameter("email");
String password = request.getParameter("password");

if ("admin@gmail.com".equals(email) && "admin".equals(password)) {
	session.setAttribute("email", email);
	response.sendRedirect("admin/adminDashboard.jsp");
} else {
	boolean isValidUser = false;
	Connection con = null;
	PreparedStatement pst = null;
	ResultSet rs = null;

	try {
		con = DatabaseUtil.getCon();
		String query = "SELECT * FROM users WHERE email = ? AND password = ?";
		pst = con.prepareStatement(query);
		pst.setString(1, email);
		pst.setString(2, DatabaseUtil.hashPassword(password));
		rs = pst.executeQuery();

		if (rs.next()) {
	isValidUser = true;
	session.setAttribute("email", email);
	response.sendRedirect("userDashboard.jsp");
		}

		if (!isValidUser) {
	response.sendRedirect("login.jsp?msg=NotExists");
		}
	} catch (Exception e) {
		System.out.println(e);
		response.sendRedirect("login.jsp?msg=Invalid");
	} finally {
		try {
	if (rs != null)
		rs.close();
	if (pst != null)
		pst.close();
	if (con != null)
		con.close();
		} catch (SQLException e) {
	System.out.println("Error closing resources: " + e.getMessage());
		}
	}
}
%>
