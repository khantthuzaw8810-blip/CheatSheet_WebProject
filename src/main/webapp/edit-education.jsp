<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.cheatsheet.model.Education" %>
<%
    Education edu = (Education) request.getAttribute("education");
    if (edu == null) {
        edu = new Education(); // Null Pointer Exception မဖြစ်အောင် ကာကွယ်ခြင်း
    }
%>
<html>
<head>
    <title>Edit Education Content</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f4f7f6; padding: 50px; color: #2c3e50; }
        .form-container { background: white; padding: 30px; border-radius: 10px; max-width: 500px; margin: auto; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        h2 { margin-top: 0; color: #005bea; font-size: 22px; }
        label { font-weight: 600; font-size: 14px; display: block; margin-top: 15px; }
        input[type="text"], textarea, select { width: 100%; padding: 10px; margin: 5px 0 10px 0; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; font-family: inherit; }
        input[type="file"] { margin: 10px 0; display: block; }
        .btn-update { background: #005bea; color: white; border: none; padding: 12px 20px; cursor: pointer; width: 100%; border-radius: 5px; font-weight: bold; font-size: 15px; margin-top: 15px; transition: background 0.2s; }
        .btn-update:hover { background: #0046b8; }
        .current-img-lbl { font-size: 12px; color: #7f8c8d; display: block; margin-bottom: 5px; }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>Edit Lesson</h2>
        <form action="EducationUpdateServlet" method="POST" enctype="multipart/form-data">
            
            <input type="hidden" name="id" value="<%= edu.getId() %>">
            <input type="hidden" name="oldImageName" value="<%= (edu.getImageUrl() != null) ? edu.getImageUrl() : "" %>">

            <label>Title</label>
            <input type="text" name="title" value="<%= (edu.getTitle() != null) ? edu.getTitle().replace("\"", "&quot;") : "" %>" required>
            
            <label>Description</label>
            <textarea name="description" rows="5" required><%= (edu.getDescription() != null) ? edu.getDescription() : "" %></textarea>
            
            <label>Category</label>
            <select name="category">
                <% String currentCat = (edu.getCategory() != null) ? edu.getCategory() : ""; %>
                <option value="Programming" <%= currentCat.equals("Programming") ? "selected" : "" %>>Programming</option>
                <option value="Web Tech" <%= currentCat.equals("Web Tech") ? "selected" : "" %>>Web Tech</option>
                <option value="SQL" <%= currentCat.equals("SQL") ? "selected" : "" %>>SQL</option>
                <option value="Software" <%= currentCat.equals("Software") ? "selected" : "" %>>Software</option>
                <option value="Java" <%= currentCat.equals("Java") ? "selected" : "" %>>Java</option>
            </select>
            
            <label>Change Image (Optional)</label>
            <% if(edu.getImageUrl() != null && !edu.getImageUrl().isEmpty()) { %>
                <span class="current-img-lbl"><i class="far fa-image"></i> Current: <%= edu.getImageUrl() %></span>
            <% } %>
            <input type="file" name="imageFile" accept="image/*">
            
            <button type="submit" class="btn-update">Update Content</button>
        </form>
    </div>
</body>
</html>