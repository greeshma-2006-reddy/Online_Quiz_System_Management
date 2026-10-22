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

public class CodingQuestionServlet extends HttpServlet {

protected void doPost(
HttpServletRequest request,
HttpServletResponse response)

throws ServletException, IOException {

String assessmentName =
request.getParameter("assessmentName");

String subject =
request.getParameter("subject");

String level =
request.getParameter("level");

String mode =
request.getParameter("mode");

try{

Connection con =
DBConnection.getConnection();

if(mode.equals("own")){

String codingQuestion =
request.getParameter("codingQuestion");

PreparedStatement ps =
con.prepareStatement(

"INSERT INTO coding_questions(subject,level,question) VALUES(?,?,?)"

);

ps.setString(1, subject);

ps.setString(2, level);

ps.setString(3, codingQuestion);

ps.executeUpdate();

response.getWriter().println(
"Coding question added successfully"
);

}
else{

PreparedStatement ps =
con.prepareStatement(

"SELECT question FROM coding_questions " +

"WHERE subject=? AND level=? LIMIT 1"

);

ps.setString(1, subject);

ps.setString(2, level);

ResultSet rs =
ps.executeQuery();

if(rs.next()){

response.getWriter().println(

"Generated Question : " +

rs.getString("question")

);

}
else{

response.getWriter().println(

"No coding question found"

);

}

}

con.close();

}
catch(Exception e){

e.printStackTrace();

response.getWriter().println(

e.getMessage()

);

}

}

}