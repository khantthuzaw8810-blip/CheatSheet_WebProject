<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.URLEncoder, com.cheatsheet.model.Education" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    Education edu = (Education) request.getAttribute("education");
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= edu != null ? edu.getTitle() : "View Education Content" %></title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* 🎨 Default: Light Mode Theme */
        :root { 
            --primary-blue: #0a3d62; 
            --bg: #f5f6fa; 
            --card-bg: #ffffff;
            --text-main: #2f3640;
            --text-sub: #7f8c8d;
            --border-line: #dcdde1;
            --content-bg: #f8f9fa;
        }

        /* 🌙 Dark Mode Theme */
        body.dark-mode {
            --bg: #121212; 
            --card-bg: #1e1e1e;
            --text-main: #e0e0e0;
            --text-sub: #aaa;
            --border-line: #333;
            --content-bg: #151515;
        }

        body {
            font-family: 'Inter', 'Segoe UI', sans-serif;
            background-color: var(--bg);
            margin: 0;
            color: var(--text-main);
            transition: background-color 0.3s, color 0.3s;
            min-height: 100vh; 
            display: flex;
            flex-direction: column;
        }

        .container {
            max-width: 95%;
            width: 100%;
            margin: 25px 0 25px 40px; 
            padding: 0 20px 0 0;
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
            flex: 1;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #3498db;
            text-decoration: none;
            font-weight: 600;
            margin-bottom: 15px;
            align-self: flex-start;
        }

        /* 🎯 ပြင်ပ Container */
        .view-card {
            background: transparent; 
            display: flex;
            flex-direction: column;
            gap: 25px; 
            width: 100%; 
            box-sizing: border-box;
        }
        
       /* 🎯 ဤနေရာတွင် ပုံရဲ့ Box ကို ၁ လက်မပတ်လည် (96px) သေးသေးလေးအဖြစ် ပြောင်းလဲလိုက်ပါသည် */
        .img-container {
            width: 96px;             /* 💡 1 inch = 96px ကွက်တိ */
            height: 96px;            /* 💡 အမြင့်ကိုပါ 96px သတ်မှတ်၍ ၁လက်မပတ်လည် စတုရန်းပုံစံလုပ်ခြင်း */
            margin: 0 0 15px 0;      /* အောက်က စာရွက်နဲ့ ခွာဖို့ မာဂျင်အနည်းငယ်သာ ချန်သည် */
            border-radius: 8px;      
            overflow: hidden;
            border: 1px solid var(--border-line);
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            background: var(--card-bg);
            flex-shrink: 0; 
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* 🎯 တကယ့် Image ဖိုင်ကို ၁ လက်မ ဘောင်ထဲ ကွက်တိဝင်အောင် ညှိပေးခြင်း */
        .img-container img {
            width: 100%;
            height: 100%;           
            display: block;
            object-fit: cover;       /* 🔥 ပုံမရှုံ့ဘဲ ဘောင်ထဲ ကွက်တိဖြတ်ညှိပေးမည့် စနစ် */
            object-position: center; 
        }

        /* 🎯 ဤနေရာသည် မျက်လှည့်ဆန်ဆန် စာမျက်နှာခွဲပေးမည့် CSS Container ဖြစ်သည် */
        .page-splitter {
            width: 100%;
            /* 💡 စာရွက်တစ်ရွက်စာ အကျယ်ကို ၁၀၀% ထားပြီး ဘေးတိုက်မထွက်အောင် ပိတ်ထားသည် */
            column-width: 100%; 
            column-gap: 0px;
            
            /* စာရွက်များ အောက်သို့သာ တန်းစီဆင်းသွားစေရန် အမြင့်ကို ကန့်သတ်ပေးခြင်း */
            height: auto; 
        }

        /* 🎯 တကယ့် စာရွက်တစ်ရွက်စာ (Paper Box) ပုံေသ အမြင့် သတ်မှတ်ချက် */
        .paper-page {
            background: var(--card-bg);
            padding: 35px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            border: 1px solid var(--border-line);
            margin-bottom: 30px; /* စာရွက်တစ်ရွက်ချင်းစီကြား အကွာအဝေး */
            
            font-family: 'Consolas', 'Fira Code', Monaco, monospace;
            font-size: 14px; 
            line-height: 1.6;
            white-space: pre-wrap;
            color: var(--text-main);
            text-align: left;
            box-sizing: border-box;
            word-break: break-word;
            
            /* စာရွက်တစ်ရွက်စီ၏ အမြင့်ကို ပုံသေ 500px ချုပ်လိုက်ခြင်း */
            height: 500px; 
            
            /* 💡 အဓိကအချက်: စာသားများ 500px ပြည့်ပါက နောက်စာရွက်အဖြစ် အောက်သို့ တွန်းပို့စေခြင်း */
            break-inside: avoid;
            page-break-inside: avoid;
        }
    </style>
    
    <script>
        function applySavedTheme() {
            const currentTheme = localStorage.getItem('theme') || localStorage.getItem('darkMode');
            if (currentTheme === 'dark' || currentTheme === 'enabled') {
                document.documentElement.classList.add('dark-mode');
                document.body.classList.add('dark-mode');
            } else {
                document.documentElement.classList.remove('dark-mode');
                document.body.classList.remove('dark-mode');
            }
        }
        document.addEventListener("DOMContentLoaded", applySavedTheme);
    </script>
</head>
<body>

    <div class="container">
        <a href="EducationList" class="back-link">
            <i class="fa-solid fa-arrow-left"></i> Back to List
        </a>

        <div class="view-card">
            <% 
                if (edu != null && edu.getImageUrl() != null && !edu.getImageUrl().trim().isEmpty()) {
                    String encoded = URLEncoder.encode(edu.getImageUrl(), "UTF-8");
            %>
                <div class="img-container">
                    <img src="<%= request.getContextPath() %>/ImageServlet?name=<%= encoded %>" alt="Resource Image">
                </div>
            <% 
                } 
            %>
            
            <div class="page-splitter">
                <div class="paper-page"><% 
                    if (edu != null && edu.getDescription() != null) {
                        // HTML ကုဒ်များကို Text အဖြစ် အန္တရာယ်ကင်းကင်း ပြောင်းလဲထုတ်ပြခြင်း
                        String cleanDescription = edu.getDescription()
                            .replace("<", "&lt;")
                            .replace(">", "&gt;");
                        out.print(cleanDescription);
                    } else {
                        out.print("No description available.");
                    }
                %></div>
            </div>
        </div>
    </div>

</body>
</html>