const express = require('express');
const mysql = require('mysql2/promise'); // Use promise version
const AWS = require('aws-sdk');

const app = express();
const port = 4000;

// Configure AWS region (matches your RDS region)
AWS.config.update({ region: 'ap-south-2' });

// Create Secrets Manager client
const secretsManager = new AWS.SecretsManager();

// Secret name (match what you created in Secrets Manager)
const SECRET_NAME = ''; //provide your secret ARN

// Global variable to hold database config
let dbConfig = null;

/**
 * Fetch database credentials from Secrets Manager
 */
async function fetchDatabaseCredentials() {
    try {
        console.log('Fetching database credentials from Secrets Manager...');

        const data = await secretsManager.getSecretValue({ SecretId: SECRET_NAME }).promise();

        let secret;
        if (data.SecretString) {
            secret = JSON.parse(data.SecretString);
        } else {
            // Handle binary secret (unlikely for RDS)
            const buff = Buffer.from(data.SecretBinary, 'base64');
            secret = JSON.parse(buff.toString('ascii'));
        }

        console.log('Successfully retrieved credentials from Secrets Manager');

        // Return formatted database config
        return {
            host: secret.host,         // RDS endpoint
            user: secret.username,      // database username
            password: secret.password,   // database password
            database: process.env.DB_NAME || 'application', // database name from env or default
            port: 3306
        };
    } catch (error) {
        console.error('Error fetching credentials from Secrets Manager:', error);
        throw error; // Fail fast – don't start app without credentials
    }
}

/**
 * Initialize database connection and start server
 */
async function startApp() {
    try {
        // Fetch credentials from Secrets Manager
        dbConfig = await fetchDatabaseCredentials();

        // Create connection pool (using promise version)
        const pool = mysql.createPool(dbConfig);

        // Health check endpoint (for load balancer)
        app.get('/health', async (req, res) => {
            try {
                // Test database connection
                await pool.query('SELECT 1');
                res.status(200).json({
                    status: 'healthy',
                    database: 'connected'
                });
            } catch (error) {
                res.status(503).json({
                    status: 'unhealthy',
                    database: 'disconnected',
                    error: error.message
                });
            }
        });

        // Test database connection endpoint
        app.get('/api/test-db', async (req, res) => {
            try {
                const [rows] = await pool.query('SELECT 1 + 1 AS solution');
                res.json({
                    message: 'Database connected successfully!',
                    result: rows[0].solution
                });
            } catch (error) {
                console.error('Database error:', error);
                res.status(500).json({
                    error: 'Database connection failed!',
                    details: error.message
                });
            }
        });

        // Simple test endpoint
        app.get('/api/test', (req, res) => {
            res.json({
                message: 'App tier is working!',
                timestamp: new Date().toISOString()
            });
        });

        // Start server
        app.listen(port, () => {
            console.log(`App tier listening on port ${port}`);
            console.log('Database credentials retrieved from Secrets Manager');
        });

    } catch (error) {
        console.error('Failed to start application:', error);
        process.exit(1); // Exit if can't start
    }
}

// Start the application
startApp();