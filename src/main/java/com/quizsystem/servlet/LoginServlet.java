package com.quizsystem.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.quizsystem.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // Get form values
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        response.setContentType("text/html");

        try {
            Connection con = DBConnection.getConnection();

            String sql = "SELECT * FROM users WHERE username=? AND password=? AND role=?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, role);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                // Create session
                HttpSession session = request.getSession();
                session.setAttribute("userId", rs.getInt("id"));
                session.setAttribute("username", rs.getString("username"));
                session.setAttribute("role", rs.getString("role"));

                String dbRole = rs.getString("role");

                // Redirect based on role
                switch (dbRole.toLowerCase()) {

                    case "admin":
                        response.sendRedirect("adminDashboard.jsp");
                        break;

                    case "faculty":
                        response.sendRedirect("facultyDashboard.jsp");
                        break;

                    case "student":

                        int userId = rs.getInt("id");

                        PreparedStatement ps2 = con.prepareStatement(
                            "SELECT * FROM students WHERE user_id=?"
                        );

                        ps2.setInt(1, userId);

                        ResultSet rs2 = ps2.executeQuery();

                        if(rs2.next()){

                            int studentId = rs2.getInt("student_id");

                            session.setAttribute("studentId", studentId);
                            session.setAttribute("level",
                                    rs2.getString("level"));
                            session.setAttribute("badge",
                                    rs2.getString("badge"));

                            System.out.println("User ID = " + userId);
                            System.out.println("Student ID = " + studentId);
                            System.out.println("Level = " +
                                    rs2.getString("level"));
                            System.out.println("Badge = " +
                                    rs2.getString("badge"));

                        }else{

                            System.out.println(
                                "No student record found for user_id = "
                                + userId
                            );
                        }

                        rs2.close();
                        ps2.close();

                        response.sendRedirect("studentDashboard.jsp");
                        break;

                    default:
                        response.sendRedirect("login.jsp");
                        break;
                }

            } else {

                response.getWriter().println(
                    "<h3 style='color:red;text-align:center;'>Invalid Username / Password / Role</h3>"
                );

            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();

            response.getWriter().println(
                "<h3 style='color:red;text-align:center;'>Database Error Occurred</h3>"
            );
        }
    }
}