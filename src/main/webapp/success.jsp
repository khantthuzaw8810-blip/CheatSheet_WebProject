<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // ၁။ Login စစ်ဆေးခြင်း
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // ၂။ Session မှ Data များယူခြင်း
    java.util.Date lastLogin = (java.util.Date) session.getAttribute("lastLogin");
    String adminDisplayName = (String) session.getAttribute("username"); 

    Object cheatObj = session.getAttribute("cheatCount");
    Object catObj = session.getAttribute("categoryCount");
    
    int finalCheatCount = (cheatObj != null) ? Integer.parseInt(cheatObj.toString()) : 0;
    int finalCategoryCount = (catObj != null) ? Integer.parseInt(catObj.toString()) : 0;

    // 🎯 JSP (Java) ဘက်ကနေ အချိန်ကို သေချာတွက်ချက်ခြင်း
    int javaHour = java.util.Calendar.getInstance().get(java.util.Calendar.HOUR_OF_DAY);
    String javaGreet = "Good Morning";
    String javaIcon = "fa-cloud-sun";
    
    if (javaHour >= 12 && javaHour < 17) {
        javaGreet = "Good Afternoon";
        javaIcon = "fa-sun";
    } else if (javaHour >= 17 && javaHour < 22) {
        javaGreet = "Good Evening";
        javaIcon = "fa-cloud-moon";
    } else if (javaHour >= 22 || javaHour < 5) {
        javaGreet = "Good Night (အိပ်ယာဝင်ရတော့မယ်)"; // 💡 ည ၁၀ နာရီကျော်ရင် ဒါတိုက်ရိုက်ပြမယ်
        javaIcon = "fa-moon";
    }
    
    String finalAdminName = (adminDisplayName != null && !adminDisplayName.trim().equals("") && !adminDisplayName.equals("null")) ? adminDisplayName : "Admin";
%>

