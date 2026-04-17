package com.tracker.util;

import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.sql.DatabaseMetaData;
import java.sql.SQLException;

/**
 * DatabaseConnection Utility Class
 * Handles JDBC connection to MySQL database
 * This class manages the database connectivity for the Expense Tracker application
 */
public class DatabaseConnection {
    
    // Database Configuration
    private static final String MYSQL_DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String H2_DRIVER = "org.h2.Driver";
    private static final String URL = resolveConfig("expense.db.url", "EXPENSE_DB_URL", "jdbc:mysql://localhost:3306/expense_tracker");
    private static final String USER = resolveConfig("expense.db.user", "EXPENSE_DB_USER", "root");
    private static final String PASSWORD = resolveConfig("expense.db.password", "EXPENSE_DB_PASSWORD", "root");
    private static final String FALLBACK_DB_PATH = new File(System.getProperty("user.home"), ".expense-tracker/expense_tracker").getAbsolutePath();
    private static final String FALLBACK_URL = "jdbc:h2:file:" + FALLBACK_DB_PATH + ";MODE=MySQL;DATABASE_TO_LOWER=TRUE;CASE_INSENSITIVE_IDENTIFIERS=TRUE;DB_CLOSE_DELAY=-1";
    private static volatile boolean fallbackSchemaInitialized = false;
    
    /**
     * Gets a database connection
     * @return Connection object to the database
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        try {
            // Load MySQL JDBC Driver
            Class.forName(MYSQL_DRIVER);
            
            // Create and return connection
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            return conn;
        } catch (ClassNotFoundException e) {
            System.out.println("MySQL JDBC Driver not found: " + e.getMessage());
        } catch (SQLException e) {
            System.out.println("Connection failed: " + e.getMessage());
            System.out.println("Falling back to embedded H2 database at: " + FALLBACK_DB_PATH);
        }

        return getFallbackConnection();
    }

    private static Connection getFallbackConnection() throws SQLException {
        try {
            Class.forName(H2_DRIVER);
            Connection conn = DriverManager.getConnection(FALLBACK_URL, "sa", "");
            initializeFallbackSchema(conn);
            return conn;
        } catch (SQLException e) {
            throw e;
        } catch (ClassNotFoundException e) {
            throw new SQLException("H2 driver not found", e);
        }
    }
    
    /**
     * Closes a database connection
     * @param conn Connection object to close
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.out.println("Error closing connection: " + e.getMessage());
            }
        }
    }

    private static synchronized void initializeFallbackSchema(Connection conn) throws SQLException {
        if (fallbackSchemaInitialized) {
            return;
        }

        try (Statement statement = conn.createStatement()) {
            DatabaseMetaData metaData = conn.getMetaData();
            boolean usersMatches = usersTableMatches(metaData);
            boolean categoriesMatches = tableExists(metaData, "categories");
            boolean expensesMatches = tableExists(metaData, "expenses");

            if (!usersMatches && (tableExists(metaData, "users") || categoriesMatches || expensesMatches)) {
                statement.execute("DROP ALL OBJECTS");
                usersMatches = false;
                categoriesMatches = false;
                expensesMatches = false;
            }

            if (!usersMatches) {
                statement.execute("CREATE TABLE users (" +
                        "user_id INT PRIMARY KEY AUTO_INCREMENT, " +
                        "username VARCHAR(50) UNIQUE NOT NULL, " +
                        "password VARCHAR(100) NOT NULL, " +
                        "email VARCHAR(100) NOT NULL, " +
                        "created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
            }

            if (!categoriesMatches) {
                statement.execute("CREATE TABLE categories (" +
                        "category_id INT PRIMARY KEY AUTO_INCREMENT, " +
                        "user_id INT NOT NULL, " +
                        "category_name VARCHAR(50) NOT NULL, " +
                        "description VARCHAR(255), " +
                        "created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                        "FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE)");
            }

            if (!expensesMatches) {
                statement.execute("CREATE TABLE expenses (" +
                        "expense_id INT PRIMARY KEY AUTO_INCREMENT, " +
                        "user_id INT NOT NULL, " +
                        "category_id INT NOT NULL, " +
                        "amount DECIMAL(10, 2) NOT NULL, " +
                        "description VARCHAR(255), " +
                        "expense_date DATE NOT NULL, " +
                        "created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                        "updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, " +
                        "FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE, " +
                        "FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE CASCADE)");
            }
        }

        fallbackSchemaInitialized = true;
    }

    private static boolean usersTableMatches(DatabaseMetaData metaData) throws SQLException {
        return columnExists(metaData, "users", "user_id")
                && columnExists(metaData, "users", "username")
                && columnExists(metaData, "users", "password")
                && columnExists(metaData, "users", "email");
    }

    private static boolean tableExists(DatabaseMetaData metaData, String tableName) throws SQLException {
        try (java.sql.ResultSet resultSet = metaData.getTables(null, null, tableName.toUpperCase(), null)) {
            if (resultSet.next()) {
                return true;
            }
        }

        try (java.sql.ResultSet resultSet = metaData.getTables(null, null, tableName.toLowerCase(), null)) {
            return resultSet.next();
        }
    }

    private static boolean columnExists(DatabaseMetaData metaData, String tableName, String columnName) throws SQLException {
        try (java.sql.ResultSet resultSet = metaData.getColumns(null, null, tableName.toUpperCase(), columnName.toUpperCase())) {
            if (resultSet.next()) {
                return true;
            }
        }

        try (java.sql.ResultSet resultSet = metaData.getColumns(null, null, tableName.toLowerCase(), columnName.toLowerCase())) {
            return resultSet.next();
        }
    }

    private static String resolveConfig(String systemProperty, String envVar, String defaultValue) {
        String value = System.getProperty(systemProperty);
        if (value == null || value.isEmpty()) {
            value = System.getenv(envVar);
        }
        return (value == null || value.isEmpty()) ? defaultValue : value;
    }
}
