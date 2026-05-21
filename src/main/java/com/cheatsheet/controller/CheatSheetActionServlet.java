package com.cheatsheet.controller;

import com.cheatsheet.config.DBconnect;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/CheatSheetActionServlet")
public class CheatSheetActionServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String idRaw = request.getParameter("id");
        
        if ("approve".equals(action) && idRaw != null && !idRaw.isEmpty()) {
            int sheetId = Integer.parseInt(idRaw);
            
            // Database ထဲတွင် Status ကို APPROVED ပြောင်းမည့် SQL Query
            String sql = "UPDATE cheatsheets SET status = 'approved', updated_at = NOW() WHERE sheet_id = ?";
            
            try (Connection conn = DBconnect.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {
                
                stmt.setInt(1, sheetId);
                stmt.executeUpdate();
                
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        // လုပ်ဆောင်ပြီးပါက Dashboard List ဆီသို့ ပြန်လည်လမ်းကြောင်းလွှဲခြင်း
        response.sendRedirect(request.getContextPath() + "/CheatSheetListServlet");
    }
}