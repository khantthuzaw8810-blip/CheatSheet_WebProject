package com.cheatsheet.controller;

import com.cheatsheet.model.Education;
import com.cheatsheet.repository.EducationRepository;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/EducationAction")
public class EducationActionServlet extends HttpServlet {
    private EducationRepository repository = new EducationRepository();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");

        if (action != null && idStr != null) {
            int id = Integer.parseInt(idStr);
            if ("delete".equals(action)) {
                repository.delete(id);
                response.sendRedirect("EducationList");
            } else if ("edit".equals(action)) {
                Education edu = repository.getById(id);
                request.setAttribute("education", edu);
                // ပြင်ဆင်ဖို့အတွက် Form page ဆီ ပို့မယ်
                request.getRequestDispatcher("edit-education.jsp").forward(request, response);
            }
        }
    }
}