package com.quizsystem.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.quizsystem.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AddStudentServlet extends HttpServlet {

protected void doPost(

HttpServletRequest request,

HttpServletResponse response)

throws ServletException,IOException{

try{

String name=

request.getParameter(
"studentName"
);

String password=

request.getParameter(
"password"
);

Connection con=

DBConnection.getConnection();

PreparedStatement ps1=

con.prepareStatement(

"INSERT INTO users(username,password,role) VALUES(?,?,?)",

PreparedStatement.RETURN_GENERATED_KEYS

);

ps1.setString(
1,
name
);

ps1.setString(
2,
password
);

ps1.setString(
3,
"student"
);

ps1.executeUpdate();

ResultSet rs=

ps1.getGeneratedKeys();

int userId=0;

if(rs.next()){

userId=

rs.getInt(1);

}

PreparedStatement ps2=

con.prepareStatement(

"INSERT INTO students(user_id,level,badge) VALUES(?,?,?)"

);

ps2.setInt(
1,
userId
);

ps2.setString(
2,
"Beginner"
);

ps2.setString(
3,
"Bronze"
);

ps2.executeUpdate();

rs.close();

ps1.close();

ps2.close();

con.close();

response.sendRedirect(

"manageStudents.jsp?msg=" +

name +

"%20added%20successfully"

);

}

catch(Exception e){

e.printStackTrace();

response.getWriter().println(

"Error : "+

e.getMessage()

);

}

}

}