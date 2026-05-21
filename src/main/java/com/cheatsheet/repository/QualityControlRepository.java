package com.cheatsheet.repository;

import java.sql.*;
import java.util.*;
import com.cheatsheet.model.QualityControlDTO;

public class QualityControlRepository {
    private String url = "jdbc:mysql://localhost:3306/cheat_sheet_db"; 
    private String user = "root";
    private String password = "root"; // မိမိစက်၏ Password ပြန်စစ်ပါ

    private Connection getConnection() throws SQLException {
        try { Class.forName("com.mysql.cj.jdbc.Driver"); } 
        catch (ClassNotFoundException e) { e.printStackTrace(); }
        return DriverManager.getConnection(url, user, password);
    }

    /**
     * ၁။ Quality Control Page အတွက် PENDING ဖြစ်နေသော စာရင်းကို ဆွဲထုတ်သည့် Method
     */
    public List<QualityControlDTO> getPendingQCList(String type) {
        List<QualityControlDTO> list = new ArrayList<>();
        String sql = "";

        if (type.equals("Programming")) {
            sql = "SELECT sheet_id AS id, title, content, created_by AS author_name " +
                  "FROM cheatsheets " +
                  "WHERE TRIM(UPPER(status)) = 'PENDING'";
        } else {
            sql = "SELECT e.id, e.title, e.description AS content, u.username AS author_name " +
                  "FROM education e " +
                  "INNER JOIN users u ON e.user_id = u.user_id " +
                  "WHERE TRIM(UPPER(e.status)) = 'PENDING'";
        }

        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                QualityControlDTO dto = new QualityControlDTO();
                dto.setId(rs.getInt("id"));
                dto.setTitle(rs.getString("title"));
                dto.setContent(rs.getString("content"));
                dto.setAuthor(rs.getNString("author_name") != null ? rs.getString("author_name") : "Unknown User"); 
                dto.setType(type);
                list.add(dto);
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return list;
    }

    /**
     * ၂။ cheatsheets table မှ APPROVED ဖြစ်သွားသော Programming ဒေတာများကို ဆွဲထုတ်ရန်
     */
    public List<QualityControlDTO> getAllApprovedCheatsheets() {
        List<QualityControlDTO> list = new ArrayList<>();
        String sql = "SELECT sheet_id AS id, title, content, created_by AS author_name " +
                     "FROM cheatsheets " +
                     "WHERE TRIM(UPPER(status)) = 'APPROVED'";

        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                QualityControlDTO dto = new QualityControlDTO();
                dto.setId(rs.getInt("id"));
                dto.setTitle(rs.getString("title"));
                dto.setContent(rs.getString("content"));
                dto.setAuthor(rs.getNString("author_name") != null ? rs.getString("author_name") : "Unknown User"); 
                dto.setType("Programming"); 
                list.add(dto);
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return list;
    }

    /**
     * ၃။ education table မှ APPROVED ဖြစ်သွားသော Education ဒေတာများကို ဆွဲထုတ်ရန် (အသစ်ဖြည့်စွက်ချက်)
     */
    public List<QualityControlDTO> getAllApprovedEducation() {
        List<QualityControlDTO> list = new ArrayList<>();
        // users table နှင့် join ပြီး စာရေးသူနာမည်ပါ တစ်ခါတည်း ဆွဲထုတ်ပါမည်
        String sql = "SELECT e.id, e.title, e.description AS content, u.username AS author_name, e.category " +
                     "FROM education e " +
                     "INNER JOIN users u ON e.user_id = u.user_id " +
                     "WHERE TRIM(UPPER(e.status)) = 'APPROVED'";

        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                QualityControlDTO dto = new QualityControlDTO();
                dto.setId(rs.getInt("id"));
                dto.setTitle(rs.getString("title"));
                dto.setContent(rs.getString("content"));
                dto.setAuthor(rs.getNString("author_name") != null ? rs.getString("author_name") : "Unknown User"); 
                
                // category ထဲမှာ ရှိတဲ့ တန်ဖိုး (ဥပမာ- Backend, SQL) ကို ယူမယ်၊ မရှိရင် Education လို့ ပြမယ်
                String cat = rs.getString("category");
                dto.setType(cat != null ? cat : "Education"); 
                
                list.add(dto);
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return list;
    }

    /**
     * ၄။ Approve သို့မဟုတ် Reject လုပ်လျှင် Status ပြောင်းလဲပေးသည့် အလုပ်လုပ်ဆောင်ချက်
     */
    public void updateStatus(int id, String action, String type) {
        String table = type.equalsIgnoreCase("Programming") ? "cheatsheets" : "education";
        String idCol = type.equalsIgnoreCase("Programming") ? "sheet_id" : "id";
        String sql = action.equals("approve") ? 
            "UPDATE " + table + " SET status = 'approved' WHERE " + idCol + " = ?" : 
            "DELETE FROM " + table + " WHERE " + idCol + " = ?";
            
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }
}