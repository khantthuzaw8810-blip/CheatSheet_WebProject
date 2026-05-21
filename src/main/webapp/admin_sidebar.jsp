<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- Font Awesome Icons --%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    /* 🌌 Global Layout Protection */
    * { box-sizing: border-box; margin: 0; padding: 0; }

    /* 🔒 Sidebar Main Layout - Page တိုင်းမှာ အရွယ်အစား လုံးဝ မရွေ့စေရန် Fix ထားသည် */
    .admin-sidebar {
        width: 260px;
        min-width: 260px;
        max-width: 260px;
        height: 100vh;
        background: #111827;
        color: #f8fafc;
        position: fixed;
        left: 0;
        top: 0;
        display: flex;
        flex-direction: column;
        z-index: 1000;
        box-shadow: 4px 0 10px rgba(0,0,0,0.1);
    }

    /* Logo Section */
    .sidebar-brand {
        padding: 35px 25px;
        font-size: 24px;
        font-weight: 800;
        color: #6366f1;
        letter-spacing: 1.5px;
        text-transform: uppercase;
    }

    /* 👤 User Profile Section - နာမည်ရှည်လည်း Layout မပျက်အောင် ထိန်းထားသည် */
    .user-profile {
        margin: 0 20px 0 20px; 
        padding: 16px;
        background: rgba(255, 255, 255, 0.05);
        border-radius: 16px;
        display: flex;
        align-items: center;
        gap: 12px;
        border: 1px solid rgba(255, 255, 255, 0.1);
        overflow: hidden;
    }
    .profile-avatar {
        width: 42px;
        min-width: 42px;
        height: 42px;
        background: linear-gradient(135deg, #6366f1, #4f46e5);
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 800;
        font-size: 18px;
        color: white;
    }
    .profile-info {
        display: flex;
        flex-direction: column;
        min-width: 0;
    }
    .profile-info .name {
        display: block;
        font-size: 14px;
        font-weight: 700;
        color: #ffffff;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    .profile-info .status {
        font-size: 11px;
        color: #22c55e;
        display: flex;
        align-items: center;
        gap: 6px;
        margin-top: 2px;
    }

    /* Navigation Menu */
    .nav-menu {
        flex: 1;
        list-style: none;
        padding: 0 15px;
        margin: 0;
    }
    .nav-item {
        margin-bottom: 8px;
    }
    .nav-link {
        display: flex;
        align-items: center;
        padding: 14px 18px;
        color: #94a3b8;
        text-decoration: none;
        font-size: 14px;
        font-weight: 600;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        border-radius: 12px;
        white-space: nowrap;
    }
    .nav-link i {
        margin-right: 14px;
        width: 20px;
        font-size: 18px;
        text-align: center;
    }
    
    /* Hover & Active States */
    .nav-link:hover {
        background: rgba(255, 255, 255, 0.03);
        color: #ffffff;
    }
    .nav-link.active {
        background: rgba(99, 102, 241, 0.15);
        color: #6366f1;
        font-weight: 700;
    }
    .nav-link.active i {
        color: #6366f1;
    }

    /* Footer / Logout Section */
    .sidebar-footer {
        padding: 20px 15px;
        border-top: 1px solid rgba(255, 255, 255, 0.05);
    }
    .logout-link {
        display: flex;
        align-items: center;
        color: #f87171;
        text-decoration: none;
        font-weight: 700;
        font-size: 14px;
        padding: 14px 18px;
        transition: 0.3s;
        border-radius: 12px;
    }
    .logout-link i {
        margin-right: 14px;
    }
    .logout-link:hover {
        background: rgba(239, 68, 68, 0.1);
    }
</style>

<div class="admin-sidebar">
    <div class="sidebar-brand">Cheat<span>Sheet</span></div>

    <%-- Dynamic Profile Card --%>
    <a href="ProfileServlet" style="text-decoration: none; display: block; color: inherit; transition: transform 0.2s;" onmouseover="this.style.transform='scale(1.02)'" onmouseout="this.style.transform='scale(1)'">
        <div class="user-profile" style="cursor: pointer;">
            <div class="profile-avatar">
                <%= (session.getAttribute("username") != null) ? session.getAttribute("username").toString().substring(0, 1).toUpperCase() : "A" %>
            </div>
            <div class="profile-info">
                <span class="name">
                    <%= (session.getAttribute("username") != null) ? session.getAttribute("username") : "Admin User" %>
                </span>
                <span class="status">
                    <i class="fa-solid fa-circle" style="font-size: 6px;"></i> 
                    Online Access
                </span>
            </div>
        </div>
    </a>
    
    <div style="margin-bottom: 30px;"></div>

    <%-- Menu Items --%>
    <ul class="nav-menu">
        <li class="nav-item">
            <a href="AdminServlet" class="nav-link ${activePage == 'dashboard' ? 'active' : ''}">
                <i class="fa-solid fa-gauge-high"></i> Dashboard
            </a>
        </li>
        <li class="nav-item">
            <a href="UserManagementServlet" class="nav-link ${activePage == 'command' ? 'active' : ''}">
                <i class="fa-solid fa-shield-halved"></i> Command Center
            </a>
        </li>
        <li class="nav-item">
            <a href="QualityControlServlet" class="nav-link ${activePage == 'qc' ? 'active' : ''}">
                <i class="fa-solid fa-magnifying-glass-chart"></i> Quality Control
            </a>
        </li>
        <li class="nav-item">
            <a href="SubmissionHubServlet" class="nav-link ${activePage == 'hub' ? 'active' : ''}">
                <i class="fa-solid fa-layer-group"></i> Submission Hub
            </a>
        </li>
        <li class="nav-item">
            <a href="ProfileServlet" class="nav-link ${activePage == 'settings' ? 'active' : ''}">
                <i class="fa-solid fa-gears"></i> Control Settings
            </a>
        </li>
    </ul>

    <%-- Logout Area --%>
    <div class="sidebar-footer">
        <a href="LogoutServlet" class="logout-link">
            <i class="fa-solid fa-right-from-bracket"></i> Logout
        </a>
    </div>
</div>