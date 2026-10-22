<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.quizsystem.util.DBConnection" %>

<%
String studentName =
(String)session.getAttribute("username");

if(studentName==null)
studentName="Student";


Integer studentIdObj =
(Integer)session.getAttribute("studentId");

int studentId = 0;

if(studentIdObj != null)
studentId = studentIdObj;


Connection con =
DBConnection.getConnection();


String level =
(String)session.getAttribute("level");

if(level==null)
level="Beginner";


String badge = "Bronze";

try{

PreparedStatement psBadge =
con.prepareStatement(
"SELECT badge FROM students WHERE student_id=?"
);

psBadge.setInt(1, studentId);

ResultSet rsBadge =
psBadge.executeQuery();

if(rsBadge.next()){

badge =
rsBadge.getString("badge");

session.setAttribute(
"badge",
badge
);

}

rsBadge.close();
psBadge.close();

}catch(Exception e){

e.printStackTrace();

}


double latestPercentage = 0;

try{

PreparedStatement ps =
con.prepareStatement(
"SELECT percentage FROM results WHERE student_id=? ORDER BY id DESC LIMIT 1"
);

ps.setInt(1, studentId);

ResultSet rs =
ps.executeQuery();

if(rs.next()){

latestPercentage =
rs.getDouble("percentage");

}

rs.close();
ps.close();

}catch(Exception e){

e.printStackTrace();

}
%>

<!DOCTYPE html>
<html>
<head>

<title>Student Dashboard</title>

<style>

*{
margin:0;
padding:0;
box-sizing:border-box;
font-family:Arial;
}

body{
background:#0f172a;
color:white;
display:flex;
}

.sidebar{
width:260px;
height:100vh;
background:#111827;
padding:20px;
position:fixed;
left:0;
top:0;
overflow:auto;
}

.sidebar h2{
color:#B6FF6B;
margin-bottom:20px;
}

.sidebar button{
width:100%;
padding:12px;
margin-bottom:10px;
border:none;
border-radius:10px;
background:#1f2937;
color:white;
cursor:pointer;
}

.sidebar button:hover{
background:#B6FF6B;
color:black;
}

.main{
margin-left:280px;
padding:25px;
width:100%;
}

.section{
display:none;
background:#111827;
padding:20px;
border-radius:15px;
margin-bottom:20px;
}

.active{
display:block;
}

.avatar{
width:80px;
height:80px;
border-radius:50%;
background:#B6FF6B;
color:black;
display:flex;
align-items:center;
justify-content:center;
font-size:30px;
font-weight:bold;
}

.badge{
background:#B6FF6B;
color:black;
padding:8px 15px;
border-radius:8px;
display:inline-block;
margin-top:10px;
font-weight:bold;
}

.grid{
display:grid;
grid-template-columns:repeat(3,1fr);
gap:15px;
margin-top:20px;
}

.card{
background:#1f2937;
padding:15px;
border-radius:10px;
}

.card h3{
color:#B6FF6B;
margin-bottom:10px;
}

input,
select,
textarea{
width:100%;
padding:10px;
margin-top:10px;
border:none;
border-radius:8px;
background:#1f2937;
color:white;
}

.greenBtn{
background:#B6FF6B;
color:black;
padding:10px;
border:none;
border-radius:8px;
cursor:pointer;
margin-top:10px;
font-weight:bold;
}

.improve-box{
background:#1f2937;
padding:15px;
border-radius:10px;
margin-top:10px;
}

</style>

<script>

function showSection(id){

var section=document.getElementById(id);

if(section==null){
alert(id + " section not found");
return;
}

document.querySelectorAll(".section")
.forEach(function(s){
s.classList.remove("active");
});

section.classList.add("active");
}

function toggleMode(){

let mode=
document.getElementById("mode").value;

let fields=
document.querySelectorAll(".qcount");

if(mode==="custom"){

fields.forEach(function(f){
f.disabled=false;
});

}
else{

fields.forEach(function(f){
f.disabled=true;
f.value="";
});

}
}

</script>

</head>

<body>

