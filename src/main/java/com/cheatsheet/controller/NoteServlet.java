/*
 * package com.cheatsheet.controller;
 * 
 * import com.cheatsheet.repository.NoteRepository; import
 * com.cheatsheet.model.Comment; import javax.servlet.ServletException; import
 * javax.servlet.annotation.WebServlet; import javax.servlet.http.*; import
 * java.io.IOException; import java.util.List;
 * 
 * @WebServlet("/noteAction") public class NoteServlet extends HttpServlet {
 * private final NoteRepository noteRepo = new NoteRepository();
 * 
 * // Browser ကနေ Card ကို နှိပ်လိုက်ရင် Note list ကို ပြပေးခြင်း
 * 
 * @Override protected void doGet(HttpServletRequest request,
 * HttpServletResponse response) throws ServletException, IOException {
 * 
 * String idParam = request.getParameter("id"); if (idParam != null) { int
 * sheetId = Integer.parseInt(idParam); List<Comment> noteList =
 * noteRepo.findAllBySheetId(sheetId);
 * 
 * // JSP မှာ သုံးဖို့ data တွေ ထည့်ပေးခြင်း request.setAttribute("noteList",
 * noteList); request.setAttribute("currentSheetId", sheetId);
 * request.getRequestDispatcher("detail.jsp").forward(request, response); } else
 * { response.sendRedirect("DashboardServlet"); } }
 * 
 * // Form ကနေ Submit လုပ်လိုက်ရင် (Insert, Update, Delete) လုပ်ဆောင်ခြင်း
 * 
 * @Override protected void doPost(HttpServletRequest request,
 * HttpServletResponse response) throws ServletException, IOException {
 * 
 * String action = request.getParameter("action"); String sheetIdStr =
 * request.getParameter("sheet_id");
 * 
 * if (sheetIdStr == null) { response.sendRedirect("DashboardServlet"); return;
 * }
 * 
 * int sheetId = Integer.parseInt(sheetIdStr);
 * 
 * if ("insert".equals(action)) { String content =
 * request.getParameter("note_content"); noteRepo.save(sheetId, content); } else
 * if ("update".equals(action)) { int commentId =
 * Integer.parseInt(request.getParameter("comment_id")); String content =
 * request.getParameter("note_content"); noteRepo.update(commentId, content); }
 * else if ("delete".equals(action)) { int commentId =
 * Integer.parseInt(request.getParameter("comment_id"));
 * noteRepo.delete(commentId); }
 * 
 * // အလုပ်ပြီးရင် မူလ detail page ဆီကို redirect လုပ်ပြီး data အသစ်ကို
 * ပြန်ပြမယ် response.sendRedirect("noteAction?id=" + sheetId); } }
 */