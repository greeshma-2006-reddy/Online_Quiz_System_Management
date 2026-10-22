<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.sql.*" %>

<%@ page import="com.quizsystem.util.DBConnection" %>

<!DOCTYPE html>

<html>

<head>

<title>Dashboard</title>

<style>

body{

background:#0f172a;

color:white;

font-family:Arial;

padding:30px;

}

h1{

color:#B6FF6B;

margin-bottom:25px;

}

.card{

background:#111827;

padding:20px;

border-radius:15px;

margin-bottom:20px;

}

.avatar{

width:70px;

height:70px;

border-radius:50%;

background:#B6FF6B;

color:black;

display:flex;

align-items:center;

justify-content:center;

font-size:28px;

font-weight:bold;

}

.row{

display:flex;

align-items:center;

gap:20px;

}

</style>

</head>

<body>

<h1>

All Students Leaderboard

</h1>

<%

try{

Connection con=

DBConnection.getConnection();

PreparedStatement ps=

con.prepareStatement(

"SELECT u.username,s.badge," +

"COALESCE(MAX(r.percentage),0) AS score " +

"FROM students s " +

"JOIN users u ON s.user_id=u.id " +

"LEFT JOIN results r ON s.student_id=r.student_id " +

"GROUP BY u.username,s.badge"

);

ResultSet rs=

ps.executeQuery();

while(rs.next()){

String name=

rs.getString("username");

%>

<div class="card">

<div class="row">

<div class="avatar">

<%= name.charAt(0) %>

</div>

<div>

<h3>

<%= name %>

</h3>

<p>

📊 Score :

<%= rs.getDouble("score") %> %

</p>

<p>

🏅 Badge :

<%= rs.getString("badge") %>

</p>

</div>

</div>

</div>

<%

}

rs.close();

ps.close();

con.close();

}

catch(Exception e){

%>

<div class="card">

Error :

<%= e.getMessage() %>

</div>

<%

}

%>

</body>

</html>