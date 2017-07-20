title: weixin
categories: [Document]
date: 2016-12-20
---
微信小程序中的每一个页面的【路径+页面名】都需要写在 app.json 的 pages 中，且 pages 中的第一个页面是小程序的首页。

通过全局函数 getApp() 可以获取全局的应用实例，如果需要全局的数据可以在 App() 中设置

```
对象
<template is="objectCombine" data="{{for: a, bar: b}}"></template>
Page({
  data: {
    a: 1,
    b: 2
  }
})
最终组合成的对象是 {for: 1, bar: 2}

也可以用扩展运算符 ... 来将一个对象展开

<template is="objectCombine" data="{{...obj1, ...obj2, e: 5}}"></template>
Page({
  data: {
    obj1: {
      a: 1,
      b: 2
    },
    obj2: {
      c: 3,
      d: 4
    }
  }
})
```