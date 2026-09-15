const express = require('express');
const os = require('os');
const app = express();

const PORT = process.env.PORT || 3000;
const APP_ENV = process.env.APP_ENV || 'development';
const APP_VERSION = process.env.APP_VERSION || '1.0.0';

app.use(express.json());

// ============================================
// ROUTES
// ============================================

// Health check — used by Kubernetes liveness probe
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString()
  });
});

// Readiness check — used by Kubernetes readiness probe
app.get('/ready', (req, res) => {
  res.status(200).json({
    status: 'ready',
    timestamp: new Date().toISOString()
  });
});

// Main route
app.get('/', (req, res) => {
  res.status(200).json({
    message: 'Hello from EKS! 🚀',
    environment: APP_ENV,
    version: APP_VERSION,
    hostname: os.hostname(),  // Shows which pod handled request
    timestamp: new Date().toISOString()
  });
});

// Info route
app.get('/info', (req, res) => {
  res.status(200).json({
    app: 'eks-node-app',
    version: APP_VERSION,
    environment: APP_ENV,
    node_version: process.version,
    hostname: os.hostname(),
    uptime: process.uptime(),
    memory: process.memoryUsage()
  });
});

// ============================================
// START SERVER
// ============================================
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`Environment: ${APP_ENV}`);
  console.log(`Version: ${APP_VERSION}`);
});

module.exports = app;
