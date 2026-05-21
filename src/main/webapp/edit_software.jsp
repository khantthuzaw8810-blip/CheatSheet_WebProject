<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.cheatsheet.model.CheatSheet" %>
<html>
<head>
    <title>Edit Software</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f4f7f6; padding: 40px; }
        .form-container { background: white; padding: 25px; border-radius: 8px; max-width: 500px; margin: auto; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        h2 { color: #333; border-bottom: 2px solid #a90033; padding-bottom: 10px; margin-bottom: 20px; }
        label { font-weight: bold; display: block; margin-top: 15px; color: #555; }
        input[type="text"], input[type="url"], textarea { width: 100%; padding: 12px; margin-top: 5px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
        input[type="file"] { margin-top: 5px; }
        .button-group { display: flex; gap: 10px; margin-top: 25px; }
        .btn-update { background: #a90033; color: white; border: none; padding: 12px 20px; border-radius: 5px; cursor: pointer; font-weight: bold; flex: 2; transition: 0.3s; }
        .btn-update:hover { background: #800026; }
        .btn-cancel { background: #ccc; color: #333; text-decoration: none; padding: 12px 20px; border-radius: 5px; text-align: center; flex: 1; font-weight: bold; transition: 0.3s; }
        .btn-cancel:hover { background: #bbb; }
        small { color: #888; display: block; margin-top: 5px; font-style: italic; }
    </style>
</head>
<body>

<%
    // Servlet ကနေ ပို့လိုက်တဲ့ 'software' object ကို ယူခြင်း
    CheatSheet s = (CheatSheet) request.getAttribute("software");
    if (s != null) {
%>
    <div class="form-container">
        <h2><i class="fas fa-edit"></i> Edit Software Tool</h2>
        
        <form action="SoftwareServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="<%= s.getCheatSheetId() %>">
            
            <label>Software Name:</label>
            <input type="text" name="title" value="<%= s.getTitle() %>" required>
            
            <label>Description:</label>
            <textarea name="content" rows="4" required><%= s.getContent() %></textarea>
            
            <label>Logo Image:</label>
            <input type="file" name="softwareLogo" accept="image/*">
            <small>လက်ရှိပုံ- <%= s.getImageUrl() != null ? s.getImageUrl() : "ပုံမရှိပါ" %></small>
            
            <label>Download Link (URL):</label>
            <input type="url" name="reference_link" value="<%= s.getReferenceLink() != null ? s.getReferenceLink() : "" %>" 
                   placeholder="https://example.com/download">
            
            <div class="button-group">
                <button type="submit" class="btn-update">Update Software</button>
                <a href="SoftwareServlet" class="btn-cancel">Cancel</a>
            </div>
        </form>
    </div>
<% 
    } else { 
%>
    <div style="text-align:center;">
        <p>Data ရှာမတွေ့ပါ။ <a href="SoftwareServlet">ဒီမှာ ပြန်သွားပါ</a></p>
    </div>
<% 
    } 
%>

</body>
</html>