'use strict';

const fs = require("fs");
const https = require("https");

// 生成证书私钥
//   openssl genrsa -out rsa-secret.key 1024
// 生成签名请求(Certificate Signing Request)，密码 lasa
//   openssl req -new -key rsa-secret.key -out rsa-request.csr
// 生成自签名证书
//   openssl x509 -req -in rsa-request.csr -signkey rsa-secret.key -out rsa-public.cer
let options = {
  key:  fs.readFileSync('./rsa-secret.key'),
  cert: fs.readFileSync('./rsa-public.cer')
};
// 生成 CSR 文件和私钥
//   openssl req -new -newkey rsa:2048 -nodes -out rsa-request.csr -keyout rsa-secret.key

https.createServer(options, function(request, response) {
  //console.log("REQ:", request);
  console.log("HTTP Version:", request.httpVersion);
  console.log("Request Headers:");
  for(let i=0; i<request.rawHeaders.length; i+=2) {
    console.log(request.rawHeaders[i]+ ' : '+ request.rawHeaders[i+1]);
  }
  response.writeHead(200, {
    "content-type": "text/html"
  });
  response.write(
    "<!DOCTYPE html>"
    + "<html lang=\"\">"
    +   "<head>"
    +     "<meta charset=\"utf-8\">"
    +     "<title>HTTPS 简单服务 | NodeJS</title>"
    +   "</head>"
    +   "<body>"
    +     "<p style=\"text-align: center; font-size: 100px;\">Hi, HTTPS 服务正常！</p>"
    +   "</body>"
    + "</html>");
  response.end();
}).listen(5555);

// 启动命令 node https-server.js
console.log("Local HTTPS Server: https://localhost:5555");
console.log("检测命令  $ curl -k https://localhost:5555");
console.log("检测命令  $ curl -v https://localhost:5555");
console.log("验证方式  浏览器打开 http://localhost:5555");
