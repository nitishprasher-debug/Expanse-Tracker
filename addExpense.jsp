package com.tracker.servlet;

import java.io.IOException;
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
 * DashboardServlet - Displays dashboard with expenses overview
 * Maps to: /dashboard
 * Methods: GET
 * Requires: User session
 */
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession();
        if (session.getAttribute("userId") == null) {
            response.sendRedirect("login");
            return;
        }
        
        int userId = (Integer) session.getAttribute("userId");
        
        // Get all expenses for the user
        ExpenseDAO expenseDAO = new ExpenseDAO();
        List<Expense> expenses = expenseDAO.getAllExpenses(userId);
        
        // Get all categories for the user
        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categories = categoryDAO.getAllCategories(userId);
        
        // Calculate total expenses
        double totalExpenses = 0;
        for (Expense expense : expenses) {
            totalExpenses += expense.getAmount();
        }
        
        // Set attributes for JSP
        request.setAttribute("expenses", expenses);
        request.setAttribute("categories", categories);
        request.setAttribute("totalExpenses", totalExpenses);
        request.setAttribute("expenseCount", expenses.size());
        
        // Forward to dashboard JSP
        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }
}
