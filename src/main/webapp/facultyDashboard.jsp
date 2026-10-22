<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>Faculty Dashboard</title>

<style>
*{
margin:0;
padding:0;
box-sizing:border-box;
font-family:Arial,sans-serif;
}

body{
background:#0f172a;
color:white;
display:flex;
min-height:100vh;
}

/* Sidebar */
.sidebar{
width:260px;
background:#111827;
padding:20px;
display:flex;
flex-direction:column;
gap:15px;
}

.sidebar h2{
color:#B6FF6B;
margin-bottom:20px;
}

.sidebar button{
width:100%;
padding:12px;
border:none;
border-radius:10px;
cursor:pointer;
background:#1f2937;
color:white;
text-align:left;
transition:0.3s;
}

.sidebar button:hover{
background:#B6FF6B;
color:black;
}

/* Main */
.main{
flex:1;
padding:30px;
}

.header h1{
color:#B6FF6B;
margin-bottom:20px;
}

/* Section */
.section{
background:rgba(255,255,255,0.05);
padding:20px;
border-radius:15px;
margin-bottom:20px;
}

input, select{
width:100%;
padding:10px;
margin-top:10px;
margin-bottom:10px;
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
margin-top:10px;
}

button:hover{
background:#9BE04E;
}

.small-grid{
display:grid;
grid-template-columns:repeat(2,1fr);
gap:10px;
}
</style>

<script>
function toggleMode(){
let mode = document.getElementById("mode").value;

let inputs = document.querySelectorAll(".qcount");

if(mode === "mixed"){
inputs.forEach(i=>{
i.disabled = true;
i.value = "";
});
}else{
inputs.forEach(i=>{
i.disabled = false;
});
}
}
</script>

</head>

<body>

<!-- SIDEBAR -->
<div class="sidebar">

<h2>Faculty Panel</h2>

<button onclick="location.href='dashboard.jsp'">

🏠 Dashboard

</button>
<form action="uploadNotes.jsp">

<button type="submit">
📄 Upload Notes
</button>

</form>
<button onclick="location.href='addQuestion.jsp'">

➕ Add Questions

</button>
<button onclick="location.href='codingQuestions.jsp'">

💻 Coding Questions

</button>
<button onclick="location.href='manageQuestions.jsp'">

📚 Manage Questions

</button>
<button onclick="location.href='manageStudents.jsp'">

👨‍🎓 Manage Students

</button>
<button onclick="location.href='resultsHome.jsp'">

📊 View Results

</button>

<button onclick="location.href='analytics.jsp'">

📈 Analytics

</button>
<form action="LogoutServlet"

method="post">

<button

type="submit"

style="background:#ef4444;
color:white;">

🚪 Logout

</button>

</form>

</div>

<!-- MAIN -->
<div class="main">

<div class="header">
<h1>Faculty Dashboard</h1>
</div>

<!-- GENERATE ASSESSMENT -->
<div class="section">

<h2 style="color:#B6FF6B;">Generate Assessment</h2>

<form action="GenerateAssessmentServlet" method="post">

<input type="text" name="assessmentName" placeholder="Assessment Name" required>

<input type="text" name="subject" placeholder="Subject" required>

<input type="number" name="duration" placeholder="Duration (Minutes)" required>

<input type="number" name="totalQuestions" placeholder="Total Number of Questions" required>

<select name="level">
<option value="easy">Easy</option>
<option value="medium">Medium</option>
<option value="hard">Hard</option>
<option value="mixed">Mixed (Auto Divide)</option>
</select>

<select id="mode" name="mode" onchange="toggleMode()">
<option value="mixed">Mixed Question Type</option>
<option value="custom">Select Multiple Question Types</option>
</select>

<div class="small-grid">

<input class="qcount" type="number" name="mcqCount" placeholder="MCQs" disabled>
<input class="qcount" type="number" name="fillCount" placeholder="Fill Blanks" disabled>
<input class="qcount" type="number" name="tfCount" placeholder="True/False" disabled>
<input class="qcount" type="number" name="codingCount" placeholder="Coding" disabled>

</div>

<button type="submit">Generate Assessment</button>

</form>

</div>


</div>

</body>
</html>