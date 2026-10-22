<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.quizsystem.util.DBConnection" %>

<%
Connection con = DBConnection.getConnection();
ResultSet rs = null;

Integer aid = (Integer) session.getAttribute("assessmentId");

List<Integer> ids =
(List<Integer>) session.getAttribute("mockQuestions");
%>

<!DOCTYPE html>
<html>
<head>
<title>Take Test</title>

<style>

body{
background:#0f172a;
font-family:Arial;
color:white;
margin:0;
padding:20px;
user-select:none;
}

.header{
display:flex;
justify-content:space-between;
align-items:center;
margin-bottom:20px;
}

#timer{
background:#B6FF6B;
color:black;
padding:10px 20px;
border-radius:10px;
font-weight:bold;
}

.container{
display:flex;
gap:20px;
}

.questionPanel{
flex:3;
background:#111827;
padding:25px;
border-radius:15px;
}

.palette{
flex:1;
background:#111827;
padding:20px;
border-radius:15px;
}

.questionCard{
display:none;
}

.questionCard.active{
display:block;
}

.questionCard label{
display:block;
background:#1f2937;
padding:12px;
margin:10px 0;
border-radius:10px;
cursor:pointer;
}

button{
background:#B6FF6B;
border:none;
padding:10px 15px;
border-radius:10px;
font-weight:bold;
cursor:pointer;
}

.navBtn{
width:45px;
height:45px;
margin:5px;
background:#6b7280;
color:white;
border:none;
border-radius:8px;
}

.activeNav{ background:#3b82f6; }
.answered{ background:#22c55e; }
.review{ background:#a855f7 !important; }

.submitBtn{
width:100%;
margin-top:20px;
}

<style>

/* your existing CSS */

.navBtn {
    width:45px;
    height:45px;
}

/* ⭐ PASTE HERE (at bottom of style section) */



</style>

</head>

<body>


<div class="header">
    <h2>Assessment Test</h2>
    <div id="timer">30:00</div>
</div>

<div class="container">

<!-- QUESTION PANEL -->
<div class="questionPanel">

<form action="SubmitMockTestServlet" method="post">

<input type="hidden" name="aid" value="<%= aid == null ? 0 : aid %>">

<%
int count = 0;

// FACULTY TEST
if(aid != null){

PreparedStatement ps =
con.prepareStatement(
"SELECT * FROM questions WHERE assessment_id=?");

ps.setInt(1, aid);

rs = ps.executeQuery();

}
// MOCK TEST
else if(ids != null && !ids.isEmpty()){

StringBuilder query =
new StringBuilder("SELECT * FROM mock_questions WHERE id IN (");

for(int i=0;i<ids.size();i++){
query.append("?");
if(i < ids.size()-1) query.append(",");
}
query.append(")");

PreparedStatement ps = con.prepareStatement(query.toString());

for(int i=0;i<ids.size();i++){
ps.setInt(i+1, ids.get(i));
}

rs = ps.executeQuery();
}
%>

<%
while(rs != null && rs.next()){

count++;

String type = rs.getString("type");
%>

<div class="questionCard <%= count==1 ? "active" : "" %>">

<h3><%= rs.getString("question") %></h3>

<%

if("mcq".equalsIgnoreCase(type)){

%>

<label>

<input type="radio"
name="q<%=rs.getInt("id")%>"
value="A"
onclick="markAnsweredManual()">

<%= rs.getString("optA") %>

</label>

<label>

<input type="radio"
name="q<%=rs.getInt("id")%>"
value="B"
onclick="markAnsweredManual()">

<%= rs.getString("optB") %>

</label>

<label>

<input type="radio"
name="q<%=rs.getInt("id")%>"
value="C"
onclick="markAnsweredManual()">

<%= rs.getString("optC") %>

</label>

<label>

<input type="radio"
name="q<%=rs.getInt("id")%>"
value="D"
onclick="markAnsweredManual()">

<%= rs.getString("optD") %>

</label>

<%
}

else if("truefalse".equalsIgnoreCase(type)){

%>

<label>

<input type="radio"
name="q<%=rs.getInt("id")%>"
value="true"
onclick="markAnsweredManual()">

True

</label>

<label>

<input type="radio"
name="q<%=rs.getInt("id")%>"
value="false"
onclick="markAnsweredManual()">

False

</label>

<%
}

else if("fill".equalsIgnoreCase(type)){

%>

<input type="text"

name="q<%=rs.getInt("id")%>"

placeholder="Enter your answer"

onkeyup="markAnsweredManual()">

<%
}
%>

</div>

<%
}
%>
<div>
<button type="button" onclick="prevQuestion()">Previous</button>
<button type="button" onclick="nextQuestion()">Next</button>
<button type="button" onclick="markReview()">Mark Review</button>
</div>

</form>

</div>

<!-- NAV PANEL -->
<div class="palette">

<h3>Questions</h3>

<%
int total = count;

for(int i=1;i<=total;i++){
%>

<button type="button"
class="navBtn"
id="nav<%=i%>"
onclick="goToQuestion(<%=i-1%>)">
<%=i%>
</button>

<%
}
%>

<button class="submitBtn" onclick="document.forms[0].submit()">
Submit Test
</button>

</div>

</div>

<script>

let current = 0;
let questions = document.querySelectorAll(".questionCard");

// status tracking
let status = new Array(questions.length).fill("notVisited");
status[0] = "active";
updateNav();

function markAnswered(){
let selected = questions[current]
.querySelector("input[type='radio']:checked");

if(selected){
status[current] = "answered";
updateNav();
}
}
function markAnsweredManual(){

	let radio = questions[current]
	.querySelector("input[type='radio']:checked");

	let text = questions[current]
	.querySelector("input[type='text']");

	if(radio || (text && text.value.trim() !== "")){

	status[current] = "answered";

	}

	updateNav();

	}
function updateNav(){

for(let i=0;i<status.length;i++){

let btn = document.getElementById("nav"+(i+1));
btn.className = "navBtn";

if(status[i] === "active"){
btn.classList.add("activeNav");
}
else if(status[i] === "answered"){
btn.classList.add("answered");
}
else if(status[i] === "review"){
btn.classList.add("review");
}
else{
	btn.className = "navBtn";
	}
}
}

function showQuestion(index){

for(let i=0;i<questions.length;i++){
questions[i].classList.remove("active");
}

current = index;
questions[current].classList.add("active");
}

function nextQuestion(){

	let radio = questions[current]
	.querySelector("input[type='radio']:checked");

	let text = questions[current]
	.querySelector("input[type='text']");

	if(radio || (text && text.value.trim() !== "")){

	status[current] = "answered";

	}

    updateNav();

    if(current < questions.length-1){
        current++;
    }

    showQuestion(current);
}
function prevQuestion(){

if(current > 0){
current--;
}

showQuestion(current);
updateNav();
}

function goToQuestion(index){

current = index;
showQuestion(current);
updateNav();
}

function markReview(){
status[current] = "review";
updateNav();
}

// TIMER
let time = 1800;

setInterval(()=>{

let m = Math.floor(time/60);
let s = time%60;

document.getElementById("timer").innerHTML =
m + ":" + (s<10?"0":"") + s;

time--;

},1000);
window.onbeforeunload = function(){
    markAnsweredManual();
};

</script>
</body>
</html>