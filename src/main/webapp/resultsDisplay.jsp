<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.sql.*" %>

<%
ResultSet rs =
(ResultSet)request.getAttribute("results");
%>

<!DOCTYPE html>

<html>

<head>

<title>Results</title>

<style>

body{

background:#0f172a;

color:white;

font-family:Arial;

padding:20px;

}

.card{

background:#111827;

padding:15px;

margin:10px 0;

border-radius:10px;

}

h2{

color:#B6FF6B;

}

</style>

</head>

<body>

<h2>

Assessment Results

</h2>

<%

if(rs!=null){

while(rs.next()){

%>

<div class="card">

<p>

Student :

<%= rs.getString("username") %>

</p>

<p>

Badge :

<%= rs.getString("badge") %>

</p>

<p>

Score :

<%= rs.getDouble("percentage") %> %

</p>

<p>

Correct :

<%= rs.getInt("correct") %>

</p>

<p>

Wrong :

<%= rs.getInt("wrong") %>

</p>

</div>

<%

}

}

%>

</body>

</html>