<div class="sidebar">

<h2>Student Panel</h2>
<button onclick="showSection('allStudents')">
🏠 Dashboard
</button>

<button onclick="showSection('home')">🏡 My Dashboard</button>

<button onclick="showSection('test')">📊 Generate Test</button>

<button onclick="showSection('facultyTests')">📝 Faculty Tests</button>

<button onclick="showSection('notes')">📚 Notes</button>

<button onclick="showSection('result')">📄 Results</button>

<button onclick="showSection('past')">📜 Past Results</button>

<button onclick="showSection('improve')">📈 Improvement</button>

<button onclick="showSection('badgeSection')">🏅 Badges</button>
<form action="LogoutServlet" method="post">

    <button type="submit"
            style="background:#ef4444;color:white;">
        🚪 Logout
    </button>

</form>

</div>

<div class="main">

<div id="allStudents" class="section">

<h2>All Students Leaderboard</h2>

<%
try{

PreparedStatement ps=
con.prepareStatement(

"SELECT u.username, s.badge, " +

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

<div style="display:flex;
align-items:center;
gap:15px;">

<div class="avatar">

<%= name.charAt(0) %>

</div>

<div>

<h3>

<%= name %>

</h3>

<p>

Score :

<%= rs.getDouble("score") %> %

</p>

<p>

Badge :

<%= rs.getString("badge") %>

</p>

</div>

</div>

</div>

<br>

<%
}

}catch(Exception e){

out.println(e.getMessage());

}
%>

</div>

<div id="home" class="section active">

<h2 style="color:#B6FF6B;">
Welcome, <%= studentName %>
</h2>

<br>

<div style="display:flex;gap:15px;align-items:center;">

<div class="avatar">
<%= studentName.charAt(0) %>
</div>

<div>

<h3><%= studentName %></h3>

<div class="badge">
<%= level %> | <%= badge %>
</div>

</div>

</div>

<div class="grid">

<div class="card">
<h3>Current Score</h3>
<p><%= latestPercentage %>%</p>
</div>

<div class="card">
<h3>Level</h3>
<p><%= level %></p>
</div>

<div class="card">
<h3>Badge</h3>
<p><%= badge %></p>
</div>

</div>

</div>
<div id="test" class="section">

<h2>Generate Test</h2>

<form action="GenerateMockTestServlet" method="post">

<input type="text"
name="subject"
placeholder="Subject"
required>

<input type="text"
name="topic"
placeholder="Topic"
required>

<input type="number"
name="duration"
placeholder="Duration"
required>

<input type="number"
name="totalQuestions"
placeholder="Total Questions"
required>

<select name="level">

<option value="easy">Easy</option>

<option value="medium">Medium</option>

<option value="hard">Hard</option>

<option value="mixed">Mixed</option>

</select>

<select
id="mode"
name="mode"
onchange="toggleMode()">

<option value="mixed">
Mixed Question Type
</option>

<option value="custom">
Custom Distribution
</option>

</select>

<input
class="qcount"
type="number"
name="mcqCount"
placeholder="MCQ Count"
disabled>

<input
class="qcount"
type="number"
name="fillCount"
placeholder="Fill Count"
disabled>

<input
class="qcount"
type="number"
name="tfCount"
placeholder="True False Count"
disabled>

<button class="greenBtn">
Generate Test
</button>

</form>

</div>

<div id="facultyTests" class="section">

<h2>Faculty Tests</h2>

<%
try{

	PreparedStatement ps=
			con.prepareStatement(
			"SELECT * FROM assessments");	
ResultSet rs=
ps.executeQuery();

while(rs.next()){
%>

<div class="card">

<h3>
<%= rs.getString("assessment_name") %>
</h3>

<p>
Subject :
<%= rs.getString("subject") %>
</p>

<p>
Level :
<%= rs.getString("level") %>
</p>

<p>
Duration :
<%= rs.getInt("duration") %> mins
</p>

<form action="StartTestServlet" method="post">

<input type="hidden"
       name="assessmentId"
       value="<%= rs.getInt("id") %>">

<button class="greenBtn"
        type="submit">

Attempt Test

</button>

</form>

</div>

<br>
<%
}
}catch(Exception e){
e.printStackTrace();
}
%>

