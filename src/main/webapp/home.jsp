<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Home</title>
    <style>
        body { font-family: Arial; background-color: #eef; }
        .container { width: 600px; margin: 50px auto; text-align: center; }
        a { text-decoration: none; color: #007bff; font-weight: bold; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Welcome, ${sessionScope.username}!</h2>
        <p>You have successfully logged in.</p>
        <a href="LogoutServlet">Logout</a>
    </div>
</body>
</html>
