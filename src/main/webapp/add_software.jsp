<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Add New Software</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bg-main: #f4f6f9;
            --card-bg: #ffffff;
            --text-color: #333333;
            --border-color: #eeeeee;
            --input-bg: #f0f4ff;
            --btn-green: linear-gradient(90deg, #28a745, #218838);
        }
        body { 
            font-family: 'Segoe UI', sans-serif; 
            padding: 50px; 
            background: var(--bg-main); 
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }
        .form-container { 
            background: var(--card-bg); 
            padding: 40px; 
            border-radius: 15px; 
            width: 100%;
            max-width: 500px; 
            box-shadow: 0 4px 20px rgba(0,0,0,0.06); 
            border: 1px solid var(--border-color);
        }
        h2 { 
            text-align: center; 
            margin-top: 0;
            margin-bottom: 30px; 
            color: var(--text-color); 
            font-weight: 700;
        }
        label {
            display: block;
            font-size: 14px;
            font-weight: 700;
            margin-top: 15px;
            margin-bottom: 5px;
            color: var(--text-color);
        }
        input[type=text], textarea, input[type=file] { 
            width: 100%; 
            padding: 12px; 
            margin-bottom: 10px; 
            border: 1px solid var(--border-color); 
            border-radius: 8px; 
            background-color: var(--input-bg);
            color: var(--text-color);
            font-size: 15px;
            box-sizing: border-box; 
            transition: 0.3s;
        }
        input:focus, textarea:focus {
            outline: none;
            border-color: #005bea;
            box-shadow: 0 0 8px rgba(0, 91, 234, 0.15);
        }
        .btn-save { 
            background: var(--btn-green); 
            color: white; 
            border: none; 
            padding: 14px; 
            width: 100%; 
            border-radius: 8px;
            cursor: pointer; 
            font-weight: bold; 
            font-size: 16px;
            margin-top: 20px;
            transition: 0.3s;
            box-shadow: 0 4px 10px rgba(40, 167, 69, 0.2);
        }
        .btn-save:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 15px rgba(40, 167, 69, 0.3);
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h2><i class="fa-solid fa-square-plus" style="color: #28a745; margin-right: 8px;"></i>Add New Software Tool</h2>
        
        <form action="SoftwareServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="add">
            
            <label>Software Name:</label>
            <input type="text" name="title" placeholder="e.g. VS Code" required>
            
            <label>Description:</label>
            <textarea name="content" rows="4" placeholder="Brief description..."></textarea>
            
            <label>Logo Image File:</label>
            <input type="file" name="softwareLogo" accept="image/*" required>
            
            <label>Download Reference Link:</label>
            <input type="text" name="reference_link" placeholder="https://code.visualstudio.com">
            
            <button type="submit" class="btn-save">Save Software Tool</button>
        </form>
    </div>
</body>
</html>