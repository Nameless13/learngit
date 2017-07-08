title: centos sublime
categories: 
- Linux
date: 2017-07-08
---
# 建立软件安装目录（我一般把软件安装在opt目录下）

`mkdir /opt`
`cd /opt`

## 下载软件

http://www.sublimetext.com/3
注意一定要下Ubuntu/tarball包。
也可以用命令下载

wget http://c758482.r82.cf2.rackcdn.com/sublime_text_3_build_3083_x64.tar.bz2

如果链接地址失效，请到官网获取最新下载地址。
## 解压软件包

tar jxvf sublime_text_3_build_3059_x64.tar.bz2

## 命令行下直接运行

`cd /opt/sublime_text_3`
`./sublime_text`

## 创建桌面快捷方式

复制文件

`cp /opt/sublime_text_3/sublime_text.desktop /usr/share/applications`

更改配置文件

 
`vim /usr/share/applications/sublime_text.desktop`

```
我的配置如下
[Desktop Entry]
Version=1.0
Type=Application
Name=Sublime Text
GenericName=Text Editor
Comment=Sophisticated text editor for code, markup and prose
Exec=/opt/sublime_text_3/sublime_text %F
Terminal=false
MimeType=text/plain;
Icon=/opt/sublime_text_3/Icon/48x48/sublime-text.png
Categories=TextEditor;Development;
StartupNotify=true
Actions=Window;Document;

[Desktop Action Window]
Name=New Window
Exec=/opt/sublime_text_3/sublime_text -n
OnlyShowIn=Unity;

[Desktop Action Document]
Name=New File
Exec=/opt/sublime_text/sublime_text_3 --command new_file
OnlyShowIn=Unity;
```

## 打开软件

应用程序 >编程 > Sublime Text”右键”将此启动器添加到桌面”