const http = require('http');
const os = require('os');

const PORT = process.env.PORT || 8080;
const VERSION = process.env.APP_VERSION || 'v1';

const server = http.createServer((req, res) => {
  // Health endpoint for Kubernetes probes
  if (req.url === '/health' || req.url === '/ready') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ status: 'ok' }));
    return;
  }

  // Main page - shows which pod served the request
  res.writeHead(200, { 'Content-Type': 'text/html' });
  res.end(`
    <html>
      <head><title>EKS Demo</title></head>
      <body style="font-family: sans-serif; text-align: center; padding-top: 80px; background:#0f172a; color:#e2e8f0;">
        <h1>Hello from EKS</h1>
        <h2>Version: ${VERSION}</h2>
        <p style="font-size: 22px;">Served by pod: <b style="color:#38bdf8;">${os.hostname()}</b></p>
        <p style="color:#64748b;">Refresh the page, the pod name changes as the load balancer spreads requests across pods.</p>
      </body>
    </html>
  `);
});

server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}, version ${VERSION}, pod ${os.hostname()}`);
});
