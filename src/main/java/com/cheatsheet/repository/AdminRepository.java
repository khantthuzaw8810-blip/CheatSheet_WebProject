package com.cheatsheet.repository;

import com.cheatsheet.config.DBconnect;
import com.cheatsheet.model.AdminUser;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminRepository {

    // User အားလုံးကို ယူရန်
    public List<AdminUser> getAllUsers() {
        List<AdminUser> list = new ArrayList<>();
        String sql = "SELECT user_id, username, role, status FROM users";
        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                AdminUser u = new AdminUser();
                u.setUserId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setRole(rs.getString("role"));
                u.setStatus(rs.getString("status"));
                list.add(u);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // နာမည်ဖြင့် ရှာဖွေရန် (Search Logic)
    public List<AdminUser> searchUsers(String name) {
        List<AdminUser> list = new ArrayList<>();
        String sql = "SELECT user_id, username, role, status FROM users WHERE username LIKE ?";
        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + name + "%"); // LIKE %name% သုံးထား၍ နာမည်တစ်စိတ်တစ်ပိုင်းဖြင့် ရှာနိုင်သည်
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                AdminUser u = new AdminUser();
                u.setUserId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setRole(rs.getString("role"));
                u.setStatus(rs.getString("status"));
                list.add(u);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Dashboard အရေအတွက်များ တွက်ချက်ရန်
    public int getCount(String tableName, String condition) {
        String sql = "SELECT COUNT(*) FROM " + tableName + (condition != null ? " WHERE " + condition : "");
        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    // Status ပြင်ဆင်ရန် (Ban/Unban)
    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE users SET status = ? WHERE user_id = ?";
        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }
}