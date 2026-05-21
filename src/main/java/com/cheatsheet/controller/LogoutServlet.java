package com.cheatsheet.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        String username = "User";
        
        if (session != null) {
            if (session.getAttribute("username") != null) {
                username = (String) session.getAttribute("username");
            }
            // 🚀 Session ကို ဖျက်ချလိုက်ပြီ
            session.invalidate(); 
        }
        
        // 🚀 နှုတ်ဆက်တဲ့ Page ဆီကို နာမည်ပါ ပါးလိုက်မယ်
        response.sendRedirect(request.getContextPath() + "/logout_goodbye.jsp?name=" + java.net.URLEncoder.encode(username, "UTF-8"));
    }
}