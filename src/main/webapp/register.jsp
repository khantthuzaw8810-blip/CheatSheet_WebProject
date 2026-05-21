<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>User Register</title>
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            background-color: #f4f4f4; 
            display: flex; justify-content: center; align-items: center; 
            height: 100vh; margin: 0;
        }
        .register-box {
            width: 400px; padding: 40px; background: #fff; 
            border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }
        h2 { text-align: center; margin-bottom: 30px; color: #333; font-size: 28px; }
        label { font-weight: bold; display: block; margin-top: 15px; color: #000; }
        
        input[type=text], input[type=password] {
            width: 100%; padding: 12px; margin: 8px 0;
            border: 1px solid #ddd; border-radius: 6px;
            background-color: #f0f4ff; /* မင်းရဲ့ UI input color */
            font-size: 16px; box-sizing: border-box;
        }
        
        .register-btn {
            width: 100%; padding: 14px; background: #28a745; /* Green Button */
            border: none; border-radius: 6px; color: #fff;
            font-weight: bold; font-size: 16px; margin-top: 25px;
            cursor: pointer; transition: background 0.3s;
        }
        .register-btn:hover { background: #218838; }
        
        .footer-link { text-align: center; margin-top: 20px; font-size: 14px; }
        .footer-link a { color: #007bff; text-decoration: none; }
    </style>
</head>
<body>
    <div class="register-box">
    <h2>User Register</h2>
    <form action="RegisterServlet" method="post">
        <label>Username:</label>
        <input type="text" name="username" placeholder="Enter username" required />

        <label>Password:</label>
        <div style="position: relative;">
            <input type="password" id="regPassword" name="password" placeholder="Create password" required 
                   style="width: 100%; padding: 12px; background-color: #f0f4ff; border: 1px solid #ddd; border-radius: 6px; box-sizing: border-box;"/>
            <span onclick="toggleRegPassword()" style="position: absolute; right: 12px; top: 12px; cursor: pointer; opacity: 0.6;">👁️</span>
        </div>

        <input type="submit" value="Register" class="register-btn" />
    </form>
    
    <div class="footer-link">
        Already have an account? <a href="login.jsp">Login here</a>
    </div>
</div>

<script>
function toggleRegPassword() {
    var pwd = document.getElementById("regPassword");
    pwd.type = (pwd.type === "password") ? "text" : "password";
}
</script>
</body>
</html>