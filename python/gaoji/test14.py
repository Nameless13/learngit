#!/usr/bin/python
# -*- coding: UTF-8 -*-

def reduceNum(n):
    print '{} = '.format(n),
    if not isinstance(n,int) or n <= 0:
        print '请输入一个正确的数字!'
        exit(0)
    elif n in [1] :
        pirnt '{}'.format(n)
    while n not in [1] :
        print index
