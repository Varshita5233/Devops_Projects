const http = require('http');
const os = require('os');

const PORT = process.env.PORT || 8080;
const VERSION = process.env.APP_VERSION || 'v1';
// The backend service URL - uses Kubernetes service DNS name
const BACKEND_URL = process.env.BACKEND_URL || 'http://backend-service';
const startTime = Date.now();
let requestCount = 0;

// Helper to call the backend service (pod-to-pod / east-west traffic)
function callBackend() {
  return new Promise((resolve) => {
    http.get(BACKEND_URL, (resp) => {
      let data = '';
      resp.on('data', chunk => data += chunk);
      resp.on('end', () => {
        try { resolve(JSON.parse(data)); }
        catch { resolve({ error: 'bad response from backend' }); }
      });
    }).on('error', (err) => {
      resolve({ error: 'could not reach backend: ' + err.message });
    });
  });
}

const server = http.createServer(async (req, res) => {
  if (req.url === '/health' || req.url === '/ready') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ status: 'ok', pod: os.hostname() }));
    return;
  }

  requestCount++;
  const uptime = Math.floor((Date.now() - startTime) / 1000);

  // Call the backend service - THIS is the pod-to-pod communication
  const backend = await callBackend();
  const backendPod = backend.backendPod || backend.error || 'unknown';

  res.writeHead(200, { 'Content-Type': 'text/html' });
  res.end(`
    <html>
      <head>
        <title>EKS Demo Dashboard</title>
        <meta http-equiv="refresh" content="2">
        <style>
          body { font-family: -apple-system, sans-serif; background: #0f172a; color: #e2e8f0;
                 display: flex; align-items: center; justify-content: center; height: 100vh; margin: 0; }
          .card { background: #1e293b; padding: 48px 64px; border-radius: 16px;
                  box-shadow: 0 20px 60px rgba(0,0,0,0.5); text-align: center; border: 1px solid #334155; max-width: 640px; }
          h1 { margin: 0 0 8px; font-size: 30px; }
          .badge { display: inline-block; background: #0ea5e9; color: white; padding: 4px 14px;
                   border-radius: 999px; font-size: 14px; font-weight: 600; margin-bottom: 24px; }
          .grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-top: 20px; }
          .stat { background: #0f172a; padding: 14px 20px; border-radius: 10px; }
          .stat .label { font-size: 11px; color: #64748b; text-transform: uppercase; letter-spacing: 1px; }
          .stat .value { font-size: 17px; font-weight: 700; color: #38bdf8; margin-top: 4px; word-break: break-all; }
          .backend { margin-top: 20px; background: #0f172a; padding: 16px 20px; border-radius: 10px; border: 1px solid #22c55e33; }
          .backend .label { font-size: 11px; color: #22c55e; text-transform: uppercase; letter-spacing: 1px; }
          .backend .value { font-size: 16px; font-weight: 700; color: #4ade80; margin-top: 4px; word-break: break-all; }
          .hint { margin-top: 20px; color: #64748b; font-size: 12px; }
          .live { color: #22c55e; }
          .arrow { color: #64748b; font-size: 22px; margin: 8px 0; }
        </style>
      </head>
      <body>
        <div class="card">
          <div class="badge">EKS &middot; Microservices</div>
          <h1>Frontend → Backend 👋</h1>
          <div class="grid">
            <div class="stat"><div class="label">Frontend pod</div><div class="value">${os.hostname()}</div></div>
            <div class="stat"><div class="label">Version</div><div class="value">${VERSION}</div></div>
          </div>
          <div class="arrow">⬇ calls backend service (pod-to-pod) ⬇</div>
          <div class="backend">
            <div class="label">✓ Backend responded from pod</div>
            <div class="value">${backendPod}</div>
          </div>
          <p class="hint"><span class="live">● LIVE</span> &nbsp; Auto-refreshes every 2s. Watch BOTH pod names change — the frontend load-balances across its pods, and it calls the backend service which load-balances across backend pods.</p>
        </div>
      </body>
    </html>
  `);
});

server.listen(PORT, () => {
  console.log(`Frontend running on port ${PORT}, calling backend at ${BACKEND_URL}`);
});