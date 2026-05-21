<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>User Login</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* 🎯 Dashboard ရဲ့ Theme ရောင်စုံ Palette */
        :root {
            --bg-main: #f4f6f9;
            --card-bg: #ffffff;
            --text-color: #333333;
            --text-sub: #555555;
            --border-color: #eeeeee;
            --input-bg: #f0f4ff; /* မင်းပုံထဲက အပြာနုရောင် Input ကွက် */
            --btn-green: linear-gradient(90deg, #28a745, #218838);
        }

        /* 🌗 Dark Mode အတွက် Variable များ */
        body.dark-mode {
            --bg-main: #121212;
            --card-bg: #1e1e1e;
            --text-color: #e0e0e0;
            --text-sub: #aaaaaa;
            --border-color: #333333;
            --input-bg: #2d2d2d;
        }

        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            background-color: var(--bg-main); 
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            transition: background-color 0.3s;
        }

        .login-box {
            width: 400px; 
            padding: 40px;
            background: var(--card-bg); 
            border-radius: 15px; /* Dashboard card တွေအတိုင်း 15px ညှိပေးထားပါတယ် */
            box-shadow: 0 4px 20px rgba(0,0,0,0.06); 
            border: 1px solid var(--border-color);
            transition: 0.3s;
        }

        h2 { 
            text-align: center; 
            margin-top: 0;
            margin-bottom: 30px; 
            color: var(--text-color); 
            font-size: 32px;
            font-weight: 700;
            letter-spacing: -0.5px;
        }

        label { 
            font-weight: 700; 
            display: block; 
            margin-top: 20px; 
            font-size: 14px;
            color: var(--text-color); 
        }

        input[type=text], input[type=password] {
            width: 100%; 
            padding: 12px 15px; 
            margin: 8px 0;
            border: 1px solid var(--border-color); 
            border-radius: 8px;
            background-color: var(--input-bg); 
            color: var(--text-color);
            font-size: 15px;
            box-sizing: border-box;
            transition: 0.3s;
        }

        /* Input ကိုနှိပ်လိုက်ရင် Dashboard ရဲ့ Modern Blue Variant Line လေး ထွက်လာအောင် */
        input[type=text]:focus, input[type=password]:focus {
            outline: none;
            border-color: #005bea;
            box-shadow: 0 0 8px rgba(0, 91, 234, 0.15);
        }

        .password-wrapper { 
            position: relative; 
        }

        /* 👁️ Eye Icon နေရာချထားမှု ပုံစံညှိချက် */
        .eye-icon {
            position: absolute; 
            right: 15px; 
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer; 
            color: var(--text-sub);
            font-size: 16px;
            transition: 0.3s;
        }
        .eye-icon:hover {
            color: #005bea;
        }

        /* 🟢 Login Button ကို မင်းပုံထဲက အစိမ်းရောင် ခလုတ်အတိုင်း Modern ဆန်ဆန် ပြင်ဆင်မှု */
        input[type=submit] {
            width: 100%; 
            padding: 14px; 
            background: var(--btn-green); 
            border: none; 
            border-radius: 8px; 
            color: #fff;
            font-weight: bold; 
            font-size: 16px;
            margin-top: 25px;
            cursor: pointer;
            transition: 0.3s;
            box-shadow: 0 4px 10px rgba(40, 167, 69, 0.2);
        }

        input[type=submit]:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 15px rgba(40, 167, 69, 0.3);
        }

        .error { 
            color: #dc3545; 
            text-align: center; 
            margin-top: 15px; 
            font-size: 14px;
            font-weight: 600;
        }

        /* 🟢 Password ချိန်းတာ အောင်မြင်ရင်ပြမယ့် Box လေးရဲ့ စတိုင်လ် */
        .success-box {
            background-color: rgba(16, 185, 129, 0.1);
            border-left: 4px solid #10b981;
            color: #10b981;
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 0 8px 8px 0;
            font-size: 14px;
            font-weight: 600;
            text-align: left;
        }
        
        /* Register link အတွက် */
        .footer-link {
            text-align: center;
            margin-top: 25px;
            font-size: 14px;
            color: var(--text-sub);
        }
        .footer-link a {
            color: #005bea;
            text-decoration: none;
            font-weight: 600;
            transition: 0.3s;
        }
        .footer-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="login-box">
        <h2>User Login</h2>

        <% if(session.getAttribute("loginSuccessMessage") != null) { %>
            <div class="success-box">
                <i class="fa-solid fa-circle-check" style="margin-right: 6px;"></i>
                <%= session.getAttribute("loginSuccessMessage") %>
            </div>
            <% session.removeAttribute("loginSuccessMessage"); %>
        <% } %>

        <form action="LoginServlet" method="post">
            <label>Username:</label>
            <input type="text" name="username" placeholder="Username" required />

            <label>Password:</label>
            <div class="password-wrapper">
                <input type="password" id="password" name="password" placeholder="Password" required />
                <span class="eye-icon" onclick="togglePassword()">
                    <i id="eye-id" class="fa-solid fa-eye"></i>
                </span>
            </div>

            <input type="submit" value="Login" />
        </form>
        
        <div class="footer-link">
            Don't have an account? <a href="register.jsp">Register here</a>
        </div>
        
        <p class="error">${error}</p>
    </div>

    <script>
    // 🎯 Password ဖွင့်/ပိတ် နဲ့ Icon ပြောင်းလဲခြင်း လုပ်ဆောင်ချက်
    function togglePassword() {
        var pwd = document.getElementById("password");
        var eyeIcon = document.getElementById("eye-id");
        
        if (pwd.type === "password") {
            pwd.type = "text";
            eyeIcon.classList.remove("fa-eye");
            eyeIcon.classList.add("fa-eye-slash");
        } else {
            pwd.type = "password";
            eyeIcon.classList.remove("fa-eye-slash");
            eyeIcon.classList.add("fa-eye");
        }
    }

    // 🎯 Dashboard မှာ သိမ်းခဲ့တဲ့ Theme ကို Auto လှမ်းစစ်ပြီး Dark ဖြစ်နေရင် တစ်ခါတည်း လိုက်ပြောင်းပေးမယ့် စနစ်
    window.onload = function() {
        if (localStorage.getItem('theme') === 'dark' || localStorage.getItem('darkMode') === 'enabled') {
            document.body.classList.add('dark-mode');
        }
    };
    </script>
</body>
</html>