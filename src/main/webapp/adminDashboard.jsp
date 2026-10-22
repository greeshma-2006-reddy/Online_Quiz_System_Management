<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.quizsystem.util.DBConnection" %>

<%
Connection con = DBConnection.getConnection();

int totalStudents = 0;
int totalFaculty = 0;
int totalAdmin = 0;
int totalTests = 0;
int totalQuestions = 0;

try {

// Students count
PreparedStatement ps1 = con.prepareStatement(
"SELECT COUNT(*) FROM users WHERE role='student'"
);
ResultSet rs1 = ps1.executeQuery();
if(rs1.next()) totalStudents = rs1.getInt(1);

// Faculty count
PreparedStatement ps2 = con.prepareStatement(
"SELECT COUNT(*) FROM users WHERE role='faculty'"
);
ResultSet rs2 = ps2.executeQuery();
if(rs2.next()) totalFaculty = rs2.getInt(1);

// Admin count
PreparedStatement ps3 = con.prepareStatement(
"SELECT COUNT(*) FROM users WHERE role='admin'"
);
ResultSet rs3 = ps3.executeQuery();
if(rs3.next()) totalAdmin = rs3.getInt(1);

// Tests count (assessments table)
PreparedStatement ps4 = con.prepareStatement(
"SELECT COUNT(*) FROM assessments"
);
ResultSet rs4 = ps4.executeQuery();
if(rs4.next()) totalTests = rs4.getInt(1);

// Questions count
PreparedStatement ps5 = con.prepareStatement(
"SELECT COUNT(*) FROM questions"
);
ResultSet rs5 = ps5.executeQuery();
if(rs5.next()) totalQuestions = rs5.getInt(1);

con.close();

} catch(Exception e){
e.printStackTrace();
}
%>

<!DOCTYPE html>

<html>

<head>

<title>Admin Dashboard</title>

<style>

*{

margin:0;

padding:0;

box-sizing:border-box;

font-family:Arial,sans-serif;

}

body{

background:#111827;

color:white;

display:flex;

height:100vh;

}

.sidebar{

width:260px;

background:rgba(255,255,255,0.08);

backdrop-filter:blur(10px);

padding:20px;

border-right:1px solid rgba(255,255,255,0.1);

}

.sidebar h2{

color:#B6FF6B;

text-align:center;

margin-bottom:25px;

}

.sidebar a{

display:block;

text-decoration:none;

color:white;

padding:12px;

margin-bottom:10px;

border-radius:10px;

transition:0.3s;

}

.sidebar a:hover{

background:#B6FF6B;

color:black;

}

.content{

flex:1;

padding:30px;

}

.header{

background:rgba(255,255,255,0.08);

padding:20px;

border-radius:15px;

}

.header h1{

color:#B6FF6B;

}

.cards{

display:flex;

gap:20px;

margin-top:30px;

flex-wrap:wrap;

}

.card{

background:rgba(255,255,255,0.08);

width:220px;

padding:25px;

border-radius:15px;

text-align:center;

}

.card h3{

color:#B6FF6B;

margin-bottom:10px;

}

.card p{

font-size:20px;

}

</style>

</head>

<body>

<div class="sidebar">

<h2>ADMIN PANEL</h2>

<a href="dashboard.jsp">

🏠 Dashboard

</a>

<a href="manageFaculty.jsp">

👨‍🏫 Manage Faculty

</a>

<a href="manageStudents.jsp">

👨‍🎓 Manage Students

</a>

<a href="viewUsers.jsp">

👥 View Users

</a>

<a href="resultsHome.jsp">

📊 View Results

</a>

<a href="systemActivity.jsp">

📋 System Activities

</a>

<a href="login.jsp">

🚪 Logout

</a>

</div>

<div class="content">

<div class="header">

<h1>

Welcome Admin

</h1>

<p>

Online Automated Assessment System

</p>

</div>

<div class="cards">

<div class="card">
<h3>Total Students</h3>
<p><%= totalStudents %></p>
</div>

<div class="card">
<h3>Total Faculty</h3>
<p><%= totalFaculty %></p>
</div>

<div class="card">
<h3>Total Admin</h3>
<p><%= totalAdmin %></p>
</div>

<div class="card">
<h3>Total Tests</h3>
<p><%= totalTests %></p>
</div>

<div class="card">
<h3>Total Questions</h3>
<p><%= totalQuestions %></p>
</div>

</div>

</div>

</body>

</html>