<html>
<head>
    <title>Admin Dashboard | Control Panel</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    <style>
    :root {
        --bg-main: #f4f6f9;
        --sidebar-grad: linear-gradient(180deg,#005bea,#00c6fb);
        --card-bg: #ffffff;
        --text-color: #333333;
        --text-sub: #555555;
        --border-color: #eeeeee;
        --input-bg: #ffffff;
    }

    body.dark-mode {
        --bg-main: #121212;
        --sidebar-grad: linear-gradient(180deg, #1e3a8a, #0f172a);
        --card-bg: #1e1e1e;
        --text-color: #e0e0e0;
        --text-sub: #aaaaaa;
        --border-color: #333333;
        --input-bg: #2d2d2d;
    }

    body { 
        margin:0; 
        font-family: 'Segoe UI', sans-serif; 
        background: var(--bg-main); 
        color: var(--text-color); 
        transition: 0.3s; 
    }

    .top-header {
        margin-left: 250px;
        padding: 15px 30px;
        display: flex;
        justify-content: space-between; 
        align-items: center;
        background: var(--card-bg);
        border-bottom: 1px solid var(--border-color);
        position: sticky; top: 0; z-index: 999;
        height: 70px;
        box-sizing: border-box;
    }

    .header-greeting {
        font-size: 16px;
        font-weight: 600;
        color: var(--text-color);
        display: flex;
        align-items: center;
        gap: 8px;
    }
    .header-greeting i {
        color: #ff9800; 
    }

    .search-box { position: relative; width: 300px; }
    .search-box input {
        width: 100%; padding: 10px 35px 10px 15px;
        border-radius: 20px; border: 1px solid var(--border-color);
        background: var(--bg-main); color: var(--text-color);
    }
    .search-box i { position: absolute; right: 15px; top: 12px; color: var(--text-sub); }
    
    .sidebar { 
        width:250px; height:100vh; 
        background: var(--sidebar-grad);
        color:white; position:fixed; left:0; top:0; padding-top:10px; 
        box-shadow: 2px 0 10px rgba(0,0,0,0.1); z-index: 1000; 
    }

    .profile-section { text-align: center; padding: 20px; border-bottom: 1px solid rgba(255,255,255,0.1); margin-bottom: 10px; }
    .profile-section i { font-size: 50px; color: white; cursor: pointer; transition: 0.3s; }
    .profile-section h2 { margin-top: 10px; font-size: 18px; letter-spacing: 0.5px; cursor: pointer; }

    .menu-item { padding:15px 25px; font-size:17px; cursor:pointer; transition:0.3s; display: flex; align-items: center; gap: 10px; }
    .menu-item:hover { background:rgba(255,255,255,0.2); border-left: 5px solid #fff; }
    
    .content { margin-left:250px; padding:30px; }

    .card { 
        background: var(--card-bg); 
        padding:25px; border-radius:15px;
        box-shadow:0 4px 15px rgba(0,0,0,0.05); 
        margin-bottom:20px; 
        transition: 0.3s; 
        border: 1px solid var(--border-color);
    }

    .welcome-title { 
        font-size: 48px; font-weight: 900; text-align: center;
        background: linear-gradient(90deg, #005bea, #00c6fb, #673ab7, #005bea);
        background-size: 200% auto; -webkit-background-clip: text;
        -webkit-text-fill-color: transparent; animation: shine 3s linear infinite;
        margin-top: 20px; letter-spacing: -1px;
    }

    @keyframes shine { to { background-position: 200% center; } }

    .settings-container { max-width: 900px; margin: 0 auto; padding: 40px !important; }
    .settings-header { margin-bottom: 35px; border-bottom: 1px solid var(--border-color); padding-bottom: 20px; }
    .settings-header h1 { font-size: 28px; margin: 0; color: var(--text-color); }
    .settings-header p { color: var(--text-sub); margin-top: 5px; }

    .settings-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 30px; }
    .settings-section { background: var(--bg-main); padding: 25px; border-radius: 12px; border: 1px solid var(--border-color); }
    .full-width { grid-column: span 2; }

    .section-title { font-weight: 700; font-size: 16px; margin-bottom: 20px; color: #005bea; display: flex; align-items: center; gap: 10px; }
    
    .setting-item { display: flex; justify-content: space-between; align-items: center; }
    .setting-info span { display: block; font-weight: 600; }
    .setting-info small { color: var(--text-sub); font-size: 12px; }

    .input-group { margin-bottom: 15px; text-align: left; }
    .input-group label { display: block; font-size: 13px; font-weight: 600; margin-bottom: 8px; color: var(--text-sub); }
    
    .input-with-icon { position: relative; }
    .input-with-icon i { position: absolute; left: 15px; top: 13px; color: #aaa; transition: 0.3s; }
    .input-with-icon input { 
        width: 100%; padding: 12px 15px 12px 45px; border-radius: 8px; 
        border: 1px solid var(--border-color); background: var(--card-bg); 
        color: var(--text-color); font-size: 14px; transition: 0.3s;
    }

    .btn-save, .btn-change-pw {
        width: 100%; padding: 12px; border: none; border-radius: 8px; cursor: pointer;
        font-weight: 700; transition: 0.3s; display: flex; align-items: center; justify-content: center; gap: 8px;
    }
    .btn-save { background: #005bea; color: white; margin-top: 10px; }
    .btn-change-pw { background: #d32f2f; color: white; }

    .switch { position: relative; display: inline-block; width: 50px; height: 26px; }
    .switch input { opacity: 0; width: 0; height: 0; }
    .slider { position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0; background-color: #ccc; transition: .4s; border-radius: 34px; }
    .slider:before { position: absolute; content: ""; height: 18px; width: 18px; left: 4px; bottom: 4px; background-color: white; transition: .4s; border-radius: 50%; }
    input:checked + .slider { background-color: #28a745; }
    input:checked + .slider:before { transform: translateX(24px); }

    .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 25px; }
    .glass-card { background: var(--card-bg); border-radius: 20px; padding: 20px; text-align: center; border: 1px solid var(--border-color); transition: 0.3s; }
    @keyframes fadeInDown { from { opacity: 0; transform: translateY(-20px); } to { opacity: 1; transform: translateY(0); } }
</style>

<script>
    const cheatData = <%= finalCheatCount %>;
    const categoryData = <%= finalCategoryCount %>;
    let adminName = "<%= finalAdminName %>";

    function handleSearch(query) {
        let items = document.querySelectorAll('.glass-card, .menu-item');
        if (query.length >= 2) {
            items.forEach(item => {
                let text = item.innerText.toLowerCase();
                if (text.includes(query.toLowerCase())) {
                    item.style.opacity = "1"; item.style.transform = "scale(1)";
                } else {
                    item.style.opacity = "0.3"; item.style.transform = "scale(0.95)";
                }
            });
        } else {
            items.forEach(item => {
                item.style.opacity = "1"; item.style.transform = "scale(1)";
            });
        }
    }

    function applyTheme(isDark) {
        if (isDark) {
            document.body.classList.add('dark-mode');
            localStorage.setItem('theme', 'dark');
        } else {
            document.body.classList.remove('dark-mode');
            localStorage.setItem('theme', 'light');
        }
    }

    function confirmLogout() {
        const isDark = document.body.classList.contains('dark-mode') || localStorage.getItem('theme') === 'dark';
        
        Swal.fire({
            title: 'Sign Out?',
            text: 'Are you sure you want to log out of your account?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3498db',
            cancelButtonColor: '#e74c3c',
            confirmButtonText: 'Yes, Logout',
            cancelButtonText: 'Cancel',
            background: isDark ? '#1e1e1e' : '#ffffff',
            color: isDark ? '#e0e0e0' : '#333333'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = "LogoutServlet";
            }
        });
    }

   
    function loadDashboard() {
        let content = document.getElementById("mainContent");
        content.innerHTML = `
            <div style="text-align: center; padding: 20px 0; animation: fadeInDown 0.8s ease-out;">
                <h1 class="welcome-title">Welcome to CheatSheet System</h1>
                <p style="color: var(--text-sub); font-size: 20px; font-weight: 500;">Management Control Panel Dashboard</p>
            </div>
            <div class="stats-grid">
                <div class="glass-card" style="border-bottom: 4px solid #005bea;"><i class="fa-solid fa-book-open" style="color: #005bea;"></i><span style="color: var(--text-sub);">Cheat Sheets</span><b>${cheatData}</b></div>
                <div class="glass-card" style="border-bottom: 4px solid #28a745;"><i class="fa-solid fa-folder-tree" style="color: #28a745;"></i><span style="color: var(--text-sub);">Categories</span><b>${categoryData}</b></div>
                <div class="glass-card" style="border-bottom: 4px solid #ff9800;"><i class="fa-solid fa-user-check" style="color: #ff9800;"></i><span style="color: var(--text-sub);">Active Sessions</span><b>1</b></div>
                <div class="glass-card" style="border-bottom: 4px solid #673ab7;"><i class="fa-solid fa-clock-rotate-left" style="color: #673ab7;"></i><span style="color: var(--text-sub);">Last Login</span><span style="font-size: 13px; display: block; margin-top: 10px;"><%= lastLogin %></span></div>
            </div>
            <div style="display: grid; grid-template-columns: 1.5fr 1fr; gap: 20px;">
                <div class="card">
                    <h3 style="margin-top:0;"><i class="fa-solid fa-chart-bar" style="color: #005bea;"></i> Content Distribution</h3>
                    <div style="height: 250px;"><canvas id="contentChart"></canvas></div>
                </div>
                <div class="card">
                    <h3 style="margin-top:0;"><i class="fa-solid fa-shield-heart" style="color: #e91e63;"></i> System Status</h3>
                    <div class="status-item"><span class="dot" style="background: #28a745;"></span> Database: <b style="color: #28a745;">Connected</b></div>
                </div>
            </div>`;
        initChart();
    }

    function initChart() {
        const ctx = document.getElementById('contentChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['Cheat Sheets', 'Categories'],
                datasets: [{ label: 'Counts', data: [cheatData, categoryData], backgroundColor: ['rgba(0, 91, 234, 0.7)', 'rgba(40, 167, 69, 0.7)'], borderRadius: 8 }]
            },
            options: { responsive: true, maintainAspectRatio: false }
        });
    }

    function loadPage(page) {
        let content = document.getElementById("mainContent");
        
        if (page === "profile") {
            content.innerHTML = `
                <div class="card settings-container" style="animation: fadeInDown 0.6s ease;">
                    <div class="settings-header">
                        <h1><i class="fa-solid fa-circle-user"></i> Profile Account</h1>
                        <p>Update your account details and security settings</p>
                    </div>
                    <div class="settings-grid">
                        <div class="settings-section full-width">
                            <div class="section-title"><i class="fa-solid fa-user-pen"></i> Identity Management</div>
                            <form action="AdminSettingsServlet" method="POST" style="display:flex; gap:15px; align-items:flex-end;">
                                <input type="hidden" name="action" value="updateProfile">
                                <div class="input-group" style="flex:1;">
                                    <label>New Admin Name</label>
                                    <div class="input-with-icon">
                                        <i class="fa-solid fa-signature"></i>
                                        <input type="text" name="username" value="${adminName}" required>
                                    </div>
                                </div>
                                <button type="submit" class="btn-save" style="width:150px; margin-bottom:15px;">Save Changes</button>
                            </form>
                        </div>
                        <div class="settings-section full-width">
                            <div class="section-title"><i class="fa-solid fa-shield-halved"></i> Security</div>
                            <form action="AdminSettingsServlet" method="POST" style="display:grid; grid-template-columns:1fr 1fr; gap:20px;">
                                <input type="hidden" name="action" value="changePassword">
                                <div class="input-group">
                                    <label>Current Password</label>
                                    <div class="input-with-icon"><i class="fa-solid fa-lock"></i><input type="password" name="oldPassword" required placeholder="••••••••"></div>
                                </div>
                                <div class="input-group">
                                    <label>New Security Password</label>
                                    <div class="input-with-icon"><i class="fa-solid fa-key"></i><input type="password" name="newPassword" required placeholder="New password"></div>
                                </div>
                                <div style="grid-column: span 2;">
                                    <button type="submit" class="btn-change-pw"><i class="fa-solid fa-rotate"></i> Update Password</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>`;
        }
        
        if (page === "settings") {
            content.innerHTML = `
                <div class="card settings-container" style="animation: fadeInDown 0.6s ease;">
                    <div class="settings-header">
                        <h1><i class="fa-solid fa-gears"></i> System Settings</h1>
                        <p>Personalize your interface experience</p>
                    </div>
                    <div class="settings-section full-width">
                        <div class="section-title"><i class="fa-solid fa-palette"></i> Appearance Management</div>
                        <div class="setting-item">
                            <div class="setting-info">
                                <span>Dark Mode Appearance</span>
                                <small>Switch between light and dark themes for better comfort</small>
                            </div>
                            <label class="switch">
                                <input type="checkbox" id="darkToggle" onchange="applyTheme(this.checked)">
                                <span class="slider"></span>
                            </label>
                        </div>
                    </div>
                </div>`;
            if(localStorage.getItem('theme') === 'dark') document.getElementById('darkToggle').checked = true;
        }
    }

    window.onload = function() {
        if (localStorage.getItem('theme') === 'dark') document.body.classList.add('dark-mode');
        loadDashboard();
    };
</script>
</head>

<body>
    <div class="top-header">
        <div class="header-greeting" id="headerGreetingText">
            <i class="fa-solid <%= javaIcon %>"></i> <%= javaGreet %>, <span style="color: #005bea; font-weight: 700;"><%= finalAdminName %></span>
        </div>
        
        <div class="search-box">
            <input type="text" placeholder="Search (min 2 chars)..." oninput="handleSearch(this.value)">
            <i class="fa-solid fa-magnifying-glass"></i>
        </div>
    </div>

    <div class="sidebar">
        <div class="profile-section">
            <i class="fa-solid fa-circle-user" onclick="loadPage('profile')" style="cursor:pointer;"></i>
            <h2 id="sidebarUsername" onclick="loadPage('profile')" style="cursor:pointer;"><%= finalAdminName %></h2>
        </div>
        <div class="menu-item" onclick="loadDashboard()">🏠 Dashboard</div>
        <div class="menu-item" onclick="window.location='CheatSheetListServlet'">💻 Programming</div>
        <div class="menu-item" onclick="window.location='SoftwareServlet'">🖥 Software</div>
        <div class="menu-item" onclick="window.location='EducationList'">🎓 Education</div>
        <div class="menu-item" onclick="loadPage('settings')">⚙ Settings</div>
        <div class="menu-item" onclick="confirmLogout()">🚪 Logout</div>
    </div>

    <div class="content">
        <div id="mainContent"></div>
    </div>
</body>
</html>