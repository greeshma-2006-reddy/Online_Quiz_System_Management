package com.quizsystem.servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class StartTestServlet extends HttpServlet {

protected void doPost(
        HttpServletRequest request,
        HttpServletResponse response)
        throws ServletException, IOException {
	request.getSession().removeAttribute("mockQuestions");
    String assessmentId =
            request.getParameter("assessmentId");

    request.getSession().setAttribute(
            "assessmentId",
            Integer.parseInt(assessmentId));

    request.getRequestDispatcher(
            "takeTest.jsp")
            .forward(request, response);
}

protected void doGet(
        HttpServletRequest request,
        HttpServletResponse response)
        throws ServletException, IOException {

    doPost(request, response);
}

}