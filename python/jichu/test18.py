#!/usr/bin/python
# -*- coding: UTF-8 -*-

fo = open("foo.txt","r+")
str = fo.read(10);
print "put str: ", str

fo.close()
