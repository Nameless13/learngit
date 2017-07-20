title: Python文件处理
categories: [python]
date: 2017-06-15
---
# Python文件处理
文件打开方法: open(name[,mode[buf]])
name: 文件路径
mode: 打开方式
buf: 缓冲buffering大小

- 文件读取方式:
    + read([size]):读取文件(读取size个字节,默认读取全部)
    + readline([size]):读取一行
    + readlines([size]):读取完文件,返回每一行所组成的列表
- 文件写入方式:
    + write(str):将字符串写入文件
    + writelines(sequence_of_strings):写多行到文件
