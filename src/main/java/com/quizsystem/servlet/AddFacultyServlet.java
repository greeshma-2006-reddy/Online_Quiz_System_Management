package com.quizsystem.servlet;

import java.io.IOException;
import java.sql.*;
import com.quizsystem.util.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class AddFacultyServlet extends HttpServlet {

protected void doPost(HttpServletRequest request, HttpServletResponse response)
throws ServletException, IOException {

try {

String username = request.getParameter("username");
String password = request.getParameter("password");

Connection con = DBConnection.getConnection();

PreparedStatement ps = con.prepareStatement(
"INSERT INTO users(username,password,role) VALUES(?,?,?)"
);

ps.setString(1, username);
ps.setString(2, password);
ps.setString(3, "faculty");

ps.executeUpdate();

response.sendRedirect("manageFaculty.jsp");

} catch(Exception e) {
e.printStackTrace();
response.getWriter().println(e.getMessage());
}
}
}