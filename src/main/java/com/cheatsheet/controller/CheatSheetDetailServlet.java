package com.cheatsheet.controller;

import com.cheatsheet.config.DBconnect;
import com.cheatsheet.model.CheatSheet;
import com.cheatsheet.repository.CheatSheetRepository;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;

@WebServlet("/CheatSheetDetailServlet")
public class CheatSheetDetailServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        //id parameter ရှိ/မရှိ စစ်ဆေးခြင်း
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            request.setAttribute("errorMessage", "Missing id parameter");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        try {
            int id = Integer.parseInt(idParam);

            try (Connection conn = DBconnect.getConnection()) {
                CheatSheetRepository repo = new CheatSheetRepository(conn);
                CheatSheet sheet = repo.findById(id);

                // sheet null ဖြစ်ရင် error page သို့
                if (sheet == null) {
                    request.setAttribute("errorMessage", "Cheat sheet not found for id: " + id);
                    request.getRequestDispatcher("/error.jsp").forward(request, response);
                    return;
                }

                // JSP သို့ sheet object ပို့ခြင်း
                request.setAttribute("sheet", sheet);

                // <-- ဒီနေရာမှာ forward လုပ်ပါ (absolute path to JSP)
                request.getRequestDispatcher("/cheatsheet_detail.jsp")
                       .forward(request, response);
            }

        } catch (NumberFormatException nfe) {
            request.setAttribute("errorMessage", "Invalid id parameter");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
