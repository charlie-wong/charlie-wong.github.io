#!/usr/bin/env bash

# Root CA 签发新 Middle CA 中间层证书
set -xe # 显示命令及参数, 任意命令返回非零值则终止

XID=20240410102927 # 时间戳
NOW=$(date '+%Y%m%d%H%M%S')

XCA_PREFIX='xyz'
XCA_DOMAIN='https://you.domain.org'

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
  XCA_DOMAIN=${XCA_DOMAIN} XCA_PREFIX=${XCA_PREFIX} XCA_SUFFIX=${alg}-${XID} \
  openssl req -new -outform PEM -config middle.conf \
    -key middle/priv/${XCA_PREFIX}-middle-ca-${alg}-${NOW}.key \
    -out middle/cert/${XCA_PREFIX}-middle-ca-${alg}-${NOW}.csr
done

echo "###### => Root CA 签发 Middle CA 证书(有效期 50 年)"
for alg in ed25519 rsa4096 rsa2048; do # master.conf 配置文件默认有效期 50 年
  XCA_DOMAIN=${XCA_DOMAIN} XCA_PREFIX=${XCA_PREFIX} XCA_SUFFIX=${alg}-${XID} \
  openssl ca -config master.conf \
    -keyfile master/priv/${XCA_PREFIX}-master-ca-${alg}-${XID}.key \
    -cert    master/cert/${XCA_PREFIX}-master-ca-${alg}-${XID}.crt \
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

echo "###### => 证书格式转换: PEM, DER"
for alg in ed25519 rsa4096 rsa2048; do
  openssl x509 -outform PEM \
    -in  middle/cert/${XCA_PREFIX}-middle-ca-${alg}-${NOW}.crt \
    -out middle/cert/${XCA_PREFIX}-middle-ca-${alg}-${NOW}.crt

  openssl x509 -outform DER \
    -in  middle/cert/${XCA_PREFIX}-middle-ca-${alg}-${NOW}.crt \
    -out middle/cert/${XCA_PREFIX}-middle-ca-${alg}-${NOW}.der
done

echo "###### => 创建证书链: Root CA 证书 + Middle CA 证书"
for alg in ed25519 rsa4096 rsa2048; do
  cat master/cert/${XCA_PREFIX}-master-ca-${alg}-${XID}.crt >> middle/cert/${XCA_PREFIX}-chains-ca-${alg}-${NOW}.crt
  cat middle/cert/${XCA_PREFIX}-middle-ca-${alg}-${NOW}.crt >> middle/cert/${XCA_PREFIX}-chains-ca-${alg}-${NOW}.crt
done
