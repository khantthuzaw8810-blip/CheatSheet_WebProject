<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.cheatsheet.model.AdminUser" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>CheatSheet | Command Center</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #3b82f6;
            --bg: #f8fafc;
            --sidebar: #1e293b;
            --card: #ffffff;
            --text-main: #1e293b;
            --text-sub: #64748b;
            --success: #22c55e;
            --danger: #ef4444;
        }

        body { display: flex; margin: 0; font-family: 'Inter', sans-serif; background: var(--bg); color: var(--text-main); }
        
        /* Sidebar Styles */
        .sidebar { width: 260px; height: 100vh; background: var(--sidebar); color: white; position: fixed; }
        .sidebar-brand { padding: 30px; font-size: 22px; font-weight: bold; }
        .sidebar-brand span { color: var(--primary); }
        .nav-links { list-style: none; padding: 20px; }
        .nav-link { 
            display: flex; align-items: center; gap: 15px; padding: 12px;
            color: #94a3b8; text-decoration: none; border-radius: 8px; transition: 0.3s;
        }
        .nav-link.active, .nav-link:hover { background: #334155; color: white; }

        /* Main Content */
        .content { margin-left: 260px; width: 100%; padding: 40px; }
        
        /* Search Section */
        .control-panel { 
            background: var(--card); padding: 20px; border-radius: 15px; 
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 30px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
        }
        .search-box { position: relative; width: 350px; }
        .search-box input { 
            width: 100%; padding: 12px 40px; border: 1px solid #e2e8f0; 
            border-radius: 10px; outline: none; font-size: 14px;
        }
        .search-box i { position: absolute; left: 15px; top: 14px; color: var(--text-sub); }

        /* Professional Table */
        .table-container { background: var(--card); border-radius: 15px; overflow: hidden; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); }
        .member-table { width: 100%; border-collapse: collapse; }
        .member-table th { background: #f1f5f9; padding: 15px; text-align: left; font-size: 12px; text-transform: uppercase; color: var(--text-sub); }
        .member-table td { padding: 15px; border-bottom: 1px solid #f1f5f9; font-size: 14px; }
        
        /* Badges & Buttons */
        .status-badge { padding: 5px 12px; border-radius: 20px; font-size: 11px; font-weight: bold; }
        .active-bg { background: #dcfce7; color: #15803d; }
        .banned-bg { background: #fee2e2; color: #b91c1c; }
        
        .action-btn { 
            padding: 8px 15px; border-radius: 8px; border: none; cursor: pointer;
            font-weight: 600; font-size: 12px; transition: 0.2s;
        }
        .ban-btn { background: #fef2f2; color: var(--danger); }
        .ban-btn:hover { background: var(--danger); color: white; }
        .unban-btn { background: #f0fdf4; color: var(--success); }
        .unban-btn:hover { background: var(--success); color: white; }
    </style>
</head>
<body>

    <aside class="sidebar">
        <div class="sidebar-brand">Command<span>Center</span></div>
        <ul class="nav-links">
            <li><a href="AdminServlet" class="nav-link"><i class="fa-solid fa-gauge"></i> Dashboard</a></li>
            <li><a href="UserManagementServlet" class="nav-link active"><i class="fa-solid fa-users-gear"></i> Member Registry</a></li>
            <li><a href="LogoutServlet" class="nav-link"><i class="fa-solid fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </aside>

    <main class="content">
        <header style="margin-bottom: 30px;">
            <h1 style="font-size: 28px;">Member Registry</h1>
            <p style="color: var(--text-sub);">Manage system access and monitor user activity.</p>
        </header>

        <div class="control-panel">
            <form action="UserManagementServlet" method="get" class="search-box">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" name="search" placeholder="Search by username or email..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
            </form>
            <div class="filters">
                <span style="font-size: 14px; color: var(--text-sub);">Sort by: <b>Newest Members</b></span>
            </div>
        </div>

        <div class="table-container">
            <table class="member-table">
                <thead>
                    <tr>
                        <th>Member Details</th>
                        <th>Role</th>
                        <th>Account Status</th>
                        <th style="text-align: right;">Operational Control</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<AdminUser> users = (List<AdminUser>) request.getAttribute("userList");
                        if (users != null && !users.isEmpty()) {
                            for (AdminUser u : users) {
                    %>
                    <tr>
                        <td>
                            <div style="display: flex; align-items: center; gap: 12px;">
                                <div style="width: 40px; height: 40px; background: #e2e8f0; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; color: var(--primary);">
                                    <%= u.getUsername().substring(0, 1).toUpperCase() %>
                                </div>
                                <div>
                                    <div style="font-weight: bold;"><%= u.getUsername() %></div>
                                    <div style="font-size: 12px; color: var(--text-sub);">ID: #<%= u.getUserId() %></div>
                                </div>
                            </div>
                        </td>
                        <td><span style="text-transform: capitalize;"><%= u.getRole() %></span></td>
                        <td>
                            <span class="status-badge <%= "active".equals(u.getStatus()) ? "active-bg" : "banned-bg" %>">
                                <i class="fa-solid <%= "active".equals(u.getStatus()) ? "fa-check-circle" : "fa-ban" %>"></i>
                                <%= u.getStatus().toUpperCase() %>
                            </span>
                        </td>
                        <td style="text-align: right;">
                            <% if (!"admin".equalsIgnoreCase(u.getRole())) { %>
                                <form action="UserManagementServlet" method="post" style="display: inline;">
                                    <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                    <input type="hidden" name="newStatus" value="<%= "active".equals(u.getStatus()) ? "banned" : "active" %>">
                                    <button type="submit" class="action-btn <%= "active".equals(u.getStatus()) ? "ban-btn" : "unban-btn" %>">
                                        <%= "active".equals(u.getStatus()) ? "Restrict Access" : "Restore Access" %>
                                    </button>
                                </form>
                            <% } else { %>
                                <span style="font-size: 12px; color: var(--text-sub); font-style: italic;">Protected</span>
                            <% } %>
                        </td>
                    </tr>
                    <% 
                            }
                        } else { 
                    %>
                    <tr>
                        <td colspan="4" style="text-align: center; padding: 50px; color: var(--text-sub);">
                            No members found matching your search.
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </main>

</body>
</html>