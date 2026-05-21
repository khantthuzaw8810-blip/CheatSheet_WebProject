<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    /* Sidebar Design */
    .sidebar { 
        width: 250px; height: 100vh; 
        background: linear-gradient(180deg, #005bea, #00c6fb);
        color: white; position: fixed; left: 0; top: 0; 
        padding-top: 30px; box-shadow: 2px 0 10px rgba(0,0,0,0.1); 
        z-index: 1000;
    }
    .sidebar h2 { text-align: center; margin-bottom: 30px; font-size: 22px; letter-spacing: 1px; }
    .menu-item { 
        padding: 15px 25px; font-size: 17px; cursor: pointer; 
        transition: 0.3s; display: flex; align-items: center; gap: 10px; 
    }
    .menu-item:hover { background: rgba(255,255,255,0.2); border-left: 5px solid #fff; }
</style>

<div class="sidebar">
    <h2>📋 Admin Panel</h2>
    <div class="menu-item" onclick="window.location='DashboardServlet'">🏠 Dashboard</div>
    <div class="menu-item" onclick="window.location='CheatSheetListServlet'">💻 Programming</div>
    <div class="menu-item" onclick="window.location='SoftwareServlet'">🖥 Software</div>
    <div class="menu-item" onclick="loadPage('education')">🎓 Education</div>
    <div class="menu-item" onclick="loadPage('settings')">⚙ Settings</div>
    <div class="menu-item" onclick="window.location='logout.jsp'">🚪 Logout</div>
</div>