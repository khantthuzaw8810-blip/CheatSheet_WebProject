<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 🎯 ၁။ Session ထဲကနေ လက်ရှိ Login ဝင်ထားတဲ့ username ကို အရင်ဆုံး အပြည့်အဝ ဆွဲယူပါမယ်
    String username = (String) session.getAttribute("username");

    // တကယ်လို့ တစ်ခုခုမှားယွင်းပြီး session မရှိခဲ့ရင် Login Form က ရိုက်ခဲ့တဲ့ parameter ကနေပါ Safe Check အနေနဲ့ ထပ်ဖတ်ထားပေးပါတယ်
    if (username == null || username.trim().isEmpty()) {
        username = request.getParameter("name");
    }

    // နာမည် လုံးဝမရှိရင် "Developer" လို့ ပြပေးထားပါမယ်
    if (username == null || username.trim().isEmpty()) {
        username = "Developer";
    }

    // 🎯 ၂။ နာမည်ကို Variable ထဲ သေချာသိမ်းပြီးမှ Session ကို စနစ်တကျ ဖျက်ဆီးပစ်ပါမယ် (ဒါမှ အောက်မှာ နာမည် မှန်မှန်ကန်ကန် ထွက်မှာပါ)
    session.invalidate();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Logging Out...</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* 🎯 Premium Dynamic Background (Setting mode နဲ့ အကိုက်ဖြစ်အောင် ညှိထားပါတယ်) */
        :root {
            --bg-color: #0f172a;
            --box-bg: rgba(30, 41, 59, 0.7);
            --text-color: #f8fafc;
            --accent-color: #38bdf8;
            --border-color: rgba(255, 255, 255, 0.1);
        }

        body.light-mode {
            --bg-color: #f1f5f9;
            --box-bg: rgba(255, 255, 255, 0.85);
            --text-color: #0f172a;
            --accent-color: #0284c7;
            --border-color: rgba(0, 0, 0, 0.05);
        }

        body {
            margin: 0;
            padding: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background: var(--bg-color);
            font-family: 'Segoe UI', system-ui, sans-serif;
            overflow: hidden;
            transition: background 0.5s ease;
        }

        /* ✨ Glassmorphism Premium Box Effect */
        .goodbye-box {
            background: var(--box-bg);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--border-color);
            padding: 40px 60px;
            border-radius: 24px;
            text-align: center;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
            animation: popIn 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards;
            max-width: 400px;
            width: 100%;
        }

        .icon-wrapper {
            font-size: 55px;
            color: var(--accent-color);
            margin-bottom: 20px;
            animation: wave 1.5s infinite ease-in-out;
            display: inline-block;
        }

        h1 {
            font-size: 28px;
            margin: 0 0 10px 0;
            color: var(--text-color);
            font-weight: 700;
            letter-spacing: -0.5px;
        }

        p {
            font-size: 15px;
            color: var(--text-color);
            opacity: 0.7;
            margin: 0 0 25px 0;
        }

        /* ⏳ Premium 2-Second Linear Progress Bar */
        .progress-container {
            width: 100%;
            height: 5px;
            background: var(--border-color);
            border-radius: 10px;
            overflow: hidden;
        }

        .progress-bar {
            width: 0%;
            height: 100%;
            background: var(--accent-color);
            box-shadow: 0 0 12px var(--accent-color);
            border-radius: 10px;
            animation: loadProgress 2s linear forwards;
        }

        /* 🎬 Smooth Animations */
        @keyframes popIn {
            0% { transform: scale(0.9) translateY(20px); opacity: 0; }
            100% { transform: scale(1) translateY(0); opacity: 1; }
        }

        @keyframes wave {
            0%, 100% { transform: rotate(0deg); }
            25% { transform: rotate(-15deg); }
            75% { transform: rotate(15deg); }
        }

        @keyframes loadProgress {
            0% { width: 0%; }
            100% { width: 100%; }
        }
    </style>
</head>
<body>

    <div class="goodbye-box">
        <div class="icon-wrapper">
            <i class="fa-solid fa-hand"></i>
        </div>
        <h1>See You, <%= username %>!</h1>
        <p>Safely signing out of your session...</p>
        
        <div class="progress-container">
            <div class="progress-bar"></div>
        </div>
    </div>

    <script>
        // Dashboard ရဲ့ Theme settings အတိုင်း Auto လိုက်ပြောင်းပေးခြင်း
        const savedTheme = localStorage.getItem('theme') || localStorage.getItem('darkMode');
        if (savedTheme !== 'dark' && savedTheme !== 'enabled') {
            document.body.classList.add('light-mode');
        }

        // ⏱ Progress Bar က ၂ စက္ကန့်မို့လို့ တိတိကျကျ ၂ စက္ကန့် (2000ms) ပြည့်ရင် Login Page သို့ ခေါ်သွားမယ်
        setTimeout(function() {
            window.location.href = "<%= request.getContextPath() %>/login.jsp";
        }, 6000);
    </script>

</body>
</html>