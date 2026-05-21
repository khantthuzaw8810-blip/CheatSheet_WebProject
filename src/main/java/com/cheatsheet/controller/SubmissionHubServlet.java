package com.cheatsheet.controller;

import com.cheatsheet.repository.QualityControlRepository;
import com.cheatsheet.model.QualityControlDTO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/SubmissionHubServlet")
public class SubmissionHubServlet extends HttpServlet {
    private QualityControlRepository qcRepository = new QualityControlRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect("login.jsp?error=unauthorized");
            return;
        }

        // ၁။ Sidebar Active link token သတ်မှတ်ခြင်း
        request.setAttribute("activeTab", "submission-hub");

        try {
            // ၂။ QualityControlRepository တစ်ခုတည်းကနေ Table နှစ်ခုလုံးရဲ့ APPROVED စာရင်းကို ဆွဲယူခြင်း
            List<QualityControlDTO> approvedEduList = qcRepository.getAllApprovedEducation(); 
            List<QualityControlDTO> approvedProgList = qcRepository.getAllApprovedCheatsheets(); 
            
            // Request Scope ထဲသို့ Attribute ပို့ဆောင်ခြင်း
            request.setAttribute("approvedEduList", approvedEduList);
            request.setAttribute("approvedProgList", approvedProgList);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // ၃။ Sidebar Navigation alignment အတွက် token သတ်မှတ်ခြင်း
        request.setAttribute("activePage", "hub");
        
        // ၄။ ရရှိလာတဲ့ ဒေတာတွေကို View Layer (JSP) ဆီ ပို့ဆောင်ခြင်း
        request.getRequestDispatcher("submission-hub.jsp").forward(request, response);
    }
}