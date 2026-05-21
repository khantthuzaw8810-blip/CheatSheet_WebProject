package com.cheatsheet.controller;

import com.cheatsheet.config.DBconnect;
import com.cheatsheet.model.Education;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ViewEducationServlet")
public class ViewEducationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/EducationList?error=InvalidId");
            return;
        }

        int id = Integer.parseInt(idStr);
        Education edu = null;

        String sql = "SELECT * FROM education WHERE id = ?"; 
        
        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    edu = new Education();
                    edu.setId(rs.getInt("id"));
                    edu.setTitle(rs.getString("title"));
                    edu.setDescription(rs.getString("description"));
                    edu.setCategory(rs.getString("category"));
                    edu.setImageUrl(rs.getString("image_url"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        if (edu != null) {
            request.setAttribute("education", edu);
            // Forward directly using the correct relative path from the webapp root
            request.getRequestDispatcher("/view_education.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/EducationList?error=NotFound");
        }
    }
}