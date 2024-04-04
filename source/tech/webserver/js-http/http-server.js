'use strict';

const http = require("http");

http.createServer((request, response) => {
  console.log("REQ:", request.httpVersion);
  console.log("REQ:", request.rawHeaders);

  response.writeHead(200, {
    "content-type": "text/html"
  });
  response.write(
      "<!DOCTYPE html>"
    + "<html lang=\"\">"
    +   "<head>"
    +     "<meta charset=\"utf-8\">"
    +     "<title>HTTP 简单服务 | NodeJS</title>"
    +   "</head>"
    +   "<body>"
    +     "<p style=\"text-align: center; font-size: 100px;\">Hi, Node.js HTTP Simple Server!</p>"
    +   "</body>"
    + "</html>");
  response.end();
}).listen(5555);

// 启动命令 node https-server.js
console.log("Local HTTP Server: http://localhost:5555");
console.log("检测命令 $ curl -k http://localhost:5555");
console.log("检测命令 $ curl -v http://localhost:5555");
console.log("验证方式 浏览器打开 http://localhost:5555");
