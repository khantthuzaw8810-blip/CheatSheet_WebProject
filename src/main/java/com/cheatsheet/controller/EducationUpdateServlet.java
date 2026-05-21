package com.cheatsheet.controller;

import com.cheatsheet.repository.EducationRepository;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/EducationUpdateServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class EducationUpdateServlet extends HttpServlet {
    private EducationRepository repository = new EducationRepository();
    private static final String UPLOAD_DIR = "C:/cheatsheet_uploads"; // ImageServlet နဲ့ တူရပါမယ်

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            // 🔒 Multipart ဖောင်ဖြစ်သောကြောင့် request.getParameter အစား getValueFromPart ဖြင့် စိတ်ချရအောင် ဖတ်ပါမည်။
            String idStr = getValueFromPart(request.getPart("id"));
            String title = getValueFromPart(request.getPart("title"));
            String description = getValueFromPart(request.getPart("description"));
            String category = getValueFromPart(request.getPart("category"));
            String oldImageName = getValueFromPart(request.getPart("oldImageName"));

            // ID ကို Integer ပြောင်းခြင်း
            int id = Integer.parseInt(idStr);
            
            // ပုံအသစ် တင်၊ မတင် စစ်ဆေးခြင်း
            Part filePart = request.getPart("imageFile");
            String fileName = (filePart != null) ? filePart.getSubmittedFileName() : "";
            String finalImageName;

            if (fileName != null && !fileName.isEmpty()) {
                // Folder မရှိသေးလျှင် ဆောက်ပေးခြင်း
                File uploadDir = new File(UPLOAD_DIR);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                
                // ပုံအသစ်တင်လျှင် External folder ထဲ သိမ်းမည်
                filePart.write(UPLOAD_DIR + File.separator + fileName);
                finalImageName = fileName;
            } else {
                // ပုံအသစ်မတင်လျှင် ပုံဟောင်းအမည်ကိုပဲ ပြန်ယူမည်
                finalImageName = oldImageName; 
            }

            // Database ထဲတွင် Update လုပ်ခြင်း (မူလ Logic အတိုင်း)
            boolean success = repository.update(id, title, description, finalImageName, category);

            if (success) {
                response.sendRedirect("EducationList"); // အောင်မြင်လျှင် list သို့ ပြန်သွားမည်
            } else {
                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().println("<h3>Update Failed in Database!</h3>");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<h3>Error: " + e.getMessage() + "</h3>");
        }
    }

    // 🎯 Part ထဲကစာသားကို သန့်သန့်ရှင်းရှင်း String ပြန်ပြောင်းပေးပြီး HTML tags တွေမကွဲအောင် ထိန်းပေးသည့် Helper Method
    private String getValueFromPart(Part part) throws IOException {
        if (part == null) return "";
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(part.getInputStream(), "UTF-8"))) {
            StringBuilder value = new StringBuilder();
            char[] buffer = new char[1024];
            int length;
            while ((length = reader.read(buffer)) > 0) {
                value.append(buffer, 0, length);
            }
            return value.toString().trim();
        }
    }
}