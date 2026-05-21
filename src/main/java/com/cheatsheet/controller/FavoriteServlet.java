package com.cheatsheet.controller;

import com.cheatsheet.repository.EducationRepository;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/FavoriteServlet")
public class FavoriteServlet extends HttpServlet {
    private EducationRepository repo = new EducationRepository();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(401);
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");
        String idStr = request.getParameter("id");
        String type = request.getParameter("type");

        if (idStr != null && type != null) {
            try {
                int contentId = Integer.parseInt(idStr);
                boolean success = repo.toggleGeneralFavorite(userId, contentId, type);
                
                if (success) {
                    response.setStatus(200);
                    response.getWriter().write("success");
                } else {
                    response.setStatus(500);
                }
                return;
            } catch (Exception e) { e.printStackTrace(); }
        }
        response.setStatus(400);
    }
}