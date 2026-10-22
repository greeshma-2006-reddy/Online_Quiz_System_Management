<%@ page import="java.sql.*" %>
<%@ page import="com.quizsystem.util.DBConnection" %>

<!DOCTYPE html>

<html>

<head>

<title>Add Question</title>

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
width:600px;
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

color:black;

font-weight:bold;

cursor:pointer;
}

#tf,#fill{

display:none;
}

</style>

<script>

function showFields(){

let type=

document.getElementById(
"type"
).value;

document.getElementById(
"mcq"
).style.display="none";

document.getElementById(
"tf"
).style.display="none";

document.getElementById(
"fill"
).style.display="none";

if(type=="mcq"){

document.getElementById(
"mcq"
).style.display="block";

}

else if(type=="truefalse"){

document.getElementById(
"tf"
).style.display="block";

}

else if(type=="fill"){

document.getElementById(
"fill"
).style.display="block";

}

}

</script>

</head>

<body>

<div class="box">

<h2>Add Question</h2>

<form action="AddQuestionServlet"

method="post">

<label>

Assessment Name

</label>

<select

name="assessmentName"

required>

<%

Connection con=

DBConnection.getConnection();

PreparedStatement ps=

con.prepareStatement(

"SELECT assessment_name FROM assessments"

);

ResultSet rs=

ps.executeQuery();

while(rs.next()){

%>

<option>

<%= rs.getString(
"assessment_name"
) %>

</option>

<%

}

%>

</select>

<input

type="text"

name="subject"

placeholder="Subject"

required>

<select

name="type"

id="type"

onchange="showFields()"

required>

<option value="mcq">

MCQ

</option>

<option value="truefalse">

True False

</option>

<option value="fill">

Fill Blank

</option>

</select>

<input

type="text"

name="question"

placeholder="Enter Question"

required>

<div id="mcq">

<input type="text"

name="optA"

placeholder="Option A">

<input type="text"

name="optB"

placeholder="Option B">

<input type="text"

name="optC"

placeholder="Option C">

<input type="text"

name="optD"

placeholder="Option D">

<input type="text"

name="correctOption"

placeholder="Correct Option">

</div>

<div id="tf">

<p>

Options : True / False

</p>

<input type="text"

name="correctOption"

placeholder="Correct Answer">

</div>

<div id="fill">

<input type="text"

name="answerText"

placeholder="Answer">

</div>

<select

name="difficulty">

<option value="easy">

Easy

</option>

<option value="medium">

Medium

</option>

<option value="hard">

Hard

</option>

</select>

<button type="submit">

Add Question

</button>

</form>

</div>

</body>

</html>