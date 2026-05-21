package com.cheatsheet.controller;

import com.cheatsheet.config.DBconnect;
import com.cheatsheet.model.CheatSheet;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ViewCheatServlet")
public class ViewCheatServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Session စစ်ဆေးခြင်း (JSP ထဲတင်မကဘဲ Servlet ကနေပါ ကြိုစစ်ထားရင် ပိုစိပ်စပ်ပါတယ်)
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/DashboardServlet?error=InvalidId");
            return;
        }

        int id = Integer.parseInt(idStr);
        CheatSheet cheat = null;

        String sql = "SELECT * FROM cheatsheets WHERE sheet_id = ?";
        
        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    cheat = new CheatSheet();
                    cheat.setCheatSheetId(rs.getInt("sheet_id"));
                    cheat.setTitle(rs.getString("title"));
                    cheat.setContent(rs.getString("content"));
                    cheat.setImageUrl(rs.getString("image_url"));
                    cheat.setUpdatedAt(rs.getTimestamp("updated_at"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // 🎯 ပြင်ဆင်မှု - လမ်းကြောင်းကို အရှေ့က Slash (/) ခံပြီး သေချာညွှန်ပြခြင်း
        if (cheat != null) {
            request.setAttribute("cheat", cheat);
            // "/view_cheat.jsp" ဟု ရေးမှသာ Tomcat က JSP Lifecycle အတိုင်း အလုပ်လုပ်မှာ ဖြစ်ပါတယ်
            request.getRequestDispatcher("/view_cheat.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/DashboardServlet?error=NotFound");
        }
    }
}