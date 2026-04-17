package com.tracker.servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * LogoutServlet - Handles user logout
 * Maps to: /logout
 * Methods: GET
 */
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get session and invalidate it
        HttpSession session = request.getSession();
        session.invalidate();
        
        // Redirect to login page
        response.sendRedirect("login");
    }
}
