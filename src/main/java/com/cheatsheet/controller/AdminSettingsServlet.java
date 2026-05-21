package com.cheatsheet.controller;

import com.cheatsheet.repository.UserRepository;
import org.mindrot.jbcrypt.BCrypt; // BCrypt library ကို import လုပ်ထားပါ

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/AdminSettingsServlet")
public class AdminSettingsServlet extends HttpServlet {
    private UserRepository repo = new UserRepository();

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String action = req.getParameter("action");
        HttpSession session = req.getSession();
        Integer userId = (Integer) session.getAttribute("userId"); // Login ချိန်မှာ သိမ်းခဲ့တဲ့ ID

        if (userId == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        if ("updateProfile".equals(action)) {
            String newName = req.getParameter("username");
            repo.updateUsername(userId, newName);
        } 
        else if ("changePassword".equals(action)) {
            String newPass = req.getParameter("newPassword");
            
            // Password ကို BCrypt ဖြင့် Hash လုပ်ခြင်း (မူလ logic ကို မထိခိုက်စေဘဲ ပေါင်းထည့်ခြင်း)
            String hashedPw = BCrypt.hashpw(newPass, BCrypt.gensalt());
            
            // Hash လုပ်ထားသော password ကို repository သို့ ပေးပို့သိမ်းဆည်းခြင်း
            repo.updatePassword(userId, hashedPw); 
        }

        // DashboardServlet ဆီသို့ ပြန်ညွှန်းခြင်း (သို့မဟုတ် မူလအတိုင်း settings.jsp သို့ သွားခြင်း)
        resp.sendRedirect("success.jsp?status=success");
    }
}