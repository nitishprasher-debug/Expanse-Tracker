package com.tracker.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.tracker.model.Expense;
import com.tracker.util.DatabaseConnection;

/**
 * ExpenseDAO Class
 * Data Access Object for Expense CRUD operations
 * Implements all database operations for expenses using JDBC
 */
public class ExpenseDAO {
    
    /**
     * Create/Insert a new expense
     */
    public boolean addExpense(Expense expense) {
        String sql = "INSERT INTO expenses (user_id, category_id, amount, description, expense_date) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, expense.getUserId());
            pstmt.setInt(2, expense.getCategoryId());
            pstmt.setDouble(3, expense.getAmount());
            pstmt.setString(4, expense.getDescription());
            pstmt.setDate(5, new java.sql.Date(expense.getExpenseDate().getTime()));
            
            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Error adding expense: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Read/Retrieve all expenses for a user
     */
    public List<Expense> getAllExpenses(int userId) {
        List<Expense> expenses = new ArrayList<>();
        String sql = "SELECT e.*, c.category_name FROM expenses e " +
                    "JOIN categories c ON e.category_id = c.category_id " +
                    "WHERE e.user_id = ? ORDER BY e.expense_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Expense expense = new Expense();
                expense.setExpenseId(rs.getInt("expense_id"));
                expense.setUserId(rs.getInt("user_id"));
                expense.setCategoryId(rs.getInt("category_id"));
                expense.setAmount(rs.getDouble("amount"));
                expense.setDescription(rs.getString("description"));
                expense.setExpenseDate(rs.getDate("expense_date"));
                expense.setCategoryName(rs.getString("category_name"));
                
                expenses.add(expense);
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving expenses: " + e.getMessage());
        }
        
        return expenses;
    }
    
    /**
     * Read/Retrieve a specific expense by ID
     */
    public Expense getExpenseById(int expenseId) {
        String sql = "SELECT e.*, c.category_name FROM expenses e " +
                    "JOIN categories c ON e.category_id = c.category_id " +
                    "WHERE e.expense_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, expenseId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Expense expense = new Expense();
                expense.setExpenseId(rs.getInt("expense_id"));
                expense.setUserId(rs.getInt("user_id"));
                expense.setCategoryId(rs.getInt("category_id"));
                expense.setAmount(rs.getDouble("amount"));
                expense.setDescription(rs.getString("description"));
                expense.setExpenseDate(rs.getDate("expense_date"));
                expense.setCategoryName(rs.getString("category_name"));
                
                return expense;
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving expense: " + e.getMessage());
        }
        
        return null;
    }
    
    /**
     * Update an existing expense
     */
    public boolean updateExpense(Expense expense) {
        String sql = "UPDATE expenses SET category_id=?, amount=?, description=?, expense_date=? WHERE expense_id=?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, expense.getCategoryId());
            pstmt.setDouble(2, expense.getAmount());
            pstmt.setString(3, expense.getDescription());
            pstmt.setDate(4, new java.sql.Date(expense.getExpenseDate().getTime()));
            pstmt.setInt(5, expense.getExpenseId());
            
            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Error updating expense: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Delete an expense
     */
    public boolean deleteExpense(int expenseId) {
        String sql = "DELETE FROM expenses WHERE expense_id=?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, expenseId);
            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting expense: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Get expenses by category for a user
     */
    public List<Expense> getExpensesByCategory(int userId, int categoryId) {
        List<Expense> expenses = new ArrayList<>();
        String sql = "SELECT e.*, c.category_name FROM expenses e " +
                    "JOIN categories c ON e.category_id = c.category_id " +
                    "WHERE e.user_id = ? AND e.category_id = ? ORDER BY e.expense_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            pstmt.setInt(2, categoryId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Expense expense = new Expense();
                expense.setExpenseId(rs.getInt("expense_id"));
                expense.setUserId(rs.getInt("user_id"));
                expense.setCategoryId(rs.getInt("category_id"));
                expense.setAmount(rs.getDouble("amount"));
                expense.setDescription(rs.getString("description"));
                expense.setExpenseDate(rs.getDate("expense_date"));
                expense.setCategoryName(rs.getString("category_name"));
                
                expenses.add(expense);
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving expenses by category: " + e.getMessage());
        }
        
        return expenses;
    }
    
    /**
     * Get total expenses for a month
     */
    public double getTotalExpensesByMonth(int userId, int year, int month) {
        String sql = "SELECT SUM(amount) as total FROM expenses " +
                    "WHERE user_id = ? AND YEAR(expense_date) = ? AND MONTH(expense_date) = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            pstmt.setInt(2, year);
            pstmt.setInt(3, month);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble("total");
            }
        } catch (SQLException e) {
            System.out.println("Error calculating total expenses: " + e.getMessage());
        }
        
        return 0.0;
    }
}
