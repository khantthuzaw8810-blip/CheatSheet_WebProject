package com.cheatsheet.controller;

import com.cheatsheet.model.Education;
import com.cheatsheet.repository.EducationRepository;

import java.io.File;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet("/EducationList")
@MultipartConfig
public class EducationServlet extends HttpServlet {
    private EducationRepository repository = new EducationRepository();
    private static final String UPLOAD_DIR = "C:/cheatsheet_uploads";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        String userRole = "user"; // ပုံမှန်အားဖြင့် user ဟု သတ်မှတ်မည်
        
        if (session != null && session.getAttribute("role") != null) {
            userRole = (String) session.getAttribute("role");
        }

        // 🚀 ၁။ Admin Approve ပြုလုပ်သည့် Logic အား ထည့်သွင်းခြင်း
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");

        if ("approve".equals(action) && idStr != null) {
            if ("admin".equalsIgnoreCase(userRole)) { // Admin ဖြစ်မှသာ ခွင့်ပြုမည်
                try {
                    int id = Integer.parseInt(idStr);
                    repository.approveStatus(id); 
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            // Approve လုပ်ပြီးပါက List စာမျက်နှာကို Refresh ဖြစ်အောင် ပြန်မောင်းနှင်မည်
            response.sendRedirect("EducationList");
            return;
        }

        // 🚀 ၂။ Role အပေါ်မူတည်၍ အတည်ပြုပြီးသား (သို့မဟုတ်) အားလုံးကို ဆွဲထုတ်ခြင်း
     // 🚀 အားလုံးမြင်ရအောင် Parameter မပါဘဲ ရိုးရိုးပဲ လှမ်းခေါ်ခိုင်းလိုက်ပါပြီ
        List<Education> list = repository.getAll();
        request.setAttribute("eduList", list);
        
        request.getRequestDispatcher("education.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");

        // ၁။ Session စစ်ဆေးခြင်း
        HttpSession session = request.getSession(false); 
        Integer userId = null;
        
        if (session != null) {
            userId = (Integer) session.getAttribute("user_id");
        }

        // ၂။ Debug လုပ်ရန်
        System.out.println("DEBUG: Current User ID is: " + userId);
        
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=session_expired");
            return;
        }

        // Form data ယူခြင်း
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String category = request.getParameter("category");

        // ပုံသိမ်းခြင်း
        Part filePart = request.getPart("imageFile");
        String fileName = (filePart != null) ? filePart.getSubmittedFileName() : "";
        
        if (fileName != null && !fileName.isEmpty()) {
            File uploadDir = new File(UPLOAD_DIR);
            if (!uploadDir.exists()) uploadDir.mkdirs();
            filePart.write(UPLOAD_DIR + File.separator + fileName);
        }

        // ၃။ Model ထဲထည့်ခြင်း
        Education edu = new Education();
        edu.setTitle(title);
        edu.setDescription(description);
        edu.setCategory(category);
        edu.setImageUrl(fileName);
        edu.setUserId(userId); 

        // 🚀 ၄။ Database သိမ်းခြင်းနှင့် လမ်းကြောင်း တိုက်ရိုက်လွှဲခြင်း (Redirect)
        try {
            boolean isSaved = repository.save(edu);
            
            if (isSaved) {
                // ✨ ဒီနေရာမှာ စာတန်းစိမ်းပြတဲ့ ရည်ညွှန်းချက်ကို ဖြုတ်ပြီး Main List ဆီ တန်းမောင်းလိုက်တာဖြစ်ပါတယ်
                response.sendRedirect("EducationList");
            } else {
                response.sendRedirect("add-education.jsp?error=save_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("add-education.jsp?error=save_failed");
        }
    }
}