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

public class RemoveStudentServlet extends HttpServlet {

    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)

            throws ServletException, IOException {

        try {

            System.out.println(
            "RemoveStudentServlet called"
            );

            int studentId = Integer.parseInt(

            request.getParameter(
            "studentId"
            )

            );

            Connection con =

            DBConnection.getConnection();

            // Get user id

            PreparedStatement ps1 =

            con.prepareStatement(

            "SELECT user_id FROM students WHERE student_id=?"

            );

            ps1.setInt(
            1,
            studentId
            );

            ResultSet rs =

            ps1.executeQuery();

            int userId = 0;

            if(rs.next()){

                userId =

                rs.getInt(
                "user_id"
                );

            }

            // If student does not exist

            if(userId == 0){

                response.sendRedirect(

                "manageStudents.jsp?msg=Student%20not%20found"

                );

                return;

            }

            // Get student name

            String studentName = "";

            PreparedStatement ps2 =

            con.prepareStatement(

            "SELECT username FROM users WHERE id=?"

            );

            ps2.setInt(
            1,
            userId
            );

            ResultSet rs2 =

            ps2.executeQuery();

            if(rs2.next()){

                studentName =

                rs2.getString(
                "username"
                );

            }

            // Delete from students table

            PreparedStatement ps3 =

            con.prepareStatement(

            "DELETE FROM students WHERE student_id=?"

            );

            ps3.setInt(
            1,
            studentId
            );

            ps3.executeUpdate();

            // Delete from users table

            PreparedStatement ps4 =

            con.prepareStatement(

            "DELETE FROM users WHERE id=?"

            );

            ps4.setInt(
            1,
            userId
            );

            ps4.executeUpdate();

            rs.close();

            rs2.close();

            ps1.close();

            ps2.close();

            ps3.close();

            ps4.close();

            con.close();

            response.sendRedirect(

            "manageStudents.jsp?msg=" +

            studentName +

            "%20removed%20successfully"

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