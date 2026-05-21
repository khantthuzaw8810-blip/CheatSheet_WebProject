<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<html>
<head>
    <title>Add New Education Content</title>
    <style>
        body { font-family: sans-serif; background: #f4f7f6; padding: 50px; }
        .form-container { background: white; padding: 30px; border-radius: 10px; max-width: 500px; margin: auto; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        input, textarea, select { width: 100%; padding: 12px; margin: 10px 0; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; }
        .btn-save { background: #27ae60; color: white; border: none; padding: 12px; cursor: pointer; width: 100%; border-radius: 5px; font-weight: bold; }
        /* Message box အတွက် style အသစ် */
        .msg-box { background-color: #d4edda; color: #155724; padding: 15px; margin-bottom: 20px; border-radius: 5px; text-align: center; border: 1px solid #c3e6cb; }
    </style>
</head>
<body>
    <div class="form-container">
        
        <%-- ✅ Servlet က ပို့လိုက်တဲ့ Success Message ကို ပြရန် --%>
        <% if (request.getAttribute("message") != null) { %>
            <div class="msg-box">
                <%= request.getAttribute("message") %>
            </div>
        <% } %>

        <h2>➕ Add New Content</h2>
        <form action="EducationList" method="POST" enctype="multipart/form-data">
            <label>Title</label>
            <input type="text" name="title" placeholder="Enter Title" required>
            
            <label>Description</label>
            <textarea name="description" placeholder="Description" rows="4" required></textarea>
            
            <label>Category</label>
            <select name="category">
                <option value="Programming">Programming</option>
                <option value="Web Tech">Web Tech</option>
                <option value="SQL">SQL</option>
                <option value="Software">Software</option>
                <option value="Java">Java</option>
            </select>
        <div class="form-group">
    <label>Upload Image</label>
    <input type="file" name="image" class="form-control"> 
</div>
            <button type="submit" class="btn-save">Save Content</button>
            <br><br>
            <a href="EducationList" style="display:block; text-align:center; color:#666; text-decoration:none;">Cancel</a>
        </form>
    </div>
</body>
</html>