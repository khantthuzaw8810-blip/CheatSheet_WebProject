package com.cheatsheet.controller;

import com.cheatsheet.model.QualityControlDTO;
import com.cheatsheet.repository.QualityControlRepository;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/QualityControlServlet")
public class QualityControlServlet extends HttpServlet {
    private QualityControlRepository repo = new QualityControlRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Fetch pending quality control verification payloads via targeted DTO lists
        List<QualityControlDTO> progList = repo.getPendingQCList("Programming");
        List<QualityControlDTO> eduList = repo.getPendingQCList("Education");

        // 2. Bind collection records to request scope properties
        request.setAttribute("progList", progList);
        request.setAttribute("eduList", eduList);
        
        // 3. Set the active sidebar state token for quality control view navigation
        request.setAttribute("activePage", "qc");
        
        // 4. Dispatch the structured lifecycle states to the display layer
        request.getRequestDispatcher("quality_control.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Extract core routing keys and action targets from payload
            int id = Integer.parseInt(request.getParameter("postId"));
            String action = request.getParameter("action");
            String type = request.getParameter("type");
            
            // Execute approval or rejection transactional switch workflow
            repo.updateStatus(id, action, type);
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        // Redirect execution loop back to primary service interface
        response.sendRedirect("QualityControlServlet");
    }
}