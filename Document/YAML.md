title: YAML
categories: [Document]
date: 2016-09-07
---
# YAML

[demo实例](http://nodeca.github.io/js-yaml/   )

- 大小写敏感
- 使用缩进表示层级关系
- 缩进时不允许使用Tab键,只运行使用空格
- 缩进的空格数目不重要,只要相同层级的元素左侧对齐即可
- # 表示注释,从这个*字符*一直到行尾,都会被解析器忽略

### YAML支持的数据结构有三种
- 对象:键值对的集合又称为映射（mapping）/ 哈希（hashes） / 字典（dictionary）
- 数组:一组按次序排列的值，又称为序列（sequence） / 列表（list）
- 纯量（scalars）：单个的、不可再分的值

## 对象
对象的一组键值对，使用冒号结构表示
animal: pets --> JS { animal: 'pets' }

Yaml 也允许另一种写法，将所有键值对写成一个行内对象。
hash: { name: Steve, foo: bar }   --> JS { hash: { name: 'Steve', foo: 'bar' } }

## 数组
一组连词线开头的行，构成一个数组。
`

    - Cat
    - Dog
    - Goldfish
    `

--> JS
[ 'Cat', 'Dog', 'Goldfish' ]

数据结构的子成员是一个数组，则可以在该项下面缩进一个空格。
`

    -
     - Cat
     - Dog
     - Goldfish    
`    
-->JS
[ [ 'Cat', 'Dog', 'Goldfish' ] ]
数组也可以采用行内表示法。