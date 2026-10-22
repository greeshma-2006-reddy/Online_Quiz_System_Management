package com.quizsystem.servlet;

import java.io.IOException;
import java.sql.*;

import com.quizsystem.util.DBConnection;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class RemoveQuestionServlet
extends HttpServlet{

protected void doPost(
HttpServletRequest request,
HttpServletResponse response)

throws ServletException,
IOException{

try{

int questionId =

Integer.parseInt(

request.getParameter(
"questionId"
)

);

Connection con=

DBConnection.getConnection();

PreparedStatement ps=

con.prepareStatement(

"DELETE FROM questions WHERE id=?"

);

ps.setInt(
1,
questionId
);

ps.executeUpdate();

response.sendRedirect(
"manageQuestions.jsp"
);

}catch(Exception e){

e.printStackTrace();

}
}
}