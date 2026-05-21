package com.cheatsheet.controller;

import com.cheatsheet.config.DBconnect;
import com.cheatsheet.model.CheatSheet;
import com.cheatsheet.repository.CheatSheetRepository;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.util.UUID;

@WebServlet("/CheatSheetServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class CheatSheetServlet extends HttpServlet {
    private static final String UPLOAD_DIR = "C:/cheatsheet_uploads";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        // Session ထဲကနေ လက်ရှိ Login ဝင်ထားသည့် Username ကို ယူခြင်း (မူလအတိုင်း)
        HttpSession session = request.getSession();
        String currentUsername = (String) session.getAttribute("username");
        
        if (currentUsername == null || currentUsername.isEmpty()) {
            currentUsername = "Unknown"; 
        }

        try (Connection conn = DBconnect.getConnection()) {
            CheatSheetRepository repository = new CheatSheetRepository(conn);

            if ("add".equals(action) || "update".equals(action)) {
                // Form Data များကို ယူခြင်း (မူလအတိုင်း)
                String title = request.getParameter("title");
                String content = request.getParameter("content");
                String referenceLink = request.getParameter("referenceLink");
                
                String catIdRaw = request.getParameter("categoryId");
                int categoryId = (catIdRaw != null && !catIdRaw.isEmpty()) ? Integer.parseInt(catIdRaw) : 1;

                // Image Upload Handle လုပ်ခြင်း (မူလအတိုင်း)
                Part filePart = request.getPart("imageFile");
                String imageUrlForDB = null;

                if (filePart != null && filePart.getSize() > 0) {
                    String uniqueName = saveImage(filePart);
                    if (uniqueName != null) {
                        imageUrlForDB = uniqueName;
                    }
                }

                // CheatSheet Object တည်ဆောက်ခြင်း
                CheatSheet sheet = new CheatSheet();
                sheet.setTitle(title);
                sheet.setContent(content);
                sheet.setCategoryId(categoryId);
                sheet.setReferenceLink(referenceLink);
                sheet.setImageUrl(imageUrlForDB);
                
                // တင်သည့်လူကို သတ်မှတ်ပေးခြင်း
                sheet.setCreatedBy(currentUsername); 

                if ("add".equals(action)) {
                    // 🚀 🎯 အသစ်တင်သည့်အခါတွင် အလိုအလျောက် ပိတ်ထားရန် PENDING စာသား သတ်မှတ်ပေးခြင်း
                    sheet.setStatus("PENDING"); 
                    repository.insert(sheet);
                } else {
                    String idRaw = request.getParameter("id");
                    if (idRaw != null && !idRaw.isEmpty()) {
                        int currentId = Integer.parseInt(idRaw);
                        sheet.setCheatSheetId(currentId);
                        
                        // 🚀 🎯 [ပြင်ဆင်လိုက်သည့်နေရာ] - အကယ်၍ Update လုပ်လျှင် မူလရှိပြီးသား Status ကို ဒေတာဘေ့စ်မှ ပြန်ရှာဖတ်ပြီး 
                        // Status ပျောက်ပျက်မသွားစေရန် သို့မဟုတ် ပြင်လိုက်လျှင် စီစစ်ရန်အလို့ငှာ ပြန်လည်ထိန်းသိမ်းပေးခြင်း
                        CheatSheet oldSheet = repository.findById(currentId);
                        if (oldSheet != null) {
                            sheet.setStatus(oldSheet.getStatus());
                            // အကယ်၍ ပုံအသစ်ထပ်မတင်ဖြစ်ခဲ့ရင် မူလပုံဟောင်းအတိုင်း ပြန်သိမ်းပေးရန် ကာကွယ်ခြင်း
                            if (imageUrlForDB == null) {
                                sheet.setImageUrl(oldSheet.getImageUrl());
                            }
                        } else {
                            sheet.setStatus("PENDING");
                        }
                        
                        repository.update(sheet);
                    }
                }
            } else if ("delete".equals(action)) {
                String idRaw = request.getParameter("id");
                if (idRaw != null && !idRaw.isEmpty()) {
                    repository.delete(Integer.parseInt(idRaw));
                }
            }
            
            // အောင်မြင်ရင် List ကို ပြန်သွားမယ်
            response.sendRedirect(request.getContextPath() + "/CheatSheetListServlet");

        } catch (Exception e) {
            e.printStackTrace();
            handleError(response, e);
        }
    }

    // Image သိမ်းဆည်းသည့် Helper Method (မူလအတိုင်း လုံးဝမပြောင်းလဲပါ)
    private String saveImage(Part filePart) throws IOException {
        String submittedName = getFileName(filePart);
        if (submittedName == null || submittedName.isEmpty()) return null;

        String ext = "";
        int dot = submittedName.lastIndexOf('.');
        if (dot > 0) ext = submittedName.substring(dot);
        
        String uniqueName = System.currentTimeMillis() + "_" + UUID.randomUUID().toString() + ext;
        File uploadDir = new File(UPLOAD_DIR);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        filePart.write(uploadDir.getAbsolutePath() + File.separator + uniqueName);
        return uniqueName;
    }

    // Filename ထုတ်ယူသည့် Helper Method (မူလအတိုင်း လုံးဝမပြောင်းလဲပါ)
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        for (String token : contentDisp.split(";")) {
            if (token.trim().startsWith("filename")) {
                String fileName = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                return fileName.substring(fileName.lastIndexOf(File.separator) + 1).substring(fileName.lastIndexOf('/') + 1);
            }
        }
        return null;
    }

    // Error ပြသပေးသည့် Helper Method (မူလအတိုင်း လုံးဝမပြောင်းလဲပါ)
    private void handleError(HttpServletResponse response, Exception e) throws IOException {
        response.setContentType("text/html");
        response.getWriter().println("<h3 style='color:red;'>Error: " + e.getMessage() + "</h3>");
        response.getWriter().println("<a href='javascript:history.back()'>Go Back</a>");
    }
}