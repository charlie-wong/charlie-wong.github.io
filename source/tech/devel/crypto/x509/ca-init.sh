#!/usr/bin/env bash

set -xe # 显示命令及参数, 任意命令返回非零值则终止
NOW=$(date '+%Y%m%d%H%M%S') # 当前时间戳(文件名后缀)

# NOTE master.conf 和 middle.conf 所需环境变量
# master.conf => 根 CA 配置; middle.conf => 中间 CA 配置
# XCA_DOMAIN(网址域名), XCA_PREFIX(文件名前缀), XCA_SUFFIX(文件名后缀)
XCA_PREFIX='xyz' # 证书文件的前缀
XCA_DOMAIN='https://you.domain.org'

# 转换 X509 证书格式: DER(二进制), PEM(Base64)
# openssl crl  -in xxx -outform DER -out yyy.der # 输出 DER
# openssl x509 -in xxx -outform DER -out yyy.der # 输出 DER

for WHERE in master  middle  sb-mok; do
  mkdir -p ${WHERE}/priv # 存储 CA 证书的私钥
  mkdir -p ${WHERE}/cert # 保存 CA 证书的公钥

  mkdir -p ${WHERE}/crls # 已签发 CRLs 的位置
  mkdir -p ${WHERE}/sign # 已签发证书保存位置

  # 结构化数据含义
  # 第 1 列 - Status V=Valid, R=Revoked, E=Expired
  # 第 2 列 - Expiry date in format of YYMMDDHHMMSSZ
  # 第 3 列 - Revocation date or empty if not revoked
  # 第 4 列 - Hexadecimal serial number
  # 第 5 列 - File location or unknown
  # 第 6 列 - Distinguished name
  touch ${WHERE}/index  # 保存 CA 已签发证书

  echo 0001 > ${WHERE}/crls/crlnumber    # 初始化 CRL 列表的序号, 十六进制
  openssl rand -hex 16 > ${WHERE}/serial # 新建证书序列号(HEX, 16字节, 随机数)
done

#############
# Master CA # ED25519 密钥长度固定 256-bits, RSA 密钥长度 1024/2048/4096 bits
#############
echo "###### => 创建 Root CA 私钥和公钥"
# 创建密钥时添加 -aes256 -pass pass:123456 参数进行 AES256 加密(密码 123456)
openssl genpkey -algorithm ED25519 \
  -outform PEM -out master/priv/${XCA_PREFIX}-master-ca-ed25519-${NOW}.key
openssl genpkey -algorithm RSA \
  -pkeyopt rsa_keygen_bits:4096 -pkeyopt rsa_keygen_primes:3 \
  -outform PEM -out master/priv/${XCA_PREFIX}-master-ca-rsa4096-${NOW}.key
openssl genpkey -algorithm RSA \
  -pkeyopt rsa_keygen_bits:2048 -pkeyopt rsa_keygen_primes:3 \
  -outform PEM -out master/priv/${XCA_PREFIX}-master-ca-rsa2048-${NOW}.key

# openssl pkey -noout -text  -in path/to/ca.key    # 显示: 公钥和私钥
# openssl pkey -noout -check -in path/to/ca.key    # 检查: 公钥和私钥
# openssl pkey -noout -pubcheck -in path/to/ca.key # 检查: 仅公钥部分

# openssl x509 -noout -pubkey -in ca.crt -out ca.pubkey # 从证书导出公钥
# openssl pkey -pubout -in ca.key -out ca.pubkey # 从私钥导出公钥(加密后需密码)

echo "###### => 创建 Root CA 自签名证书(有效期 100 年)"
for alg in ed25519 rsa4096 rsa2048; do # 命令行参数覆盖 master.conf 文件设置
  XCA_DOMAIN=${XCA_DOMAIN} XCA_PREFIX=${XCA_PREFIX} XCA_SUFFIX=${alg}-${NOW} \
  openssl req -new -x509 -days 36500 -outform PEM -config master.conf \
    -key master/priv/${XCA_PREFIX}-master-ca-${alg}-${NOW}.key \
    -out master/cert/${XCA_PREFIX}-master-ca-${alg}-${NOW}.crt
