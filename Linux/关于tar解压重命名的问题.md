title: 关于tar解压重命名的问题
categories: [Linux]
date: 2018-05-23 09:57:35
---
# 关于tar解压重命名的问题
## 问题描述：
`wget http://oss.aliyuncs.com/aliyunecs/onekey/mysql/mysql-5.6.15-linux-glibc2.5-i686.tar.gz`
显然下载下来的文件就是：mysql-5.6.15-linux-glibc2.5-i686.tar.gz

有时候这样的文件名不便于shell脚本的自动化操作，在特定条件下你希望将“mysql-5.6.15-linux-glibc2.5-i686.tar.gz” 变为 “mysql-5.6.15.tar.gz”，于是大家都会像下面这样做：

`wget -O mysql-5.6.15.tar.gz  http://oss.aliyuncs.com/aliyunecs/onekey/mysql/mysql-5.6.15-linux-glibc2.5-i686.tar.gz`
好，现在已经得到了是“mysql-5.6.15.tar.gz”这样的文件名了。但是，接着你将“mysql-5.6.15.tar.gz”解压后就会发现好像不是你想要的，如下：

`tar -zxvf mysql-5.6.15.tar.gz`
mysql-5.6.15-linux-glibc2.5-i686 （这就是解压后的文件名）

如何保证“mysql-5.6.15.tar.gz”解压后的文件名就是“mysql-5.6.15”呢？

 

完整解决过程：

```
wget -O mysql-5.6.15.tar.gz  http://oss.aliyuncs.com/aliyunecs/onekey/mysql/mysql-5.6.15-linux-glibc2.5-i686.tar.gz

mkdir ./mysql-5.6.15 && tar -xzvf mysql-5.6.15.tar.gz -C ./mysql-5.6.15 --strip-components 1
```
这样就得到了“mysql-5.6.15”命名的解压文件。