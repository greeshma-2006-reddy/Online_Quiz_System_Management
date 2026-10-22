<%@ page import="java.sql.*" %>

<!DOCTYPE html>

<html>

<head>

<title>Analytics Result</title>

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

.avatar{

width:60px;

height:60px;

border-radius:50%;

background:#B6FF6B;

color:black;

display:flex;

align-items:center;

justify-content:center;

font-size:25px;

font-weight:bold;
}

</style>

</head>

<body>

<h2 style="color:#B6FF6B;">

Student Analytics

</h2>

<%

ResultSet rs=

(ResultSet)

request.getAttribute(
"analyticsData"
);

if(rs!=null){

while(rs.next()){

String name=

rs.getString("username");

%>

<div class="card">

<div style="display:flex;
gap:15px;
align-items:center;">

<div class="avatar">

<%= name.charAt(0) %>

</div>

<div>

<h3>

<%= name %>

</h3>

<p>

Badge :

<%= rs.getString("badge") %>

</p>

<p>

Improvement :

<%= 100-rs.getDouble("score") %> %

</p>

</div>

</div>

</div>

<%
}

}
%>

</body>

</html>