<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.URLEncoder, com.cheatsheet.model.CheatSheet" %>
<%
    CheatSheet sheet = (CheatSheet) request.getAttribute("sheet");
    String action = request.getAttribute("action") != null ? (String) request.getAttribute("action") : request.getParameter("action");
    if (sheet == null) sheet = new CheatSheet();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title><%= "update".equals(action) ? "Edit Cheat Sheet | Admin Panel" : "Add Cheat Sheet | Admin Panel" %></title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-maroon: #a90033;
            --accent-yellow: #ffdf6c;
            --bg-gray: #f4f7f6;
            --text: #333;
        }
        * { box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--bg-gray);
            margin: 0;
            color: var(--text);
        }
        .header-bar {
            background-color: var(--primary-maroon);
            color: white;
            padding: 15px 40px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }
        .container {
            max-width: 900px;
            margin: 36px auto;
            background: white;
            padding: 28px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            border-top: 5px solid var(--primary-maroon);
        }
        h2 {
            color: #222;
            margin-top: 0;
            border-bottom: 2px solid #eee;
            padding-bottom: 10px;
            display:flex;
            align-items:center;
            gap:10px;
        }
        .form-group { margin-bottom: 18px; }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #444;
        }
        input[type="text"],
        input[type="number"],
        input[type="url"],
        textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            background: #fff;
        }
        textarea { min-height: 120px; resize: vertical; }
        input[type="file"] {
            padding: 10px;
            background: #fafafa;
            border: 1px dashed #ccc;
            width: 100%;
            border-radius: 6px;
        }
        .grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; }
        .preview-box { margin-top: 10px; display:flex; gap:12px; align-items:center; }
        .preview-box img { max-width: 260px; max-height: 160px; border-radius:6px; border:1px solid #e6e6e6; object-fit:cover; }
        .small-note { color:#777; font-size:13px; margin-top:6px; display:block; }
        .actions {
            display: flex;
            gap: 12px;
            margin-top: 22px;
            padding-top: 18px;
            border-top: 1px solid #f0f0f0;
        }
        .btn {
            padding: 12px 18px;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            color: white;
            font-size: 14px;
        }
        .btn-save { background: var(--primary-maroon); }
        .btn-back { background: #6c757d; }
        @media (max-width: 720px) {
            .grid-2 { grid-template-columns: 1fr; }
            .container { margin: 16px; padding: 18px; }
        }
    </style>
    <script>
        function previewSelectedImage(input) {
            var file = input.files && input.files[0];
            var previewImg = document.getElementById('currentPreviewImg');
            var previewWrapper = document.getElementById('previewWrapper');
            if (!file) {
                if (previewImg) previewImg.src = '';
                return;
            }
            var reader = new FileReader();
            reader.onload = function(e) {
                if (!previewImg) {
                    previewImg = document.createElement('img');
                    previewImg.id = 'currentPreviewImg';
                    previewWrapper.innerHTML = '';
                    previewWrapper.appendChild(previewImg);
                }
                previewImg.src = e.target.result;
            };
            reader.readAsDataURL(file);
        }
    </script>
</head>
<body>
    <div class="header-bar">
        <div style="display:flex; align-items:center; gap:12px;">
            <i class="fas fa-file-alt" style="font-size:18px;"></i>
            <strong>Cheat Sheet Editor</strong>
        </div>
        <div style="font-size:14px; opacity:0.95;">Admin Mode</div>
    </div>

    <div class="container">
        <div class="breadcrumb" style="font-size:13px;color:#666;margin-bottom:12px;">
            <i class="fas fa-home"></i> Dashboard &gt; Programming &gt; <strong><%= "update".equals(action) ? "Edit Sheet" : "Add Sheet" %></strong>
        </div>

        <h2><i class="fas fa-edit" style="color: var(--primary-maroon);"></i> <%= "update".equals(action) ? "Edit Cheat Sheet Details" : "Add New Cheat Sheet" %></h2>

        <form action="<%= request.getContextPath() %>/CheatSheetServlet" method="post" enctype="multipart/form-data">
           <%-- ဒီ line ကို ရှာပြီး အောက်ကအတိုင်း အစားထိုးလိုက်ပါ --%>
<input type="hidden" name="action" value="<%= (sheet.getCheatSheetId() != 0) ? "update" : "add" %>" />
<input type="hidden" name="id" value="<%= sheet.getCheatSheetId() %>" />
            
            <div class="form-group">
                <label><i class="fas fa-heading"></i> Sheet Title</label>
                <input type="text" name="title" value="<%= sheet.getTitle() != null ? sheet.getTitle() : "" %>" required />
            </div>

            <div class="form-group">
                <label><i class="fas fa-align-left"></i> Content Description</label>
                <textarea name="content" required><%= sheet.getContent() != null ? sheet.getContent() : "" %></textarea>
            </div>

            <div class="grid-2">
               <div class="form-group">
    <label><i class="fas fa-tags"></i> Category</label>
    <select name="categoryId" class="form-control" style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px;">
        <%-- value မှာ ID (1,2,3) ကို ထည့်မယ်၊ အပြင်မှာ နာမည် (Programming) ကို ပြမယ် --%>
        <option value="1" <%= sheet.getCategoryId() == 1 ? "selected" : "" %>>Programming</option>
        <option value="2" <%= sheet.getCategoryId() == 2 ? "selected" : "" %>>Mathematics</option>
        <option value="3" <%= sheet.getCategoryId() == 3 ? "selected" : "" %>>Networking</option>
        <option value="4" <%= sheet.getCategoryId() == 4 ? "selected" : "" %>>Graphic Design</option>
    </select>
    <small class="small-note">Select the appropriate category for this cheat sheet.</small>
</div>
                <div class="form-group">
                    <label><i class="fas fa-image"></i> Choose Photo</label>
                    <input type="file" name="imageFile" accept="image/*" onchange="previewSelectedImage(this)" />
                    <small class="small-note">Leave empty to keep existing image. Max file size enforced by server.</small>

                    <div id="previewWrapper" class="preview-box">
                        <%
                            String imgName = sheet.getImageUrl();
                            if (imgName != null && !imgName.trim().isEmpty()) {
                                String encoded = URLEncoder.encode(imgName, "UTF-8");
                        %>
                            <img id="currentPreviewImg" src="<%= request.getContextPath() %>/ImageServlet?name=<%= encoded %>" alt="Current Image" onerror="this.src='https://via.placeholder.com/260x160?text=Image+Not+Found';" />
                        <%
                            } else {
                        %>
                            <div style="color:#999;font-size:13px;">No current image</div>
                        <%
                            }
                        %>
                    </div>

                    <small class="small-note">Current filename: <strong><%= (sheet.getImageUrl() != null && !sheet.getImageUrl().isEmpty()) ? sheet.getImageUrl() : "None" %></strong></small>
                </div>
            </div>

            <div class="form-group">
                <label><i class="fas fa-link"></i> External Reference Link</label>
                <input type="url" name="reference_link" value="<%= sheet.getReferenceLink() != null ? sheet.getReferenceLink() : "" %>" placeholder="https://example.com" />
            </div>

            <div class="actions">
                <button type="submit" class="btn btn-save"><i class="fas fa-save"></i> Save Changes</button>
                <a href="<%= request.getContextPath() %>/CheatSheetListServlet" class="btn btn-back" style="text-decoration:none; display:inline-flex; align-items:center;"><i class="fas fa-arrow-left"></i> Back to List</a>
            </div>
        </form>
    </div>
</body>
</html>
