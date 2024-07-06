# `git unpack-objects` 将 packed-objects 解压为 loose-objects

```bash
# 创建解压仓库
mkdir test; git init

# 拷贝 demo 仓库的 packed-objects 文件
cp path/demo/.git/objects/pack/* test/

# 解压 packed-objects 文件到 test/.git/objects/
git unpack-objects < *.pack
```
