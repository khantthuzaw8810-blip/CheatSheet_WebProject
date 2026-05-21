<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>CheatSheet | Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root { 
            --primary: #6366f1; 
            --content-bg: #f8fafc; 
            --card-white: #ffffff; 
            --text-slate: #64748b; 
            --text-dark: #1e293b; 
            --border-color: #f1f5f9; 
        }
        
        * { 
            box-sizing: border-box; 
            margin: 0; 
            padding: 0; 
        }
        
        body { 
            display: flex; 
            font-family: 'Plus Jakarta Sans', sans-serif; 
            background: var(--content-bg); 
            color: var(--text-dark); 
        }
        
        /* Layout container responsive constraints mapped to fixed sidebar dimensions */
        .main-content { 
            margin-left: 260px; 
            width: calc(100% - 260px); 
            padding: 45px; 
            min-width: 0;
        }
        
        .header-title h1 { 
            font-size: 32px; 
            font-weight: 800; 
            margin: 0; 
        }
        
        .header-title p {
            color: var(--text-slate);
            margin-top: 5px;
            font-size: 14px;
        }
        
        .stats-grid { 
            display: grid; 
            grid-template-columns: repeat(3, 1fr); 
            gap: 24px; 
            margin-top: 40px; 
        }
        
        .stat-card { 
            background: var(--card-white); 
            padding: 28px; 
            border-radius: 24px; 
            border: 1px solid var(--border-color); 
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
        }
        
        .stat-val { 
            font-size: 36px; 
            font-weight: 800; 
            margin-top: 12px; 
        }
        
        .welcome-banner { 
            margin-top: 40px; 
            background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%); 
            padding: 45px; 
            border-radius: 28px; 
            color: white; 
        }
        
        .welcome-banner p {
            margin-top: 8px;
            opacity: 0.9;
        }
    </style>
</head>
<body>

    <jsp:include page="admin_sidebar.jsp" />

    <main class="main-content">
        <div class="header-title">
            <h1>System Overview</h1>
            <p>Welcome back! Monitor your system performance.</p>
        </div>
        
        <div class="stats-grid">
            <div class="stat-card">
                <div style="font-size:13px; font-weight:700; color:var(--text-slate);">Total Members</div>
                <div class="stat-val">
                    <%= request.getAttribute("totalUsers") != null ? request.getAttribute("totalUsers") : "0" %>
                </div>
            </div>
            
            <div class="stat-card">
                <div style="font-size:13px; font-weight:700; color:var(--text-slate);">Resource Sheets</div>
                <div class="stat-val">
                    <%= request.getAttribute("totalSheets") != null ? request.getAttribute("totalSheets") : "0" %>
                </div>
            </div>
            
            <div class="stat-card">
                <div style="font-size:13px; font-weight:700; color:var(--text-slate);">Banned Accounts</div>
                <div class="stat-val" style="color:#ef4444;">
                    <%= request.getAttribute("bannedUsers") != null ? request.getAttribute("bannedUsers") : "0" %>
                </div>
            </div>
        </div>
        
        <div class="welcome-banner">
            <h2>Optimal System Performance</h2>
            <p>The CheatSheet central database is currently operating at full capacity.</p>
        </div>
    </main>

</body>
</html>