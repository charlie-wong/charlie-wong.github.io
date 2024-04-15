#!/usr/bin/env bash

# Middle CA 签发叶证书(下级子证书)
set -xe # 显示命令及参数, 任意命令返回非零值则终止

MIDDLE_SUB_DIR=middle/user
mkdir -p ${MIDDLE_SUB_DIR}

XID=20240410102927 # 时间戳
NOW=$(date '+%Y%m%d%H%M%S')

XCA_PREFIX='xyz'
XCA_DOMAIN='https://you.domain.org'

LEAF_CERT_DN+="/C=CN"
LEAF_CERT_DN+="/ST=Guangdong"
LEAF_CERT_DN+="/L=Shenzhen"
LEAF_CERT_DN+="/O=YourNickname"
LEAF_CERT_DN+="/OU=Network Technology"
LEAF_CERT_DN+="/CN=$(date '+%Y%m%d') End User Cert"
LEAF_CERT_DN+="/emailAddress=YourNickname@example.com"

echo "###### => 创建 LeafCert 私钥和公钥"
openssl genpkey -algorithm ED25519 \
  -outform PEM -out ${MIDDLE_SUB_DIR}/${XCA_PREFIX}-leaf-cert-ed25519-${NOW}.key
openssl genpkey -algorithm RSA \
  -pkeyopt rsa_keygen_bits:4096 -pkeyopt rsa_keygen_primes:3 \
  -outform PEM -out ${MIDDLE_SUB_DIR}/${XCA_PREFIX}-leaf-cert-rsa4096-${NOW}.key
openssl genpkey -algorithm RSA \
  -pkeyopt rsa_keygen_bits:2048 -pkeyopt rsa_keygen_primes:3 \
  -outform PEM -out ${MIDDLE_SUB_DIR}/${XCA_PREFIX}-leaf-cert-rsa2048-${NOW}.key

echo "###### => 创建 LeafCert 签名请求(CSR)"
for alg in ed25519 rsa4096 rsa2048; do
  XCA_DOMAIN=${XCA_DOMAIN} XCA_PREFIX=${XCA_PREFIX} XCA_SUFFIX=${alg}-${XID} \
  openssl req -new -outform PEM -config middle.conf -subj "${LEAF_CERT_DN}" \
    -key ${MIDDLE_SUB_DIR}/${XCA_PREFIX}-leaf-cert-${alg}-${NOW}.key \
    -out ${MIDDLE_SUB_DIR}/${XCA_PREFIX}-leaf-cert-${alg}-${NOW}.csr
done

echo "###### => Middle CA 签发 LeafCert 证书(有效期 50 年)"
for alg in ed25519 rsa4096 rsa2048; do # middle.conf 配置文件默认有效期 50 年
  XCA_DOMAIN=${XCA_DOMAIN} XCA_PREFIX=${XCA_PREFIX} XCA_SUFFIX=${alg}-${XID} \
  openssl ca -config middle.conf \
    -keyfile   middle/priv/${XCA_PREFIX}-middle-ca-${alg}-${XID}.key \
    -cert      middle/cert/${XCA_PREFIX}-middle-ca-${alg}-${XID}.crt \
    -in  ${MIDDLE_SUB_DIR}/${XCA_PREFIX}-leaf-cert-${alg}-${NOW}.csr \
    -out ${MIDDLE_SUB_DIR}/${XCA_PREFIX}-leaf-cert-${alg}-${NOW}.crt
done

echo "###### => 证书格式转换: PEM, DER"
for alg in ed25519 rsa4096 rsa2048; do
  openssl x509 -outform PEM \
    -in  ${MIDDLE_SUB_DIR}/${XCA_PREFIX}-leaf-cert-${alg}-${NOW}.crt \
    -out ${MIDDLE_SUB_DIR}/${XCA_PREFIX}-leaf-cert-${alg}-${NOW}.crt

  openssl x509 -outform DER \
    -in  ${MIDDLE_SUB_DIR}/${XCA_PREFIX}-leaf-cert-${alg}-${NOW}.crt \
    -out ${MIDDLE_SUB_DIR}/${XCA_PREFIX}-leaf-cert-${alg}-${NOW}.der
done

# 证书链验证
if false; then
  openssl verify -show_chain -CAfile master.crt -untrusted middle.crt  user.crt
  cat master.crt > chains.crt; cat middle.crt >> chains.crt # 多证书链 PEM 格式
  openssl verify -show_chain -CAfile chains.crt    user.crt
fi
