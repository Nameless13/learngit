#!usr/bin/env python
# -*- coding: utf-8 -*-

import os
import time

for dirpath, dirs, files in os.walk('.'):                # 递归遍历当前目录和所有子目录的文件和目录 绝对路径
    for name in files:                                   # files 保存的是所有的文件名 绝对路径
        if os.path.splitext(name)[1] == '.mdown' or os.path.splitext(name)[1] == '.md' :           # 用splitext判断文件名的后缀是.md
            filename = os.path.join(dirpath, name)       # 加上路径，dirpath是遍历时文件对应的路径
            fname = os.path.splitext(os.path.basename(name))[0] #获取文件名
            filedate = time.strftime('%Y/%m/%d %H:%M:%S', time.localtime(os.path.getctime(filename)))
            # print "文件名:     " + filename.split("/")[-2]
            secondpath = filename.split("/")[-2]
            if filename.split("/")[-3] != '.':
                # print "文件名:     " + filename.split("/")[-3]
                firstpath = filename.split("/")[-3]
                suit = 'title: ' + fname + '\n' + 'categories: ' + '\n' + '- ' + firstpath + '\n' + '- ' + secondpath+ '\n' + 'date: ' + filedate + '\n' + '---' + '\n' 
                f = open(filename)
                s = f.read()
                f.close()
                s = suit+s
                f = open(filename,'w')
                f.seek(0)
                f.write(s)
                f.flush()
                f.close()    
            else:
                suit = 'title: ' + fname + '\n' +  'categories: ' + '\n' + '- ' + secondpath+ '\n' +'date: ' + filedate + '\n' + '---' + '\n' 
                f = open(filename)
                s = f.read()
                f.close()
                s = suit+s
                f = open(filename,'w')
                f.seek(0)
                f.write(s)
                f.flush()
                f.close()     

