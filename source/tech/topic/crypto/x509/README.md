# X.509/PKI(Public Key Infrastructure)

- 缩略词含义, Certificate Authority 认证授权 **CA**

  - **CRL** - `.crl` - Certificate Revocation List
  - **CSR** - `.csr` - Certificate Signing Request
  - **BER** - `.ber` - Basic Encoding Rules, Binary
  - **PEM** - `.pem` - Privacy-Enhanced Mail, Base64
  - **DER** - `.der` - Distinguished Encoding Rules, Binary
  - **CER** - `.cer` - Canonical Encoding Rules, Binary or Base64

  - **PKCS** - Public Key Cryptography Standards
    - `.p7b`, `.p7r`, **PKCS#7**  格式, Base64, 多证书(信任链), 不含私钥
    - `.pfx`, `.p12`, **PKCS#12** 格式, Binary, 多证书(信任链), 包含私钥

  - **Binary** `.ber`, `.cer`, `.der`
  - **Base64** `.pem`, `.cer`, `.crt`, `.key`(private keys)

- 本地开发证书操作 https://github.com/jsha/minica
- 术语表 https://letsencrypt.org/zh-cn/docs/glossary
- X509 概念简介 https://zhuanlan.zhihu.com/p/492475360
- Ubuntu 系预置 CA 目录 `/usr/share/ca-certificates/mozilla/`

- X.509 相关国际标准
  * https://www.itu.int/rec/T-REC-X.509/en
  * ISO OID(Object Identifier) http://oid-info.com/
  * Internet X.509 Certificate https://datatracker.ietf.org/doc/rfc5280/

- X.509 配置字段含义参考
  * https://www.openssl.org/docs/manmaster/man5/config.html
  * https://www.openssl.org/docs/man3.0/man1/openssl-ca.html
  * https://javadoc.iaik.tugraz.at/iaik_jce/current/iaik/x509/extensions/KeyUsage.html
  * https://learn.microsoft.com/zh-cn/dotnet/api/system.security.cryptography.x509certificates

- 创建本地证书(三级体系)
  * https://wiki.archlinux.org/title/OpenSSL
  * https://letsencrypt.org/zh-cn/docs/certificates-for-localhost
  * https://jamielinux.com/docs/openssl-certificate-authority/index.html
  * https://www.golinuxcloud.com/tutorial-pki-certificates-authority-ocsp
  * https://learn.microsoft.com/zh-cn/azure/iot-hub/tutorial-x509-test-certs
  * https://docs.oracle.com/en/operating-systems/oracle-linux/certmanage
  * https://access.redhat.com/documentation/en-us/red_hat_certificate_system/9/html/administration_guide/certificate_and_crl_extensions
  * 三级结构证书链
    - Root 证书(自签名)
      - Mid 证书1(由根证书签名)
        - User 证书A(由中间 证书1 签名)
        - User 证书B(由中间 证书1 签名)
      - Mid 证书2(由根证书签名)
        - User 证书C(由中间 证书2 签名)
        - User 证书D(由中间 证书2 签名)

## OpenSSL 命令备忘

