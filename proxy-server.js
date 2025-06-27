import express from "express";
import { createProxyMiddleware } from "http-proxy-middleware";
import cors from "cors";

const app = express();
const PORT = 3001;

// CORS 설정
app.use(
  cors({
    origin: [
      "http://localhost:60212",
      "http://127.0.0.1:60212",
      /http:\/\/localhost:\d+/,
    ],
    credentials: true,
    methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allowedHeaders: [
      "Content-Type",
      "Authorization",
      "X-Target-Server",
      "Cookie",
    ],
  })
);

// CORS preflight(OPTIONS) 직접 응답
app.options("*", (req, res) => {
  res.header("Access-Control-Allow-Origin", req.headers.origin || "*");
  res.header("Access-Control-Allow-Methods", "GET,POST,PUT,DELETE,OPTIONS");
  res.header(
    "Access-Control-Allow-Headers",
    "Content-Type, Authorization, X-Target-Server, Cookie"
  );
  res.header("Access-Control-Allow-Credentials", "true");
  res.sendStatus(200);
});

// Synology API 프록시
app.use("/api/synology", (req, res, next) => {
  const targetServer = req.headers["x-target-server"];
  if (!targetServer) {
    return res
      .status(400)
      .json({ error: "X-Target-Server header is required" });
  }

  const proxy = createProxyMiddleware({
    target: `https://${targetServer}`,
    changeOrigin: true,
    pathRewrite: {
      "^/api/synology": "/webapi",
    },
    onProxyReq: (proxyReq, req, res) => {
      if (proxyReq.headers) {
        delete proxyReq.headers["x-target-server"];
        delete proxyReq.headers["origin"];
        delete proxyReq.headers["referer"];
        if (req.headers.cookie) {
          proxyReq.setHeader("Cookie", req.headers.cookie);
        }
      }
      console.log(`Proxying to Synology: ${targetServer}${req.url}`);
    },
    onProxyRes: (proxyRes, req, res) => {
      const origin = req.headers.origin || "*";
      proxyRes.headers["Access-Control-Allow-Origin"] = origin;
      proxyRes.headers["Access-Control-Allow-Methods"] =
        "GET, POST, PUT, DELETE, OPTIONS";
      proxyRes.headers["Access-Control-Allow-Headers"] =
        "Content-Type, Authorization, X-Target-Server, Cookie";
      proxyRes.headers["Access-Control-Allow-Credentials"] = "true";
      proxyRes.headers["Access-Control-Expose-Headers"] = "Set-Cookie";

      console.log(`Synology response: ${proxyRes.statusCode}`);
    },
    onError: (err, req, res) => {
      console.error("Synology proxy error:", err.message);
      res.status(500).json({ error: "Proxy error", details: err.message });
    },
  });

  proxy(req, res, next);
});

// qBittorrent API 프록시
app.use("/api/qbittorrent", (req, res, next) => {
  const targetServer = req.headers["x-target-server"];
  if (!targetServer) {
    return res
      .status(400)
      .json({ error: "X-Target-Server header is required" });
  }

  const proxy = createProxyMiddleware({
    target: `https://${targetServer}`,
    changeOrigin: true,
    pathRewrite: {
      "^/api/qbittorrent": "/api/v2",
    },
    onProxyReq: (proxyReq, req, res) => {
      if (proxyReq.headers) {
        delete proxyReq.headers["x-target-server"];
        delete proxyReq.headers["origin"];
        delete proxyReq.headers["referer"];
        if (req.headers.cookie) {
          proxyReq.setHeader("Cookie", req.headers.cookie);
        }
      }
      console.log(`Proxying to qBittorrent: ${targetServer}${req.url}`);
    },
    onProxyRes: (proxyRes, req, res) => {
      const origin = req.headers.origin || "*";
      proxyRes.headers["Access-Control-Allow-Origin"] = origin;
      proxyRes.headers["Access-Control-Allow-Methods"] =
        "GET, POST, PUT, DELETE, OPTIONS";
      proxyRes.headers["Access-Control-Allow-Headers"] =
        "Content-Type, Authorization, X-Target-Server, Cookie";
      proxyRes.headers["Access-Control-Allow-Credentials"] = "true";
      proxyRes.headers["Access-Control-Expose-Headers"] = "Set-Cookie";

      console.log(`qBittorrent response: ${proxyRes.statusCode}`);
    },
    onError: (err, req, res) => {
      console.error("qBittorrent proxy error:", err.message);
      res.status(500).json({ error: "Proxy error", details: err.message });
    },
  });

  proxy(req, res, next);
});

// 헬스 체크
app.get("/health", (req, res) => {
  res.json({ status: "OK", message: "Proxy server is running" });
});

app.listen(PORT, () => {
  console.log(`Proxy server running on http://localhost:${PORT}`);
  console.log("Available endpoints:");
  console.log("  - /api/synology/* -> Synology NAS API");
  console.log("  - /api/qbittorrent/* -> qBittorrent API");
  console.log("  - /health -> Health check");
});
