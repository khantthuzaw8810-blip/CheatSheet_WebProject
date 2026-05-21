package com.cheatsheet.repository;

import com.cheatsheet.model.Education;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EducationRepository {
    
    private Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection("jdbc:mysql://localhost:3306/cheat_sheet_db", "root", "root");
    }

    /**
     * ✅ ၁။ Education List အားလုံးကို ဆွဲထုတ်ခြင်း (အသစ်တင်သမျှ တန်းပေါ်စေရန် အကုန်ဆွဲထုတ်ပါသည်)
     */
    public List<Education> getAll() {
        List<Education> list = new ArrayList<>();
        String sql = "SELECT e.*, IFNULL(u.username, 'Unknown') AS created_by FROM education e " +
                     "LEFT JOIN users u ON e.user_id = u.user_id " +
                     "ORDER BY e.created_at DESC";
        
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Education e = new Education();
                e.setId(rs.getInt("id"));
                e.setTitle(rs.getString("title"));
                e.setDescription(rs.getString("description"));
                e.setCategory(rs.getString("category"));
                e.setImageUrl(rs.getString("image_url"));
                e.setUserId(rs.getInt("user_id"));
                e.setCreatedAt(rs.getString("created_at"));
                e.setStatus(rs.getString("status"));
                e.setCreatedBy(rs.getString("created_by")); 
                list.add(e);
            }
        } catch (Exception ex) { 
            ex.printStackTrace(); 
        }
        return list;
    }

    // ✅ ၂။ New Content သိမ်းဆည်းခြင်း (Status ကို 'pending' အဖြစ် သိမ်းဆည်းပါသည်)
    public boolean save(Education edu) {
        String sql = "INSERT INTO education (title, description, image_url, category, user_id, status, created_at) VALUES (?, ?, ?, ?, ?, 'pending', NOW())";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, edu.getTitle());
            ps.setString(2, edu.getDescription());
            ps.setString(3, edu.getImageUrl());
            ps.setString(4, edu.getCategory());
            ps.setInt(5, edu.getUserId());
            return ps.executeUpdate() > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        }
    }

    // ✅ ၃။ ID ဖြင့် ဒေတာ ရှာဖွေခြင်း
    public Education getById(int id) {
        String sql = "SELECT e.*, IFNULL(u.username, 'Unknown') AS created_by FROM education e " +
                     "LEFT JOIN users u ON e.user_id = u.user_id " + 
                     "WHERE e.id = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Education e = new Education();
                e.setId(rs.getInt("id"));
                e.setTitle(rs.getString("title"));
                e.setDescription(rs.getString("description"));
                e.setImageUrl(rs.getString("image_url"));
                e.setCategory(rs.getString("category"));
                e.setUserId(rs.getInt("user_id")); 
                e.setCreatedAt(rs.getString("created_at"));
                e.setStatus(rs.getString("status"));
                e.setCreatedBy(rs.getString("created_by"));
                return e;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
    }

    // ✅ ၄။ Update Logic
    public boolean update(int id, String title, String description, String imageUrl, String category) {
        String sql = "UPDATE education SET title=?, description=?, image_url=?, category=? WHERE id=?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, imageUrl);
            ps.setString(4, category);
            ps.setInt(5, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ ၅။ Object ပုံစံဖြင့် Update ပြုလုပ်ရန် Method အပို
    public boolean update(Education edu) {
        return update(edu.getId(), edu.getTitle(), edu.getDescription(), edu.getImageUrl(), edu.getCategory());
    }

    // ✅ ၆။ Delete Logic
    public boolean delete(int id) {
        String sql = "DELETE FROM education WHERE id = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        }
    }

    // ✅ ၇။ Admin မှ Content အား အတည်ပြု (Approve) ပေးသည့် Logic
    public boolean approveStatus(int id) {
        String sql = "UPDATE education SET status = 'approved' WHERE id = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        }
    }

    // =========================================================================
    // 🚀 [➕ ထပ်တိုးရန်] SUBMISSION HUB အတွက် လိုအပ်သော နည်းလမ်းအသစ်များ (မူရင်းကုဒ်များကို လုံးဝမထိခိုက်ပါ)
    // =========================================================================

    /**
     * ✅ ၈။ Approved ဖြစ်ပြီးသား ဒေတာများကိုသာ သီးသန့်ဆွဲထုတ်ခြင်း (Submission Hub တွင် ပြသရန်)
     */
    public List<Education> getAllApproved() {
        List<Education> list = new ArrayList<>();
        String sql = "SELECT e.*, IFNULL(u.username, 'Unknown') AS created_by FROM education e " +
                     "LEFT JOIN users u ON e.user_id = u.user_id " +
                     "WHERE LOWER(e.status) = 'approved' " +
                     "ORDER BY e.created_at DESC";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Education e = new Education();
                e.setId(rs.getInt("id"));
                e.setTitle(rs.getString("title"));
                e.setDescription(rs.getString("description"));
                e.setCategory(rs.getString("category"));
                e.setImageUrl(rs.getString("image_url"));
                e.setUserId(rs.getInt("user_id"));
                e.setCreatedAt(rs.getString("created_at"));
                e.setStatus(rs.getString("status"));
                e.setCreatedBy(rs.getString("created_by")); 
                list.add(e);
            }
        } catch (Exception ex) { 
            ex.printStackTrace(); 
        }
        return list;
    }

    /**
     * ✅ ၉။ General Favorites ဇယားထဲသို့ ဒေတာ ထည့်သွင်းခြင်း / ဖျက်ထုတ်ခြင်း (Toggle Logic)
     */
    public boolean toggleGeneralFavorite(int userId, int contentId, String contentType) {
        boolean isFav = isGeneralFavorite(userId, contentId, contentType);
        
        if (isFav) {
            String deleteSql = "DELETE FROM general_favorites WHERE user_id = ? AND content_id = ? AND LOWER(content_type) = LOWER(?)";
            try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(deleteSql)) {
                ps.setInt(1, userId);
                ps.setInt(2, contentId);
                ps.setString(3, contentType);
                return ps.executeUpdate() > 0;
            } catch (Exception ex) { ex.printStackTrace(); }
        } else {
            String insertSql = "INSERT INTO general_favorites (user_id, content_id, content_type) VALUES (?, ?, ?)";
            try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(insertSql)) {
                ps.setInt(1, userId);
                ps.setInt(2, contentId);
                ps.setString(3, contentType.toUpperCase());
                return ps.executeUpdate() > 0;
            } catch (Exception ex) { ex.printStackTrace(); }
        }
        return false;
    }

    /**
     * ✅ ၁၀။ သတ်မှတ်ထားသော User က ဤပို့စ်အား Fav ပေးထားခြင်း ရှိမရှိ စစ်ဆေးခြင်း
     */
    public boolean isGeneralFavorite(int userId, int contentId, String contentType) {
        String sql = "SELECT favorite_id FROM general_favorites WHERE user_id = ? AND content_id = ? AND LOWER(content_type) = LOWER(?)";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, contentId);
            ps.setString(3, contentType);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception ex) { ex.printStackTrace(); }
        return false;
    }
}