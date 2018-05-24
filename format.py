#!usr/bin/env python
# -*- coding: utf-8 -*-
# version 0.2 代码复用过大,目前能判断是否需要添加hexo的头部说明,但是文件日期还是当前日期

import os,re,time,datetime
def fname_format(fname):
    if fname[0] != '[':
        pass
        # continue #continue 将跳出for循环 单独验证的时候使用
    else:
        fname=re.search('(?<=])\w.*$',fname).group()
    return fname

# 把时间戳转化为时间
def TimeStampToTime(timestamp):
    timeStruct = time.localtime(timestamp)
    return time.strftime('%Y-%m-%d %H:%M:%S',timeStruct)

#获取文件的访问时间
def get_FileAccessTime(filePath):
    t = os.path.getatime(filePath)
    return TimeStampToTime(t)

#获取文件的创建时间
def get_FileCreateTime(filePath):
    t = os.path.getctime(filePath)
    return TimeStampToTime(t)

#获取文件的修改时间
def get_FileModifyTime(filePath):
    t = os.path.getmtime(filePath)
    return TimeStampToTime(t)

def write_title(filename_path,fname):
    f = open(filename_path,encoding='UTF-8')
    lines = f.readlines()
    n = 0
    # print line[0][0:5] 第一行 前五个字符
    if (lines[0][0:5] == 'title'): 
        f.close()
    else:
        f.close()
        f = open(filename_path,encoding='UTF-8')
        s = f.read()
        f.close()
        #获取categories
        # secondpath = filename_path.split("/")[1:-1] #For MAC,Linux
        secondpath = filename_path.split("\\")[1:-1]  #For Windows
        secondpath_tostr=",".join(secondpath)
        filemtime=get_FileModifyTime(filename_path)
        categories_format = 'title: ' + fname + '\n' + \
                            'categories: ' + '[' + secondpath_tostr + ']' + '\n' + \
                            'date: ' + filemtime + '\n' + \
                            '---' + '\n' + '\n' 
        s = categories_format+s
        f = open(filename_path,'w',encoding='UTF-8')
        f.seek(0)
        f.write(s)
        f.flush()
        f.close()    
        print(filename_path)

# 递归遍历当前目录和所有子目录的文件和目录 绝对路径
for root, dirs, files in os.walk('.'):                
    # files 保存的是所有的文件名 绝对路径
    for name in files:                                   
        # 用splitext判断文件名的后缀是.md
        if os.path.splitext(name)[1] == '.mdown' or os.path.splitext(name)[1] == '.md' :           
            # 加上路径，root是遍历时文件对应的路径
            filename_path = os.path.join(root, name)       
            #获取文件名
            fname = os.path.splitext(os.path.basename(name))[0] 
            fname = fname_format(fname)
            
            write_title(filename_path,fname)
