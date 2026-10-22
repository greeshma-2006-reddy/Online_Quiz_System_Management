<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.quizsystem.util.DBConnection" %>

<%
Connection con = DBConnection.getConnection();
ResultSet rs = null;

Integer aid = null;

if(session.getAttribute("assessmentId") != null){
    aid = (Integer) session.getAttribute("assessmentId");
    if(aid == 0) aid = null;
}

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

/* START SCREEN */
#startScreen{
position:fixed;
top:0;
left:0;
width:100%;
height:100%;
background:#0f172a;
display:flex;
justify-content:center;
align-items:center;
z-index:9999;
}

.container{
display:none;
}
</style>
</head>

<body>

<!-- START SCREEN -->
<div id="startScreen">
    <button id="startBtn" onclick="startExam()">Start Test</button>
</div>

<div class="header">
    <h2>Assessment Test</h2>
    <div id="timer">30:00</div>
</div>

<div class="container">

<div class="questionPanel">

<form action="SubmitTestServlet" method="post">

<input type="hidden" name="aid" value="<%= aid == null ? 0 : aid %>">

<%
int count = 0;

if(aid != null && ids == null){

PreparedStatement ps =
con.prepareStatement("SELECT * FROM questions WHERE assessment_id=?");
ps.setInt(1, aid);
rs = ps.executeQuery();

}else if(ids != null && !ids.isEmpty()){

StringBuilder query =
new StringBuilder("SELECT * FROM questions WHERE id IN (");

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
int qid = rs.getInt("id");
%>

<div class="questionCard <%= (count==1 ? "active" : "") %>">

    <p><b>Q<%=count%>: <%=rs.getString("question")%></b></p>

    <% if("mcq".equalsIgnoreCase(type)) { %>

        <label>
            <input type="radio"
                   name="answer<%=qid%>"
                   value="<%=rs.getString("optA")%>"
                   onclick="markAnsweredManual()">
            <%=rs.getString("optA")%>
        </label>

        <label>
            <input type="radio"
                   name="answer<%=qid%>"
                   value="<%=rs.getString("optB")%>"
                   onclick="markAnsweredManual()">
            <%=rs.getString("optB")%>
        </label>

        <label>
            <input type="radio"
                   name="answer<%=qid%>"
                   value="<%=rs.getString("optC")%>"
                   onclick="markAnsweredManual()">
            <%=rs.getString("optC")%>
        </label>

        <label>
            <input type="radio"
                   name="answer<%=qid%>"
                   value="<%=rs.getString("optD")%>"
                   onclick="markAnsweredManual()">
            <%=rs.getString("optD")%>
        </label>

    <% } 
    else if("truefalse".equalsIgnoreCase(type)) { %>

        <label>
            <input type="radio"
                   name="answer<%=qid%>"
                   value="True"
                   onclick="markAnsweredManual()">
            True
        </label>

        <label>
            <input type="radio"
                   name="answer<%=qid%>"
                   value="False"
                   onclick="markAnsweredManual()">
            False
        </label>

    <% } 
    else { %>

        <input type="text"
               name="answer<%=qid%>"
               placeholder="Enter answer"
               onkeyup="markAnsweredManual()">

    <% } %>

</div>
<% } %>

<div>
<button type="button" onclick="prevQuestion()">Prev</button>
<button type="button" onclick="nextQuestion()">Next</button>
<button type="button" onclick="markReview()">Mark Review</button>
</div>

</form>

</div>

<div class="palette">
<h3>Questions</h3>

<%
for(int i=1;i<=count;i++){
%>

<button type="button"
class="navBtn"
id="nav<%=i%>"
onclick="goToQuestion(<%=i-1%>)">
<%=i%>
</button>

<% } %>

<button class="submitBtn" type="button"
        onclick="markLastQuestion(); document.forms[0].submit();">
    Submit Test
</button>

</div>
</div>

<!-- JS -->
<script>

let warnings = 0;

/* RIGHT CLICK BLOCK */
document.addEventListener("contextmenu", e => e.preventDefault());

/* COPY CUT PASTE BLOCK */
document.addEventListener("copy", e => e.preventDefault());
document.addEventListener("cut", e => e.preventDefault());
document.addEventListener("paste", e => e.preventDefault());

/* KEYBOARD BLOCK */
document.addEventListener("keydown", function(e){

if(
    e.key === "F12" ||
    (e.ctrlKey && ["c","v","x","u","s","p"].includes(e.key)) ||
    (e.ctrlKey && e.shiftKey && ["I","J"].includes(e.key))
){
    e.preventDefault();
}

});

/* TAB SWITCH DETECTION */
document.addEventListener("visibilitychange", function(){

if(document.hidden){

warnings++;

alert("Warning " + warnings + ": Tab switching is not allowed!");

if(warnings >= 3){
    alert("Test submitted due to violations");
    document.forms[0].submit();
}

}

});

