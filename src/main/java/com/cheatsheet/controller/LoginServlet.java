package com.cheatsheet.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

import com.cheatsheet.model.User;
import com.cheatsheet.repository.UserRepository;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private UserRepository userRepository = new UserRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String loginPass = request.getParameter("password");
        HttpSession session = request.getSession();

        // 1. Account Lock Check (Security) - ၅ ခါမှားလို့ ပိတ်ထားရင် စစ်ဆေးသည့်အပိုင်း
        Long lockTime = (Long) session.getAttribute("lockTime");
        if (lockTime != null && System.currentTimeMillis() < lockTime) {
            long remain = (lockTime - System.currentTimeMillis()) / 1000 / 60;
            response.sendRedirect("login.jsp?error=StillLocked&min=" + (remain + 1));
            return;
        }

        // 2. Fetch User from Database
        User user = userRepository.findByUsername(username);

        if (user == null) {
            request.setAttribute("error", "User not found. Please register first! ❌");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // 3. 🔥 Password Validation & Hash Match Verification (Console မှာ ပါဝင်ပြသမည်)
        boolean match = false;
        
        System.out.println("============= [LOGIN ATTEMPT VERIFICATION] =============");
        System.out.println("Attempting Login for User: " + username);
        System.out.println("Input Password: " + loginPass);
        System.out.println("Stored Hash in DB: " + user.getPasswordHash());

        // BCrypt ဖြင့် ရိုက်နှိပ်လိုက်သော စကားဝှက်နှင့် DB ထဲက Hash တန်ဖိုးအား အစစ်အမှန် တိုက်စစ်ခြင်း
        if (BCrypt.checkpw(loginPass, user.getPasswordHash())) {
            match = true;
            System.out.println("Verification Result: MATCH SUCCESS ✅");
        } else {
            System.out.println("Verification Result: MATCH FAILED ❌ (Password Incorrect)");
        }
        System.out.println("=======================================================");

        // 4. Successful Password Match Handling
        if (match) {
            // Blocks access if the account status is "BANNED"
            if (user.getStatus() != null && user.getStatus().toString().equalsIgnoreCase("BANNED")) {
                request.setAttribute("error", "Your account is banned and cannot access the system. ❌");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            // Reset attempts on successful login
            session.setAttribute("attempts", 0);
            session.removeAttribute("lockTime");
            
            // Populate Session Data
            session.setAttribute("user_id", user.getUserId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());
            session.setAttribute("lastLogin", new java.util.Date());
            session.setAttribute("adminName", user.getUsername()); 

            // Role-Based Redirection
            String role = user.getRole();                                                    
            if (role != null && role.equalsIgnoreCase("admin")) {
                response.sendRedirect("AdminServlet"); 
            } else {
                response.sendRedirect("DashboardServlet");
            }

        } else {
            // 5. 🛑 Failed Attempt Logic (၅ ကြိမ်သာ အခွင့်အရေးပေးပြီး ပိတ်ပစ်မည့် Anti-Brute Force စနစ်)
            Integer attempts = (Integer) session.getAttribute("attempts");
            if (attempts == null) attempts = 0;
            attempts++;
            session.setAttribute("attempts", attempts);

            if (attempts >= 5) {
                // ၅ ကြိမ်ထက်ကျော်ပါက ၅ မိနစ် အကောင့်ပိတ်ပစ်မည်
                session.setAttribute("lockTime", System.currentTimeMillis() + (5 * 60 * 1000));
                System.out.println("ALERT: User " + username + " has been LOCKED due to 5 failed attempts.");
                response.sendRedirect("login.jsp?error=Locked");
            } else {
                request.setAttribute("error", "Password incorrect ❌ (Remaining Attempts: " + (5 - attempts) + ")");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        }
    }
}