package com.cheatsheet.repository;

import com.cheatsheet.model.Category;

import java.awt.desktop.SystemEventListener;
import java.sql.*;
import java.util.*;

public class CategoryRepository {
    private Connection conn;

    public CategoryRepository(Connection conn) {
        this.conn = conn;
    }

    public void insert(Category category) throws SQLException {
        String sql = "INSERT INTO categories (name) VALUES (?)";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, category.getName());
        stmt.executeUpdate();
    }

    public void update(Category category) throws SQLException {
        String sql = "UPDATE categories SET name=? WHERE category_id=?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, category.getName());
        stmt.setInt(2, category.getCategoryId());
        stmt.executeUpdate();
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM categories WHERE category_id=?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, id);
        stmt.executeUpdate();
    }

    public List<Category> findAll() throws SQLException {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM categories";
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql);
        while (rs.next()) {
            Category c = new Category();
            c.setCategoryId(rs.getInt("category_id"));
            c.setName(rs.getString("name"));
            list.add(c);
           
        }
        return list;
    }

   
}
    

