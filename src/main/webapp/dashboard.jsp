<%-- <%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // ၁။ Login စစ်ဆေးခြင်း
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    // ၂။ Session မှ လက်ရှိ Login ဝင်ထားတဲ့ နာမည်ကို ယူခြင်း
    String adminDisplayName = (String) session.getAttribute("username");
    if (adminDisplayName == null || adminDisplayName.trim().equals("")) {
        adminDisplayName = "Admin";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cheatsheet Management</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bg-color: #0f172a;
            --sidebar-bg: #1e293b;
            --card-bg: rgba(30, 41, 59, 0.7);
            --code-bg: #0b0f19;
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
            --accent-color: #38bdf8;
            --accent-hover: #0284c7;
            --border-color: rgba(255, 255, 255, 0.08);
            --danger-color: #ef4444;
            --success-color: #22c55e;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', system-ui, sans-serif;
        }

        body {
            background-color: var(--bg-color);
            color: var(--text-main);
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        /* --- SIDEBAR STYLE --- */
        .sidebar {
            width: 260px;
            background-color: var(--sidebar-bg);
            display: flex;
            flex-direction: column;
            border-right: 1px solid var(--border-color);
        }

        .sidebar-brand {
            padding: 24px;
            font-size: 20px;
            font-weight: 700;
            color: var(--accent-color);
            display: flex;
            align-items: center;
            gap: 10px;
            border-bottom: 1px solid var(--border-color);
        }

        .sidebar-menu {
            list-style: none;
            padding: 24px 16px;
            flex-grow: 1;
        }

        .sidebar-item {
            margin-bottom: 8px;
        }

        .sidebar-link {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 16px;
            color: var(--text-muted);
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .sidebar-link:hover, .sidebar-item.active .sidebar-link {
            background-color: rgba(56, 189, 248, 0.1);
            color: var(--accent-color);
        }

        .sidebar-footer {
            padding: 16px;
            border-top: 1px solid var(--border-color);
        }

        .logout-btn {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 16px;
            color: var(--danger-color);
            text-decoration: none;
            border-radius: 8px;
            font-weight: 500;
            transition: background 0.3s;
        }

        .logout-btn:hover {
            background: rgba(239, 68, 68, 0.1);
        }

        /* --- MAIN CONTENT STYLE --- */
        .main-content {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            overflow-y: auto;
        }

        /* Top Header */
        .top-header {
            height: 70px;
            background-color: var(--sidebar-bg);
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 32px;
            border-bottom: 1px solid var(--border-color);
        }

        .page-title h1 {
            font-size: 22px;
            font-weight: 600;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .greeting-text {
            font-size: 14px;
            font-weight: 500;
            color: var(--text-main);
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            background: var(--accent-color);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--bg-color);
            font-weight: bold;
            text-transform: uppercase;
        }

        /* Content Body */
        .content-body {
            padding: 32px;
        }

        /* --- CONTROL & FILTER ROW --- */
        .filter-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            gap: 16px;
            flex-wrap: wrap;
        }

        .search-filter-box {
            display: flex;
            gap: 12px;
            flex-grow: 1;
            max-width: 600px;
        }

        .search-input {
            background: var(--sidebar-bg);
            border: 1px solid var(--border-color);
            padding: 10px 16px;
            border-radius: 8px;
            color: var(--text-main);
            font-size: 14px;
            flex-grow: 1;
        }

        .search-input:focus {
            outline: 1px solid var(--accent-color);
        }

        .select-filter {
            background: var(--sidebar-bg);
            border: 1px solid var(--border-color);
            padding: 10px 16px;
            border-radius: 8px;
            color: var(--text-main);
            font-size: 14px;
            cursor: pointer;
        }

        .action-btn {
            background-color: var(--accent-color);
            color: var(--bg-color);
            border: none;
            padding: 10px 18px;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: background 0.2s;
        }

        .action-btn:hover {
            background-color: var(--accent-hover);
        }

        /* --- CHEATSHEET CARDS GRID --- */
        .cheatsheet-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
            gap: 24px;
        }

        .cheat-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 20px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .cheat-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 12px;
        }

        .cheat-title h3 {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 4px;
        }

        .tech-badge {
            font-size: 11px;
            padding: 3px 8px;
            border-radius: 4px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .badge-java { background: rgba(224, 150, 41, 0.15); color: #e09629; }
        .badge-sql { background: rgba(56, 189, 248, 0.15); color: var(--accent-color); }
        .badge-html { background: rgba(240, 101, 41, 0.15); color: #f06529; }

        .cheat-desc {
            font-size: 13px;
            color: var(--text-muted);
            margin-bottom: 14px;
            line-height: 1.5;
        }

        .code-container {
            background: var(--code-bg);
            border-radius: 6px;
            padding: 12px;
            position: relative;
            margin-bottom: 16px;
        }

        .code-container pre {
            font-family: 'Consolas', 'Courier New', monospace;
            font-size: 12px;
            overflow-x: auto;
            color: #e2e8f0;
            white-space: pre-wrap;
        }

        .cheat-actions {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            border-top: 1px solid var(--border-color);
            padding-top: 12px;
        }

        .btn-text-icon {
            background: transparent;
            border: none;
            color: var(--text-muted);
            cursor: pointer;
            font-size: 13px;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: color 0.2s;
        }

        .btn-text-icon:hover { color: var(--accent-color); }
        .btn-text-icon.delete:hover { color: var(--danger-color); }

        /* --- MODAL DIALOG --- */
        .modal-overlay {
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(15, 23, 42, 0.8);
            backdrop-filter: blur(4px);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 100;
            display: none; 
        }

        .modal-box {
            background: var(--sidebar-bg);
            border: 1px solid var(--border-color);
            width: 100%;
            max-width: 550px;
            border-radius: 16px;
            padding: 24px;
        }

        .modal-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .close-modal {
            background: transparent;
            border: none;
            color: var(--text-muted);
            font-size: 18px;
            cursor: pointer;
        }

        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; font-size: 13px; color: var(--text-muted); margin-bottom: 6px; }

        .form-control {
            width: 100%;
            background: var(--bg-color);
            border: 1px solid var(--border-color);
            padding: 10px 14px;
            border-radius: 8px;
            color: var(--text-main);
            font-size: 14px;
        }

        .form-control:focus { outline: 1px solid var(--accent-color); }
        textarea.form-control { resize: vertical; font-family: 'Consolas', monospace; font-size: 13px; }
        .form-actions { display: flex; justify-content: flex-end; gap: 12px; margin-top: 24px; }

        .btn-secondary {
            background: transparent;
            border: 1px solid var(--border-color);
            color: var(--text-main);
            padding: 10px 18px;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
        }
    </style>
</head>
<body>

    <aside class="sidebar">
        <div class="sidebar-brand">
            <i class="fa-solid fa-code"></i>
            <span>DevSpace Panel</span>
        </div>
        
        <ul class="sidebar-menu">
            <li class="sidebar-item">
                <a href="#" class="sidebar-link"><i class="fa-solid fa-chart-pie"></i> Dashboard</a>
            </li>
            <li class="sidebar-item active">
                <a href="#" class="sidebar-link"><i class="fa-solid fa-file-code"></i> Cheatsheets</a>
            </li>
            <li class="sidebar-item">
                <a href="#" class="sidebar-link"><i class="fa-solid fa-boxes-stack"></i> Inventory / Stock</a>
            </li>
            <li class="sidebar-item">
                <a href="#" class="sidebar-link"><i class="fa-solid fa-calendar-days"></i> Tournaments</a>
            </li>
        </ul>

        <div class="sidebar-footer">
            <a href="logout.jsp" class="logout-btn">
                <i class="fa-solid fa-right-from-bracket"></i> Sign Out
            </a>
        </div>
    </aside>

    <main class="main-content">
        <header class="top-header">
            <div class="page-title">
                <h1>Cheatsheet Manager</h1>
            </div>
            <div class="user-profile">
                <span id="timeGreeting" class="greeting-text">Loading...</span>
                <div class="user-avatar" id="avatarLetter">-</div>
            </div>
        </header>

        <div class="content-body">
            <section class="filter-row">
                <div class="search-filter-box">
                    <input type="text" class="search-input" placeholder="Search snippets or titles...">
                    <select class="select-filter">
                        <option value="all">All Tech</option>
                        <option value="java">Java</option>
                        <option value="sql">SQL / JDBC</option>
                        <option value="html">HTML / CSS</option>
                    </select>
                </div>
                <button class="action-btn" onclick="toggleModal(true)">
                    <i class="fa-solid fa-plus"></i> Create Snippet
                </button>
            </section>

            <section class="cheatsheet-grid">
                <div class="cheat-card">
                    <div>
                        <div class="cheat-header">
                            <div class="cheat-title"><h3>Database Connection Setup</h3></div>
                            <span class="tech-badge badge-java">Java</span>
                        </div>
                        <p class="cheat-desc">Standard connection code for linking to local SQL databases using raw JDBC driver manager.</p>
                        <div class="code-container">
<pre>Connection conn = DriverManager
  .getConnection(url, user, pass);</pre>
                        </div>
                    </div>
                    <div class="cheat-actions">
                        <button class="btn-text-icon"><i class="fa-solid fa-pen"></i> Edit</button>
                        <button class="btn-text-icon delete"><i class="fa-solid fa-trash"></i> Delete</button>
                    </div>
                </div>

                <div class="cheat-card">
                    <div>
                        <div class="cheat-header">
                            <div class="cheat-title"><h3>Inventory Balance Update</h3></div>
                            <span class="tech-badge badge-sql">SQL</span>
                        </div>
                        <p class="cheat-desc">Calculates current stock balance by tracking stock-in and stock-out operations dynamically.</p>
                        <div class="code-container">
<pre>SELECT stock_in - stock_out 
AS current_balance 
FROM inventory 
WHERE id = ?;</pre>
                        </div>
                    </div>
                    <div class="cheat-actions">
                        <button class="btn-text-icon"><i class="fa-solid fa-pen"></i> Edit</button>
                        <button class="btn-text-icon delete"><i class="fa-solid fa-trash"></i> Delete</button>
                    </div>
                </div>

                <div class="cheat-card">
                    <div>
                        <div class="cheat-header">
                            <div class="cheat-title"><h3>Flexbox Center Layout</h3></div>
                            <span class="tech-badge badge-html">HTML</span>
                        </div>
                        <p class="cheat-desc">Simple CSS utility rules to quickly align and center child elements vertically and horizontally.</p>
                        <div class="code-container">
<pre>.center-box {
    display: flex;
    justify-content: center;
    align-items: center;
}</pre>
                        </div>
                    </div>
                    <div class="cheat-actions">
                        <button class="btn-text-icon"><i class="fa-solid fa-pen"></i> Edit</button>
                        <button class="btn-text-icon delete"><i class="fa-solid fa-trash"></i> Delete</button>
                    </div>
                </div>
            </section>
        </div>
    </main>

    <div class="modal-overlay" id="snippetModal">
        <div class="modal-box">
            <div class="modal-title">
                <span>Create New Cheatsheet</span>
                <button class="close-modal" onclick="toggleModal(false)"><i class="fa-solid fa-xmark"></i></button>
            </div>
            <form action="#" method="POST">
                <div class="form-group">
                    <label>Title</label>
                    <input type="text" class="form-control" placeholder="e.g., BCrypt Password Hashing" required>
                </div>
                <div class="form-group">
                    <label>Technology / Language</label>
                    <select class="form-control" style="background-color: var(--bg-color);">
                        <option value="java">Java</option>
                        <option value="sql">SQL / JDBC</option>
                        <option value="html">HTML / CSS</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Short Description</label>
                    <input type="text" class="form-control" placeholder="Briefly explain what this code snippet does...">
                </div>
                <div class="form-group">
                    <label>Code Snippet</label>
                    <textarea class="form-control" rows="6" placeholder="// Paste your clean code block here..."></textarea>
                </div>
                <div class="form-actions">
                    <button type="button" class="btn-secondary" onclick="toggleModal(false)">Cancel</button>
                    <button type="submit" class="action-btn">Save Cheatsheet</button>
                </div>
            </form>
        </div>
    </div>

   <script>
        let adminName = "<%= adminDisplayName %>";
        if (adminName === "null" || !adminName || adminName.trim() === "") {
            adminName = "Admin";
        }

        function toggleModal(show) {
            const modal = document.getElementById('snippetModal');
            if(modal) modal.style.display = show ? 'flex' : 'none';
        }

        function updateGreeting() {
            try {
                const hour = new Date().getHours();
                let greet = ""; 
                let icon = "";
                
                if (hour >= 5 && hour < 12) { 
                    greet = "Good Morning"; 
                    icon = "fa-sun"; 
                } else if (hour >= 12 && hour < 17) { 
                    greet = "Good Afternoon"; 
                    icon = "fa-cloud-sun"; 
                } else if (hour >= 17 && hour < 22) { 
                    greet = "Good Evening"; 
                    icon = "fa-moon"; 
                } else { 
                    greet = "Good Night"; 
                    icon = "fa-bed"; 
                }
                
                const greetingBox = document.getElementById("timeGreeting");
                if (greetingBox) {
                    greetingBox.innerHTML = `<i class="fa-solid ${icon}" style="color: #38bdf8; margin-right: 6px;"></i> ${greet}, <strong>${adminName}</strong>`;
                }

                const avatarBox = document.getElementById("avatarLetter");
                if (avatarBox && adminName.length > 0) {
                    avatarBox.innerText = adminName.charAt(0).toUpperCase();
                }
            } catch (error) {
                console.error("Greeting Error: ", error);
            }
        }

        // စာမျက်နှာ အားလုံးအဆင်သင့်ဖြစ်တာနဲ့ တန်းပွင့်စေခြင်း
        if (document.readyState === "loading") {
            document.addEventListener("DOMContentLoaded", function() {
                updateGreeting();
                setInterval(updateGreeting, 10000);
            });
        } else {
            updateGreeting();
            setInterval(updateGreeting, 10000);
        }
    </script>
</body>
</html> --%>