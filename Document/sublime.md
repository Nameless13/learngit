title: sublime
categories: 
- document
date: 2017-07-07
---
#Package Control

import urllib.request,os,hashlib; h = '2915d1851351e5ee549c20394736b442' + '8bc59f460fa1548d1514676163dafc88'; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); by = urllib.request.urlopen( 'http://packagecontrol.io/' + pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); print('Error validating download (got %s instead of %s), please try manual install' % (dh, h)) if dh != h else open(os.path.join( ipp, pf), 'wb' ).write(by)

---
##MarkDown
###MarkDown Editing：
支持Markdown语法高亮；支持Github Favored Markdown语法；自带3个主题。	
`GFW setting:`
{
    "extensions":
    [
        "md"
    ],

    "color_scheme": "Packages/MarkdownEditing/MarkdownEditor.tmTheme",

    "line_padding_top": 4,
    "line_padding_bottom": 4,

    "tab_size": 4,
    "translate_tabs_to_spaces": true,

    "draw_centered": false,
    "word_wrap": true,
    "wrap_width": 80,
    // "rulers": [80, 120]
}

---
###OmniMarkupPreviwer：
实时在浏览器中预，而MarkdownPreview是需要手动生成的和F5的。览如果双屏的话，应该具有不错的体验。快捷键如下：
Ctrl+Alt+O: Preview Markup in Browser.
Ctrl+Alt+X: Export Markup as HTML.
Ctrl+Alt+C: Copy Markup as HTML.



---
解决在Ubuntu14.04下Sublime Text 3无法输入中文的问题

cd 
vim sublime_imfix.c
sudo apt-get install gtk+-2.0
gcc -shared -o libsublime-imfix.so sublime_imfix.c  `pkg-config --libs --cflags gtk+-2.0` -fPIC
sudo mv libsublime-imfix.so /opt/sublime_text/

修改文件/usr/bin/subl的内容
sudo gedit /usr/bin/subl
将
#!/bin/sh
exec /opt/sublime_text/sublime_text "$@"
修改为
#!/bin/sh
LD_PRELOAD=/opt/sublime_text/libsublime-imfix.so exec /opt/sublime_text/sublime_text "$@"
此时，在命令中执行 subl 将可以使用搜狗for linux的中文输入