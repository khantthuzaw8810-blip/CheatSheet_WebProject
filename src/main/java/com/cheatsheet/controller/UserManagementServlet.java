package com.cheatsheet.controller;

import com.cheatsheet.model.AdminUser;
import com.cheatsheet.service.AdminService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/UserManagementServlet")
public class UserManagementServlet extends HttpServlet {
    private final AdminService adminService = new AdminService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Extract search parameter query string
        String search = request.getParameter("search"); 
        List<AdminUser> list;
        
        // 2. Query filtered user management data listings via service layer
        list = adminService.searchUsers(search); 
        
        // 3. Set the active sidebar state token for command center view alignment
        request.setAttribute("activePage", "command");
        
        // 4. Bind results context to request scope and dispatch to view template
        request.setAttribute("userList", list);
        request.getRequestDispatcher("command_center.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Extract unique identity and target access modifier values
            int id = Integer.parseInt(request.getParameter("userId"));
            String status = request.getParameter("newStatus");
            
            // Execute lifecycle modification through internal persistence logic
            adminService.updateUserStatus(id, status);
          
            // Return validation redirect sequence carrying update transaction parameters
            response.sendRedirect("UserManagementServlet?success=updated"); 
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("UserManagementServlet?error=failed");
        }
    }
}