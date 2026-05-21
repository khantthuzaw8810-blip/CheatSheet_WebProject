package com.cheatsheet.repository;

import com.cheatsheet.config.DBconnect;
import com.cheatsheet.model.AdminUser;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CommandCenterRepository {

    /**
     * User အားလုံးကို ရှာဖွေရန် သို့မဟုတ် နာမည်ဖြင့် ရှာရန်
     * Admin မဟုတ်သော ရိုးရိုး User များကိုသာ ပြသမည်
     */
    public List<AdminUser> searchUsers(String query) {
        List<AdminUser> list = new ArrayList<>();
        
        // SQL: Admin မဟုတ်သူတွေကိုပဲ ပြမယ်။ Search ပါရင် LIKE နဲ့ ရှာမယ်။
        String sql = (query == null || query.trim().isEmpty()) 
                     ? "SELECT * FROM users WHERE role != 'admin'" 
                     : "SELECT * FROM users WHERE role != 'admin' AND username LIKE ?";

        try (Connection con = DBconnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            if (query != null && !query.trim().isEmpty()) {
                ps.setString(1, "%" + query + "%");
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                AdminUser user = new AdminUser();
                user.setUserId(rs.getInt("user_id")); // Table ထဲက column နာမည်
                user.setUsername(rs.getString("username"));
                user.setRole(rs.getString("role"));
                user.setStatus(rs.getString("status")); // active သို့မဟုတ် banned
                list.add(user);
            }
        } catch (SQLException e) {
            System.out.println("Error searching users: " + e.getMessage());
        }
        return list;
    }

    /**
     * Account ကို Ban ရန် သို့မဟုတ် Unban ရန် (Status ပြောင်းရန်)
     */
    public boolean updateUserStatus(int userId, String newStatus) {
        String sql = "UPDATE users SET status = ? WHERE user_id = ?";
        
        try (Connection con = DBconnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, newStatus); // "banned" သို့မဟုတ် "active"
            ps.setInt(2, userId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0; // အောင်မြင်ရင် true ပြန်မယ်
            
        } catch (SQLException e) {
            System.out.println("Error updating user status: " + e.getMessage());
            return false;
        }
    }
}