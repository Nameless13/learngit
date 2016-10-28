#!/usr/bin/python
# -*- coding: UTF-8 -*-

fo = open("foo.txt", "r+")
str = fo.read(10);
print "put str :", str

position = fo.tell();
print "当前位置 : ",position

position = fo.seek(0,0);

str = fo.read(10);

print "重新读取字符串 :",str

fo.close()
