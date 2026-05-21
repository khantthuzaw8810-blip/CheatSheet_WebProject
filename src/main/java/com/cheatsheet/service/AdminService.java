package com.cheatsheet.service;

import java.sql.*;
import java.util.*;
import com.cheatsheet.model.AdminUser;
import com.cheatsheet.config.DBconnect;
import org.mindrot.jbcrypt.BCrypt;

public class AdminService {

    // --- Login Logic (Includes Ban Validation) ---
    public AdminUser authenticate(String username, String password) {
        AdminUser user = null;
        String sql = "SELECT user_id, username, password, role, status FROM users WHERE username = ?";

        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, username);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String hashed = rs.getString("password");
                    
                    // Verify password using BCrypt
                    if (BCrypt.checkpw(password, hashed)) {
                        user = new AdminUser(
                            rs.getInt("user_id"),
                            rs.getString("username"),
                            rs.getString("role"),
                            rs.getString("status") 
                        );
                    }
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return user;
    }

    // 1. Get Total Users for Dashboard
    public int getTotalUsersCount() {
        int count = 0;
        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM users");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) count = rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return count;
    }

    // 2. Get Total Sheets for Dashboard
    public int getTotalSheetsCount() {
        int count = 0;
        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM cheatsheets");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) count = rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return count;
    }

    // 3. Get Banned Users count for Dashboard
    public int getBannedUsersCount() {
        int count = 0;
        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM users WHERE status = 'BANNED'")) {
             try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) count = rs.getInt(1);
             }
        } catch (SQLException e) { e.printStackTrace(); }
        return count;
    }

    // 4. Command Center - Search or Fetch All Users (Including Admins)
    public List<AdminUser> searchUsers(String searchQuery) {
        List<AdminUser> list = new ArrayList<>();
        String sql;
        boolean isSearching = (searchQuery != null && !searchQuery.trim().isEmpty());

        // Removed "AND role != 'admin'" to show all account types
        if (isSearching) {
            sql = "SELECT user_id, username, role, status FROM users WHERE username LIKE ?";
        } else {
            sql = "SELECT user_id, username, role, status FROM users";
        }

        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            if (isSearching) {
                ps.setString(1, "%" + searchQuery.trim() + "%");
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new AdminUser(
                        rs.getInt("user_id"), 
                        rs.getString("username"), 
                        rs.getString("role"), 
                        rs.getString("status")
                    ));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // 5. Update User Status (Ban/Unban)
    public void updateUserStatus(int id, String status) {
        String formattedStatus = status.toUpperCase(); 
        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE users SET status = ? WHERE user_id = ?")) {
            ps.setString(1, formattedStatus);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public List<AdminUser> fetchAllUsers() {
        return searchUsers(null);
    }
}