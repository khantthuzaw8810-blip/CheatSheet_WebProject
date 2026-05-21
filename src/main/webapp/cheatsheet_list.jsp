<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.URLEncoder, java.util.List, com.cheatsheet.model.CheatSheet" %>
<%
    // ၁။ Session ထဲကနေ လက်ရှိ Login ဝင်ထားသည့် Username နှင့် Role ကို ဆွဲထုတ်ခြင်း
    String sessionUser = (String) session.getAttribute("username");
    String userRole = (String) session.getAttribute("role"); 
    if (userRole == null) {
        userRole = "user"; // မရှိပါက ပုံမှန် user ဟု ကာကွယ်သတ်မှတ်ခြင်း
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Cheat Sheets Dashboard</title>
    <link class="preload" rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root { 
            --primary-blue: #0a3d62; 
            --accent-blue: #3c6382;
            --light-blue: #e1f5fe; 
            --bg: #ffffff; 
            --card-bg: #f8fafc; 
            --text-main: #2f3640;
            --text-sub: #7f8c8d;
            --action-edit: #0984e3;
            --action-delete: #d63031;
            --shadow: 0 6px 15px rgba(0, 0, 0, 0.04); 
            --border-line: #e2e8f0; 
        }

        /* Dark Mode (မူလအတိုင်း အပြည့်အစုံထိန်းသိမ်းထားပါသည်) */
        body.dark-mode {
            --bg: #121212;
            --card-bg: #1e1e1e;
            --text-main: #e0e0e0;
            --text-sub: #aaaaaa;
            --light-blue: #2c3e50;
            --border-line: #333333;
            --shadow: 0 10px 25px rgba(0,0,0,0.3);
        }

        body { 
            font-family: 'Inter', 'Segoe UI', Arial, sans-serif; 
            background-color: var(--bg); 
            margin: 0; 
            color: var(--text-main); 
            transition: background-color 0.3s, color 0.3s;
        }
        
        .top-nav { 
            background: var(--primary-blue); 
            color: white; 
            padding: 0 50px; 
            height: 70px;
            display: flex; 
            justify-content: space-between; 
            align-items: center;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .btn-home {
            background: rgba(255, 255, 255, 0.1);
            color: white;
            padding: 10px 22px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            display: flex;
            align-items: center; gap: 10px; transition: all 0.3s;
            border: 1px solid rgba(255,255,255,0.2);
        }

        .btn-home:hover {
            background: white;
            color: var(--primary-blue);
            transform: translateY(-2px);
        }

        .container { padding: 40px; max-width: 1100px; margin: auto; }
        
        .header-section { 
            margin-bottom: 35px; 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
        }

        body.dark-mode h2 { color: #54a0ff; }
        h2 { font-size: 32px; margin: 0; color: var(--primary-blue); font-weight: 800; letter-spacing: -1px; }
        .desc { color: var(--text-sub); margin-top: 6px; font-size: 15px; font-weight: 400; }

        .btn-add {
            background: var(--action-edit);
            color: white;
            padding: 11px 22px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            transition: 0.3s;
            box-shadow: 0 4px 15px rgba(9, 132, 227, 0.3);
            font-size: 14px;
        }

        .btn-add:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(9, 132, 227, 0.4);
            filter: brightness(1.1);
        }

        .grid { 
            display: grid; 
            grid-template-columns: repeat(3, 1fr); 
            gap: 30px; 
        }

        .card { 
            background: var(--card-bg); 
            border-radius: 16px; 
            overflow: hidden;
            box-shadow: var(--shadow); 
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            display: flex; 
            flex-direction: column;
            border: 1px solid #cbd5e1; 
            height: 295px; 
            position: relative;
        }

        .card:hover { 
            transform: translateY(-6px);
            box-shadow: 0 12px 24px rgba(0,0,0,0.08); 
            border-color: var(--action-edit); 
        }

        .card-img { width: 100%; height: 135px; object-fit: cover; }
        
        .no-preview { 
            background: linear-gradient(135deg, #cbd5e1 0%, #94a3b8 100%); 
            height: 135px; 
            display: flex; align-items: center; justify-content: center; color: white; flex-direction: column; gap: 8px; 
        }
        .no-preview i { font-size: 28px; }

        .card-body { padding: 18px; flex-grow: 1; display: flex; flex-direction: column; justify-content: space-between; }
        body.dark-mode .card h3 { color: #54a0ff; }
        
        .card h3 { 
            margin: 0 0 6px 0; 
            color: var(--primary-blue); 
            font-size: 17px; 
            font-weight: 700;
            display: -webkit-box;
            -webkit-line-clamp: 1;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .card p { 
            display: none !important; 
        }

        .meta-info { 
            margin-top: auto; 
            padding-top: 10px; 
            border-top: 1px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
            font-size: 12px; 
            color: var(--text-sub); 
            font-weight: 500;
        }

        .card-footer { padding: 0 18px 18px; }
        .actions { display: flex; gap: 8px; }
        
        .btn { 
            flex: 1; padding: 8px; border-radius: 8px; border: none; cursor: pointer; font-size: 13px; font-weight: 600;
            text-decoration: none; display: inline-flex; align-items: center; gap: 6px; justify-content: center; transition: 0.3s;
        }

        .btn-edit { background: var(--light-blue); color: var(--action-edit); }
        .btn-edit:hover { background: var(--action-edit); color: white; }
        
        .btn-delete { background: #fff5f5; color: var(--action-delete); }
        body.dark-mode .btn-delete { background: #442020; }
        .btn-delete:hover { background: var(--action-delete); color: white; }

        .btn-approve { background: #e2fbf0; color: #2ed573; }
        .btn-approve:hover { background: #2ed573; color: white; }

        /* PENDING ဖြစ်နေစဉ် ခလုတ်များအား နှိပ်မရအောင် တားဆီးသည့် CSS */
        .btn-disabled {
            opacity: 0.5;
            pointer-events: none;
            cursor: not-allowed;
        }

        @media (max-width: 992px) {
            .grid { grid-template-columns: repeat(2, 1fr); gap: 25px; }
        }

        @media (max-width: 768px) {
            .container { padding: 20px; }
            .top-nav { padding: 0 20px; }
            .header-section { flex-direction: column; align-items: flex-start; gap: 15px; }
            .btn-add { width: 100%; justify-content: center; }
            .grid { grid-template-columns: 1fr; }
        }
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

    <nav class="top-nav">
        <a href="success.jsp" class="btn-home">
            <i class="fas fa-th-large"></i> Home
        </a>
        <div style="font-weight: 700; font-size: 18px; letter-spacing: 1px; opacity: 0.9;">
            <i class="fas fa-shield-halved"></i> SYSTEM USER
        </div>
    </nav>

    <div class="container">
        <div class="header-section">
            <div>
                <h2>Manage Cheat Sheets</h2>
                <p class="desc">Digital library for programming resources and developer guides.</p>
            </div>
            <a href="cheatsheet_form.jsp" class="btn-add">
                <i class="fas fa-plus"></i> Add New Resource
            </a>
        </div>

        <div class="grid">
            <%
                List<CheatSheet> sheets = (List<CheatSheet>) request.getAttribute("cheatSheets");
                if (sheets == null) {
                    sheets = (List<CheatSheet>) request.getAttribute("cheatList");
                }
                
                if (sheets != null && !sheets.isEmpty()) {
                    for (CheatSheet s : sheets) {
                        
                        boolean isPending = "PENDING".equalsIgnoreCase(s.getStatus());
                        boolean isAdmin = "admin".equalsIgnoreCase(userRole);
                        boolean isOwner = (sessionUser != null && sessionUser.equalsIgnoreCase(s.getCreatedBy()));
                        
                        // 🚀 🎯 [ပြင်ဆင်လိုက်သည့်နေရာ - ကတ်တစ်ခုလုံးအား Click တားဆီးခြင်း Logic]
                        String cardStyle = "";
                        String clickAction = "window.location='ViewCheatServlet?id=" + s.getCheatSheetId() + "'";
                        
                        if (isPending) {
                            if (isAdmin) {
                                // Admin ဖြစ်ပါက ကတ်ကို နှိပ်ခွင့်ပေးမည် (Approve လုပ်ရန်အတွက်)
                                cardStyle = "border-style: dashed; border-color: #ff9f43;";
                            } else {
                                // 🚀 Admin မဟုတ်ပါက (ဘယ်သူပဲဖြစ်ဖြစ်) ကတ်တစ်ခုလုံးကို လုံးဝနှိပ်လို့မရအောင်၊ Pointer မပေါ်အောင် ပိတ်ပစ်မည်
                                cardStyle = "border-style: dashed; border-color: #ff9f43; opacity: 0.55; pointer-events: none; cursor: not-allowed;";
                                clickAction = "return false;";
                            }
                        }
            %>
            <div class="card" onclick="<%= clickAction %>" style="<%= cardStyle %>">
                
                <% if (isPending) { %>
                    <div style="position: absolute; top: 12px; right: 12px; background: #ff9f43; color: white; padding: 5px 10px; border-radius: 20px; font-size: 11px; font-weight: 700; z-index: 10; box-shadow: 0 4px 10px rgba(255,159,67,0.3);">
                        <i class="fas fa-clock"></i> PENDING
                    </div>
                <% } %>

                <%
                    String imgName = s.getImageUrl();
                    if (imgName != null && !imgName.trim().isEmpty()) {
                        String encoded = URLEncoder.encode(imgName, "UTF-8");
                %>
                    <img src="<%= request.getContextPath() %>/ImageServlet?name=<%= encoded %>" class="card-img"
                         onerror="this.src='https://via.placeholder.com/400x210/3c6382/ffffff?text=Image+Missing';" alt="Cheat Sheet" />
                <%
                    } else {
                %>
                    <div class="no-preview">
                        <i class="fas fa-code-branch fa-2x"></i>
                        <span style="font-weight:600; font-size:12px; letter-spacing:1px;">NO PREVIEW</span>
                    </div>
                <%
                    }
                %>

                <div class="card-body">
                    <h3><%= s.getTitle() %></h3>
                    
                    <p>
                        <%= s.getContent() != null && s.getContent().length() > 95 ? s.getContent().substring(0,95) + "..." : (s.getContent() == null ? "Description not provided for this item." : s.getContent()) %>
                    </p>

                    <div class="meta-info">
                        <span><i class="fas fa-tag"></i> Cat <%= s.getCategoryId() %></span>
                        <span><i class="fas fa-user"></i> By: <%= s.getCreatedBy() != null ? s.getCreatedBy() : "Unknown" %></span>
                    </div>
                </div>

                <div class="card-footer">
                    <div class="actions">
                        <% 
                            if (isAdmin) { 
                                // က။ Admin ဖြစ်ပါက -> Approve ပေးခွင့်၊ Edit / Delete အပြည့်အဝ ရှိရမည်။
                                if (isPending) { 
                        %>
                                <a href="CheatSheetActionServlet?action=approve&id=<%= s.getCheatSheetId() %>" class="btn btn-approve" onclick="event.stopPropagation();">
                                    <i class="fas fa-check"></i> Approve
                                </a>
                        <%      } %>
                                <form action="<%= request.getContextPath() %>/CheatSheetDetailServlet" method="get" style="flex:1; margin:0;">
                                    <input type="hidden" name="id" value="<%= s.getCheatSheetId() %>" />
                                    <button type="submit" class="btn btn-edit" onclick="event.stopPropagation();">
                                        <i class="fas fa-edit"></i> Edit
                                    </button>
                                </form>
                                <form action="<%= request.getContextPath() %>/CheatSheetServlet" method="post" onsubmit="return confirm('Are you sure you want to delete this resource?');" style="flex:1; margin:0;">
                                    <input type="hidden" name="id" value="<%= s.getCheatSheetId() %>" />
                                    <input type="hidden" name="action" value="delete" />
                                    <button type="submit" class="btn btn-delete" onclick="event.stopPropagation();">
                                        <i class="fas fa-trash-alt"></i> Delete
                                    </button>
                                </form>

                        <% 
                            } else if (isOwner) { 
                                // ခ။ တင်သည့် User (Owner) မိမိကိုယ်တိုင်ဖြစ်ပါက -> Edit / Delete ကို ပြသမည်။
                                // သို့သော် PENDING ဖြစ်နေစဉ်တွင် နှိပ်၍မရအောင် Disable ချုပ်ထားမည်။
                                String disableClass = isPending ? "btn-disabled" : "";
                        %>
                                <form action="<%= request.getContextPath() %>/CheatSheetDetailServlet" method="get" style="flex:1; margin:0;" class="<%= disableClass %>">
                                    <input type="hidden" name="id" value="<%= s.getCheatSheetId() %>" />
                                    <button type="submit" class="btn btn-edit" onclick="event.stopPropagation();" <%= isPending ? "disabled" : "" %>>
                                        <i class="fas fa-edit"></i> Edit
                                    </button>
                                </form>
                                <form action="<%= request.getContextPath() %>/CheatSheetServlet" method="post" onsubmit="return confirm('Are you sure you want to delete this resource?');" style="flex:1; margin:0;" class="<%= disableClass %>">
                                    <input type="hidden" name="id" value="<%= s.getCheatSheetId() %>" />
                                    <input type="hidden" name="action" value="delete" />
                                    <button type="submit" class="btn btn-delete" onclick="event.stopPropagation();" <%= isPending ? "disabled" : "" %>>
                                        <i class="fas fa-trash-alt"></i> Delete
                                    </button>
                                </form>

                        <% 
                            } else { 
                                // ဂ။ တင်တဲ့သူလည်းမဟုတ်၊ Admin လည်းမဟုတ်သည့် (အခြားသူများ) အတွက် -> View Resource သာ ပြသမည်။
                        %>
                                <a href="ViewCheatServlet?id=<%= s.getCheatSheetId() %>" class="btn btn-edit" style="width: 100%;" onclick="event.stopPropagation();">
                                    <i class="fas fa-eye"></i> View Resource
                                </a>
                        <% 
                            } 
                        %>
                    </div>
                </div>
            </div>
            <%      }
                } else { %>
                <div style="grid-column: 1/-1; text-align: center; padding: 100px; background: var(--card-bg); border-radius: 25px; box-shadow: var(--shadow);">
                    <i class="fas fa-folder-open fa-4x" style="color:#dfe6e9; margin-bottom:25px;"></i>
                    <p style="color:#b2bec3; font-size:20px; font-weight:500;">No resources found in the database.</p>
                </div>
           <% } %>
        </div>
    </div>
</body>
</html>