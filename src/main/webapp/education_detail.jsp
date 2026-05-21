<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.URLEncoder, com.cheatsheet.model.CheatSheet" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    // Servlet က ပို့ပေးလိုက်တဲ့ Object ကို ဖတ်မယ်
    CheatSheet eduData = (CheatSheet) request.getAttribute("eduData");
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= eduData != null ? eduData.getTitle() : "View Education Detail" %></title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { 
            --primary-blue: #0a3d62; 
            --bg: #f5f6fa; 
            --card-bg: #ffffff;
            --text-main: #2f3640;
            --text-sub: #7f8c8d;
            --border-line: #f1f2f6;
        }
        body {
            font-family: 'Inter', 'Segoe UI', sans-serif;
            background-color: var(--bg);
            margin: 0;
            color: var(--text-main);
        }
        .container {
            max-width: 800px;
            margin: 40px auto;
            padding: 0 20px;
        }
        .view-card {
            background: var(--card-bg);
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            border: 1px solid var(--border-line);
        }
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #0984e3;
            text-decoration: none;
            font-weight: 600;
            margin-bottom: 25px;
            cursor: pointer;
        }
        .header-section {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 25px;
        }
        .img-box-small {
            width: 96px;       
            height: 96px;
            flex-shrink: 0;    
        }
        .img-box-small img {
            width: 100%;
            height: 100%;
            object-fit: cover; 
            border-radius: 12px;
            border: 1px solid var(--border-line);
        }
        .header-text {
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        h1 {
            font-size: 24px;
            margin: 0 0 6px 0;
            color: var(--primary-blue);
            font-weight: 700;
        }
        .meta {
            color: var(--text-sub);
            font-size: 13px;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .content-view {
            font-family: 'Consolas', 'Fira Code', Monaco, monospace;
            font-size: 15px; 
            line-height: 1.7;
            white-space: pre-wrap;
            background: var(--bg);
            padding: 25px;
            border-radius: 12px;
            border: 1px solid var(--border-line);
            color: var(--text-main);
            box-sizing: border-box;
            word-break: break-word;
        }
    </style>
    <script>
        function goBack() { window.history.back(); }
    </script>
</head>
<body>

    <div class="container">
        <a onclick="goBack()" class="back-link">
            <i class="fa-solid fa-arrow-left"></i> Back to List
        </a>

        <div class="view-card">
            <div class="header-section">
                <% 
                    if (eduData != null && eduData.getImageUrl() != null && !eduData.getImageUrl().trim().isEmpty()) {
                        String encoded = URLEncoder.encode(eduData.getImageUrl(), "UTF-8");
                %>
                    <div class="img-box-small">
                        <img src="<%= request.getContextPath() %>/ImageServlet?name=<%= encoded %>" alt="Resource">
                    </div>
                <% 
                    } 
                %>

                <div class="header-text">
                    <h1><%= eduData != null ? eduData.getTitle() : "No Title" %></h1>
                    <div class="meta">
                        <i class="fa-solid fa-clock"></i> Updated: <%= eduData != null ? eduData.getUpdatedAt() : "" %>
                    </div>
                </div>
            </div>
            
            <div class="content-view"><%= eduData != null ? eduData.getContent() : "No content available." %></div>
        </div>
    </div>

</body>
</html>