package com.tracker.servlet;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.tracker.model.Expense;
import com.tracker.model.Category;
import com.tracker.dao.ExpenseDAO;
import com.tracker.dao.CategoryDAO;

/**
 * ExpenseServlet - Handles expense CRUD operations
 * Maps to: /expense
 * Methods: GET, POST
 * Parameters:
 *   action: add, edit, delete, view
 *   expenseId: ID of expense to edit/delete
 */
public class ExpenseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ExpenseDAO expenseDAO = new ExpenseDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession();
        if (session.getAttribute("userId") == null) {
            response.sendRedirect("login");
            return;
        }
        
        int userId = (Integer) session.getAttribute("userId");
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "view";
        }
        
        switch (action) {
            case "add":
                showAddExpenseForm(request, response, userId);
                break;
            case "edit":
                showEditExpenseForm(request, response, userId);
                break;
            case "delete":
                deleteExpense(request, response);
                break;
            default:
                viewExpenses(request, response, userId);
                break;
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession();
        if (session.getAttribute("userId") == null) {
            response.sendRedirect("login");
            return;
        }
        
        int userId = (Integer) session.getAttribute("userId");
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "add";
        }
        
        switch (action) {
            case "add":
                addExpense(request, response, userId);
                break;
            case "update":
                updateExpense(request, response);
                break;
            default:
                response.sendRedirect("expense");
                break;
        }
    }
    
    private void showAddExpenseForm(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        List<Category> categories = categoryDAO.getAllCategories(userId);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/addExpense.jsp").forward(request, response);
    }
    
    private void showEditExpenseForm(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        int expenseId = Integer.parseInt(request.getParameter("expenseId"));
        Expense expense = expenseDAO.getExpenseById(expenseId);
        List<Category> categories = categoryDAO.getAllCategories(userId);
        
        request.setAttribute("expense", expense);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/editExpense.jsp").forward(request, response);
    }
    
    private void addExpense(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        try {
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            double amount = Double.parseDouble(request.getParameter("amount"));
            String description = request.getParameter("description");
            String expenseDateStr = request.getParameter("expenseDate");
            
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date expenseDate = sdf.parse(expenseDateStr);
            
            Expense expense = new Expense(userId, categoryId, amount, description, expenseDate);
            
            if (expenseDAO.addExpense(expense)) {
                response.sendRedirect("expense?action=view&success=Expense added successfully");
            } else {
                request.setAttribute("error", "Failed to add expense");
                showAddExpenseForm(request, response, userId);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
            showAddExpenseForm(request, response, userId);
        }
    }
    
    private void updateExpense(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int expenseId = Integer.parseInt(request.getParameter("expenseId"));
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            double amount = Double.parseDouble(request.getParameter("amount"));
            String description = request.getParameter("description");
            String expenseDateStr = request.getParameter("expenseDate");
            
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date expenseDate = sdf.parse(expenseDateStr);
            
            Expense expense = new Expense();
            expense.setExpenseId(expenseId);
            expense.setCategoryId(categoryId);
            expense.setAmount(amount);
            expense.setDescription(description);
            expense.setExpenseDate(expenseDate);
            
            if (expenseDAO.updateExpense(expense)) {
                response.sendRedirect("expense?action=view&success=Expense updated successfully");
            } else {
                request.setAttribute("error", "Failed to update expense");
                request.getRequestDispatcher("/editExpense.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("/editExpense.jsp").forward(request, response);
        }
    }
    
    private void deleteExpense(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int expenseId = Integer.parseInt(request.getParameter("expenseId"));
        
        if (expenseDAO.deleteExpense(expenseId)) {
            response.sendRedirect("expense?action=view&success=Expense deleted successfully");
        } else {
            response.sendRedirect("expense?action=view&error=Failed to delete expense");
        }
    }
    
    private void viewExpenses(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        List<Expense> expenses = expenseDAO.getAllExpenses(userId);
        request.setAttribute("expenses", expenses);
        request.getRequestDispatcher("/viewExpenses.jsp").forward(request, response);
    }
}
