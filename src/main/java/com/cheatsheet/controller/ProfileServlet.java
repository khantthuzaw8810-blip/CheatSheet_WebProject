package com.cheatsheet.controller;

import com.cheatsheet.model.User;
import com.cheatsheet.repository.UserRepository;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/ProfileServlet"})
public class ProfileServlet extends HttpServlet {
    private UserRepository userRepo = new UserRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        request.setAttribute("activePage", "settings");
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String username = (String) session.getAttribute("username");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        request.setAttribute("activePage", "settings");

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "New passwords do not match!");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }

        User currentUser = userRepo.findByUsername(username);

        // Current Password မှန်၊ မမှန် အရင်စစ်မယ်
        if (currentUser == null || !BCrypt.checkpw(currentPassword, currentUser.getPasswordHash())) {
            request.setAttribute("error", "Incorrect current password!");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }

        // 🔥 စကားဝှက်အသစ်ကို BCrypt ဖြင့် Hash အသစ် ပြောင်းလဲခြင်း
        String newPasswordHash = BCrypt.hashpw(newPassword, BCrypt.gensalt(10));
        
        // Database ထဲက မူရင်း Hash နေရာမှာ အသစ်စက်စက် သွားအစားထိုးသိမ်းဆည်းလိုက်ခြင်း
        boolean success = userRepo.updatePassword(currentUser.getUserId(), newPasswordHash);
        
        if (success) {
            // 📝 [Console Output] Password အသစ်ပြောင်းသွားတာကို Console မှာ ပြသခြင်း
            System.out.println("==================================================");
            System.out.println("[CONSOLE LOG] Password successfully updated!");
            System.out.println("User: " + username);
            System.out.println("New Plain Password: " + newPassword);
            System.out.println("New Hash stored in DB: " + newPasswordHash);
            System.out.println("==================================================");
            
            // 🎯 Login Form သို့မသွားတော့ဘဲ Admin Dashboard (AdminServlet) သို့ တိုက်ရိုက် ပြန်မောင်းနှင်ခြင်း
            response.sendRedirect("AdminServlet");
            return;
        } else {
            request.setAttribute("error", "Database error occurred while updating password.");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        }
    } 
}