/* FULLSCREEN EXIT DETECTION */
document.addEventListener("fullscreenchange", function(){

if(!document.fullscreenElement){

warnings++;

alert("Warning " + warnings + ": Do not exit fullscreen");

if(warnings >= 3){
    document.forms[0].submit();
}else{
    enterFullscreen();
}

}

});

</script>

<script>

let current = 0;
let questions = document.querySelectorAll(".questionCard");
window.onload = function(){
    enterFullscreen();
};
let status = new Array(questions.length).fill("notVisited");
status[0] = "active";

function startExam(){

document.getElementById("startScreen").style.display="none";
document.querySelector(".container").style.display="flex";
let warnings = 0;

/* TAB SWITCH DETECTION */
document.addEventListener("visibilitychange", function () {
    if (document.hidden) {
        warnings++;

        alert("⚠ Warning " + warnings + ": Tab switching is not allowed!");

        if (warnings >= 3) {
            alert("❌ 3 warnings reached. Test will be submitted!");
            document.forms[0].submit();
        }
    }
});

/* FULLSCREEN EXIT DETECTION */
document.addEventListener("fullscreenchange", function () {
    if (!document.fullscreenElement) {
        warnings++;

        alert("⚠ Warning " + warnings + ": Do not exit fullscreen!");

        if (warnings >= 3) {
            alert("❌ Test submitted due to violations");
            document.forms[0].submit();
        } else {
            enterFullscreen();
        }
    }
});

/* RIGHT CLICK BLOCK */
document.addEventListener("contextmenu", function (e) {
    e.preventDefault();
    alert("⚠ Right click disabled!");
});

/* COPY / CUT / PASTE BLOCK */
document.addEventListener("copy", function (e) {
    e.preventDefault();
    alert("⚠ Copying is not allowed!");
});

document.addEventListener("cut", function (e) {
    e.preventDefault();
    alert("⚠ Cutting is not allowed!");
});

document.addEventListener("paste", function (e) {
    e.preventDefault();
    alert("⚠ Pasting is not allowed!");
});

/* KEYBOARD SHORTCUT BLOCK */
document.addEventListener("keydown", function (e) {

    if (
        e.key === "F12" ||
        (e.ctrlKey && ["c", "v", "x", "u", "s", "p"].includes(e.key)) ||
        (e.ctrlKey && e.shiftKey && ["I", "J"].includes(e.key))
    ) {
        e.preventDefault();
        alert("⚠ Keyboard shortcut blocked!");
    }

});

enterFullscreen();
}

function enterFullscreen(){

	let el = document.documentElement;

	if(el.requestFullscreen){
	    el.requestFullscreen().catch(()=>{});
	}
	else if(el.webkitRequestFullscreen){
	    el.webkitRequestFullscreen();
	}
	else if(el.msRequestFullscreen){
	    el.msRequestFullscreen();
	}

	}

function showQuestion(index){

    questions.forEach(q => q.classList.remove("active"));

    current = index;
    questions[current].classList.add("active");

    updateNav();
}
function markAnsweredManual(){

    let radio = questions[current].querySelector("input[type='radio']:checked");
    let text = questions[current].querySelector("input[type='text']");

    if(radio || (text && text.value.trim() !== "")){
        status[current] = "answered";
    }

    updateNav();
}
function nextQuestion(){

    let radio = questions[current].querySelector("input[type='radio']:checked");
    let text = questions[current].querySelector("input[type='text']");

    if(radio || (text && text.value.trim() !== "")){
        status[current] = "answered";
    }

    if(current < questions.length - 1){
        current++;
    }

    showQuestion(current);
}

function prevQuestion(){
if(current > 0){
current--;
}
showQuestion(current);
}

function goToQuestion(i){
current = i;
showQuestion(i);
updateNav();
}

function markLastQuestion(){
    let radio = questions[current].querySelector("input[type='radio']:checked");
    let text = questions[current].querySelector("input[type='text']");

    if(radio || (text && text.value.trim() !== "")){
        status[current] = "answered";
    }

    updateNav();
}
function updateNav(){

    for(let i=0;i<status.length;i++){

        let btn = document.getElementById("nav"+(i+1));
        btn.className = "navBtn";

        if(i === current){
            btn.classList.add("activeNav");
        }
        else if(status[i] === "answered"){
            btn.classList.add("answered");
        }
        else if(status[i] === "review"){
            btn.classList.add("review");
        }
    }
}
let time = 1800;

setInterval(() => {

if(time <= 0){
    document.forms[0].submit();
    return;
}

let m = Math.floor(time / 60);
let s = time % 60;

document.getElementById("timer").innerHTML =
m + ":" + (s < 10 ? "0" : "") + s;

time--;

}, 1000);

</script>

</body>
