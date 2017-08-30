#!usr/bin/env python
# -*- coding: utf-8 -*-

import os
# fn= "/Users/nameless13/Projects/blog/source/_posts/Document/weixin.md"
fn= "/Users/nameless13/Projects/blog/source/_posts/Document/weixin.md"

# n = 0 应该每个循环开始前赋值的 否则后面会一直递增
cut = 0 

# 递归遍历当前目录和所有子目录的文件和目录 绝对路径
for dirpath, dirs, files in os.walk('.'):                
    # files 保存的是所有的文件名 绝对路径  
    for name in files:                                   
      # 用splitext判断文件名的后缀是.md
      if os.path.splitext(name)[1] == '.mdown' or os.path.splitext(name)[1] == '.md' :           
            filename = os.path.join(dirpath, name)    
            f = open(filename)
            lines = f.readlines()
            n = 0
            # print line[0][0:5] 第一行 前五个字符
            if (lines[0][0:5] == 'title'): 
                  while n < 9:
                        if (lines[n][0:3] == '---'):
                              cut = n + 1
                              # n = 0
                              break
                        else:
                              n = n + 1

            # print type(cut)
            # <type 'int'>
            # print filename  
            # 把剩下的行拆分依旧是list
            line = lines[cut:]
            # line = lines[0:cut]
            # print type(line)
            Leftover=''.join(line)
            # print type(Leftover) <type 'str'>
            # print cut
            # print Leftover;
            f.close() 
            f = open(filename,'w')
            f.seek(0)
            f.write(Leftover)
            f.flush()
            f.close() 







