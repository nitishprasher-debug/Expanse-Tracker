package com.tracker.model;

import java.util.Date;

/**
 * Expense Model Class
 * Represents an expense record in the system
 */
public class Expense {
    private int expenseId;
    private int userId;
    private int categoryId;
    private double amount;
    private String description;
    private Date expenseDate;
    private Date createdDate;
    private Date updatedDate;
    private String categoryName;
    
    // Constructors
    public Expense() {}
    
    public Expense(int userId, int categoryId, double amount, String description, Date expenseDate) {
        this.userId = userId;
        this.categoryId = categoryId;
        this.amount = amount;
        this.description = description;
        this.expenseDate = expenseDate;
    }
    
    public Expense(int expenseId, int userId, int categoryId, double amount, 
                   String description, Date expenseDate, String categoryName) {
        this.expenseId = expenseId;
        this.userId = userId;
        this.categoryId = categoryId;
        this.amount = amount;
        this.description = description;
        this.expenseDate = expenseDate;
        this.categoryName = categoryName;
    }
    
    // Getters and Setters
    public int getExpenseId() {
        return expenseId;
    }
    
    public void setExpenseId(int expenseId) {
        this.expenseId = expenseId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public int getCategoryId() {
        return categoryId;
    }
    
    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }
    
    public double getAmount() {
        return amount;
    }
    
    public void setAmount(double amount) {
        this.amount = amount;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public Date getExpenseDate() {
        return expenseDate;
    }
    
    public void setExpenseDate(Date expenseDate) {
        this.expenseDate = expenseDate;
    }
    
    public Date getCreatedDate() {
        return createdDate;
    }
    
    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }
    
    public Date getUpdatedDate() {
        return updatedDate;
    }
    
    public void setUpdatedDate(Date updatedDate) {
        this.updatedDate = updatedDate;
    }
    
    public String getCategoryName() {
        return categoryName;
    }
    
    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }
    
    @Override
    public String toString() {
        return "Expense [expenseId=" + expenseId + ", userId=" + userId + ", categoryId=" + categoryId 
               + ", amount=" + amount + ", description=" + description + ", expenseDate=" + expenseDate + "]";
    }
}
