title: Ruby入门
categories: 
- Ruby
date: 2017-05-24
---
1. 方法调用的最外层括号可以省略
2. 函数最后一行默认有return
3. hash处于一个函数最后一个参数的时候大括号可以省略
	Apple.create :name => 'apple',:color =>'red'
	Apple.create({:name => 'aplle',:color =>'red'})
	Apple.create name:'apple',color:'red'
4. 调用block
	Apple.all.map { |apple| apple.name }
	Apple.all.map (&:name)

5. Module 
	- 不能别new
    - 不能被include
    - module 中的 self.xx 方法可以被直接调用(不建议)
    - module 中的普通方法,需要被某个class include 之后,由对应的class调用


['jim','li_lei','han_mei_mei'].each do |name|
    define_method "say_hi_to_#{name}" do
        puts "hi,#{name}"
    end
end

想知道 第一行中 |name| 这种写法是定义遍历前面数组的参数的意思么?我猜的

`:: 开头的是类方法 可以直接调用`
`# 开头的是实例方法 需要new`
