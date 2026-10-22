package com.quizsystem.servlet;

import java.io.IOException;
import java.sql.*;

import com.quizsystem.util.DBConnection;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class ManageQuestionsServlet
extends HttpServlet {

protected void doPost(
HttpServletRequest request,
HttpServletResponse response)

throws ServletException,
IOException{

String action =
request.getParameter("action");

try{

Connection con =
DBConnection.getConnection();

if("search".equals(action)){

String assessmentName =
request.getParameter("assessmentName");

String subject =
request.getParameter("subject");

String type =
request.getParameter("type");

PreparedStatement ps =
con.prepareStatement(

"SELECT q.id,q.question " +

"FROM questions q " +

"JOIN assessments a " +

"ON q.assessment_id=a.id " +

"WHERE a.assessment_name=? " +

"AND q.subject=? " +

"AND q.type=?"

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
type
);
System.out.println("Assessment = " + assessmentName);

System.out.println("Subject = " + subject);

System.out.println("Type = " + type);

ResultSet rs =
ps.executeQuery();

request.setAttribute(
"questions",
rs
);

RequestDispatcher rd =
request.getRequestDispatcher(
"manageQuestionsResult.jsp"
);

rd.forward(
request,
response
);

}

}catch(Exception e){

e.printStackTrace();

}
}
}