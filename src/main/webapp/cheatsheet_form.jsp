<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.cheatsheet.model.CheatSheet" %>
<%
    // Servlet ကနေ ပို့လိုက်တဲ့ sheet data ကို ယူခြင်း
    CheatSheet sheet = (CheatSheet) request.getAttribute("sheet");
    if (sheet == null) {
        sheet = new CheatSheet(); // Add New အတွက်ဆိုရင် object အသစ်ဆောက်ပေးရမယ်
    }
    
    // Action သတ်မှတ်ခြင်း (ID ရှိရင် update၊ မရှိရင် add)
    String idParam = request.getParameter("id");
    String action = (idParam != null && !idParam.isEmpty()) ? "update" : "add";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Cheat Sheet Editor</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <script>
        (function() {
            const savedTheme = localStorage.getItem('theme');
            if (savedTheme === 'dark') {
                document.documentElement.classList.add('dark-mode');
            }
        })();
    </script>

    <style>
        :root {
            --bg: #f4f7f6;
            --card-bg: #ffffff;
            --header-red: #c0392b;
            --text-main: #2d3436;
            --text-sub: #636e72;
            --border: #dfe6e9;
            --accent: #3498db;
            --input-bg: #ffffff;
        }

        .dark-mode {
            --bg: #121212;
            --card-bg: #1e1e1e;
            --text-main: #e0e0e0;
            --text-sub: #aaaaaa;
            --border: #333333;
            --input-bg: #252525;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--bg);
            color: var(--text-main);
            margin: 0;
            transition: 0.3s;
        }

        .top-navbar {
            background-color: var(--header-red);
            padding: 12px 25px;
            color: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.2);
        }

        .main-content {
            display: flex;
            justify-content: center;
            padding: 40px 20px;
        }

        .form-card {
            background: var(--card-bg);
            width: 100%;
            max-width: 850px;
            border-radius: 12px;
            border-top: 4px solid var(--header-red);
            border: 1px solid var(--border);
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            padding: 30px;
        }

        .form-group { margin-bottom: 20px; }
        .form-group label {
            display: flex; align-items: center; gap: 8px;
            margin-bottom: 10px; font-weight: 600; font-size: 14px;
            color: var(--text-sub);
        }

        input[type="text"], textarea, select {
            width: 100%; padding: 12px; border-radius: 6px;
            border: 1px solid var(--border); background: var(--input-bg);
            color: var(--text-main); font-size: 14px; outline: none;
        }

        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 25px; }

        .btn-container {
            border-top: 1px solid var(--border);
            padding-top: 25px; display: flex; gap: 15px;
        }

        .btn {
            padding: 12px 25px; border-radius: 6px; font-weight: 600;
            cursor: pointer; text-decoration: none; border: none;
            display: flex; align-items: center; gap: 8px;
        }
        .btn-save { background: #2980b9; color: white; }
        .btn-back { background: var(--border); color: var(--text-main); }
    </style>
</head>
<body>

<div class="top-navbar">
    <h1><i class="fas fa-file-alt"></i> Cheat Sheet Editor</h1>
</div>

<div class="main-content">
    <div class="form-card">
        <div class="breadcrumb" style="font-size: 13px; color: var(--text-sub); margin-bottom: 15px;">
            <i class="fas fa-home"></i> Dashboard > Programming > <%= "update".equals(action) ? "Edit Sheet" : "Add Sheet" %>
        </div>

        <div class="title-section">
            <h2><i class="fas fa-edit"></i> <%= "update".equals(action) ? "Edit Cheat Sheet Details" : "Add New Cheat Sheet" %></h2>
        </div>

        <form action="CheatSheetServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="id" value="<%= sheet.getCheatSheetId() %>">
            <input type="hidden" name="action" value="<%= action %>">

            <div class="form-group">
                <label><i class="fas fa-heading"></i> Sheet Title</label>
                <input type="text" name="title" value="<%= sheet.getTitle() != null ? sheet.getTitle() : "" %>" required>
            </div>

            <div class="form-group">
                <label><i class="fas fa-align-left"></i> Content Description</label>
                <textarea name="content" rows="6"><%= sheet.getContent() != null ? sheet.getContent() : "" %></textarea>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label><i class="fas fa-tags"></i> Category</label>
                    <select name="categoryId">
                        <option value="1" <%= sheet.getCategoryId() == 1 ? "selected" : "" %>>Programming</option>
                        <option value="2" <%= sheet.getCategoryId() == 2 ? "selected" : "" %>>Mathematics</option>
                        <option value="3" <%= sheet.getCategoryId() == 3 ? "selected" : "" %>>Networking</option>
                        <option value="4" <%= sheet.getCategoryId() == 4 ? "selected" : "" %>>Graphic Design</option>
                    </select>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-image"></i> Choose Photo</label>
                    <input type="file" name="imageFile" style="padding: 8px; border: 1px dashed var(--border); width: 100%;">
                    <div style="font-size: 11px; color: #f39c12; margin-top: 5px;">Leave empty to keep current image</div>
                </div>
            </div>

            <div class="form-group">
                <label><i class="fas fa-link"></i> External Reference Link</label>
                <input type="text" name="referenceLink" value="<%= sheet.getReferenceLink() != null ? sheet.getReferenceLink() : "" %>" placeholder="https://example.com">
            </div>

            <div class="btn-container">
                <button type="submit" class="btn btn-save">
                    <i class="fas fa-save"></i> Save Changes
                </button>
                <a href="CheatSheetListServlet" class="btn btn-back">
                    <i class="fas fa-times"></i> Cancel
                </a>
            </div>
        </form>
    </div>
</div>

</body>
</html>