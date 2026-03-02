const express = require('express');
const mysql = require('mysql2');
const app = express();
const port = 4000;

// Database connection configuration
const dbConfig = {
    host: process.env.DB_HOST || 'database-1.c3uymesu8u2h.ap-south-2.rds.amazonaws.com',
    user: process.env.DB_USER || 'admin',
    password: process.env.DB_PASSWORD || 'Varshita2181',
    database: process.env.DB_NAME || 'application',
    port: 3306
};

// Create connection pool
const pool = mysql.createPool(dbConfig);

// Health check endpoint (for load balancer)
app.get('/health', (req, res) => {
    res.status(200).json({ status: 'healthy' });
});

// Test database connection endpoint
app.get('/api/test-db', async (req, res) => {
    try {
        const [rows] = await pool.promise().query('SELECT 1 + 1 AS solution');
        res.json({ 
            message: 'Database connected successfully!',
            result: rows[0].solution 
        });
    } catch (error) {
        console.error('Database error:', error);
        res.status(500).json({ error: 'Database connection failed' });
    }
});

// Get all users (assuming you create this table)
app.get('/api/users', async (req, res) => {
    try {
        const [rows] = await pool.promise().query('SELECT * FROM users');
        res.json(rows);
    } catch (error) {
        console.error('Error fetching users:', error);
        res.status(500).json({ error: 'Failed to fetch users' });
    }
});

// Simple test endpoint
app.get('/api/test', (req, res) => {
    res.json({ 
        message: 'App tier is working!',
        timestamp: new Date().toISOString()
    });
});

app.listen(port, () => {
    console.log(`App tier listening on port ${port}`);
});