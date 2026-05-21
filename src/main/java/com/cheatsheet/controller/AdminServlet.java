package com.cheatsheet.controller;

import com.cheatsheet.service.AdminService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    private final AdminService adminService = new AdminService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // 1. Retrieve statistical counter data from database metrics
            int totalUsers = adminService.getTotalUsersCount(); 
            int totalSheets = adminService.getTotalSheetsCount();
            int bannedUsers = adminService.getBannedUsersCount();

            // 2. Bind metric values to request scope attributes
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalSheets", totalSheets);
            request.setAttribute("bannedUsers", bannedUsers);

            // 3. Fetch comprehensive user list via search query fallback
            request.setAttribute("userList", adminService.searchUsers(null));
            
            // 4. Set the active sidebar state token for navigation synchronization
            request.setAttribute("activePage", "dashboard");
            
            // 5. Forward state context to the dashboard view layer
            request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}