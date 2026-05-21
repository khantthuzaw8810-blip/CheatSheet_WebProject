<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.cheatsheet.model.QualityControlDTO" %>
<%
    String sessionUser = (String) session.getAttribute("username");
    String userRole = (String) session.getAttribute("role"); 
    if (userRole == null) {
        userRole = "user"; 
    }
    
    // Servlet က ပို့လိုက်တဲ့ အတည်ပြုပြီးသား အမျိုးအစားတူ List နှစ်ခုလုံးကို ဖမ်းယူခြင်း
    List<QualityControlDTO> approvedEduList = (List<QualityControlDTO>) request.getAttribute("approvedEduList");
    List<QualityControlDTO> approvedProgList = (List<QualityControlDTO>) request.getAttribute("approvedProgList");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Submission Hub</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bg-body: #f4f7f6;
            --bg-card: #ffffff; 
            --card-border: rgba(0, 91, 234, 0.12); 
            --card-shadow: rgba(165, 180, 203, 0.25); 
            --txt-main: #2c3e50;
            --txt-sub: #7f8c8d;
            --border: #eaedf1;
        }

        body { 
            margin: 0; 
            font-family: 'Segoe UI', sans-serif; 
            background: var(--bg-body); 
            color: var(--txt-main); 
            display: flex; 
        }
        
        .page-content-wrapper {
            margin-left: 260px;
            flex: 1;
            min-height: 100vh;
            box-sizing: border-box;
        }
        
        .main-container { max-width: 1200px; margin: 40px auto; padding: 0 20px; }
        
        .header { 
            background: var(--bg-card); 
            padding: 20px; border-radius: 10px; 
            box-shadow: 0 2px 5px rgba(0,0,0,0.05); margin-bottom: 30px; 
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .hub-tabs {
            display: flex;
            gap: 10px;
        }
        .hub-tab {
            padding: 10px 18px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            border: 1px solid var(--border);
            background: #f8fafc;
            color: var(--txt-sub);
            transition: all 0.2s ease;
        }
        .hub-tab i { margin-right: 6px; }
        .hub-tab.active {
            background: #005bea;
            color: white;
            border-color: #005bea;
        }

        .grid { 
            display: grid; 
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); 
            gap: 25px; 
        }
        
        .card { 
            background: var(--bg-card); 
            border-radius: 16px; 
            overflow: hidden; 
            border: 1px solid var(--card-border);
            box-shadow: 0 6px 18px var(--card-shadow); 
            transition: all 0.3s ease; 
            display: flex;
            flex-direction: column;
            height: 200px; 
            box-sizing: border-box;
            position: relative;
            cursor: pointer;
            padding: 24px;
        }
        
        .card:hover { 
            transform: translateY(-5px); 
            box-shadow: 0 10px 25px rgba(0, 91, 234, 0.15); 
            border-color: #005bea;
        }

        .card-body {
            display: flex;
            flex-direction: column;
            flex: 1;
            overflow: hidden;
        }
        
        .card-top-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;
        }

        .card-tag {
            font-size: 11px;
            color: #005bea;
            font-weight: 700;
            text-transform: uppercase;
        }
        
        .fav-btn {
            background: none;
            border: none;
            color: #cbd5e1;
            font-size: 20px;
            cursor: pointer;
            padding: 4px;
            transition: transform 0.2s ease, color 0.2s ease;
            position: relative;
            z-index: 50; 
        }
        .fav-btn:hover {
            transform: scale(1.2);
            color: #f43f5e;
        }
        .fav-btn.is-fav {
            color: #f43f5e !important;
        }

        .card-title { 
            color: var(--txt-main); 
            margin: 0 0 8px 0;
            font-size: 18px;
            font-weight: 700;
            line-height: 1.4;
            display: -webkit-box;
            -webkit-line-clamp: 2; 
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .card-hint {
            font-size: 13px;
            color: #95a5a6;
            margin: 0 0 15px 0;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .card-author {
            font-size: 12px;
            color: var(--txt-sub);
            margin-top: auto;
            display: flex;
            align-items: center;
            gap: 6px;
            font-weight: 500;
        }

        .modal {
            display: none; 
            position: fixed; z-index: 2000; 
            left: 0; top: 0; width: 100%; height: 100%; 
            background-color: rgba(0,0,0,0.5);
            backdrop-filter: blur(4px);
            align-items: center; justify-content: center;
        }
        
        .modal-content {
            background-color: #ffffff;
            padding: 25px;
            border-radius: 12px;
            width: 90%;
            max-width: 800px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            position: relative;
            max-height: 85vh;
            overflow-y: auto;
            animation: fadeIn 0.25s ease;
        }
        
        @keyframes fadeIn {
            from { transform: translateY(15px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        
        .close-btn {
            position: absolute; top: 15px; right: 15px;
            font-size: 22px; color: var(--txt-sub); cursor: pointer;
        }
        .close-btn:hover { color: #d32f2f; }
        
        .modal-header { margin-bottom: 15px; border-bottom: 1px solid var(--border); padding-bottom: 10px; }
        .modal-title { font-size: 22px; font-weight: 700; color: #2c3e50; margin: 0; }
        
        .modal-body {
            font-size: 14px; line-height: 1.6; color: #34495e;
            white-space: pre-wrap; background: #f8fafc;
            padding: 15px; border-radius: 6px; border: 1px solid var(--border);
            font-family: 'Consolas', 'Courier New', monospace;
            word-break: break-all;
        }
    </style>
</head>
<body>

    <jsp:include page="admin_sidebar.jsp" />

    <div class="page-content-wrapper">

        <%! 
            public String encodeBase64(String input) {
                if (input == null) return "";
                try {
                    return Base64.getEncoder().encodeToString(input.getBytes("UTF-8"));
                } catch (Exception e) {
                    return "";
                }
            }
        %>

        <div class="main-container">
            <div class="header">
                <h2>🚀 Submission Hub (Approved Content)</h2>
                
                <div class="hub-tabs">
                    <div class="hub-tab active" id="tab-all" onclick="switchTab('all')">
                        <i class="fas fa-th-large"></i> All Submissions
                    </div>
                    <div class="hub-tab" id="tab-fav" onclick="switchTab('fav')">
                        <i class="fas fa-heart" style="color: #f43f5e;"></i> Favorites Only
                    </div>
                </div>
            </div>

            <div class="grid" id="submissions-grid">
                <%
                    boolean hasData = false;

                    // === LOOP ၁။ Education Table မှ APPROVED များထုတ်ပြခြင်း ===
                    if (approvedEduList != null && !approvedEduList.isEmpty()) {
                        hasData = true;
                        for (QualityControlDTO edu : approvedEduList) {
                            String idStr = "edu_" + edu.getId();
                            String title = edu.getTitle();
                            String author = edu.getAuthor(); 
                            String category = edu.getType(); 
                            String content = edu.getContent();

                            String b64Title = encodeBase64(title);
                            String b64Category = encodeBase64(category);
                            String b64Author = encodeBase64(author);
                            String b64Desc = encodeBase64(content);
                %>
                <div class="card" data-card-id="<%= idStr %>" data-is-fav="false">
                    <div class="card-body">
                        <div class="card-top-row">
                            <div class="card-tag" onclick="openContentModal('<%= b64Title %>', '<%= b64Category %>', '<%= b64Author %>', '<%= b64Desc %>')">
                                <i class="fas fa-tag"></i> <%= category %>
                            </div>
                            <button class="fav-btn" onclick="toggleFavorite(event, this, '<%= idStr %>')">
                                <i class="far fa-heart"></i>
                            </button>
                        </div>
                        <div onclick="openContentModal('<%= b64Title %>', '<%= b64Category %>', '<%= b64Author %>', '<%= b64Desc %>')" style="display:flex; flex-direction:column; flex:1;">
                            <h3 class="card-title"><%= (title != null && title.length() > 50) ? "Code Snippet Content" : title %></h3>
                            <p class="card-hint"><i class="fas fa-lock" style="font-size: 11px;"></i> Click to read full content</p>
                            <div class="card-author"><i class="fas fa-user-circle"></i> By: <%= (author != null) ? author : "Unknown" %></div>
                        </div>
                    </div>
                </div>
                <% 
                        }
                    } 

                    // === LOOP ၂။ Cheatsheets (Programming) Table မှ APPROVED များထုတ်ပြခြင်း ===
                    if (approvedProgList != null && !approvedProgList.isEmpty()) {
                        hasData = true;
                        for (QualityControlDTO prog : approvedProgList) {
                            String idStr = "prog_" + prog.getId();
                            String title = prog.getTitle();
                            String author = prog.getAuthor();
                            String category = prog.getType(); 
                            String content = prog.getContent();

                            String b64Title = encodeBase64(title);
                            String b64Category = encodeBase64(category);
                            String b64Author = encodeBase64(author);
                            String b64Desc = encodeBase64(content);
                %>
                <div class="card" data-card-id="<%= idStr %>" data-is-fav="false">
                    <div class="card-body">
                        <div class="card-top-row">
                            <div class="card-tag" onclick="openContentModal('<%= b64Title %>', '<%= b64Category %>', '<%= b64Author %>', '<%= b64Desc %>')">
                                <i class="fas fa-tag"></i> <%= category %>
                            </div>
                            <button class="fav-btn" onclick="toggleFavorite(event, this, '<%= idStr %>')">
                                <i class="far fa-heart"></i>
                            </button>
                        </div>
                        <div onclick="openContentModal('<%= b64Title %>', '<%= b64Category %>', '<%= b64Author %>', '<%= b64Desc %>')" style="display:flex; flex-direction:column; flex:1;">
                            <h3 class="card-title"><%= (title != null && title.length() > 50) ? "Code Snippet Content" : title %></h3>
                            <p class="card-hint"><i class="fas fa-lock" style="font-size: 11px;"></i> Click to read full content</p>
                            <div class="card-author"><i class="fas fa-user-circle"></i> By: <%= (author != null) ? author : "Unknown" %></div>
                        </div>
                    </div>
                </div>
                <% 
                        }
                    }

                    if (!hasData) { 
                %>
                    <div style="grid-column: 1/-1; text-align: center; padding: 40px; background: white; border-radius: 10px;">
                         <p style="color: var(--txt-sub); margin: 0;">အတည်ပြုထားသည့် ဒေတာ မရှိသေးပါ။</p>
                    </div>
                <% } %>
            </div>
            
            <div id="fav-empty-msg" style="display: none; text-align: center; padding: 60px 40px; background: white; border-radius: 16px; margin-top: 20px; box-shadow: 0 6px 18px var(--card-shadow);">
                <i class="fas fa-heart-broken" style="font-size: 40px; color: #cbd5e1; margin-bottom: 15px;"></i>
                <p style="color: var(--txt-sub); margin: 0; font-weight: 600;">Favorite ပေးထားသည့် Content မရှိသေးပါ။</p>
            </div>
        </div>
    </div>

    <div id="contentModal" class="modal" onclick="closeModalOutside(event)">
        <div class="modal-content">
            <span class="close-btn" onclick="closeContentModal()">&times;</span>
            <div class="modal-header">
                <div id="m-category" style="font-size: 11px; font-weight: 700; color: #005bea; text-transform: uppercase; margin-bottom: 4px;"></div>
                <h3 id="m-title" class="modal-title"></h3>
                <div id="m-author" style="font-size: 12px; color: var(--txt-sub); margin-top: 4px;"></div>
            </div>
            <div id="m-body" class="modal-body"></div>
        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            initFavorites();
        });

        function initFavorites() {
            let favs = JSON.parse(localStorage.getItem("hub_favorites") || "[]");
            let cards = document.querySelectorAll(".card");
            cards.forEach(card => {
                let id = card.getAttribute("data-card-id");
                if (favs.includes(id)) {
                    card.setAttribute("data-is-fav", "true");
                    let btn = card.querySelector(".fav-btn");
                    if (btn) {
                        btn.classList.add("is-fav");
                        let icon = btn.querySelector("i");
                        if (icon) icon.className = "fas fa-heart";
                    }
                }
            });
        }

        function toggleFavorite(event, btnElement, cardId) {
            event.preventDefault();
            event.stopPropagation();
            let card = btnElement.closest(".card");
            if(!card) return;
            
            let icon = btnElement.querySelector("i");
            let favs = JSON.parse(localStorage.getItem("hub_favorites") || "[]");
            let isFav = card.getAttribute("data-is-fav") === "true";
            
            if (isFav) {
                card.setAttribute("data-is-fav", "false");
                btnElement.classList.remove("is-fav");
                if(icon) icon.className = "far fa-heart";
                favs = favs.filter(id => id !== cardId);
            } else {
                card.setAttribute("data-is-fav", "true");
                btnElement.classList.add("is-fav");
                if(icon) icon.className = "fas fa-heart";
                if(!favs.includes(cardId)) favs.push(cardId);
            }
            localStorage.setItem("hub_favorites", JSON.stringify(favs));
            if(document.getElementById("tab-fav").classList.contains("active")) switchTab('fav');
        }

        function switchTab(mode) {
            let cards = document.querySelectorAll(".card");
            let emptyMsg = document.getElementById("fav-empty-msg");
            let grid = document.getElementById("submissions-grid");
            
            document.getElementById("tab-all").classList.remove("active");
            document.getElementById("tab-fav").classList.remove("active");
            
            if (mode === 'all') {
                document.getElementById("tab-all").classList.add("active");
                grid.style.display = "grid";
                emptyMsg.style.display = "none";
                cards.forEach(card => card.style.display = "flex");
            } else {
                document.getElementById("tab-fav").classList.add("active");
                let hasFav = false;
                cards.forEach(card => {
                    if (card.getAttribute("data-is-fav") === "true") {
                        card.style.display = "flex";
                        hasFav = true;
                    } else {
                        card.style.display = "none";
                    }
                });
                if (!hasFav) {
                    grid.style.display = "none";
                    emptyMsg.style.display = "block";
                } else {
                    grid.style.display = "grid";
                    emptyMsg.style.display = "none";
                }
            }
        }

        function decodeB64(str) {
            try {
                return decodeURIComponent(atob(str).split('').map(function(c) {
                    return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
                }).join(''));
            } catch (e) {
                return "Error decoding content.";
            }
        }

        function openContentModal(b64Title, b64Category, b64Author, b64Description) {
            document.getElementById('m-title').innerText = decodeB64(b64Title);
            document.getElementById('m-category').innerHTML = '<i class="fas fa-tag"></i> ' + decodeB64(b64Category);
            document.getElementById('m-author').innerHTML = '<i class="fas fa-user"></i> Posted By: ' + decodeB64(b64Author);
            document.getElementById('m-body').innerText = decodeB64(b64Description);
            document.getElementById('contentModal').style.display = 'flex';
        }

        function closeContentModal() {
            document.getElementById('contentModal').style.display = 'none';
        }

        function closeModalOutside(event) {
            if (event.target.id === 'contentModal') closeContentMvodal();
        }
    </script>
</body>
</html>