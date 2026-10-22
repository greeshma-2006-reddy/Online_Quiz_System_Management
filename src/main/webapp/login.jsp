<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login Page</title>

<style>

*{
margin:0;
padding:0;
box-sizing:border-box;
font-family:Arial, sans-serif;
}

body{
height:100vh;
display:flex;
justify-content:center;
align-items:center;
background:#0f1117;
}

.login-box{
width:380px;
padding:35px;
background:#1f2937;
border-radius:15px;
box-shadow:0px 0px 25px rgba(0,0,0,0.6);
}

.login-box h1{
text-align:center;
margin-bottom:30px;
color:#2f8d46;
font-size:34px;
font-weight:bold;
}

input,select{
width:100%;
padding:14px;
margin-top:18px;
border:none;
border-radius:8px;
background:#111827;
color:white;
font-size:16px;
outline:none;
border:1px solid #2f8d46;
}

input::placeholder{
color:#bdbdbd;
}

button{
width:100%;
padding:14px;
margin-top:25px;
border:none;
border-radius:8px;
background:#2f8d46;
color:white;
font-size:18px;
font-weight:bold;
cursor:pointer;
transition:0.3s;
}

button:hover{
background:#256f38;
transform:scale(1.02);
}

</style>

</head>

<body>

<div class="login-box">

<h1>Login</h1>

<form action="login" method="post">

<input type="text"
name="username"
placeholder="Enter Username"
required>

<input type="password"
name="password"
placeholder="Enter Password"
required>

<!-- FIXED ROLE VALUES -->
<select name="role" required>

<option value="admin">Admin</option>
<option value="faculty">Faculty</option>
<option value="student">Student</option>

</select>

<button type="submit">Login</button>

</form>

</div>

</body>
</html>