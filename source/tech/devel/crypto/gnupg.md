# GnuPG

- https://wiki.debian.org/Subkeys
- https://wiki.archlinux.org/title/GnuPG
- GnuPG 概念简介 https://zhuanlan.zhihu.com/p/481900853
- OpenPGP Message Format https://datatracker.ietf.org/doc/rfc4880/
- https://www.gnupg.org/documentation/manuals/gnupg/Option-Index.html
- https://www.kernel.org/doc/html/latest/process/maintainer-pgp-guide.html

- `gpg` 缩略词含义及概念

  > GnuPG 源代码 => g10/packet.h 搜索 `_USAGE_`

  ```
  [E]  用途 Encryption  [A]  用途 Authentication
  [S]  用途 Signatures  [C]  用途 Certify/Sign Other Keys

  uid  User Id          sig  Signature          fpr  Fingerprints
  pub  Public Key       sub  Subkey
  sec  Secret Key       ssb  Secret Subkey
  rvk  Revocation Key   crt  X.509 Certificate
  rev  Revocation 签名  crs  X.509 Cert & 私钥
  ```

  - 推荐算法 `ED25519` > `RSA4096` > `RSA2048`
  - Trust Chain 分布式信任(去中心化), PKI 信任体系依赖中心化权威机构
  - Authentication 一种安全的远程登陆方式(不依赖密码), 现实实例: SSH
  - 证书/公钥的主要区别: 公钥仅绑定 User ID, 证书绑定 Subject, SAN 等更多信息

## 配置文件

```bash
# 有效 UserID 可选 => KeyID, 密钥指纹, 用户名, 邮箱
# 有效  KeyID 可选 => 9A0B1E11A434FE86, 40 位字符串

# 信任模式文件  ~/.gnupg/tofu.db       -> Trust-On-First-Use
# 默认配置文件  ~/.gnupg/gpg.conf
# 信任密钥列表  ~/.gnupg/trustdb.gpg
# 公钥列表文件  ~/.gnupg/pubring.kbx   -> new keybox format
#               ~/.gnupg/pubring.gpg   -> old legacy format

# 默认配置文件  ~/.gnupg/gpg-agent.conf
# 信任密钥列表  ~/.gnupg/trustlist.txt
# 代理私钥存储  ~/.gnupg/private-keys-v1.d/*.key
```

- 配置文件 `gpg.conf`

  ```bash
  ## Set the default key to sign with. If this option is not used,
  ## the default key is the first key found in the secret keyring.
  ## NOTE cmd line option -u or --local-user overrides this option.
  default-key 0123456789ABCDEF0123456789ABCDEF01234567 # PrimaryKey
  #keyring path/to/key/file # 指定默认密钥文件进行 => 签名 & 加解密

  # Create PEM encoded ASCII output, default is binary
  armor

  ## Include PG version in ASCII armored output
  #emit-version
  ## Exclude PG version in ASCII armored output
  no-emit-version

  ## Include the keygrip info in printed key list
  ## NOTE ~/.gnupg/private-keys-v1.d/<keygrip>.key
  with-keygrip

  ## Display key IDs: none, short(8位), long(16位), 0xshort, 0xlong
  keyid-format long

  # TOFU => Trust on First Use
  # PGP Trust Model, TOFU Trust Model
  trust-model tofu+pgp
  ```

- 配置文件 `gpg-agent.conf`

  ```bash
  # 单位秒, 默认值 600s(10m), 若在未到达指定时间之前再次使用   1800 秒 => 30 分钟
  # 相同密钥, 则不用输入密码(直接从缓存读取), 同时重置计时器   7200 秒 =>  2 小时
  default-cache-ttl 1800

  # 单位秒, 默认值 1800s(30m), 表示缓存保持密钥密码的最长时间
  max-cache-ttl 7200
  ```

