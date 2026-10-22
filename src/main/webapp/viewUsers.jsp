<%@ page import="java.sql.*" %>
<%@ page import="com.quizsystem.util.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
<title>View Users</title>

<style>
body{
background:#0f172a;
color:white;
font-family:Arial;
padding:30px;
}

table{
width:100%;
border-collapse:collapse;
}

th,td{
padding:12px;
text-align:center;
border-bottom:1px solid #1f2937;
}

th{
background:#1f2937;
color:#B6FF6B;
}
</style>
</head>

<body>

<h2>All Users</h2>

<table>
<tr>
<th>ID</th>
<th>Username</th>
<th>Role</th>
</tr>

<%
Connection con = DBConnection.getConnection();

PreparedStatement ps = con.prepareStatement(
"SELECT id, username, role FROM users"
);

ResultSet rs = ps.executeQuery();

while(rs.next()){
%>

<tr>
<td><%= rs.getInt("id") %></td>
<td><%= rs.getString("username") %></td>
<td><%= rs.getString("role") %></td>
</tr>

<%
}
con.close();
%>

</table>

</body>
</html>