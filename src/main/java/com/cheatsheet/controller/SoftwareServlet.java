package com.cheatsheet.controller;

import com.cheatsheet.model.CheatSheet;
import com.cheatsheet.repository.SoftwareRepository;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@WebServlet("/SoftwareServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class SoftwareServlet extends HttpServlet {
    private SoftwareRepository repo = new SoftwareRepository();
    private static final String UPLOAD_DIR = "C:/cheatsheet_uploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            List<CheatSheet> list = repo.findAllSoftware();
            CheatSheet existingSoftware = list.stream()
                .filter(s -> s.getCheatSheetId() == id)
                .findFirst()
                .orElse(null);
            
            request.setAttribute("software", existingSoftware);
            request.getRequestDispatcher("edit_software.jsp").forward(request, response);
        } else {
            request.setAttribute("softwareList", repo.findAllSoftware());
            request.getRequestDispatcher("software.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        // 🎯 Safe Check: Delete သက်သက် လာရင် File Part တွေ လိုက်ဖတ်စရာမလိုဘဲ တိုက်ရိုက် ဖြတ်မောင်းမယ်
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            repo.deleteSoftware(id);
            response.sendRedirect("SoftwareServlet");
            return;
        }

        // Form parameters များကို ဖတ်ယူခြင်း
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String refLink = request.getParameter("reference_link");
        
        Part filePart = request.getPart("softwareLogo"); 
        String imageUrlForDB = null;

        if (filePart != null && filePart.getSize() > 0) {
            String submittedName = getFileName(filePart);
            if (submittedName != null && !submittedName.isEmpty()) {
                String ext = "";
                int dot = submittedName.lastIndexOf('.');
                if (dot > 0) ext = submittedName.substring(dot);
                
                // Unique ဖြစ်တဲ့ File Name ထုတ်ပေးခြင်း
                String uniqueName = System.currentTimeMillis() + "_" + UUID.randomUUID().toString() + ext;
                File uploadDir = new File(UPLOAD_DIR);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                // သတ်မှတ်ထားတဲ့ လမ်းကြောင်းထဲ ဖိုင်သိမ်းဆည်းခြင်း
                filePart.write(uploadDir.getAbsolutePath() + File.separator + uniqueName);
                imageUrlForDB = uniqueName;
            }
        }

        CheatSheet s = new CheatSheet();
        s.setTitle(title);
        s.setContent(content);
        s.setReferenceLink(refLink);

        if ("add".equals(action)) {
            s.setImageUrl(imageUrlForDB);
            repo.insertSoftware(s);
        } 
        else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            s.setCheatSheetId(id);
            
            if (imageUrlForDB != null) {
                s.setImageUrl(imageUrlForDB);
            } else {
                // ပုံအသစ် ရွေးမထားရင် ပုံဟောင်းအတိုင်းပဲ ပြန်သိမ်းဖို့အတွက် Parameter ကနေ ယူနိုင်ပါတယ်
                s.setImageUrl(request.getParameter("existing_image_url"));
            }
            repo.updateSoftware(s);
        }
        
        response.sendRedirect("SoftwareServlet");
    }

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        for (String token : contentDisp.split(";")) {
            if (token.trim().startsWith("filename")) {
                String fileName = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                // လမ်းကြောင်းအမှားများ မပါလာစေရန် Clean ပြုလုပ်ခြင်း
                if (fileName.contains(File.separator)) {
                    fileName = fileName.substring(fileName.lastIndexOf(File.separator) + 1);
                }
                if (fileName.contains("/")) {
                    fileName = fileName.substring(fileName.lastIndexOf('/') + 1);
                }
                return fileName;
            }
        }
        return null;
    }
}