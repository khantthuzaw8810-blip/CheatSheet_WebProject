package com.cheatsheet.controller;

import com.cheatsheet.config.DBconnect;
import com.cheatsheet.model.CheatSheet;
import com.cheatsheet.repository.CheatSheetRepository;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/CheatSheetListServlet")
public class CheatSheetListServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // UTF-8 သတ်မှတ်ခြင်း
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try (Connection conn = DBconnect.getConnection()) {
            CheatSheetRepository repo = new CheatSheetRepository(conn);
            
            // ၁။ ဒေတာအားလုံးကို ရှာယူခြင်း
            List<CheatSheet> sheets = repo.findAll(); 

            // ၂။ JSP သို့ ပို့ရန် Attribute ထည့်ခြင်း
            request.setAttribute("cheatSheets", sheets);
            
            // ၃။ JSP သို့ Forward လုပ်ခြင်း (Try ထဲမှာပဲ တစ်ခါတည်း လုပ်ပါ)
            request.getRequestDispatcher("/cheatsheet_list.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            
            // Error ဖြစ်ခဲ့ရင် User ကို Error Message ပြရန်
            request.setAttribute("errorMessage", "Database Error: " + e.getMessage());
            
            // error.jsp ဖိုင် တကယ်ရှိတဲ့ လမ်းကြောင်းကို စစ်ဆေးပါ (ဥပမာ- /error.jsp)
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}