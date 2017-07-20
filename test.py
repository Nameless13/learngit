#!usr/bin/env python
# -*- coding: utf-8 -*-

import os
n = 0
# fn= "/Users/nameless13/Projects/blog/source/_posts/Document/weixin.md"
fn= "/Users/nameless13/Projects/blog/source/_posts/Document/weixin.md"

for dirpath, dirs, files in os.walk('.'):                # 递归遍历当前目录和所有子目录的文件和目录 绝对路径
    for name in files:                                   # files 保存的是所有的文件名 绝对路径
        if os.path.splitext(name)[1] == '.mdown' or os.path.splitext(name)[1] == '.md' :           # 用splitext判断文件名的后缀是.md
            filename = os.path.join(dirpath, name)    
            f = open(filename)
            line = f.readlines()
            if (line[0][0:5] == 'title'): # print line[0][0:5]
            	while n < 9:
            		if (line[n][0:5] == 'date:'):
            			cut = n
            			break
            		else:
            			n = n + 1
            	lines = line[cut:]
            	# print type(lines) <type 'list'>
            	remove=''.join(lines)
            	# print type(remove) <type 'str'>
            	f.close() 
            	f = open(filename,'w')
            	f.seek(0)
            	f.write(remove)
            	f.flush()
            	f.close() 







