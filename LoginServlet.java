package com.tracker.model;

/**
 * Category Model Class
 * Represents an expense category
 */
public class Category {
    private int categoryId;
    private int userId;
    private String categoryName;
    private String description;
    
    // Constructors
    public Category() {}
    
    public Category(int userId, String categoryName, String description) {
        this.userId = userId;
        this.categoryName = categoryName;
        this.description = description;
    }
    
    public Category(int categoryId, int userId, String categoryName, String description) {
        this.categoryId = categoryId;
        this.userId = userId;
        this.categoryName = categoryName;
        this.description = description;
    }
    
    // Getters and Setters
    public int getCategoryId() {
        return categoryId;
    }
    
    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getCategoryName() {
        return categoryName;
    }
    
    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    @Override
    public String toString() {
        return "Category [categoryId=" + categoryId + ", categoryName=" + categoryName + "]";
    }
}
