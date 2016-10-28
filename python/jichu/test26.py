#!/usr/bin/python
# -*- coding: UTF-8 -*-


try:
  fh=open("testfile",'w')
  try:
    fh.write("这时一个测试文件!")
  finally:
    print "关闭文件"
    fh.close()
except IOErroe:
  print "Error: 没有文件读取失败"
