package com.quizsystem.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.quizsystem.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")

public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");

        String email = request.getParameter("email");

        String password = request.getParameter("password");

        String role = request.getParameter("role");

        try {

            Connection con = DBConnection.getConnection();

            String query =
                    "INSERT INTO users(name,email,password,role) VALUES(?,?,?,?)";

            PreparedStatement ps = con.prepareStatement(query);

            ps.setString(1, name);

            ps.setString(2, email);

            ps.setString(3, password);

            ps.setString(4, role);

            ps.executeUpdate();

            response.sendRedirect("login.jsp");

        }

        catch (Exception e) {

            e.printStackTrace();

        }

    }

}