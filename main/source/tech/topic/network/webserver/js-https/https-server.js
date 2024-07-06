'use strict';

const fs = require("fs");
const https = require("https");

// NOTE 浏览器暂不支持 ED25519 格式证书, 使用 RSA2048 或 RSA4096 算法创建证书
//
// 生成私钥/公钥(不加密无密码)
//   openssl genrsa -out rsa2048.key 2048
// 生成签名请求(Certificate Signing Request)文件
//   openssl req -new -key rsa2048.key -out rsa2048.csr -subj '/C=CN/O=Development/CN=Demo'
//
// 生成 CSR 文件和私钥/公钥(不加密无密码)
//   openssl req -new -newkey rsa:2048 -nodes -out rsa2048.csr -keyout rsa2048.key -subj '/C=CN/O=Development/CN=Demo'
//
// 生成自签名证书
//   openssl x509 -req -in rsa2048.csr -signkey rsa2048.key -out rsa2048.crt

let options = {
  key:  fs.readFileSync('./rsa2048.key'),
  cert: fs.readFileSync('./rsa2048.crt')
};

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
console.log("验证方式  浏览器    https://localhost:5555");
