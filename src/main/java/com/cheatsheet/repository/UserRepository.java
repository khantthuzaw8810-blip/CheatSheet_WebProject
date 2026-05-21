package com.cheatsheet.repository;

import com.cheatsheet.config.DBconnect;
import com.cheatsheet.model.User;
import java.sql.*;
import org.mindrot.jbcrypt.BCrypt;

public class UserRepository {

    // ၁။ Register လုပ်တဲ့အခါ User အသစ်သိမ်းဖို့ (မူရင်းအတိုင်း)
    public boolean save(User user) {
        String sql = "INSERT INTO users (username, password_hash, role) VALUES (?, ?, ?)";
        
        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getUsername().trim());
            ps.setString(2, user.getPasswordHash());
            
            String role = (user.getRole() != null) ? user.getRole() : "user";
            ps.setString(3, role);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ၂။ Login ဝင်တဲ့အခါ Username နဲ့ ရှာဖို့ (မူရင်းအတိုင်း)
    public User findByUsername(String username) {
        String sql = "SELECT user_id, username, password_hash, role FROM users WHERE username = ?";
        
        try (Connection conn = DBconnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username.trim());
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setPasswordHash(rs.getString("password_hash"));
                    user.setRole(rs.getString("role"));
                    return user;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ၃။ Username ပြောင်းချင်တဲ့အခါ သုံးဖို့ (မူရင်းအတိုင်း)
    public boolean updateUsername(int userId, String newUsername) {
        String sql = "UPDATE users SET username = ? WHERE user_id = ?";
        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newUsername.trim());
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ၄။ Password ပြောင်းချင်တဲ့အခါ (သို့) Reset လုပ်တဲ့အခါ သုံးဖို့ (မူရင်းအတိုင်း)
    public boolean updatePassword(int userId, String newPasswordHash) {
        String sql = "UPDATE users SET password_hash = ? WHERE user_id = ?";
        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPasswordHash);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ၅။ ➕ အသစ်ထည့်သွင်းပေးထားသော Profile ကတ်မှ BCrypt ဖြင့် လုံခြုံစွာ စကားဝှက်ချိန်းရန် Method
    public boolean updatePasswordByUsername(String username, String newPasswordPlain) {
        String hashedPassword = BCrypt.hashpw(newPasswordPlain, BCrypt.gensalt(10));
        String sql = "UPDATE users SET password_hash = ? WHERE username = ?";
        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashedPassword);
            ps.setString(2, username);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}