done

# openssl verify path/to/ca.crt # 查看证书签名状态
# openssl x509 -noout -text -in path/to/ca.crt # 查看证书的内容
#
# 关于 X.509 扩展(V3)字段 subjectKeyIdentifier 和 authorityKeyIdentifier
# 如何计算 subjectKeyIdentifier 哈希值的命令 https://security.stackexchange.com/questions/128944
# https://learn.microsoft.com/en-us/windows/win32/api/certenroll/nn-certenroll-ix509extensionsubjectkeyidentifier
# https://learn.microsoft.com/en-us/windows/win32/api/certenroll/nn-certenroll-ix509extensionauthoritykeyidentifier
#
# 仅适用于 RSA 类型密钥, -strparse 19 表示跳过生成的公钥文件(PKCS#1格式)的前 19 个字节(magic number)
# => subjectKeyIdentifier 是生成公钥文件的 BIT STRING 部分的 SHA-1 值(20字节)
# openssl x509 -noout -pubkey -in      ca.crt | openssl asn1parse       # 显示导出公钥文件的 BIT STRING 数据的偏移量
# openssl x509 -noout -pubkey -in rsa4096.crt | openssl asn1parse -strparse 19 -noout -out - | sha1sum  # 非冒号分割
# openssl x509 -noout -pubkey -in rsa4096.crt | openssl asn1parse -strparse 19 -noout -out - | openssl dgst -c -sha1
# openssl x509 -noout -pubkey -in ed25519.crt | openssl asn1parse -strparse  9 -noout -out - | openssl dgst -c -sha1

echo "###### => 初始化 Root CA 证书吊销列表(CRL)"
for alg in ed25519 rsa4096 rsa2048; do
  XCA_DOMAIN=${XCA_DOMAIN} XCA_PREFIX=${XCA_PREFIX} XCA_SUFFIX=${alg}-${NOW} \
  openssl ca -config master.conf -gencrl \
    -keyfile master/priv/${XCA_PREFIX}-master-ca-${alg}-${NOW}.key \
    -cert    master/cert/${XCA_PREFIX}-master-ca-${alg}-${NOW}.crt \
    -out     master/crls/${XCA_PREFIX}-master-ca-${alg}-${NOW}.crl
done

# openssl crl -noout -text -in path/to/ca.crl # 查看 CRLs 文件

#############
# Middle CA #
#############
echo "###### => 创建 Middle CA 私钥和公钥"
openssl genpkey -algorithm ED25519 \
  -outform PEM -out middle/priv/${XCA_PREFIX}-middle-ca-ed25519-${NOW}.key
openssl genpkey -algorithm RSA \
  -pkeyopt rsa_keygen_bits:4096 -pkeyopt rsa_keygen_primes:3 \
  -outform PEM -out middle/priv/${XCA_PREFIX}-middle-ca-rsa4096-${NOW}.key
openssl genpkey -algorithm RSA \
  -pkeyopt rsa_keygen_bits:2048 -pkeyopt rsa_keygen_primes:3 \
  -outform PEM -out middle/priv/${XCA_PREFIX}-middle-ca-rsa2048-${NOW}.key

echo "###### => 创建 Middle CA 签名请求(CSR)"
for alg in ed25519 rsa4096 rsa2048; do
  XCA_DOMAIN=${XCA_DOMAIN} XCA_PREFIX=${XCA_PREFIX} XCA_SUFFIX=${alg}-${NOW} \
  openssl req -new -outform PEM -config middle.conf \
    -key middle/priv/${XCA_PREFIX}-middle-ca-${alg}-${NOW}.key \
    -out middle/cert/${XCA_PREFIX}-middle-ca-${alg}-${NOW}.csr
done

