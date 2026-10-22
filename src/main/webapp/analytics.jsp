<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>

<html>

<head>

<title>Analytics</title>

<style>

body{
background:#0f172a;
color:white;
font-family:Arial;
padding:30px;
}

.box{

background:#111827;

padding:25px;

border-radius:15px;

width:500px;

margin:auto;
}

input{

width:100%;

padding:10px;

margin:10px 0;

border:none;

border-radius:8px;

background:#1f2937;

color:white;
}

button{

width:100%;

padding:12px;

border:none;

border-radius:10px;

background:#B6FF6B;

color:black;

font-weight:bold;

cursor:pointer;
}

</style>

</head>

<body>

<div class="box">

<h2 style="color:#B6FF6B;">

Analytics

</h2>

<form action="AnalyticsServlet"

method="get">

<input

type="text"

name="assessmentName"

placeholder="Assessment Name"

required>

<input

type="text"

name="subject"

placeholder="Subject"

required>

<button type="submit">

View Analytics

</button>

</form>

</div>

</body>

</html>