```bash
# 非对称加密
#   公钥加密/私钥解密, 私钥加密/公钥解密
# 摘要算法
#   不定长数据经算法处理后生成定长摘要(哈希散列值), SHA-256, MD5
# 数字签名
#   将(哈希散列值)经(非对称加密)生成加密的(哈希散列值)

# 非对称加密及解密推荐算法 => ED25519 > RSA/4096
# RSA       验证快/生成慢, 签名/加密, 强度 2048/4096, 兼容性好
# DSA       生成快/验证慢, 签名/加密, 因安全问题不推及继续使用
# ECC       椭圆曲线密码学
# ECDSA     椭圆曲线数字签名算法
# EdDSA     爱德华兹曲线数字签名算法
# ED25519   安全性&性能较好, 仅能用于签名

# 预安装的 Well-Known 第三方证书软件包
apt show ca-certificates


openssl info -configdir # 显示默认配置文件
openssl dgst -list      # 显示支持的摘要算法
openssl enc -list       # 显示支持的加密算法
# https://expeditedsecurity.com/blog/measuring-ssl-rsa-keys
openssl speed rsa       # 测试 RSA 算法的性能
# https://ubuntu.com/server/docs/openssl
openssl ciphers -s -v   # 显示 TLS/SSL 版本及算法


# 本地系统证书管理工具包
apt show p11-kit # 包含 trust 和 p11-kit 命令
trust list # 显示 trusted 证书列表
sudo trust anchor /path/to/ca.cert              # 添加到 trusted 列表
trust anchor --remove /path/to/ca.cert          # 从 trusted 列表删除
trust anchor --remove "pkcs11:id=...;type=cert" # 从 trusted 列表删除


# OpenSSL 常用子命令 => ca, req, crl, x509
openssl ca ...  # 命令引用配置文件中的 [ca]  段落
openssl req ... # 命令引用配置文件中的 [req] 段落


# 创建证书的私钥及公钥(用 AES256 对密钥加密)
# openssl enc -list   显示支持的加密算法
# -outform PEM        生成 Base64 编码的 PEM 格式密钥
# pass:hello          新建私钥密码 hello, AES256 加密方式
openssl genpkey -algorithm ED25519 -outform PEM -out ca.priv.key \
  -aes256 -pass pass:hello
# rsa_keygen_bits:4096    RSA 密钥强度(密钥 key-bits 长度)
# rsa_keygen_primes:11    指定创建 RSA 密钥时的素数/质数
openssl genpkey -algorithm RSA     -outform PEM -out ca.priv.key \
  -aes256 -pass pass:hello \
  -pkeyopt rsa_keygen_bits:4096 \
  -pkeyopt rsa_keygen_primes:3


# 生成自签名证书(指定配置文件), 有效期 1 年
openssl req -new -x509 -config path/to/x.conf \
  -days 365 -key ca.priv.key -out ca.cert.crt
openssl req -new -x509 -days 365 -nodes -newkey rsa:2048 \
  -keyout ca.priv.key -out ca.cert.crt \
  -subj '/C=US/ST=Ca/L=Sunnydale/CN=localhost'


# 生成 CSR 文件, 然后将生成文件发送给其它 CA 进行签名
openssl req -new -key ca.priv.key -out ca.cert.csr \
  -subj "/C=CN/O=Test/OU=Test CA/CN=Test CA/example@test.com"
openssl req -new -newkey rsa:1024 -keyout domain.example.com.key \
  -nodes '/CN=domain.example.com/O=Example Ltd/C=GB/L=London' \
  -out domain.example.com.csr
openssl req -noout -text -verify -in ca.cert.csr # 查看签名请求

# 签发证书 => 用 ca.priv1.key 私钥对 ca.cert2.csr 进行签名(生成签名后的证书)
openssl x509 -req -signkey ca.priv1.key -in ca.cert2.csr -out ca.certs.crt


# 查看证书信息
openssl crl   -noout -text -in x.crl
openssl x509  -noout -text -in path/to/key
openssl x509  -noout -text -inform DER -in path/to/x.der
openssl x509  -noout -text -inform PEM -in path/to/x.pem

openssl pkcs7 -noout -text -print_certs             -in path/to/x.pkcs7
openssl pkcs7 -noout -text -print_certs -inform DER -in path/to/x.pkcs7

# 证书格式转换 PEM -> DER
openssl x509 -inform PEM -in x.pem -outform DER -out x.der
openssl x509 -in x.pem -outform DER -out x.der # DER(二进制)

# 证书格式转换 DER -> PEM
openssl x509 -inform DER -in x.der -outform PEM -out x.pem
openssl x509 -in x.der -outform PEM -out x.pem # PEM(Base64)

# 证书格式转换 PKCS#7 -> PEM
openssl pkcs7 -print_certs -inform DER -in x.pkcs7 -out x.pem
# 证书格式转换 PEM -> PKCS#7
openssl crl2pkcs7 -nocrl -certfile x.pem -outform DER -out x.pkcs7
openssl crl2pkcs7 -nocrl -certfile x1.pem -certfile x2.pem -outform DER -out x.pkcs7
```
