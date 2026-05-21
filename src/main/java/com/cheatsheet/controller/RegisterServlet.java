package com.cheatsheet.controller;

import com.cheatsheet.model.User;
import com.cheatsheet.repository.UserRepository;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private UserRepository userRepository = new UserRepository();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // ၁။ Encoding သတ်မှတ်ခြင်း (မြန်မာစာအတွက်)
        request.setCharacterEncoding("UTF-8");

        // ၂။ Form မှ Data များရယူခြင်း
        String username = request.getParameter("username");
        String plainPassword = request.getParameter("password");

        // ၃။ Password ကို BCrypt ဖြင့် Hash လုပ်ခြင်း
        // gensalt() သည် random salt တစ်ခုကို အလိုအလျောက် ထည့်ပေးပါသည်
        String hashedPassword = BCrypt.hashpw(plainPassword, BCrypt.gensalt());

        // ၄။ User Object တည်ဆောက်ပြီး Data ထည့်သွင်းခြင်း
        User user = new User();
        user.setUsername(username);
        user.setPasswordHash(hashedPassword); 
        
        // အရေးကြီးသည်- Register လုပ်သူတိုင်းကို "user" role သာ ပေးခြင်း
        user.setRole("user"); 

        // ၅။ UserRepository မှတစ်ဆင့် Database ထဲသို့ သိမ်းဆည်းခြင်း
        boolean isSaved = userRepository.save(user);

        // ၆။ အောင်မြင်မှုအပေါ် မူတည်ပြီး လမ်းကြောင်းပြောင်းခြင်း
        if (isSaved) {
            // Register အောင်မြင်လျှင် Login Page သို့ ပို့မည်
            response.sendRedirect("login.jsp?msg=register_success");
        } else {
            // မအောင်မြင်လျှင် Error နှင့်အတူ Register Page မှာပဲ ပြန်ထားမည်
            response.sendRedirect("register.jsp?error=fail");
        }
    }
}