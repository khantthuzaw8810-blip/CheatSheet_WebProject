package com.cheatsheet.controller;

import java.io.IOException;
import java.sql.Connection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.cheatsheet.config.DBconnect;
import com.cheatsheet.model.Category;
import com.cheatsheet.repository.CategoryRepository;

@WebServlet("/CategoryServlet")
public class CategoryServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String name = request.getParameter("name");

        try (Connection conn = DBconnect.getConnection()) {
            CategoryRepository repo = new CategoryRepository(conn);

            if ("add".equals(action)) {
                Category c = new Category();
                c.setName(name);
                repo.insert(c);

                // ✅ Insert ပြီးရင် DashboardServlet ကို redirect
                response.sendRedirect("DashboardServlet");

            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Category c = new Category();
                c.setCategoryId(id);
                c.setName(name);
                repo.update(c);

                // ✅ Update ပြီးရင် DashboardServlet ကို redirect
                response.sendRedirect("DashboardServlet");

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                repo.delete(id);

                // ✅ Delete ပြီးရင် DashboardServlet ကို redirect
                response.sendRedirect("DashboardServlet");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error processing category: " + e.getMessage());
        }
    }
}
