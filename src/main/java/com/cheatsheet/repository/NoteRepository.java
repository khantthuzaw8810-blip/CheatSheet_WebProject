/*
 * package com.cheatsheet.repository;
 * 
 * import com.cheatsheet.config.DBconnect; import com.cheatsheet.model.Comment;
 * import java.sql.*; import java.util.ArrayList; import java.util.List; import
 * java.util.Map;
 * 
 * public class NoteRepository {
 * 
 * // ၁။ သက်ဆိုင်ရာ Card (Sheet) အလိုက် Note များအားလုံးကို ဆွဲထုတ်ခြင်း public
 * List<Comment> findAllBySheetId(int sheetId) { List<Comment> notes = new
 * ArrayList<>(); String sql =
 * "SELECT * FROM comments WHERE sheet_id = ? ORDER BY created_at DESC";
 * 
 * try (Connection conn = DBconnect.getConnection(); PreparedStatement ps =
 * conn.prepareStatement(sql)) {
 * 
 * ps.setInt(1, sheetId); try (ResultSet rs = ps.executeQuery()) { while
 * (rs.next()) { Comment c = new Comment();
 * c.setCommentId(rs.getInt("comment_id")); c.setSheetId(rs.getInt("sheet_id"));
 * c.setCommenterName(rs.getString("commenter_name"));
 * c.setCommentText(rs.getString("comment_text"));
 * c.setCreatedAt(rs.getString("created_at")); notes.add(c); } } } catch
 * (Exception e) { e.printStackTrace(); } return notes; }
 * 
 * // ၂။ Note အသစ်ကို Database ထဲ သိမ်းဆည်းခြင်း public boolean save(int
 * sheetId, String text) { String sql =
 * "INSERT INTO comments (sheet_id, comment_text, commenter_name) VALUES (?, ?, 'Admin')"
 * ; try (Connection conn = DBconnect.getConnection(); PreparedStatement ps =
 * conn.prepareStatement(sql)) {
 * 
 * ps.setInt(1, sheetId); ps.setString(2, text); return ps.executeUpdate() > 0;
 * } catch (Exception e) { e.printStackTrace(); return false; } }
 * 
 * // ၃။ ရှိပြီးသား Note ကို ပြန်လည်ပြင်ဆင်ခြင်း public boolean update(int
 * commentId, String text) { String sql =
 * "UPDATE comments SET comment_text = ? WHERE comment_id = ?"; try (Connection
 * conn = DBconnect.getConnection(); PreparedStatement ps =
 * conn.prepareStatement(sql)) {
 * 
 * ps.setString(1, text); ps.setInt(2, commentId); return ps.executeUpdate() >
 * 0; } catch (Exception e) { e.printStackTrace(); return false; } }
 * 
 * // ၄။ Note ကို Database ထဲမှ ဖျက်သိမ်းခြင်း public boolean delete(int
 * commentId) { String sql = "DELETE FROM comments WHERE comment_id = ?"; try
 * (Connection conn = DBconnect.getConnection(); PreparedStatement ps =
 * conn.prepareStatement(sql)) {
 * 
 * ps.setInt(1, commentId); return ps.executeUpdate() > 0; } catch (Exception e)
 * { e.printStackTrace(); return false; } }
 * 
 * public List<Map<String, Object>> findAllSheets() {
 * 
 * return null; } }
 */