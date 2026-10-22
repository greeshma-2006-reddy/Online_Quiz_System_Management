package com.quizsystem.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import com.quizsystem.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class GenerateMockTestServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        try {

            String subject =
                    request.getParameter("subject");
            String topic =
            		request.getParameter("topic");

            String level =
                    request.getParameter("level");
            System.out.println(subject);
            System.out.println(topic);
            System.out.println(level);

            int totalQuestions =
                    Integer.parseInt(
                    request.getParameter("totalQuestions"));
            System.out.println("SUBJECT = " + subject);

            System.out.println("TOPIC = " + topic);

            System.out.println("LEVEL = " + level);

            System.out.println("TOTAL = " + totalQuestions);
            Connection con =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(

                    "SELECT * FROM mock_questions " +
                    "WHERE subject=? " +
                    "AND topic=? "+
                    "AND difficulty=? " +
                    "ORDER BY RAND() LIMIT ?"

                    );

            ps.setString(1, subject);
            ps.setString(2, topic);
            ps.setString(3, level);
            ps.setInt(4, totalQuestions);

            ResultSet rs =
                    ps.executeQuery();

            ArrayList<Integer> questionIds =
                    new ArrayList<>();

            while(rs.next()) {

                questionIds.add(
                        rs.getInt("id"));
            }
            System.out.println(questionIds);

            HttpSession session =
                    request.getSession();

            session.setAttribute(
                    "mockQuestions",
                    questionIds);

            response.sendRedirect(
                    "mockTest.jsp");

        }
        catch(Exception e) {

            e.printStackTrace();

            response.getWriter().println(
                    "Error : " + e.getMessage());
        }
    }
}