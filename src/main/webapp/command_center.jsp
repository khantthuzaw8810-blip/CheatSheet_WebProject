<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.cheatsheet.model.AdminUser" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>CheatSheet | Command Center</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #6366f1;
            --content-bg: #f8fafc;
            --card-white: #ffffff;
            --text-slate: #64748b;
            --text-dark: #1e293b;
            --border-color: #e2e8f0;
        }

        body { 
            display: flex; 
            margin: 0; 
            font-family: 'Plus Jakarta Sans', sans-serif; 
            background: var(--content-bg); 
            color: var(--text-dark); 
        }

        /* Main Area Margin ညှိခြင်း */
        .main { 
            margin-left: 280px; /* Sidebar အကျယ်အတိုင်း တွန်းထားရန် */
            width: calc(100% - 280px); 
            padding: 45px; 
            box-sizing: border-box; 
            min-height: 100vh;
        }

        .header-flex { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 35px; }
        .header-title h1 { font-size: 32px; font-weight: 800; margin: 0; }
        .header-title p { color: var(--text-slate); margin-top: 8px; }

        /* Search Box */
        .search-box { position: relative; width: 350px; }
        .search-box input { 
            width: 100%; padding: 14px 15px 14px 45px; 
            border: 1px solid var(--border-color); 
            border-radius: 14px; outline: none; 
            background: var(--card-white);
        }
        .search-box i { position: absolute; left: 18px; top: 16px; color: var(--text-slate); }

        /* Table Design */
        .table-container { 
            background: var(--card-white); 
            border-radius: 24px; 
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.02); 
            border: 1px solid var(--border-color); 
            overflow: hidden; 
        }
        .premium-table { width: 100%; border-collapse: collapse; }
        .premium-table th { 
            background: #f1f5f9; padding: 20px 24px; text-align: left;
            font-size: 12px; font-weight: 700; color: var(--text-slate); 
            text-transform: uppercase; letter-spacing: 1px;
        }
        .premium-table td { padding: 20px 24px; border-bottom: 1px solid var(--border-color); font-size: 14px; }

        .status-pill { padding: 6px 12px; border-radius: 10px; font-size: 12px; font-weight: 700; }
        .status-active { background: #dcfce7; color: #166534; }
        .status-banned { background: #fee2e2; color: #991b1b; }

        .btn-action { 
            padding: 10px 18px; border-radius: 12px; font-size: 13px; 
            font-weight: 700; border: none; cursor: pointer; transition: 0.2s;
        }
        .btn-ban { background: #fef2f2; color: #ef4444; }
        .btn-unban { background: #f0fdf4; color: #22c55e; }
    </style>
</head>
<body>

    <jsp:include page="admin_sidebar.jsp">
        <jsp:param name="activePage" value="command" />
    </jsp:include>

    <main class="main">
        <div class="header-flex">
            <div class="header-title">
                <h1>Command Center</h1>
                <p>Manage community members and access controls.</p>
            </div>

            <div class="search-box">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" id="searchInput" placeholder="Search by username..." 
                       value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
            </div>
        </div>

        <div class="table-container">
            <table class="premium-table">
                <thead>
                    <tr>
                        <th>User ID</th>
                        <th>Username</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th style="text-align: right;">Operations</th>
                    </tr>
                </thead>
                <tbody id="userTableBody">
                    <%
                        List<AdminUser> users = (List<AdminUser>) request.getAttribute("userList");
                        if (users != null && !users.isEmpty()) {
                            for (AdminUser u : users) {
                    %>
                    <tr>
                        <td style="color: var(--text-slate); font-weight: 600;">#<%= u.getUserId() %></td>
                        <td style="font-weight: 700;"><%= u.getUsername() %></td>
                        <td><%= u.getRole() %></td>
                        <td>
                            <span class="status-pill <%= "active".equalsIgnoreCase(u.getStatus()) ? "status-active" : "status-banned" %>">
                                <%= u.getStatus().toUpperCase() %>
                            </span>
                        </td>
                        <td style="text-align: right;">
                            <% if (!"admin".equalsIgnoreCase(u.getRole())) { %>
                                <form action="UserManagementServlet" method="post" style="display: inline;">
                                    <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                    <input type="hidden" name="newStatus" value="<%= "active".equalsIgnoreCase(u.getStatus()) ? "banned" : "active" %>">
                                    <button type="submit" class="btn-action <%= "active".equalsIgnoreCase(u.getStatus()) ? "btn-ban" : "btn-unban" %>">
                                        <%= "active".equalsIgnoreCase(u.getStatus()) ? "Ban User" : "Unban User" %>
                                    </button>
                                </form>
                            <% } else { %>
                                <span style="font-size: 12px; color: var(--text-slate);">System Protected</span>
                            <% } %>
                        </td>
                    </tr>
                    <% 
                            }
                        } else { 
                    %>
                    <tr><td colspan="5" style="text-align: center; padding: 40px; color: var(--text-slate);">No users found.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </main>

    <script>
        // Search Functionality
        document.getElementById('searchInput').addEventListener('keyup', function() {
            let filter = this.value.toUpperCase();
            let rows = document.querySelector("#userTableBody").rows;
            
            for (let i = 0; i < rows.length; i++) {
                let username = rows[i].cells[1].textContent.toUpperCase();
                if (username.indexOf(filter) > -1) {
                    rows[i].style.display = "";
                } else {
                    rows[i].style.display = "none";
                }      
            }
        });
    </script>
</body>
</html>