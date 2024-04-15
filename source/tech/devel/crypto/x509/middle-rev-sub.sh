#!/usr/bin/env bash

USE_ALG=$1  # 指定需要吊销的 CA 证书文件(算法即可)

# Middle CA 吊销叶证书(下级子证书)
set -xe # 显示命令及参数, 任意命令返回非零值则终止

XID=20240410102927 # 时间戳
NOW=$(date '+%Y%m%d%H%M%S')

XCA_PREFIX='xyz'
XCA_DOMAIN='https://you.domain.org'

for alg in ed25519 rsa4096 rsa2048; do
  [ ${USE_ALG} != ${alg} ] && continue;

  # 吊销指定证书(更新 index 文件)
  XCA_DOMAIN=${XCA_DOMAIN} XCA_PREFIX=${XCA_PREFIX} XCA_SUFFIX=${alg}-${XID} \
  openssl ca -config middle.conf \
    -revoke middle/cert/${XCA_PREFIX}-middle-ca-${alg}-${XID}.crt

  # 更新 Middle CA 证书吊销列表(CRL)
  XCA_DOMAIN=${XCA_DOMAIN} XCA_PREFIX=${XCA_PREFIX} XCA_SUFFIX=${alg}-${XID} \
  openssl ca -config middle.conf -gencrl \
    -keyfile middle/priv/${XCA_PREFIX}-middle-ca-${alg}-${XID}.key \
    -cert    middle/cert/${XCA_PREFIX}-middle-ca-${alg}-${XID}.crt \
    -out     middle/crls/${XCA_PREFIX}-middle-ca-${alg}-${XID}.crl
done
