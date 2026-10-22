<%@ page import="java.sql.*" %>

<!DOCTYPE html>

<html>

<head>

<title>Questions</title>

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

<h2>Questions</h2>

<%

ResultSet rs =

(ResultSet)

request.getAttribute(
"questions"
);

boolean found = false;

if(rs != null){

while(rs.next()){

found = true;

%>

<div class="card">

<p>

<%= rs.getString("question") %>

</p>

<form action="RemoveQuestionServlet"

method="post">

<input type="hidden"

name="questionId"

value="<%= rs.getInt("id") %>">

<button type="submit">

Remove

</button>

</form>

</div>

<%

}

}

if(!found){

%>

<div class="card">

No Questions Found

</div>

<%

}

%>

</body>

</html>