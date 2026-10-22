package com.quizsystem.servlet;

import java.io.IOException;
import java.sql.*;
import com.quizsystem.util.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class RemoveFacultyServlet extends HttpServlet {

protected void doPost(HttpServletRequest request, HttpServletResponse response)
throws ServletException, IOException {

try {

int id = Integer.parseInt(request.getParameter("id"));

Connection con = DBConnection.getConnection();

PreparedStatement ps = con.prepareStatement(
"DELETE FROM users WHERE id=? AND role='faculty'"
);

ps.setInt(1, id);
ps.executeUpdate();

response.sendRedirect("manageFaculty.jsp");

} catch(Exception e) {
e.printStackTrace();
}
}
}