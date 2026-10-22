<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>Upload Notes</title>

<style>
body{
background:#0f172a;
color:white;
font-family:Arial;
padding:30px;
}

.section{
background:#111827;
padding:20px;
border-radius:15px;
width:400px;
}

input, select{
width:100%;
padding:10px;
margin:10px 0;
border:none;
border-radius:8px;
background:#1f2937;
color:white;
}

button{
background:#B6FF6B;
color:black;
padding:10px;
border:none;
border-radius:8px;
font-weight:bold;
cursor:pointer;
width:100%;
}
</style>
</head>

<body>

<h2 style="color:#B6FF6B;">Upload Notes</h2>

<div class="section">

<form action="UploadNotesServlet" method="post" enctype="multipart/form-data">

<input type="text" name="subject" placeholder="Subject" required>

<input type="file" name="file" required>

<button type="submit">Upload</button>

</form>

</div>

</body>
</html>