echo "###### => Root CA 签发 Middle CA 证书(有效期 50 年)"
for alg in ed25519 rsa4096 rsa2048; do # master.conf 配置文件默认有效期 50 年
  XCA_DOMAIN=${XCA_DOMAIN} XCA_PREFIX=${XCA_PREFIX} XCA_SUFFIX=${alg}-${NOW} \
  openssl ca -config master.conf \
    -keyfile master/priv/${XCA_PREFIX}-master-ca-${alg}-${NOW}.key \
    -cert    master/cert/${XCA_PREFIX}-master-ca-${alg}-${NOW}.crt \
    -in      middle/cert/${XCA_PREFIX}-middle-ca-${alg}-${NOW}.csr \
    -out     middle/cert/${XCA_PREFIX}-middle-ca-${alg}-${NOW}.crt
done

echo "###### => 初始化 Middle CA 证书吊销列表(CRL)"
for alg in ed25519 rsa4096 rsa2048; do
  XCA_DOMAIN=${XCA_DOMAIN} XCA_PREFIX=${XCA_PREFIX} XCA_SUFFIX=${alg}-${NOW} \
  openssl ca -config middle.conf -gencrl \
    -keyfile middle/priv/${XCA_PREFIX}-middle-ca-${alg}-${NOW}.key \
    -cert    middle/cert/${XCA_PREFIX}-middle-ca-${alg}-${NOW}.crt \
    -out     middle/crls/${XCA_PREFIX}-middle-ca-${alg}-${NOW}.crl
done

# 确认证书之间的签名关系: master.crt 签发 sb-mok.crt
# openssl verify -CAfile master.crt sb-mok.crt
#
# 将包含多证书的文件(证书链)分割为独立证书: xyz-00, xyz-01, ...
# csplit -z -f xyz- chains-ca.crt '/-----BEGIN CERTIFICATE-----/' '{*}'
#
# 确认显示证书签名关系: ca0.crt 签发 ca1.crt, ca1.crt 签发 ca2.crt, ...
# openssl verify -verbose -show_chain -CAfile     ca0.crt ca1.crt ca2.crt
# openssl verify -verbose -show_chain -trusted    ca0.crt ca1.crt ca2.crt
# openssl verify -verbose -show_chain -untrusted  ca0.crt ca1.crt ca2.crt
#
# 证书格式转换
# openssl x509 -in x.pem -outform DER -out x.der # 转换为 DER(二进制)
# openssl x509 -in x.der -outform PEM -out x.pem # 转换为 PEM(Base64)
# openssl crl2pkcs7 -nocrl -certfile x.pem -outform DER -out x.pkcs7 # 转换为 PKCS#7(二进制)
# openssl crl2pkcs7 -nocrl -certfile x1.pem -certfile x2.pem -outform DER -out x.pkcs7

echo "###### => 证书格式转换: PEM, DER"
for cadn in master middle; do
  for alg in ed25519 rsa4096 rsa2048; do
    openssl x509 -outform PEM \
      -in  ${cadn}/cert/${XCA_PREFIX}-${cadn}-ca-${alg}-${NOW}.crt \
      -out ${cadn}/cert/${XCA_PREFIX}-${cadn}-ca-${alg}-${NOW}.crt

    openssl x509 -outform DER \
      -in  ${cadn}/cert/${XCA_PREFIX}-${cadn}-ca-${alg}-${NOW}.crt \
      -out ${cadn}/cert/${XCA_PREFIX}-${cadn}-ca-${alg}-${NOW}.der
  done
done

echo "###### => 创建证书链: Root CA 证书 + Middle CA 证书"
for alg in ed25519 rsa4096 rsa2048; do
  cat master/cert/${XCA_PREFIX}-master-ca-${alg}-${NOW}.crt >> middle/cert/${XCA_PREFIX}-chains-ca-${alg}-${NOW}.crt
  cat middle/cert/${XCA_PREFIX}-middle-ca-${alg}-${NOW}.crt >> middle/cert/${XCA_PREFIX}-chains-ca-${alg}-${NOW}.crt
done
