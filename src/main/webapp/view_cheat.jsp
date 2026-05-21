<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.URLEncoder, com.cheatsheet.model.CheatSheet" %>
<%
    // ၁။ Session စစ်ဆေးခြင်း (မူလအတိုင်း)
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // ၂။ Servlet က ပို့ပေးလိုက်တဲ့ CheatSheet Object ကို ဖတ်ခြင်း
    // (Servlet အမျိုးမျိုးကြောင့် Attribute Name ကွဲလွဲနေပါက အမှားမတက်အောင် ညှိယူခြင်း)
    CheatSheet cheat = (CheatSheet) request.getAttribute("cheat");
    if (cheat == null) {
        cheat = (CheatSheet) request.getAttribute("sheet");
    }
    if (cheat == null) {
        cheat = (CheatSheet) request.getAttribute("edu");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title><%= cheat != null ? cheat.getTitle() : "Cheat Sheet Detail" %></title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* ညီလေးရဲ့ မူလ ဒုတိယဖိုင်ထဲက CSS စတိုင်များ (လုံးဝမပြောင်းလဲပါ) */
        body {
            margin: 0;
            padding: 0;
            background-color: #f5f6fa; 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #2f3640;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .top-bar {
            padding: 30px 40px 10px 40px;
            background-color: #f5f6fa; 
            max-width: 900px;
            width: 100%;
            margin: 0 auto;
            box-sizing: border-box;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #0984e3;
            text-decoration: none;
            font-weight: 600;
            font-size: 16px;
            cursor: pointer;
            transition: color 0.2s;
        }
        .back-link:hover {
            color: #00a8ff;
            text-decoration: underline;
        }

        .container {
            max-width: 900px;
            width: 100%;
            margin: 10px auto 50px auto; 
            background: #ffffff; 
            padding: 40px;
            border-radius: 16px; 
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.06); 
            box-sizing: border-box;
        }

        .cheat-header {
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid #f1f2f6;
        }

        .cheat-header h1 {
            font-size: 28px;
            margin: 0 0 8px 0;
            color: #0a3d62;
            font-weight: 700;
        }

        .cheat-header .meta-info {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            color: #7f8c8d;
            font-size: 14px;
            font-weight: 500;
            align-items: center;
        }

        .cheat-header .category-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background-color: #e1f5fe;
            color: #0288d1;
            padding: 4px 12px;
            border-radius: 20px;
        }

        /* 🚀 🎯 (ထပ်ပေါင်းထည့်သည့် CSS) - ပထမဖိုင်မှ Meta Info အလှဆင်စတိုင်ကို မူလ Badge ပုံစံနှင့် ကိုက်ညီအောင် ပေါင်းစပ်ခြင်း */
        .user-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background-color: #e8f4fd;
            color: #0984e3;
            padding: 4px 12px;
            border-radius: 20px;
        }
        
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background-color: #fff3cd;
            color: #856404;
            padding: 4px 12px;
            border-radius: 20px;
        }

        .img-container {
            width: 96px;
            height: 96px;
            border-radius: 8px;
            overflow: hidden;
            border: 1px solid #e1e8ed;
            margin-bottom: 25px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            background: #fafafa;
        }
        
        .img-container img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        /* 🚀 🎯 (ပေါင်းစပ်ထားသည့် Code Block) - ပထမဖိုင်မှ မျက်စိအေးစေမည့် Dark Mode စတိုင် Content Box အတိုင်း ထားရှိပါသည် */
        .content-area {
            background: #1e293b;
            color: #f8fafc;
            padding: 25px;
            border-radius: 12px;
            font-family: 'Consolas', 'Courier New', monospace;
            font-size: 15px;
            line-height: 1.7;
            white-space: pre-wrap; 
            word-break: break-all;
            overflow-x: auto;
            box-shadow: inset 0 2px 8px rgba(0,0,0,0.2);
        }
    </style>
</head>
<body>

    <div class="top-bar">
        <a href="CheatSheetListServlet" class="back-link">
            <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
        </a>
    </div>

    <div class="container">
        
        <% if (cheat != null) { %>
            <div class="cheat-header">
                <h1><%= cheat.getTitle() %></h1>
                <div class="meta-info">
                    <span class="category-badge">
                        <i class="fa-solid fa-tag"></i> Category ID: <%= cheat.getCategoryId() %>
                    </span>
                    
                    <span class="user-badge">
                        <i class="fas fa-user-edit"></i> Created By: <strong><%= cheat.getCreatedBy() != null ? cheat.getCreatedBy() : "Unknown" %></strong>
                    </span>

                    <span class="status-badge">
                        <i class="fas fa-info-circle"></i> Status: <%= cheat.getStatus() != null ? cheat.getStatus() : "PENDING" %>
                    </span>

                    <% if (cheat.getUpdatedAt() != null) { %>
                        <span><i class="fa-solid fa-calendar-days"></i> Updated: <%= cheat.getUpdatedAt() %></span>
                    <% } %>
                </div>
            </div>

            <% 
                if (cheat.getImageUrl() != null && !cheat.getImageUrl().trim().isEmpty()) {
                    String encodedImage = URLEncoder.encode(cheat.getImageUrl(), "UTF-8");
            %>
                <div class="img-container">
                    <img src="ImageServlet?name=<%= encodedImage %>" alt="Resource Image">
                </div>
            <% 
                } 
            %>

            <div class="content-area"><% 
                if (cheat.getContent() != null) {
                    String cleanContent = cheat.getContent()
                        .replace("<", "&lt;")
                        .replace(">", "&gt;");
                    out.print(cleanContent);
                } else {
                    out.print("No content available.");
                }
            %></div>
            
        <% } else { %>
            <div style="text-align: center; padding: 60px 0;">
                <i class="fas fa-exclamation-triangle fa-3x" style="color: #ef4444; margin-bottom: 15px;"></i>
                <p style="font-size: 18px; font-weight: 600; color: #64748b;">No data found for this ID!</p>
            </div>
        <% } %>

    </div>

</body>
</html>