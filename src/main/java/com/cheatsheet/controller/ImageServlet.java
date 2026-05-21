package com.cheatsheet.controller;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import java.io.*;

@WebServlet("/ImageServlet")
public class ImageServlet extends HttpServlet {
    private static final String UPLOAD_DIR = "C:/cheatsheet_uploads";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String name = req.getParameter("name");

         
        if (name == null || name.isEmpty() || name.contains("..")  ||name.contains("/")|| name.contains("\\")) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);

            return;
        }

        File file = new File(UPLOAD_DIR, name);
        if (!file.exists() || !file.isFile()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String mime = getServletContext().getMimeType(file.getName());
        if (mime == null) mime = "application/octet-stream";
        resp.setContentType(mime);
        resp.setContentLengthLong(file.length());
        resp.setHeader("Cache-Control", "public, max-age=86400");

        try (BufferedInputStream in = new BufferedInputStream(new FileInputStream(file));
             ServletOutputStream out = resp.getOutputStream()) {
            byte[] buffer = new byte[8192];
            int len;
            while ((len = in.read(buffer)) != -1) {
                out.write(buffer, 0, len);
            }
            out.flush();
        } catch (IOException ex) {
            log("Error streaming image: " + name, ex);
            if (!resp.isCommitted()) resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
