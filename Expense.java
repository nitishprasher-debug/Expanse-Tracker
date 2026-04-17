package com.tracker.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.tracker.model.Category;
import com.tracker.util.DatabaseConnection;

/**
 * CategoryDAO Class
 * Data Access Object for Category CRUD operations
 */
public class CategoryDAO {
    
    /**
     * Get all categories for a user
     */
    public List<Category> getAllCategories(int userId) {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories WHERE user_id = ? ORDER BY category_name";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Category category = new Category();
                category.setCategoryId(rs.getInt("category_id"));
                category.setUserId(rs.getInt("user_id"));
                category.setCategoryName(rs.getString("category_name"));
                category.setDescription(rs.getString("description"));
                
                categories.add(category);
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving categories: " + e.getMessage());
        }
        
        return categories;
    }
    
    /**
     * Get a category by ID
     */
    public Category getCategoryById(int categoryId) {
        String sql = "SELECT * FROM categories WHERE category_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, categoryId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Category category = new Category();
                category.setCategoryId(rs.getInt("category_id"));
                category.setUserId(rs.getInt("user_id"));
                category.setCategoryName(rs.getString("category_name"));
                category.setDescription(rs.getString("description"));
                
                return category;
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving category: " + e.getMessage());
        }
        
        return null;
    }
    
    /**
     * Add a new category
     */
    public boolean addCategory(Category category) {
        String sql = "INSERT INTO categories (user_id, category_name, description) VALUES (?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, category.getUserId());
            pstmt.setString(2, category.getCategoryName());
            pstmt.setString(3, category.getDescription());
            
            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Error adding category: " + e.getMessage());
            return false;
        }
    }
}
