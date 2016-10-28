#!/usr/bin/python
# -*- coding: UTF-8 -*-


try:
  fh = open('testfile','w')
  fh.write("这时一个测试文件用于测试异常")
except IOError:
  print "Error: 没有文件或者读取文件失败"
else:
  print "内容写入文件成功"
  fh.close()
