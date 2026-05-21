<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>CheatSheet | Control Settings</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        /* Sidebar နှင့် CSS Variables များသည် Dashboard အတိုင်းဖြစ်ရမည် */
        :root { --primary: #6366f1; --sidebar-bg: #0f172a; --content-bg: #f8fafc; --card-white: #ffffff; --text-slate: #64748b; --text-dark: #1e293b; --border-color: #f1f5f9; }
        [data-theme="dark"] { --content-bg: #020617; --card-white: #1e293b; --text-slate: #94a3b8; --text-dark: #f8fafc; --border-color: #334155; --sidebar-bg: #000000; }

        body { display: flex; margin: 0; font-family: 'Plus Jakarta Sans', sans-serif; background: var(--content-bg); color: var(--text-dark); transition: 0.3s; }
        .sidebar { width: 280px; height: 100vh; background: var(--sidebar-bg); color: white; position: fixed; display: flex; flex-direction: column; }
        .logo-box { padding: 35px 30px; font-size: 26px; font-weight: 800; }
        .logo-box span { color: var(--primary); }
        .nav-link { display: flex; align-items: center; gap: 12px; padding: 14px 18px; color: #94a3b8; text-decoration: none; font-size: 14px; font-weight: 500; border-radius: 12px; margin-bottom: 5px; }
        .nav-link.active, .nav-link:hover { background: rgba(99, 102, 241, 0.1); color: white; }
        .main { margin-left: 280px; width: calc(100% - 280px); padding: 45px; box-sizing: border-box; }

        /* Premium Setting Card */
        .setting-card { background: var(--card-white); border-radius: 24px; padding: 35px; border: 1px solid var(--border-color); max-width: 800px; }
        .setting-row { display: flex; justify-content: space-between; align-items: center; padding: 25px 0; border-bottom: 1px solid var(--border-color); }
        .setting-row:last-child { border: none; }
        
        .theme-btn { padding: 12px 25px; border-radius: 12px; border: none; font-weight: 700; cursor: pointer; transition: 0.2s; background: var(--primary); color: white; }
    </style>
</head>
<body>
    <aside class="sidebar">
        <div class="logo-box">Cheat<span>Sheet</span></div>
        <nav class="nav-container" style="padding: 0 15px; flex-grow: 1;">
            <a href="AdminServlet" class="nav-link"><i class="fa-solid fa-chart-pie"></i> Dashboard</a>
            <a href="UserManagementServlet" class="nav-link"><i class="fa-solid fa-shield-halved"></i> Command Center</a>
            <a href="QualityControlServlet" class="nav-link"><i class="fa-solid fa-magnifying-glass-chart"></i> Quality Control</a>
            <a href="admin_settings.jsp" class="nav-link active"><i class="fa-solid fa-gears"></i> Control Settings</a>
        </nav>
    </aside>

    <main class="main">
        <h1>Control Settings</h1>
        <p style="color: var(--text-slate); margin-bottom: 40px;">Customize your administrative environment.</p>

        <div class="setting-card">
            <div class="setting-row">
                <div>
                    <div style="font-weight: 700; font-size: 18px;">Visual Appearance</div>
                    <div style="color: var(--text-slate); font-size: 14px; margin-top: 5px;">Switch between light and dark modes for the entire system.</div>
                </div>
                <button class="theme-btn" id="themeToggle">Enable Dark Mode</button>
            </div>
            
            <div class="setting-row">
                <div>
                    <div style="font-weight: 700; font-size: 18px;">Security Level</div>
                    <div style="color: var(--text-slate); font-size: 14px; margin-top: 5px;">Current status: <span style="color: #22c55e;">High Protection</span></div>
                </div>
                <button class="theme-btn" style="background: var(--border-color); color: var(--text-slate); cursor: not-allowed;">Manage</button>
            </div>
        </div>
    </main>

    <script>
        const themeToggle = document.getElementById('themeToggle');
        
        themeToggle.addEventListener('click', () => {
            const currentTheme = document.documentElement.getAttribute('data-theme');
            const targetTheme = currentTheme === 'dark' ? 'light' : 'dark';
            document.documentElement.setAttribute('data-theme', targetTheme);
            localStorage.setItem('theme', targetTheme);
            updateBtn(targetTheme);
        });

        function updateBtn(theme) {
            themeToggle.innerText = theme === 'dark' ? 'Disable Dark Mode' : 'Enable Dark Mode';
            themeToggle.style.background = theme === 'dark' ? '#ef4444' : '#6366f1';
        }

        const savedTheme = localStorage.getItem('theme') || 'light';
        document.documentElement.setAttribute('data-theme', savedTheme);
        updateBtn(savedTheme);
    </script>
</body>
</html>