#!/usr/bin/python
# -*- coding: UTF-8 -*-

class Parent:
    def myMethod(self):
        print '调用父类方法'

class Child1(Parent)      
    print 'none'

class Child(Parent):
    def myMethod(self):
        print '调用子类方法'


c=Child()
c.myMethod()

d = Child1()
d.myMethod()