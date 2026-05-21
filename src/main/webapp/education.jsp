<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.cheatsheet.model.Education" %>
<%
    String sessionUser = (String) session.getAttribute("username");
    String userRole = (String) session.getAttribute("role"); 
    if (userRole == null) {
        userRole = "user"; 
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Education Section</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bg-body: #f4f7f6;
            --bg-card: #ffffff; 
            --card-border: rgba(0, 91, 234, 0.14); 
            --card-shadow: rgba(165, 180, 203, 0.35); 
            --txt-main: #2c3e50;
            --txt-sub: #7f8c8d;
            --border: #eaedf1;
            --footer: #f8fafc;
        }

        body.dark-mode {
            --bg-body: #121212;
            --bg-card: #1e1e1e;
            --card-border: rgba(255, 255, 255, 0.08);
            --card-shadow: rgba(0, 0, 0, 0.5);
            --txt-main: #e0e0e0;
            --txt-sub: #aaa;
            --border: #333;
            --footer: #252525;
        }

        body { 
            margin: 0; 
            font-family: 'Segoe UI', sans-serif; 
            background: var(--bg-body); 
            color: var(--txt-main); 
            transition: 0.3s; 
        }
        
        .home-nav { position: fixed; top: 20px; left: 20px; z-index: 1000; }
        .home-btn { 
            background: var(--bg-card); 
            padding: 10px 15px; border-radius: 8px; 
            text-decoration: none; color: #005bea; font-weight: bold;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1); display: flex; align-items: center; gap: 8px;
        }

        .main-container { max-width: 1200px; margin: 80px auto 40px auto; padding: 0 20px; }
        
        .header { 
            background: var(--bg-card); 
            padding: 20px; border-radius: 10px; 
            display: flex; justify-content: space-between; align-items: center; 
            box-shadow: 0 2px 5px rgba(0,0,0,0.05); margin-bottom: 30px; 
        }

        .grid { 
            display: grid; 
            grid-template-columns: repeat(auto-fill, minmax(240px, 1fr)); 
            gap: 35px; 
        }
        
        .card { 
            background: var(--bg-card); 
            border-radius: 14px; 
            overflow: hidden; 
            border: 1px solid var(--card-border);
            box-shadow: 0 8px 24px var(--card-shadow); 
            transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1); 
            display: flex;
            flex-direction: column;
            height: 275px; 
            box-sizing: border-box;
            position: relative; 
        }
        
        .card:hover { 
            transform: translateY(-8px); 
            box-shadow: 0 12px 32px rgba(0, 91, 234, 0.2); 
            border-color: #005bea;
        }
        
        .card-completely-disabled {
            opacity: 0.55;
            pointer-events: none; 
            cursor: not-allowed;
            user-select: none;
        }

        .card-link {
            text-decoration: none;
            color: inherit;
            display: flex;
            flex-direction: column;
            flex: 1; 
            overflow: hidden;
            position: relative;
            z-index: 1;
        }
        
        .card-img { width: 100%; height: 110px; object-fit: cover; flex-shrink: 0; }
        
        .card-body { 
            padding: 12px 15px; 
            display: flex;
            flex-direction: column;
            flex: 1;
            justify-content: space-between; 
            overflow: hidden;
        }
        
        .card-body h3 { 
            color: var(--txt-main); 
            margin-top: 0; 
            margin-bottom: 4px;
            font-size: 15px;
            font-weight: 600;
            line-height: 1.4;
            display: -webkit-box;
            -webkit-line-clamp: 2; 
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
            word-wrap: break-word;
            word-break: break-all; 
        }

        /* 🔒 Security အရ Card အပြင်ဘက်တွင် စာသားများဖျောက်ရန် စတိုင် */
        .secure-text {
            font-size: 12px;
            color: var(--txt-sub);
            margin: 5px 0;
            font-style: italic;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .card-meta-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 11px;
            font-weight: 600;
            flex-shrink: 0;
            margin-top: auto; 
        }
        
        .card-category {
            color: #005bea; 
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .card-author {
            color: var(--txt-sub);
            display: flex;
            align-items: center;
            gap: 5px;
            max-width: 100px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        
        .card-footer { 
            padding: 8px 15px; 
            background: var(--footer); 
            display: flex; 
            gap: 10px; 
            border-top: 1px solid var(--border); 
            flex-shrink: 0; 
            height: 45px; 
            box-sizing: border-box;
            position: relative;
            z-index: 5; 
        }

        .btn { padding: 4px; border-radius: 5px; text-decoration: none; text-align: center; flex: 1; font-size: 12px; font-weight: bold; display: flex; align-items: center; justify-content: center; }
        .btn-edit { background: #e3f2fd; color: #1976d2; }
        .btn-del { background: #ffebee; color: #d32f2f; }
        .add-btn { background: #27ae60; color: white; padding: 10px 20px; border-radius: 5px; text-decoration: none; }
        
        .btn-approve { background: #e2fbf0; color: #2ed573; }
        .btn-approve:hover { background: #2ed573; color: white; }
    </style>

    <script>
        (function() {
            const savedTheme = localStorage.getItem('theme') || localStorage.getItem('darkMode');
            if (savedTheme === 'dark' || savedTheme === 'enabled') {
                document.documentElement.classList.add('dark-mode');
                document.addEventListener("DOMContentLoaded", function() {
                    document.body.classList.add('dark-mode');
                });
            }
        })();
    </script>
</head>
<body>

    <div class="home-nav">
        <a href="DashboardServlet" class="home-btn"><i class="fas fa-home"></i> Home</a>
    </div>

    <div class="main-container">
        <div class="header">
            <h2>🎓 Education Section</h2>
            <a href="add-education.jsp" class="add-btn">+ Add New Content</a>
        </div>

        <div class="grid">
            <%
                List<Education> eduList = (List<Education>) request.getAttribute("eduList");
                if (eduList != null && !eduList.isEmpty()) {
                    for (Education e : eduList) {
                        
                        boolean isPending = "PENDING".equalsIgnoreCase(e.getStatus());
                        boolean isAdmin = "admin".equalsIgnoreCase(userRole);
                        boolean isOwner = (sessionUser != null && sessionUser.equalsIgnoreCase(e.getCreatedBy()));
                        
                        String cardStateClass = "";
                        String cardStyle = "";
                        String clickAction = "window.location='ViewEducationServlet?id=" + e.getId() + "'";
                        
                        if (isPending) {
                            if (isAdmin) {
                                cardStyle = "border-style: dashed; border-color: #ff9f43;";
                            } else {
                                cardStateClass = "card-completely-disabled"; 
                                clickAction = "return false;";
                            }
                        }
            %>
            
            <div class="card <%= cardStateClass %>" style="<%= cardStyle %>">
                
                <% if (isPending) { %>
                    <div style="position: absolute; top: 10px; right: 10px; background: #ff9f43; color: white; padding: 4px 8px; border-radius: 20px; font-size: 10px; font-weight: 700; z-index: 10; box-shadow: 0 4px 8px rgba(255,159,67,0.3);">
                        <i class="fas fa-clock"></i> PENDING
                    </div>
                <% } %>
                
                <a href="#" onclick="<%= clickAction %>; return false;" class="card-link">
                    <% 
                        String imgUrl = e.getImageUrl();
                        if (imgUrl != null && imgUrl.length() < 150 && !imgUrl.contains("<%")) { 
                    %>
                        <img src="ImageServlet?name=<%= imgUrl %>" class="card-img" onerror="this.src='https://via.placeholder.com/300x180?text=No+Image'">
                    <% } else { %>
                        <img src="https://via.placeholder.com/300x180?text=No+Image" class="card-img">
                    <% } %>
                    
                    <div class="card-body">
                        <h3><%= (e.getTitle() != null && !e.getTitle().isEmpty()) ? e.getTitle() : "Untitled Content" %></h3>
                        
                        <p class="secure-text"><i class="fas fa-lock"></i> Click 'View' to read full content</p>
                        
                        <div class="card-meta-row">
                            <span class="card-category">
                                <i class="fas fa-tag"></i> 
                                <%= (e.getCategory() != null && !e.getCategory().isEmpty()) ? e.getCategory() : "No Category" %>
                            </span>
                            <span class="card-author" title="Posted by: <%= e.getCreatedBy() %>">
                                <i class="fas fa-user"></i> 
                                By: <%= (e.getCreatedBy() != null && !e.getCreatedBy().isEmpty()) ? e.getCreatedBy() : "Unknown" %>
                            </span>
                        </div>
                    </div>
                </a> 
                
                <div class="card-footer">
                    <% 
                        if (isAdmin) { 
                            // 👑 ၁။ Admin ဝင်ကြည့်လျှင် လုပ်ဆောင်နိုင်မည့် လုပ်ငန်းစဉ်
                            if (isPending) { 
                    %>
                            <a href="EducationList?action=approve&id=<%= e.getId() %>" class="btn btn-approve">Approve</a>
                    <%      } %>
                            <a href="EducationAction?action=edit&id=<%= e.getId() %>" class="btn btn-edit">Edit</a>
                            <a href="EducationAction?action=delete&id=<%= e.getId() %>" class="btn btn-del" onclick="return confirm('သေချာလား?')">Delete</a>
                    <% 
                        } else { 
                            // 👤 ၂။ ရိုးရိုး User များ ဝင်ကြည့်လျှင် တွေ့ရမည့် စနစ်သစ် Logic
                            if (isOwner) { 
                                // မိမိကိုယ်တိုင် တင်ထားသော ကတ်ပြား (Owner) ဖြစ်ခဲ့လျှင်
                                if (!isPending) { 
                                    // Admin Approve လုပ်ပြီးမှသာ Edit, Delete ကို လင်းပေးမည်
                    %>
                                    <a href="EducationAction?action=edit&id=<%= e.getId() %>" class="btn btn-edit">Edit</a>
                                    <a href="EducationAction?action=delete&id=<%= e.getId() %>" class="btn btn-del" onclick="return confirm('သေချာလား?')">Delete</a>
                    <% 
                                } else { 
                                    // ကိုယ်တိုင်တင်ထားသော်လည်း Approve မရသေးလျှင် ခလုတ်များအား မှိန်ထားမည်
                    %>
                                    <span class="btn btn-edit" style="opacity: 0.4; cursor: not-allowed; background: #eaedf1; color: #7f8c8d;" title="Admin Approve လုပ်သည်အထိ စောင့်ဆိုင်းပေးပါ">Edit</span>
                                    <span class="btn btn-del" style="opacity: 0.4; cursor: not-allowed; background: #eaedf1; color: #7f8c8d;">Delete</span>
                    <% 
                                }
                            } else { 
                                // 🔒 တင်ထားသည့် Owner မဟုတ်သော ကျန်သည့်လူများအားလုံးအတွက် "View" တစ်လုံးတည်းသာ နေရာအပြည့်ဖြင့် ပေါ်စေမည်
                    %>
                                <a href="ViewEducationServlet?id=<%= e.getId() %>" class="btn btn-edit" style="width: 100%; background: #005bea; color: white;">View</a>
                    <% 
                            } 
                        } 
                    %>
                </div>
            </div>
            <% } } else { %>
                <div style="grid-column: 1/-1; text-align: center; padding: 50px;">
                     <p style="color: var(--txt-sub);">ဒေတာ မရှိသေးပါ။</p>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>