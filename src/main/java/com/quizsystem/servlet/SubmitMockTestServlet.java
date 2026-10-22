package com.quizsystem.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import com.quizsystem.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class SubmitMockTestServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        int correct = 0;
        int wrong = 0;
        int notAttempted = 0;
        int total = 0;

        try (Connection con = DBConnection.getConnection()) {

            List<Integer> ids =
                    (List<Integer>) session.getAttribute("mockQuestions");

            if (ids == null || ids.isEmpty()) {

                response.getWriter().println(
                        "No mock questions found."
                );

                return;
            }

            Integer studentId =
                    (Integer) session.getAttribute("studentId");

            if (studentId == null) {
                studentId = 1;
            }

            for (Integer qid : ids) {

                PreparedStatement ps =
                        con.prepareStatement(
                        "SELECT * FROM mock_questions WHERE id=?"
                        );

                ps.setInt(1, qid);

                ResultSet rs =
                        ps.executeQuery();

                if (rs.next()) {

                    total++;

                    String type =
                            rs.getString("type");

                    String userAnswer =
                            request.getParameter("q" + qid);

                    if (userAnswer == null ||
                        userAnswer.trim().isEmpty()) {

                        notAttempted++;

                        continue;
                    }

                    boolean isCorrect = false;

                    // ================= MCQ =================

                    if ("mcq".equalsIgnoreCase(type)) {

                        String dbCorrect =
                                rs.getString("correct_option");

                        if (dbCorrect != null) {

                            userAnswer =
                                    userAnswer.trim().toUpperCase();

                            dbCorrect =
                                    dbCorrect.trim().toUpperCase();

                            isCorrect =
                                    userAnswer.equals(dbCorrect);
                        }
                    }

                    // ================= TRUE/FALSE =================

                    else if ("truefalse".equalsIgnoreCase(type)) {

                        String dbCorrect =
                                rs.getString("answer_text");

                        if (dbCorrect == null ||
                            dbCorrect.isEmpty()) {

                            dbCorrect =
                                    rs.getString("correct_option");
                        }

                        if (dbCorrect != null) {

                            userAnswer =
                                    normalize(userAnswer);

                            dbCorrect =
                                    normalize(dbCorrect);

                            isCorrect =
                                    userAnswer.equals(dbCorrect);
                        }
                    }

                    // ================= FILL =================

                    else if ("fill".equalsIgnoreCase(type)) {

                        String dbCorrect =
                                rs.getString("answer_text");

                        if (dbCorrect != null) {

                            userAnswer =
                                    normalize(userAnswer);

                            dbCorrect =
                                    normalize(dbCorrect);

                            isCorrect =
                                    userAnswer.equals(dbCorrect);
                        }
                    }

                    // ================= DEBUG =================

                    System.out.println("QID = " + qid);

                    System.out.println(

                    "Student = " + userAnswer +

                    " | Type = " + type +

                    " | DB Correct = " +

                    rs.getString("correct_option") +

                    " | DB Answer = " +

                    rs.getString("answer_text")

                    );

                    System.out.println(

                    "Is Correct = " + isCorrect

                    );

                    if (isCorrect)

                        correct++;

                    else

                        wrong++;
                }

                rs.close();
                ps.close();
            }

            // ================= RESULT =================

            double percentage =

            (total == 0)

            ? 0

            : (correct * 100.0 / total);

            // ================= SAVE RESULT =================

            PreparedStatement psInsert =

            con.prepareStatement(

            "INSERT INTO results(student_id,assessment_id,score,total_questions,percentage,correct,wrong,not_attempted) VALUES(?,?,?,?,?,?,?,?)"

            );

            psInsert.setInt(1, studentId);

            psInsert.setInt(2, 0);

            psInsert.setDouble(3, percentage);

            psInsert.setInt(4, total);

            psInsert.setDouble(5, percentage);

            psInsert.setInt(6, correct);

            psInsert.setInt(7, wrong);

            psInsert.setInt(8, notAttempted);

            psInsert.executeUpdate();

            psInsert.close();

            // ================= SEND TO JSP =================

            request.setAttribute(
                    "score",
                    percentage
            );

            request.setAttribute(
                    "percentage",
                    percentage
            );

            request.setAttribute(
                    "correct",
                    correct
            );

            request.setAttribute(
                    "wrong",
                    wrong
            );

            request.setAttribute(
                    "notAttempted",
                    notAttempted
            );

            request.getRequestDispatcher(
                    "result.jsp"
            ).forward(request, response);

        }

        catch (Exception e) {

            e.printStackTrace();

            response.getWriter().println(

            "Error : "

            + e.getMessage()

            );
        }
    }

    private String normalize(String s) {

        if (s == null)

            return "";

        return s.trim()

                .replaceAll("\\s+", " ")

                .toLowerCase();
    }
}