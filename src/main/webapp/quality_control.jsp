<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.cheatsheet.model.QualityControlDTO" %> 

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Quality Control | Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <style>
        body { display: flex; margin: 0; background: #f4f7fe; font-family: 'Segoe UI', sans-serif; }
        .main { margin-left: 280px; width: calc(100% - 280px); padding: 45px; }
        .tab-nav { display: flex; gap: 20px; margin-bottom: 25px; border-bottom: 2px solid #e2e8f0; }
        .tab-btn { padding: 12px 25px; cursor: pointer; border: none; background: none; font-weight: 600; color: #64748b; font-size: 16px; }
        .tab-nav .tab-btn.active { color: #4f46e5; border-bottom: 3px solid #4f46e5; background: none; }
        .qc-section { display: none; }
        .qc-section.active { display: block; }
        .qc-table { width: 100%; border-collapse: collapse; background: white; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); }
        .qc-table th { background: #f8fafc; padding: 18px; text-align: left; color: #475569; font-weight: 600; }
        .qc-table td { padding: 18px; border-bottom: 1px solid #f1f5f9; color: #1e293b; vertical-align: middle; }
        
        .btn-review { background: #e0e7ff; color: #4338ca; border: none; padding: 8px 16px; border-radius: 6px; cursor: pointer; font-weight: 600; }
        .btn-review:hover { background: #c7d2fe; }
        .btn-approve { background: #dcfce7; color: #166534; border: none; padding: 8px 16px; border-radius: 6px; cursor: pointer; font-weight: 600; margin-right: 5px; }
        .btn-approve:hover { background: #bbf7d0; }
        .btn-reject { background: #fee2e2; color: #991b1b; border: none; padding: 8px 16px; border-radius: 6px; cursor: pointer; font-weight: 600; }
        .btn-reject:hover { background: #fecaca; }
        .empty-msg { text-align: center; padding: 30px; color: #94a3b8; }
    </style>
</head>
<body>
    <jsp:include page="admin_sidebar.jsp">
        <jsp:param name="activePage" value="qc" />
    </jsp:include>

    <main class="main">
        <h1 style="color: #1e293b; margin-bottom: 5px; font-size: 2.5rem; font-weight: bold;">Quality Control Analysis</h1>
        <p style="color: #64748b; margin-bottom: 30px;">Review and manage pending community submissions.</p>

        <div class="tab-nav">
            <button class="tab-btn active" onclick="showTab(event, 'prog')">Programming</button>
            <button class="tab-btn" onclick="showTab(event, 'edu')">Education</button>
        </div>

        <%-- Programming Section --%>
        <div id="prog" class="qc-section active">
            <table class="qc-table">
                <thead><tr><th>ID</th><th>Title</th><th>Author</th><th>Actions</th></tr></thead>
                <tbody>
                    <% 
                        List<QualityControlDTO> progList = (List<QualityControlDTO>) request.getAttribute("progList");
                        if (progList != null && !progList.isEmpty()) {
                            for (QualityControlDTO item : progList) {
                                String safeContent = item.getContent() != null ? item.getContent().replace("\"", "&quot;") : "";
                                String safeTitle = item.getTitle() != null ? item.getTitle().replace("\"", "&quot;") : "";
                                String safeAuthor = item.getAuthor() != null ? item.getAuthor().replace("\"", "&quot;") : "";
                    %>
                        <tr>
                            <td>#<%= item.getId() %></td>
                            <td style="font-weight: 600;"><%= item.getTitle() %></td>
                            <td><%= item.getAuthor() %></td>
                            <td>
                                <button type="button" class="btn-review" 
                                        data-id="<%= item.getId() %>"
                                        data-title="<%= safeTitle %>"
                                        data-author="<%= safeAuthor %>"
                                        data-content="<%= safeContent %>"
                                        data-type="Programming"
                                        onclick="openReviewModal(this)">
                                    <i class="fa-solid fa-eye"></i> Review Details
                                </button>
                            </td>
                        </tr>
                    <% 
                            }
                        } else { 
                    %>
                        <tr><td colspan="4" class="empty-msg">No pending programming data found.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <%-- Education Section --%>
        <div id="edu" class="qc-section">
            <table class="qc-table">
                <thead><tr><th>ID</th><th>Title</th><th>Author</th><th>Actions</th></tr></thead>
                <tbody>
                    <% 
                        List<QualityControlDTO> eduList = (List<QualityControlDTO>) request.getAttribute("eduList");
                        if (eduList != null && !eduList.isEmpty()) {
                            for (QualityControlDTO item : eduList) {
                                String safeContent = item.getContent() != null ? item.getContent().replace("\"", "&quot;") : "";
                                String safeTitle = item.getTitle() != null ? item.getTitle().replace("\"", "&quot;") : "";
                                String safeAuthor = item.getAuthor() != null ? item.getAuthor().replace("\"", "&quot;") : "";
                    %>
                        <tr>
                            <td>#<%= item.getId() %></td>
                            <td style="font-weight: 600;"><%= item.getTitle() %></td>
                            <td><%= item.getAuthor()%></td>
                            <td>
                                <button type="button" class="btn-review" 
                                        data-id="<%= item.getId() %>"
                                        data-title="<%= safeTitle %>"
                                        data-author="<%= safeAuthor %>"
                                        data-content="<%= safeContent %>"
                                        data-type="Education"
                                        onclick="openReviewModal(this)">
                                    <i class="fa-solid fa-eye"></i> Review Details
                                </button>
                            </td>
                        </tr>
                    <% 
                            }
                        } else { 
                    %>
                        <tr><td colspan="4" class="empty-msg">No pending education resources.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </main>

    <%-- Bootstrap Pop-up Modal --%>
    <div class="modal fade" id="qcReviewModal" tabindex="-1" aria-labelledby="qcModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content" style="border-radius: 12px; border: none; box-shadow: 0 10px 25px rgba(0,0,0,0.15);">
          <div class="modal-header" style="background: #f8fafc; border-bottom: 1px solid #e2e8f0; border-top-left-radius: 12px; border-top-right-radius: 12px;">
            <h5 class="modal-title" id="qcModalLabel" style="font-weight: 700; color: #1e293b;">Quality Control Review</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body" style="padding: 25px;">
            <h4 id="qcModalTitle" style="color: #1e293b; font-weight: 700; margin-bottom: 8px;"></h4>
            <p class="text-muted mb-3" style="font-size: 14px;">Submitted By: <span id="qcModalAuthor" style="font-weight: 600; color: #4f46e5;"></span></p>
            <hr style="border-top: 1px solid #e2e8f0;">
            
            <div id="qcModalContent" style="max-height: 350px; overflow-y: auto; white-space: pre-wrap; background: #f8fafc; line-height: 1.6; font-size: 15px; border-radius: 8px;" class="p-3 border text-dark">
            </div>
          </div>
          <div class="modal-footer" style="background: #f8fafc; border-top: 1px solid #e2e8f0; border-bottom-left-radius: 12px; border-bottom-right-radius: 12px;">
            <form action="QualityControlServlet" method="POST" style="margin: 0;">
                <input type="hidden" id="formPostId_approve" name="postId">
                <input type="hidden" id="formType_approve" name="type">
                <input type="hidden" name="action" value="approve">
                <button type="submit" class="btn-approve">Approve</button>
            </form>

            <form action="QualityControlServlet" method="POST" style="margin: 0;">
                <input type="hidden" id="formPostId_reject" name="postId">
                <input type="hidden" id="formType_reject" name="type">
                <input type="hidden" name="action" value="reject">
                <button type="submit" class="btn-reject"><i class="fa-solid fa-trash"></i> Reject</button>
            </form>
          </div>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        function showTab(evt, id) {
            document.querySelectorAll('.qc-section').forEach(s => s.classList.remove('active'));
            document.querySelectorAll('.tab-nav .tab-btn').forEach(b => b.classList.remove('active'));
            document.getElementById(id).classList.add('active');
            evt.currentTarget.classList.add('active');
        }

        // ပြင်ဆင်ပြီးသား အသစ်ဖြစ်သော openReviewModal Function
        function openReviewModal(btn) {
            const id = btn.dataset.id;
            const title = btn.dataset.title;
            const author = btn.dataset.author;
            const content = btn.dataset.content;
            const type = btn.dataset.type;

            document.getElementById('qcModalTitle').textContent = title;
            document.getElementById('qcModalAuthor').textContent = author;
            document.getElementById('qcModalContent').textContent = content;

            document.getElementById('formPostId_approve').value = id;
            document.getElementById('formType_approve').value = type;

            document.getElementById('formPostId_reject').value = id;
            document.getElementById('formType_reject').value = type;

            var myModal = new bootstrap.Modal(document.getElementById('qcReviewModal'));
            myModal.show();
        }
    </script>
</body>
</html>