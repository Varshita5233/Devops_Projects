const http = require('http');
const os = require('os');

const PORT = process.env.PORT || 8080;

const server = http.createServer((req, res) => {
  if (req.url === '/health' || req.url === '/ready') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ status: 'ok' }));
    return;
  }

  // The backend returns which backend pod answered.
  // This proves the frontend is calling a separate service,
  // and that CoreDNS + kube-proxy load-balance across backend pods.
  res.writeHead(200, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify({
    message: "Hello from the BACKEND service",
    backendPod: os.hostname(),
    time: new Date().toISOString()
  }));
});

server.listen(PORT, () => {
  console.log(`Backend running on port ${PORT}, pod ${os.hostname()}`);
});