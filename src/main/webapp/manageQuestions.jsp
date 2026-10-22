<%@ page import="java.sql.*" %>

<%@ page import="com.quizsystem.util.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8"%>

<!DOCTYPE html>

<html>

<head>

<title>Manage Questions</title>

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
width:500px;
margin:auto;
}

input,select,button{

width:100%;

padding:10px;

margin:10px 0;

border:none;

border-radius:8px;
}

input,select{

background:#1f2937;

color:white;
}

button{

background:#B6FF6B;

font-weight:bold;

cursor:pointer;
}

</style>

</head>

<body>

<div class="box">

<h2>Manage Questions</h2>

<form action="ManageQuestionsServlet"

method="post">

<input type="hidden"

name="action"

value="search">

<select name="assessmentName">

<%

try{

Connection con =

DBConnection.getConnection();

PreparedStatement ps =

con.prepareStatement(

"SELECT assessment_name FROM assessments"

);

ResultSet rs =

ps.executeQuery();

while(rs.next()){

%>

<option value="<%= rs.getString("assessment_name") %>">

<%= rs.getString("assessment_name") %>

</option>

<%

}

rs.close();

ps.close();

con.close();

}

catch(Exception e){

e.printStackTrace();

}

%>

</select>

<input type="text"

name="subject"

placeholder="Subject"

required>

<select name="type">

<option value="mcq">

MCQ

</option>

<option value="fill">

Fill Blank

</option>

<option value="truefalse">

True/False

</option>

<option value="coding">

Coding

</option>

</select>

<button type="submit">

Search Questions

</button>

</form>

</div>

</body>

</html>