package com.cheatsheet.repository;

import com.cheatsheet.config.DBconnect;
import com.cheatsheet.model.CheatSheet;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SoftwareRepository {

    // Software Category ID ကို ၂ လို့ သတ်မှတ်လိုက်ပါမယ် (success.jsp အရ)
    private static final int SOFT_CAT_ID = 2;

    // 1. Read All
    public List<CheatSheet> findAllSoftware() {
        List<CheatSheet> list = new ArrayList<>();
        // category_id = 2 လို့ ပြောင်းလိုက်ပါတယ်
        String sql = "SELECT * FROM cheatsheets WHERE category_id = ? ORDER BY updated_at DESC";
        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, SOFT_CAT_ID);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                CheatSheet s = new CheatSheet();
                s.setCheatSheetId(rs.getInt("sheet_id"));
                s.setTitle(rs.getString("title"));
                s.setContent(rs.getString("content"));
                s.setImageUrl(rs.getString("image_url"));
                s.setReferenceLink(rs.getString("reference_link"));
                s.setUpdatedAt(rs.getTimestamp("updated_at"));
                list.add(s);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // 2. Create
    public boolean insertSoftware(CheatSheet s) {
        // category_id နေရာမှာ ၂ ကို သုံးပါမယ်
        String sql = "INSERT INTO cheatsheets (title, content, category_id, image_url, reference_link, created_at, updated_at) VALUES (?,?,?,?,?,NOW(),NOW())";
        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getTitle());
            ps.setString(2, s.getContent());
            ps.setInt(3, SOFT_CAT_ID);
            ps.setString(4, s.getImageUrl());
            ps.setString(5, s.getReferenceLink());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // 3. Update
    public void updateSoftware(CheatSheet s) {
        String sql = "UPDATE cheatsheets SET title=?, content=?, reference_link=?, image_url=?, updated_at=NOW() WHERE sheet_id=?";
        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getTitle());
            ps.setString(2, s.getContent());
            ps.setString(3, s.getReferenceLink()); // Link ပါလာပြီ
            ps.setString(4, s.getImageUrl());
            ps.setInt(5, s.getCheatSheetId());
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void updateSoftwareWithoutImage(CheatSheet s) {
        String sql = "UPDATE cheatsheets SET title=?, content=?, reference_link=?, updated_at=NOW() WHERE sheet_id=?";
        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getTitle());
            ps.setString(2, s.getContent());
            ps.setString(3, s.getReferenceLink()); // Link ပါလာပြီ
            ps.setInt(4, s.getCheatSheetId());
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
    // 4. Delete
    public boolean deleteSoftware(int id) {
        // category_id = 2 ဖြစ်တဲ့ data ကိုပဲ ဖျက်မယ်
        String sql = "DELETE FROM cheatsheets WHERE sheet_id=? AND category_id=?";
        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, SOFT_CAT_ID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}