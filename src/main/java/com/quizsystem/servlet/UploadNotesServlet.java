package com.quizsystem.servlet;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.quizsystem.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@MultipartConfig
public class UploadNotesServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String subject = request.getParameter("subject");
        Part filePart = request.getPart("file");

        String fileName = filePart.getSubmittedFileName();

        // folder where files will be saved
        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";

        File dir = new File(uploadPath);
        if (!dir.exists()) {
            dir.mkdir();
        }

        String filePath = uploadPath + File.separator + fileName;

        filePart.write(filePath);

        try {
        	try {

        		Connection con = DBConnection.getConnection();

        		String sql =
        		"INSERT INTO notes(subject,file_name,file_path) VALUES(?,?,?)";

        		PreparedStatement ps =
        		con.prepareStatement(sql);

        		ps.setString(1, subject);

        		ps.setString(2, fileName);

        		ps.setString(3, "uploads/" + fileName);

        		ps.executeUpdate();

        		ps.close();

        		con.close();

        		response.sendRedirect("facultyDashboard.jsp");

        		}

        		catch(Exception e){

        		e.printStackTrace();

        		response.getWriter().println(
        		"Upload failed : " + e.getMessage()
        		);

        		}

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Upload failed: " + e.getMessage());
        }
    }
}