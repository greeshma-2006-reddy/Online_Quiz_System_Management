package com.quizsystem.servlet;

import java.io.IOException;
import java.sql.*;

import com.quizsystem.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class SubmitTestServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        String aidStr = request.getParameter("aid");

        if (aidStr == null || aidStr.isEmpty()) {
            response.getWriter().println("Assessment ID missing");
            return;
        }

        int aid = Integer.parseInt(aidStr);

        int correct = 0;
        int wrong = 0;
        int notAttempted = 0;
        int total = 0;

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps = con.prepareStatement(
                "SELECT id, type, correct_option, answer_text, optA, optB, optC, optD " +
                "FROM questions WHERE assessment_id=?"
            );

            ps.setInt(1, aid);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                total++;

                int qid = rs.getInt("id");
                String type = rs.getString("type");

                String userAnswer = request.getParameter("answer" + qid);

                if (userAnswer == null || userAnswer.trim().isEmpty()) {
                    notAttempted++;
                    continue;
                }

                userAnswer = normalize(userAnswer);

                boolean isCorrect = false;

                // ================= MCQ =================
                if ("mcq".equalsIgnoreCase(type)) {

                    String dbCorrect = rs.getString("correct_option");

                    String optA = rs.getString("optA");
                    String optB = rs.getString("optB");
                    String optC = rs.getString("optC");
                    String optD = rs.getString("optD");

                    if (dbCorrect != null) {
                        dbCorrect = dbCorrect.trim().toUpperCase();

                        String correctAnswerText = "";

                        switch (dbCorrect) {
                            case "A": correctAnswerText = optA; break;
                            case "B": correctAnswerText = optB; break;
                            case "C": correctAnswerText = optC; break;
                            case "D": correctAnswerText = optD; break;
                        }

                        isCorrect = normalize(userAnswer)
                                .equalsIgnoreCase(normalize(correctAnswerText));
                    }
                }

                // ================= TRUE/FALSE =================
                else if ("truefalse".equalsIgnoreCase(type)) {

                    String dbCorrect = rs.getString("answer_text");

                    if (dbCorrect == null || dbCorrect.isEmpty()) {
                        dbCorrect = rs.getString("correct_option");
                    }

                    if (dbCorrect != null) {
                        dbCorrect = normalize(dbCorrect);
                        isCorrect = userAnswer.equalsIgnoreCase(dbCorrect);
                    }
                }

                // ================= FILL =================
                else if ("fill".equalsIgnoreCase(type)) {

                    String dbCorrect = rs.getString("answer_text");

                    if (dbCorrect != null) {
                        dbCorrect = normalize(dbCorrect);
                        isCorrect = userAnswer.equalsIgnoreCase(dbCorrect);
                    }
                }

                if (isCorrect) correct++;
                else wrong++;
            }

            // ================= SCORE =================
            double percentage = (total == 0) ? 0 : (correct * 100.0 / total);

            // ================= STUDENT ID =================
            Integer studentId = (Integer) session.getAttribute("studentId");
            if (studentId == null) studentId = 1;

            // ================= INSERT RESULT =================
            PreparedStatement psInsert = con.prepareStatement(
                "INSERT INTO results(student_id, assessment_id, score, total_questions, percentage, correct, wrong, not_attempted) " +
                "VALUES(?,?,?,?,?,?,?,?)"
            );

            psInsert.setInt(1, studentId);
            psInsert.setInt(2, aid);
            psInsert.setDouble(3, percentage); // score = percentage
            psInsert.setInt(4, total);
            psInsert.setDouble(5, percentage);
            psInsert.setInt(6, correct);
            psInsert.setInt(7, wrong);
            psInsert.setInt(8, notAttempted);

            psInsert.executeUpdate();

            // ================= BADGE CALCULATION =================
            PreparedStatement psBadge = con.prepareStatement(
                "SELECT badge_name FROM badges WHERE min_percentage <= ? ORDER BY min_percentage DESC LIMIT 1"
            );

            psBadge.setDouble(1, percentage);

            ResultSet rsBadge = psBadge.executeQuery();

            String badge = "Bronze";

            if (rsBadge.next()) {
                badge = rsBadge.getString("badge_name");
            }

            rsBadge.close();
            psBadge.close();

            // ================= UPDATE STUDENT TABLE =================
            PreparedStatement psUpdate = con.prepareStatement(
                "UPDATE students SET badge=? WHERE student_id=?"
            );

            psUpdate.setString(1, badge);
            psUpdate.setInt(2, studentId);

            psUpdate.executeUpdate();
            psUpdate.close();

            // ================= SESSION UPDATE =================
            session.setAttribute("badge", badge);
            session.setAttribute("latestPercentage", percentage);

            // ================= SEND TO JSP =================
            request.setAttribute("score", percentage);
            request.setAttribute("correct", correct);
            request.setAttribute("wrong", wrong);
            request.setAttribute("notAttempted", notAttempted);
            request.setAttribute("percentage", percentage);

            request.getRequestDispatcher("result.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println(e.getMessage());
        }
    }

    private String normalize(String s) {
        if (s == null) return "";
        return s.trim()
                .replaceAll("\\s+", " ")
                .toLowerCase();
    }
}