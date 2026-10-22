package com.quizsystem.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import com.quizsystem.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ViewResultsServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)

            throws ServletException, IOException {

        String assessmentName =
        request.getParameter("assessmentName");

        String subject =
        request.getParameter("subject");

        try {

            Connection con =
            DBConnection.getConnection();

            PreparedStatement ps =
            con.prepareStatement(

            "SELECT u.username, " +

            "s.badge, " +

            "r.percentage, " +

            "r.correct, " +

            "r.wrong " +

            "FROM results r " +

            "JOIN students s " +

            "ON r.student_id=s.student_id " +

            "JOIN users u " +

            "ON s.user_id=u.id " +

            "JOIN assessments a " +

            "ON r.assessment_id=a.id " +

            "WHERE a.assessment_name=? " +

            "AND a.subject=?"

            );

            ps.setString(1, assessmentName);

            ps.setString(2, subject);

            ResultSet rs =
            ps.executeQuery();

            ArrayList<String[]> results =
            new ArrayList<>();

            while(rs.next()){

                String[] row = {

                rs.getString("username"),

                rs.getString("badge"),

                String.valueOf(
                rs.getDouble("percentage")
                ),

                String.valueOf(
                rs.getInt("correct")
                ),

                String.valueOf(
                rs.getInt("wrong")
                )

                };

                results.add(row);
            }

            request.setAttribute(
            "results",
            results
            );

            request.getRequestDispatcher(
            "viewResults.jsp"
            )

            .forward(
            request,
            response
            );

        }

        catch(Exception e){

            e.printStackTrace();
        }

    }

}