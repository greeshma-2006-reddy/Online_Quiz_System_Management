<%@ page import="java.sql.*" %>
<%@ page import="com.quizsystem.util.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
<title>Manage Faculty</title>

<style>
body{
background:#0f172a;
color:white;
font-family:Arial;
padding:30px;
}

.card{
background:#111827;
padding:15px;
margin:10px 0;
border-radius:10px;
}

button{
background:red;
color:white;
padding:8px;
border:none;
border-radius:8px;
cursor:pointer;
}
</style>
</head>

<body>

<h2>Manage Faculty</h2>

<div class="card">
<h3>Add Faculty</h3>

<form action="AddFacultyServlet" method="post">

<input type="text" name="username" placeholder="Faculty Name" required>
<input type="text" name="password" placeholder="Password" required>

<button type="submit">Add Faculty</button>
</form>
</div>

<hr>

<h3>Faculty List</h3>

<%
Connection con = DBConnection.getConnection();

PreparedStatement ps = con.prepareStatement(
"SELECT id, username FROM users WHERE role='faculty'"
);

ResultSet rs = ps.executeQuery();

while(rs.next()){
%>

<div class="card">
<p><%= rs.getString("username") %></p>

<form action="RemoveFacultyServlet" method="post">
<input type="hidden" name="id" value="<%= rs.getInt("id") %>">
<button type="submit">Remove</button>
</form>
</div>

<%
}
con.close();
%>

</body>
</html>