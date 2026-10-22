<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Online Quiz Management System</title>

<style>

body{
    margin:0;
    padding:0;
    background:#000;
    font-family:Arial, sans-serif;
}

/* TOP NAVBAR */
.header{
    background:#0f3d2e;
    padding:18px 40px;
    display:flex;
    align-items:center;
    box-shadow:0 2px 15px rgba(0,0,0,0.5);
}

/* LOGO */
.logo{
    width:55px;
    height:55px;
    border-radius:12px;
    object-fit:cover;
    border:2px solid #1dbf73;
    margin-right:15px;
}

/* TITLE */
.title{
    color:white;
    font-size:24px;
    font-weight:bold;
}

/* MAIN SECTION */
.container{
    height:85vh;
    display:flex;
    justify-content:center;
    align-items:center;
}

/* CARD */
.card{
    background:#111;
    width:420px;
    padding:40px;
    border-radius:18px;
    text-align:center;
    box-shadow:0 0 25px rgba(0,255,120,0.15);
}

/* WELCOME */
.card h1{
    color:#1dbf73;
    margin-bottom:10px;
    font-size:40px;
}

/* TEXT */
.card p{
    color:#cccccc;
    font-size:17px;
    line-height:25px;
}

/* BUTTON STYLE */
.button{
    margin-top:25px;
    background:#0f3d2e;
    color:white;
    border:none;
    padding:13px 28px;
    border-radius:10px;
    font-size:16px;
    cursor:pointer;
    transition:0.3s;

    text-decoration:none;
    display:inline-block;
}

.button:hover{
    background:#176b4d;
    transform:scale(1.05);
}

</style>

</head>

<body>

<!-- HEADER -->
<div class="header">

    <img src="images/logo.jpeg" class="logo" alt="Logo">

    <div class="title">
        Online Quiz Management System
    </div>

</div>

<!-- MAIN -->
<div class="container">

    <div class="card">

        <h1>Welcome 🎯</h1>

        <p>
            Test your knowledge, challenge your skills,
            and improve your learning experience.
        </p>

        <!-- ✅ CORRECT NAVIGATION -->
        <a href="login.jsp" class="button">
            Start Quiz
        </a>

    </div>

</div>

</body>
</html>