#!/usr/bin/python
# -*- coding: UTF-8 -*-

# 可写函数说明
def changeme(mylist):
  mylist.append([1,2,3,4]);
  print "函数内取值:",mylist
  return

# 调用changeme函数
mylist=[10,20,30];
changeme(mylist);
print "函数外取值:",mylist
