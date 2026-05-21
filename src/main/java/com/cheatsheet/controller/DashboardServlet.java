package com.cheatsheet.controller;

import com.cheatsheet.config.DBconnect;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int cheatCount = 0;
        int categoryCount = 0;

        try (Connection conn = DBconnect.getConnection()) {
            // Cheat sheets အရေအတွက် တွက်ချက်ခြင်း
            Statement stmt1 = conn.createStatement();
            ResultSet rs1 = stmt1.executeQuery("SELECT COUNT(*) AS total FROM cheatsheets");
            if (rs1.next()) cheatCount = rs1.getInt("total");

            // Categories အရေအတွက် တွက်ချက်ခြင်း
            Statement stmt2 = conn.createStatement();
            ResultSet rs2 = stmt2.executeQuery("SELECT COUNT(*) AS total FROM categories");
            if (rs2.next()) categoryCount = rs2.getInt("total");

        } catch (Exception e) {
            e.printStackTrace();
        }

        // ⚠️ session ထဲမှာ သေချာ ထည့်ပါ
        HttpSession session = request.getSession();
        session.setAttribute("cheatCount", cheatCount);
        session.setAttribute("categoryCount", categoryCount);

        // success.jsp ကို redirect လုပ်ပါ
        response.sendRedirect("success.jsp");
    }
}