<%@ page import="java.sql.*" %>

<%@ page import="com.quizsystem.util.DBConnection" %>

<!DOCTYPE html>

<html>

<head>

<title>Manage Students</title>

<style>

body{

background:#0f172a;

color:white;

font-family:Arial;

padding:30px;

}

.box{

background:#111827;

padding:20px;

border-radius:15px;

}

table{

width:100%;

border-collapse:collapse;

}

th,td{

padding:15px;

text-align:center;

}

th{

background:#1f2937;

}

tr{

background:#111827;

}

input{

padding:10px;

margin:10px;

border:none;

border-radius:8px;

background:#1f2937;

color:white;

}

button{

padding:10px;

background:#B6FF6B;

border:none;

border-radius:8px;

cursor:pointer;

font-weight:bold;

}

.remove{

background:red;

color:white;

}

</style>

</head>

<body>

<div class="box">

<h2>Manage Students</h2>
<%

String msg =

request.getParameter(
"msg"
);

if(msg!=null){

%>

<div style="

background:#16a34a;

padding:10px;

border-radius:10px;

margin-bottom:20px;">

✅ <%= msg %>

</div>

<%

}

%>

<!-- Add Student -->

<form action="AddStudentServlet"

method="post">

<input type="text"

name="studentName"

placeholder="Student Name"

required>

<input type="text"

name="password"

placeholder="Password"

required>

<button type="submit">

Add Student

</button>

</form>

<br>

<table>

<tr>

<th>Student Name</th>

<th>Level</th>

<th>Badge</th>

<th>Action</th>

</tr>

<%

Connection con =

DBConnection.getConnection();

PreparedStatement ps =

con.prepareStatement(

"SELECT s.student_id,u.username,s.level,s.badge " +

"FROM students s " +

"JOIN users u " +

"ON s.user_id=u.id"

);

ResultSet rs =

ps.executeQuery();

while(rs.next()){

%>

<tr>

<td>

<%= rs.getString("username") %>

</td>

<td>

<%= rs.getString("level") %>

</td>

<td>

<%= rs.getString("badge") %>

</td>

<td>

<form action="RemoveStudentServlet"

method="post">

<input type="hidden"

name="studentId"

value="<%= rs.getInt("student_id") %>">

<button type="submit">

Remove

</button>

</form>

</td>

</tr>

<%

}

rs.close();

ps.close();

con.close();

%>

</table>

</div>

</body>

</html>