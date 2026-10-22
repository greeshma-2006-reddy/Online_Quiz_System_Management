<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>

<html>

<head>

<title>Coding Questions</title>

<style>

body{
background:#0f172a;
color:white;
font-family:Arial;
padding:30px;
}

.section{

background:#111827;

padding:25px;

border-radius:15px;

width:600px;

margin:auto;
}

input,select,textarea{

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

<script>

function toggleCoding(){

let mode =
document.getElementById("mode").value;

let ownQuestion =
document.getElementById("ownQuestion");

if(mode==="own"){

ownQuestion.style.display="block";

}
else{

ownQuestion.style.display="none";

}

}

</script>

</head>

<body>

<div class="section">

<h2 style="color:#B6FF6B;">

Coding Questions

</h2>

<form action="CodingQuestionServlet"

method="post">

<input type="text"

name="assessmentName"

placeholder="Assessment Name"

required>

<input type="text"

name="subject"

placeholder="Subject"

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

</select>

<select id="mode"

name="mode"

onchange="toggleCoding()">

<option value="db">

Generate From DB

</option>

<option value="own">

Add My Own Question

</option>

</select>

<div id="ownQuestion"

style="display:none;">

<textarea

name="codingQuestion"

placeholder="Enter Coding Question">

</textarea>

</div>

<button type="submit">

Generate Test

</button>

</form>

</div>

</body>

</html>