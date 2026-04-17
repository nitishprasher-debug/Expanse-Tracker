package com.tracker.servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.tracker.model.User;
import com.tracker.model.Category;
import com.tracker.dao.UserDAO;
import com.tracker.dao.CategoryDAO;

/**
 * RegisterServlet - Handles user registration
 * Maps to: /register
 * Methods: GET, POST
 */
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    /**
     * Displays registration page
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
    
    /**
     * Processes registration form submission
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        
        // Validate input
        if (username == null || username.isEmpty() || password == null || password.isEmpty() || 
            email == null || email.isEmpty()) {
            request.setAttribute("error", "All fields are required");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // Check if passwords match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // Check password length
        if (password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters long");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        UserDAO userDAO = new UserDAO();
        
        // Check if username already exists
        if (userDAO.userExists(username)) {
            request.setAttribute("error", "Username already exists");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // Create new user
        User user = new User(username, password, email);
        
        // Register user
        if (userDAO.registerUser(user)) {
            User createdUser = userDAO.getUserByUsername(username);
            if (createdUser != null) {
                CategoryDAO categoryDAO = new CategoryDAO();
                createDefaultCategories(categoryDAO, createdUser.getUserId());
            }

            request.setAttribute("success", "Registration successful. Please login.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

    private void createDefaultCategories(CategoryDAO categoryDAO, int userId) {
        String[][] defaultCategories = {
                {"Food", "Food and dining"},
                {"Transportation", "Travel and commute"},
                {"Entertainment", "Movies, games, and outings"},
                {"Utilities", "Bills and recurring payments"}
        };

        for (String[] categoryData : defaultCategories) {
            Category category = new Category();
            category.setUserId(userId);
            category.setCategoryName(categoryData[0]);
            category.setDescription(categoryData[1]);
            categoryDAO.addCategory(category);
        }
    }
}