- 配置文件 `dirmngr.conf`

  * https://www.gnupg.org/documentation/manuals/gnupg/Invoking-DIRMNGR.html

  ```bash
  # This is the server that --receive-keys, --send-keys, and --search-keys will
  # communicate with to receive keys from, send keys to, and search for keys on
  #
  # The value format is 'scheme:[//]KeyServerName[:port]'
  # scheme is keyserver type, "hkp" for HTTP, "hkps" for HTTPS

  # https://keys.openpgp.org/about/usage
  # NOTE can delete key, email IDs verification
  keyserver hkps://keys.openpgp.org

  # https://keys.mailvelope.com/manage.html
  # NOTE can delete key, email IDs verification
  keyserver hkps://keys.mailvelope.com

  # https://keyserver.ubuntu.com
  # NOTE no delete key & email IDs verification
  keyserver hkps://keyserver.ubuntu.com
  ```

- GnuPG Key Trust Level 配置

  ```bash
  # trustdb.asc
  # 设置新导入密钥的信任等级 => ultimate
  # 导入 gpg --import-ownertrust trustdb.asc
  0123456789ABCDEF0123456789ABCDEF01234567:6:
  ```

## GnuPG 命令备忘

  - armor 密钥常用后缀 `.asc`, 分离式签名文件常用后缀 `.sig`

  ```bash
  export GPG_TTY=$(tty)
  gpgconf --kill gpg-agent

  # 设置 GnuPG 数据读取位置, 默认 ~/.gnupg
  gpg --homedir path/to/gnupg
  export GNUPGHOME="path/to/gnupg"

  # ASCII Armor 格式 => 二进制格式
  gpg --dearmor path/to/key.asc > key.gpg

  # 加密 -e,--encrypt   签名 --clearsign,--clear-sign
  # 解密 -d,--decrypt   签名 -s,--sign; -b,--detach-sign
  # -a,--armor          指定加密密钥 -r,--recipient  UserId
  # --no-armor          指定签名密钥 -u,--local-user UserId
  # -o,--output FILE
  # 显示私钥 -K,--list-secret-keys
  # 显示公钥 -k,--list-public-keys,--list-keys

  # 查看公钥和私钥
  gpg --list-keys
  gpg --list-public-keys
  gpg --list-secret-keys
  gpg --show-key path/to/key

  gpg -k --with-subkey-fingerprint
  # 说明 => none, short(8位), long(16位), 0xshort(8位+0x), 0xlong
  gpg -k --keyid-format=long # none, short, long, 0xshort, 0xlong

  # 查看密钥签名及指纹
  gpg --fingerprint
  gpg --list-signatures
  gpg --check-signatures
  gpg --check-sigs
  gpg --check-sigs 89ABCDEF01234567

  # 编辑密钥: 添加 sumkey, 修改密码, 吊销 subkey
  gpg --edit-key 0123456789ABCDEF0123456789ABCDEF01234567

  # 导入公钥和私钥
  gpg --import path/to/public-key.asc # 导入公
  gpg --import path/to/secret-key.asc # 导入私钥
  gpg --import-ownertrust trusted.asc # 导入信任库

  # 导出公钥和私钥
  gpg --armor --output 公钥.asc --export 89ABCDEF01234567
  gpg --armor --output 私钥.asc --export-secret-keys 89ABCDEF01234567
  gpg --armor --export # 导出公钥到 stdout
  gpg --armor --export --output path/to/public-key.asc UserID
  gpg --armor --export-secret-keys # 导出私钥到 stdout
  gpg --armor --export-secret-keys --output path/to/secret-key.asc UserID
  gpg --armor --export-ownertrust # 备份信任数据库
  gpg --armor --export-ownertrust > path/to/trusted.asc

  # Fingerprints           0123456789ABCDEF0123456789ABCDEF01234567
  #               0123 4567 89AB CDEF 0123 4567 89AB CDEF 0123 4567
  # Long ID                                     89AB CDEF 0123 4567
  # Short ID                                              0123 4567
  #
  # ~/.gnupg/pubring.kbx          本地公钥默认读写位置
  # ~/.gnupg/private-keys-v1.d/   存储公钥对应私钥数据, Keygrip

  # 查看 fingerprint 使用的散列算法
  gpg --export | gpg --list-packets | grep 'digest algo'
  # => RFC 4880 9.4 Hash Algorithm

  # --expert        启用专家模式, 提供更多参数选择
  # --full-gen-key  比 --gen-key 提供更加丰富的选项
  gpg --generate-key
  gpg --full-generate-key
  gpg --expert --full-generate-key

  # 非对称加密: 私钥加密+公钥解密 & 公钥加密 + 私钥解密, 缺点: 加密速度慢
  echo 'hello' > hello.txt
  gpg --symmetric --cipher-algo AES256 hello.txt # GnuPG 进行对称密钥加密
  # 89ABCDEF01234567 的公钥加密, 解密则需要与之对应的私钥
  # --recipient 指定加密时的公钥及解密时的私钥
  gpg                          --encrypt --recipient 89ABCDEF01234567 hello.txt
  gpg --output hello.txt.gpg   --encrypt --recipient x@xx.example.org hello.txt
  gpg --armor -o hello.txt.asc --encrypt --recipient 89ABCDEF01234567 hello.txt
  # 解密时 --recipient 可以省略
  gpg -o hello.txt.new --decrypt hello.txt.asc # hello.txt.gpg
  gpg -o hello.txt.new --decrypt --recipient 89ABCDEF01234567 hello.txt.asc

  # 签名其它公钥
  gpg --default-key 89ABCDEF01234567 --sign-key 1234ABCD1234ABCD
  # 数据签名
  # --sign/--clearsign 对数据签名: 加密原始数据, 打包签名和加密后数据
  gpg -ao hello.txt.sig --sign      hello.txt #
  gpg -ao hello.txt.sig --clearsign hello.txt # 包含未加密原始数据
  gpg --decrypt hello.txt.sig # 查看原始数据及签名信息
  # 数据签名(分离式)
  gpg -ao hello.txt.sig --detach-sign hello.txt
  gpg --verify hello.txt.sig hello.txt # 签名验证

  # 生成吊销证书
  gpg -ao remoke-01234567 --gen-revoke 01234567 # 吊销 Master 密钥
  gpg --generate-revocation --armor --output revoke-key.asc UserID

  # 信任库位置 ~/.gnupg/trustdb.gpg
  # 修改密钥信任等级(导入的密钥不会自动添加到信任数据库中)
  gpg --edit-key 01234567 # 吊销 Master 密钥的 Subkey
  # gpg> help 显示帮助   gpg> trust  信任等级
  # gpg> save 保存修改   gpg> quit   退出程序

  # 私钥代理
  systemctl --user status gpg-agent   # gpg-agent 状态显示
  systemctl --user edit gpg-agent     # gpg-agent 服务修改
  systemctl --user revert gpg-agent   # gpg-agent 恢复默认
  systemctl --user restart gpg-agent  # gpg-agent 重新启动

  # gpg-connect-agent 用于和当前运行的 gpg-agent 服务通信
  gpg-connect-agent help # 显示控制命令列表, 退出命令 /bye
  # 默认配置文件 ~/gnupg/dirmngr.conf
  dirmngr # 用于和公钥服务器通信
  # 默认配置文件 ~/gnupg/gpgsm.conf
  gpgsm # 用于邮件加密/解密/数字认证

  # 公共服务器 -> https://www.openpgp.org/software/server
  #    https:// -> hkps://           http:// -> hkp://
  # => https://keys.mailvelope.com   can delete key, email IDs verification
  # => https://keys.openpgp.org      can delete key, email IDs verification
  # => https://keyserver.ubuntu.com  no delete key & email IDs verification
  gpg --keyserver hkps://keys.openpgp.org --send-keys KeyID    # 发送公钥到服务器
  gpg --keyserver hkps://keys.openpgp.org --search-keys UserID # 在服务器搜索公钥
  gpg --keyserver hkps://keys.openpgp.org --receive-keys KeyID # 从服务器导入公钥
  gpg --keyserver hkps://keys.openpgp.org --refresh-keys # 服务器更新本地已有密钥
  ```
