title: Linux 修改时区
categories: [CDH,Installation]
date: 2018-05-23 09:57:35
---
# linux 修改时区

在linux中与时间相关的文件有

 1. `/etc/localtime`
 2. `/etc/timezone`

其中，/etc/localtime是用来描述本机时间，而 /etc/timezone是用来描述本机所属的时区。

## 修改本机时间
`cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime`

在/usr/share/zoneinfo下存放着不同时区格式的时间文件，执行以下命令，可以将本机时间调整至目标时区的时间格式。 
但是！调整了时间格式，本机所属的时区是保持不变的！

## 修改本机时区
在linux中，有一些程序会自己计算时间，不会直接采用带有时区的本机时间格式，会根据UTC时间和本机所属的时区等计算出当前的时间。 
比如jdk应用，时区为“Etc/UTC”，本机时间改为北京时间，通过java代码中new 出来的时间还是utc时间，所以必须得修正本机的时区。

`echo 'Asia/Shanghai' >/etc/timezone`

(参考资料)[http://blog.csdn.net/linuxnews/article/details/51325180]