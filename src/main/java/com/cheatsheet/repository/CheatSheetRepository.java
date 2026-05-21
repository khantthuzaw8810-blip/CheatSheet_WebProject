package com.cheatsheet.repository;

import com.cheatsheet.model.CheatSheet;
import java.sql.*;
import java.util.*;

public class CheatSheetRepository {
    private Connection conn;

    public CheatSheetRepository(Connection conn) {
        this.conn = conn;
    }

    // ✅ ၁။ Insert (User တင်လိုက်တာနဲ့ status ရော created_by ပါ တစ်ခါတည်း သွင်းမည့်စနစ်)
    // 🚀 🎯 [ထပ်ပေါင်းထည့်ပြင်ဆင်သည့်နေရာ] - SQL Query တွင် created_by နှင့် status ကို Parameter အဖြစ် ထည့်သွင်းခြင်း
    public void insert(CheatSheet sheet) throws SQLException {
        String sql = "INSERT INTO cheatsheets (title, content, category_id, image_url, reference_link, status, created_by, created_at, updated_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, sheet.getTitle());
            stmt.setString(2, sheet.getContent());
            stmt.setInt(3, sheet.getCategoryId());
            stmt.setString(4, sheet.getImageUrl());
            stmt.setString(5, sheet.getReferenceLink());
            stmt.setString(6, sheet.getStatus() != null ? sheet.getStatus() : "PENDING"); // 👈 status တန်ဖိုးသွင်းခြင်း
            stmt.setString(7, sheet.getCreatedBy()); // 👈 created_by (တင်သည့်လူအမည်) သွင်းခြင်း
            stmt.executeUpdate();
        }
    }

    // ✅ ၂။ Find All (JSP ဘက်မှာ Logic စစ်နိုင်ရန် ဒေတာအားလုံးကို status, created_by ပါ ဆွဲထုတ်ခြင်း)
    // 🚀 🎯 [ထပ်ပေါင်းထည့်ပြင်ဆင်သည့်နေရာ] - WHERE status ကန့်သတ်ချက်ကို ဖြုတ်ပြီး အကုန်ဆွဲထုတ်မှ JSP က ပိုင်ရှင်ကို Disable/Enable စစ်နိုင်မည်
    public List<CheatSheet> findAll() throws SQLException {
        List<CheatSheet> list = new ArrayList<>();
        String sql = "SELECT * FROM cheatsheets ORDER BY updated_at DESC";
        
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapResultSetToModel(rs));
            }
        }
        return list;
    }

    // ✅ ၃။ Update (မူလ အစ်ကို့ code အတိုင်း Image ရော ID ရော စနစ်တကျ ထားရှိပါသည်)
    public void update(CheatSheet sheet) throws SQLException {
        String sql = "UPDATE cheatsheets SET title=?, content=?, category_id=?, reference_link=?, updated_at=NOW()";
        if (sheet.getImageUrl() != null) {
            sql += ", image_url=?";
        }
        sql += " WHERE sheet_id=?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, sheet.getTitle());
            stmt.setString(2, sheet.getContent());
            stmt.setInt(3, sheet.getCategoryId());
            stmt.setString(4, sheet.getReferenceLink());

            if (sheet.getImageUrl() != null) {
                stmt.setString(5, sheet.getImageUrl());
                stmt.setInt(6, sheet.getCheatSheetId());
            } else {
                stmt.setInt(5, sheet.getCheatSheetId());
            }
            stmt.executeUpdate();
        }
    }

    // ✅ ၄။ Find By ID (Detail ကြည့်ရန်)
    public CheatSheet findById(int id) throws SQLException {
        String sql = "SELECT * FROM cheatsheets WHERE sheet_id=?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapResultSetToModel(rs);
            }
        }
        return null;
    }

    // ✅ ၅။ Delete (ဖျက်ရန်)
    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM cheatsheets WHERE sheet_id=?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    // ✅ ၆။ Helper Method (Database Result များကို Model ထဲ ထည့်သွင်းခြင်း)
    // 🚀 🎯 [ထပ်ပေါင်းထည့်ပြင်ဆင်သည့်နေရာ] - status နှင့် created_by တို့ကို Model အသစ်ထဲသို့ တိတိကျကျ ဆွဲထည့်ပေးလိုက်ခြင်း
    private CheatSheet mapResultSetToModel(ResultSet rs) throws SQLException {
        CheatSheet s = new CheatSheet();
        s.setCheatSheetId(rs.getInt("sheet_id"));
        s.setTitle(rs.getString("title"));
        s.setContent(rs.getString("content"));
        s.setCategoryId(rs.getInt("category_id"));
        s.setImageUrl(rs.getString("image_url"));
        s.setReferenceLink(rs.getString("reference_link"));
        s.setCreatedAt(rs.getTimestamp("created_at"));
        s.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        // ညီလေးရဲ့ CheatSheet Model ထဲက Variable တွေဆီ ဒေတာ လှမ်းထည့်ပေးလိုက်ပြီနော်
        s.setStatus(rs.getString("status")); 
        s.setCreatedBy(rs.getString("created_by")); 
        return s;
    }
}