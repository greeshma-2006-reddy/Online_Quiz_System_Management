package com.quizsystem.servlet;

import java.io.IOException;

import java.sql.Connection;

import java.sql.PreparedStatement;

import com.quizsystem.util.DBConnection;

import jakarta.servlet.ServletException;

import jakarta.servlet.http.HttpServlet;

import jakarta.servlet.http.HttpServletRequest;

import jakarta.servlet.http.HttpServletResponse;

public class GenerateAssessmentServlet

extends HttpServlet{

protected void doPost(

HttpServletRequest request,

HttpServletResponse response)

throws ServletException,IOException{

try{

String assessmentName=

request.getParameter(
"assessmentName"
);

String subject=

request.getParameter(
"subject"
);

int duration=

Integer.parseInt(

request.getParameter(
"duration"
)

);

int totalQuestions=

Integer.parseInt(

request.getParameter(
"totalQuestions"
)

);

String level=

request.getParameter(
"level"
);

String mode=

request.getParameter(
"mode"
);

Connection con=

DBConnection.getConnection();

PreparedStatement ps=

con.prepareStatement(

"INSERT INTO assessments " +

"(assessment_name,subject,level,mode,duration,total_questions) " +

"VALUES(?,?,?,?,?,?)"

);

ps.setString(
1,
assessmentName
);

ps.setString(
2,
subject
);

ps.setString(
3,
level
);

ps.setString(
4,
mode
);

ps.setInt(
5,
duration
);

ps.setInt(
6,
totalQuestions
);

ps.executeUpdate();

ps.close();

con.close();

response.sendRedirect(

"addQuestion.jsp"

);

}

catch(Exception e){

e.printStackTrace();

response.getWriter().println(

e.getMessage()

);

}

}

}