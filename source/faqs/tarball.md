# Tarball

- https://www.baeldung.com/linux/xz-compression
- https://www.baeldung.com/linux/gzip-and-gunzip
- https://www.baeldung.com/linux/zip-unzip-command-line

## **Tar** 系列

- `.tar`
  - 解包 `tar xvf FileName.tar`
  - 打包 `tar cvf FileName.tar DirName`
- `.tar.gz`
  - 解压 `tar zxvf FileName.tar.gz`
  - 压缩 `tar zcvf FileName.tar.gz DirName`
- `.tar.bz2`
  - 解压 `tar jxvf FileName.tar.bz2`
  - 压缩 `tar jcvf FileName.tar.bz2 DirName`
- `.tar.bz`
  - 解压 `tar jxvf FileName.tar.bz`
  - 压缩
- `.tar.Z`
  - 解压 `tar Zxvf FileName.tar.Z`
  - 压缩 `tar Zcvf FileName.tar.Z DirName`
- `.tgz`
  - 解压 `tar zxvf FileName.tgz`
  - 压缩
- `.tar.tgz`
  - 解压 `tar zxvf FileName.tar.tgz`
  - 压缩 `tar zcvf FileName.tar.tgz FileName`

## **7Zip**

- 压缩 `7zzs a archive.7z "*.txt"`
- 解压 `7zzs x archive.7z`
- 列表 `7zzs l archive.7z`
- 列表 `7zzs l archive.7z -slt`

## `.gz`

- 解压 `gunzip FileName.gz`
- 解压 `gzip -d FileName.gz`
- 压缩 `gzip FileName`

## `.bz2`

- 解压 `bzip2 -d FileName.bz2`
- 解压 `bunzip2 FileName.bz2`
- 压缩 `bzip2 -z FileName`

## `.bz`

- 解压 `bzip2 -d FileName.bz`
- 解压 `bunzip2 FileName.bz`

## `.Z`

- 解压 `uncompress FileName.Z`
- 压缩 `compress FileName`

## `.zip`

- 解压 `unzip FileName.zip`
- 压缩 `zip FileName.zip DirName`

## `.lha`

- 解压 `lha -e FileName.lha`
- 压缩 `lha -a FileName.lha FileName`

## `.rar`

- 解压 `rar a FileName.rar`
- 压缩 `rar e FileName.rar`
