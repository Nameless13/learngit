title: sudo使用echo命令提示权限问题
categories: [Linux]
date: 2018-05-29 16:48:31
---
示例:
```
sudo echo a > 1.txt
-bash: 1.txt: Permission denied
```
分析：
bash 拒绝这么做，说是权限不够.
这是因为重定向符号 “>” 也是 bash 的命令。sudo 只是让 echo 命令具有了 root 权限，
但是没有让 “>” 命令也具有root 权限，所以 bash 会认为这个命令没有写入信息的权限。

解决办法：
1. 利用 “sh -c” 命令，它可以让 bash 将一个字串作为完整的命令来执行，这样就可以将 sudo 的影响范围扩展到整条命令。
具体用法如下：

`sudo sh -c "echo a > 1.txt"`

利用bash -c 也是一样的。


2.  利用管道和 tee 命令，该命令可以从标准输入中读入信息并将其写入标准输出或文件中，
具体用法如下：
```
echo a |sudo tee 1.txt
echo a |sudo tee -a 1.txt   // -a 是追加的意思，等同于 >>
```
tee 命令很好用，它从管道接受信息，一边向屏幕输出，一边向文件写入。

3. 提升shell 权限。
```
sudo -s        //提到root 权限。提示符为#
当你觉得该退回到普通权限时，
sudo su username //退回到username 权限，提示符为$
```

centos 提升权限: su  -

ubuntu 提升权限: sudu -s, sudo su