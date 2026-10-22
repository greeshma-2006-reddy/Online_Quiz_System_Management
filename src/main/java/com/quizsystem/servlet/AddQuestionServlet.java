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

public class AddQuestionServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)

            throws ServletException, IOException {

        try {

            String assessmentName =
                    request.getParameter("assessmentName");

            String subject =
                    request.getParameter("subject");

            String question =
                    request.getParameter("question");

            String type =
                    request.getParameter("type");

            String difficulty =
                    request.getParameter("difficulty");

            String optA =
                    request.getParameter("optA");

            String optB =
                    request.getParameter("optB");

            String optC =
                    request.getParameter("optC");

            String optD =
                    request.getParameter("optD");

            String correctOption =
                    request.getParameter("correctOption");

            String answerText =
                    request.getParameter("answerText");

            Connection con =
                    DBConnection.getConnection();

            // Get assessment id

            PreparedStatement ps1 =
                    con.prepareStatement(

            "SELECT id FROM assessments WHERE assessment_name=?"

            );

            ps1.setString(
                    1,
                    assessmentName
            );

            ResultSet rs =
                    ps1.executeQuery();

            int assessmentId = 0;

            if(rs.next()){

                assessmentId =
                        rs.getInt("id");

            }

            rs.close();

            ps1.close();

            if(assessmentId == 0){

                response.getWriter().println(
                        "Assessment not found"
                );

                con.close();

                return;
            }

            PreparedStatement ps =
                    con.prepareStatement(

            "INSERT INTO questions " +

            "(assessment_id,question,optA,optB,optC,optD,correct_option,type,difficulty,answer_text,subject) " +

            "VALUES(?,?,?,?,?,?,?,?,?,?,?)"

            );

            ps.setInt(
                    1,
                    assessmentId
            );

            ps.setString(
                    2,
                    question
            );

            ps.setString(
                    3,
                    optA
            );

            ps.setString(
                    4,
                    optB
            );

            ps.setString(
                    5,
                    optC
            );

            ps.setString(
                    6,
                    optD
            );

            ps.setString(
                    7,
                    correctOption
            );

            ps.setString(
                    8,
                    type
            );

            ps.setString(
                    9,
                    difficulty
            );

            ps.setString(
                    10,
                    answerText
            );

            ps.setString(
                    11,
                    subject
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

                    "Error : " +

                    e.getMessage()

            );

        }

    }

}