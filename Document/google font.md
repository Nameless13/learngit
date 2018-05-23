title: google font
categories: [Document]
date: 2018-05-23 09:57:35
---
# google字体更改到本地调用
```
layout/_partials/head/external-fonts.swig

46      {% set font_families += '&subset=latin,latin-ext' %}
47      {% set font_host = font_config.host | default('//fonts.googleapis.com') %}
48      <link href="{{ font_host }}/css?family={{ font_families }}" rel="stylesheet" type="text/css">
```


更改wp-includes文件夹下script-loader.php中的代码，大概在602行将：
```
1
$open_sans_font_url = "//fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,600italic,300,400,600&subset=$subsets";
替换为：

1
$open_sans_font_url = "//fonts.useso.com/css?family=Open+Sans:300italic,400italic,600italic,300,400,600&subset=$subsets";
```


https://link.zhihu.com/?target=https%3A//github.com/AlphaTr/redirectggfonts

http://lug.ustc.edu.cn 


