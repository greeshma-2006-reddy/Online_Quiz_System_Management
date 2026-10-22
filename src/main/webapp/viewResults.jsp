<%@ page import="java.util.*" %>

<!DOCTYPE html>

<html>

<head>

<title>Assessment Results</title>

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

margin:15px 0;

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

ArrayList<String[]> results =

(ArrayList<String[]>)

request.getAttribute(
"results"
);

if(results!=null
&& !results.isEmpty()){

for(String[] row:results){

%>

<div class="card">

<p>

Student :

<%= row[0] %>

</p>

<p>

Badge :

<%= row[1] %>

</p>

<p>

Score :

<%= row[2] %> %

</p>

<p>

Correct :

<%= row[3] %>

</p>

<p>

Wrong :

<%= row[4] %>

</p>

</div>

<%

}

}else{

%>

<div class="card">

No Results Found

</div>

<%

}

%>

</body>

</html>