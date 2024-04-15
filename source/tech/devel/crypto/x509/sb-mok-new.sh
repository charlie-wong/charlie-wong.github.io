#!/usr/bin/env bash

# 新建 UEFI 安全启动 MOK 证书, 导入/删除 MOK 时需要 OneTime 密码

set -xe # 显示命令及参数, 任意命令返回非零值则终止
# NOTE 2024/04/09 安全启动仅支持导入 RSA/2048 算法

XID=20240410102927 # 时间戳
NOW=$(date '+%Y%m%d%H%M%S')

XCA_PREFIX='xyz'
XCA_DOMAIN='https://you.domain.org'

echo "###### => 创建 MOK 私钥和公钥"
openssl genpkey -algorithm ED25519 \
  -outform PEM -out sb-mok/priv/${XCA_PREFIX}-sb-mok-ca-ed25519-${NOW}.key
openssl genpkey -algorithm RSA \
  -pkeyopt rsa_keygen_bits:4096 -pkeyopt rsa_keygen_primes:3 \
  -outform PEM -out sb-mok/priv/${XCA_PREFIX}-sb-mok-ca-rsa4096-${NOW}.key
openssl genpkey -algorithm RSA \
  -pkeyopt rsa_keygen_bits:2048 -pkeyopt rsa_keygen_primes:3 \
  -outform PEM -out sb-mok/priv/${XCA_PREFIX}-sb-mok-ca-rsa2048-${NOW}.key

echo "###### => 创建 MOK 签名请求(CSR)"
for alg in ed25519 rsa4096 rsa2048; do
  XCA_DOMAIN=${XCA_DOMAIN} XCA_PREFIX=${XCA_PREFIX} XCA_SUFFIX=${alg}-${XID} \
  openssl req -new -outform PEM -config sb-mok.conf \
    -key sb-mok/priv/${XCA_PREFIX}-sb-mok-ca-${alg}-${NOW}.key \
    -out sb-mok/cert/${XCA_PREFIX}-sb-mok-ca-${alg}-${NOW}.csr
done

echo "###### => Root CA 签发 MOK 证书(有效期 50 年)"
for alg in ed25519 rsa4096 rsa2048; do # master.conf 配置文件默认有效期 50 年
  XCA_DOMAIN=${XCA_DOMAIN} XCA_PREFIX=${XCA_PREFIX} XCA_SUFFIX=${alg}-${XID} \
  openssl ca -config master.conf -extensions issue_ca_exts_v3_sb_mok \
    -keyfile master/priv/${XCA_PREFIX}-master-ca-${alg}-${XID}.key \
    -cert    master/cert/${XCA_PREFIX}-master-ca-${alg}-${XID}.crt \
    -in      sb-mok/cert/${XCA_PREFIX}-sb-mok-ca-${alg}-${NOW}.csr \
    -out     sb-mok/cert/${XCA_PREFIX}-sb-mok-ca-${alg}-${NOW}.crt
done

echo "###### => 证书格式转换: PEM, DER"
for alg in ed25519 rsa4096 rsa2048; do
  openssl x509 -outform PEM \
    -in  sb-mok/cert/${XCA_PREFIX}-sb-mok-ca-${alg}-${NOW}.crt \
    -out sb-mok/cert/${XCA_PREFIX}-sb-mok-ca-${alg}-${NOW}.crt

  openssl x509 -outform DER \
    -in  sb-mok/cert/${XCA_PREFIX}-sb-mok-ca-${alg}-${NOW}.crt \
    -out sb-mok/cert/${XCA_PREFIX}-sb-mok-ca-${alg}-${NOW}.der
done
