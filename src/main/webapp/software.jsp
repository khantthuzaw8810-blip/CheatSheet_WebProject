<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.cheatsheet.model.CheatSheet" %>
<html>
<head>
    <title>Software Management</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* ၁။ CSS Variables သတ်မှတ်ခြင်း (Design ကို မထိဘဲ အရောင်ပဲ ပြောင်းဖို့) */
        :root { 
            --maroon: #a90033; 
            --bg: #f8f9fa; 
            --card-bg: white;
            --text-title: #333;
            --text-body: #777;
            --border: #eee;
            --blue: #3498db; 
            --green: #2ecc71; 
        }

        body.dark-mode {
            --bg: #121212;
            --card-bg: #1e1e1e;
            --text-title: #e0e0e0;
            --text-body: #aaa;
            --border: #333;
            --maroon: #ff4d88; /* Dark mode မှာ maroon ကို ပိုလင်းအောင် အနည်းငယ်ပြင်ခြင်း */
        }

        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            background: var(--bg); 
            color: var(--text-title);
            margin: 0; 
            transition: 0.3s;
        }
        
        /* Header */
        .header { background: #a90033; color: white; padding: 10px 30px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 5px rgba(0,0,0,0.1); position: sticky; top: 0; z-index: 100; }
        .header h2 { font-size: 1.2rem; margin: 0; }

        .btn-home { background: rgba(255, 255, 255, 0.15); color: white; padding: 6px 12px; border-radius: 4px; text-decoration: none; font-size: 14px; display: flex; align-items: center; gap: 6px; transition: 0.3s; }
        .btn-home:hover { background: rgba(255, 255, 255, 0.3); }

        .container { padding: 20px; max-width: 900px; margin: auto; }
        
        .btn-add { background: var(--green); color: white; padding: 8px 16px; border-radius: 4px; text-decoration: none; font-size: 14px; font-weight: 600; transition: 0.3s; }
        .btn-add:hover { background: #27ae60; box-shadow: 0 2px 8px rgba(46,204,113,0.3); }
        
        /* Soft Card */
        .soft-card { 
            background: var(--card-bg); 
            padding: 12px 20px; margin-bottom: 12px; 
            display: flex; align-items: center; border-radius: 8px; 
            box-shadow: 0 1px 4px rgba(0,0,0,0.05); 
            border-left: 4px solid #a90033; 
            transition: 0.2s; 
        }
        .soft-card:hover { transform: scale(1.01); box-shadow: 0 3px 10px rgba(0,0,0,0.08); }
        
        .soft-img { width: 50px; height: 50px; object-fit: cover; margin-right: 15px; border-radius: 6px; background: #eee; }
        .soft-details { flex: 1; }
        .soft-details h3 { margin: 0; color: var(--text-title); font-size: 16px; }
        .soft-details p { margin: 2px 0 6px 0; color: var(--text-body); font-size: 13px; line-height: 1.3; }
        
        .download-link { font-size: 12px; color: var(--maroon); text-decoration: none; font-weight: 600; display: inline-flex; align-items: center; gap: 4px; }
        .download-link:hover { text-decoration: underline; }
        
        /* Actions */
        .actions { display: flex; gap: 12px; align-items: center; margin-left: 15px; padding-left: 15px; border-left: 1px solid var(--border); }
        .btn-edit { color: var(--blue); font-size: 16px; }
        .btn-delete { color: #e74c3c; background: none; border: none; cursor: pointer; font-size: 16px; padding: 0; }
        
        .empty-state { text-align: center; padding: 40px; color: var(--text-body); font-size: 14px; }
    </style>

    <script>
        (function() {
            const savedTheme = localStorage.getItem('theme');
            if (savedTheme === 'dark') {
                document.addEventListener("DOMContentLoaded", function() {
                    document.body.classList.add('dark-mode');
                });
            }
        })();
    </script>
</head>
<body>
    <div class="header">
        <a href="success.jsp" class="btn-home">
            <i class="fas fa-home"></i> Home
        </a>
        
        <h2><i class="fas fa-laptop-code"></i> Software Section</h2>
        <a href="add_software.jsp" class="btn-add"><i class="fas fa-plus"></i> Add New</a>
    </div>

    <div class="container">
        <%
            List<CheatSheet> list = (List<CheatSheet>) request.getAttribute("softwareList");
            if (list != null && !list.isEmpty()) {
                for (CheatSheet s : list) {
                    String rawLink = s.getReferenceLink();
                    String finalLink = (rawLink != null && !rawLink.trim().isEmpty() && !rawLink.equalsIgnoreCase("null")) ? rawLink.trim() : "";
        %>
        <div class="soft-card">
            <img src="ImageServlet?name=<%= s.getImageUrl() %>" 
                 class="soft-img" 
                 onerror="this.src='https://via.placeholder.com/50?text=App'">
          
            <div class="soft-details">
                <h3><%= s.getTitle() %></h3>
                <p><%= s.getContent() %></p>
                
                <% if (!finalLink.isEmpty()) { %>
                    <a href="<%= finalLink %>" target="_blank" class="download-link">
                        <i class="fas fa-download"></i> Get Software
                    </a>
                <% } else { %>
                    <span class="download-link" style="color:#bbb; cursor:not-allowed;">
                        <i class="fas fa-link-slash"></i> No Link
                    </span>
                <% } %>
            </div>

            <div class="actions">
                <a href="SoftwareServlet?action=edit&id=<%= s.getCheatSheetId() %>" class="btn-edit" title="Edit">
                    <i class="fas fa-pen"></i>
                </a>            
                
                <form action="SoftwareServlet" method="post" style="margin:0;" onsubmit="return confirm('ဖျက်မှာ သေချာလား?')">
                    <input type="hidden" name="id" value="<%= s.getCheatSheetId() %>">
                    <input type="hidden" name="action" value="delete">
                    <button type="submit" class="btn-delete" title="Delete">
                        <i class="fas fa-trash-alt"></i>
                    </button>
                </form>
            </div>
        </div>
        <%      
                } 
            } else { 
        %>
            <div class="empty-state">
                <i class="fas fa-inbox fa-2x" style="margin-bottom: 10px;"></i>
                <p>ဒေတာ မရှိသေးပါ။</p>
            </div>
        <% } %>
    </div>
</body>
</html>