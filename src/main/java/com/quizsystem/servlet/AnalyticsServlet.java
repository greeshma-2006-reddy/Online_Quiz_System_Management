package com.quizsystem.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.quizsystem.util.DBConnection;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AnalyticsServlet extends HttpServlet {

protected void doGet(
HttpServletRequest request,
HttpServletResponse response)

throws ServletException, IOException {

try{

Connection con =
DBConnection.getConnection();

String assessmentName =
request.getParameter("assessmentName");

String subject =
request.getParameter("subject");

PreparedStatement ps =
con.prepareStatement(

"SELECT u.username," +

"s.badge," +

"MAX(r.percentage) AS score " +

"FROM results r " +

"JOIN students s ON r.student_id=s.student_id " +

"JOIN users u ON s.user_id=u.id " +

"JOIN assessments a ON r.assessment_id=a.id " +

"WHERE a.assessment_name=? " +

"AND a.subject=? " +

"GROUP BY u.username,s.badge"

);

ps.setString(1, assessmentName);

ps.setString(2, subject);

ResultSet rs =
ps.executeQuery();

request.setAttribute(
"analyticsData",
rs
);

RequestDispatcher rd =
request.getRequestDispatcher(
"analyticsResult.jsp"
);

rd.forward(request,response);

}
catch(Exception e){

e.printStackTrace();

}

}

}