</div>   <!-- closes facultyTests section -->
<div id="notes" class="section">

<h2>Available Notes</h2>

<%
try{

PreparedStatement ps=
con.prepareStatement(
"SELECT * FROM notes ORDER BY id DESC"
);

ResultSet rs=
ps.executeQuery();

boolean found=false;

while(rs.next()){

found=true;
%>

<div class="card">

<h3>
<%= rs.getString("subject") %>
</h3>

<p>

<%= rs.getString("file_name") %>

</p>

<a href="<%= rs.getString("file_path") %>"

style="color:#B6FF6B;">

⬇ Download

</a>

</div>

<br>

<%
}

if(!found){
%>

<div class="card">

No Notes Available

</div>

<%
}

}catch(Exception e){
%>

<div class="card">

Error :
<%= e.getMessage() %>

</div>

<%
}
%>

</div>
<div id="result" class="section">

<h2>Latest Result</h2>

<p>Student ID = <%= studentId %></p>

<%
try{

PreparedStatement ps=
con.prepareStatement(
"SELECT * FROM results WHERE student_id=? ORDER BY id DESC LIMIT 1");

ps.setInt(1,studentId);

ResultSet rs=
ps.executeQuery();

if(rs.next()){
%>

<div class="card">

<h3>
Percentage : <%= rs.getDouble("percentage") %> %
</h3>

<p>
Correct : <%= rs.getInt("correct") %>
</p>

<p>
Wrong : <%= rs.getInt("wrong") %>
</p>

<p>
Assessment ID :
<%= rs.getInt("assessment_id") %>
</p>

</div>

<%
}else{
%>

<div class="card">
No Results Found
</div>

<%
}

}catch(Exception e){
%>

<div class="card">
Error : <%= e.getMessage() %>
</div>

<%
}
%>

</div>
<div id="past" class="section">

<h2>Past Results</h2>

<%
try{

PreparedStatement ps=
con.prepareStatement(
"SELECT * FROM results WHERE student_id=? ORDER BY id DESC");

ps.setInt(1,studentId);

ResultSet rs=
ps.executeQuery();

boolean found=false;

while(rs.next()){

found=true;
%>

<div class="card">

<h3>
<%= rs.getDouble("percentage") %> %
</h3>

<p>
Correct :
<%= rs.getInt("correct") %>
</p>

<p>
Wrong :
<%= rs.getInt("wrong") %>
</p>

<p>
Date :
<%= rs.getTimestamp("attempt_date") %>
</p>

</div>

<br>

<%
}

if(!found){
%>

<div class="card">
No Past Results Found
</div>

<%
}

}catch(Exception e){
%>

<div class="card">
Error : <%= e.getMessage() %>
</div>

<%
}
%>

</div>
<div id="improve" class="section">

<h2>Improvement Areas</h2>

<p>Student ID = <%= studentId %></p>

<%
try{

PreparedStatement ps=
con.prepareStatement(
"SELECT * FROM improvement WHERE student_id=?");

ps.setInt(1,studentId);

ResultSet rs=
ps.executeQuery();

boolean found=false;

while(rs.next()){

found=true;
%>

<div class="improve-box">

<h3>
<%= rs.getString("topic") %>
</h3>

<p>
Accuracy :
<%= rs.getDouble("accuracy") %> %
</p>

</div>

<br>

<%
}

if(!found){
%>

<div class="card">
No Improvement Data Found
</div>

<%
}

}catch(Exception e){
%>

<div class="card">
Error : <%= e.getMessage() %>
</div>

<%
}
%>

</div>

<div id="badgeSection" class="section">

<h2>Badges</h2>

<div class="card">

<h3>
Current Badge
</h3>

<p>
<%= badge %>
</p>

<p>
Level :
<%= level %>
</p>

</div>

</div>

</div>

</body>
</html>

<%
if(con!=null)
con.close();
%>