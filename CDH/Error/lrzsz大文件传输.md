title: lrzsz大文件传输
categories: 
- CDH
- Error
date: 2017-06-05
---
rz、sz命令结合方便的上下传文件，但经过跳板机之后直接rz、sz一个稍大的文件会在上传一部分后退出并显示一堆乱码，这是因为这中间有控制字符的原因。 

*解决办法：** 加参数-e忽略控制字符：rz -e和sz -e



rz，sz是Linux/Unix同Windows进行ZModem文件传输的命令行工具。

windows端需要支持ZModem的telnet/ssh客户端（比如SecureCRT），运行命令rz即是接收文件，SecureCRT就会弹出文件选择对话框，选好文件之后关闭对话框，文件就会上传到当前目录。注意：单独用rz会有两个问题：上传中断、上传文件变化（md5不同），解决办法是上传时用rz -be，并且去掉弹出的对话框中“Upload files as ASCII”前的勾选。-a, –ascii -b, –binary ，用binary的方式上传下载，不解释字符为ascii，-e, –escape 强制escape 所有控制字符，比如Ctrl+x，DEL等rar,gif等文件。采用 -b 用binary的方式上传。文件比较大而上传出错的话，采用参数 -e。如果用不带参数的rz命令上传大文件时，常常上传一半就断掉了，很可能是rz以为上传的流中包含某些特殊控制字符，造成rz提前退出