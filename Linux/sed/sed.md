# sed
## 流处理编辑器
1. 文本或管道输入
2. 读入一行到模式空间(临时缓冲区)
3. sed命令处理(处理后接着读下一行)
4. 输出到屏幕

## 文本处理
正则选定文本
sed进行处理
### 格式
- 命令行格式
    + `$sed [option] 'command' file(s)`
    + optians: -e ; -n
    + command: 行定位(正则) + sed命令(操作)
    + `$sed -n '/root/p'`
    + `$sed -e '10,20d' -e 's/false/true/g'`
- 脚本格式
    + `$sed -f scriptfile file(s)`

### 操作命令
- 基本操作命令
    + -p 打印相关的行
    + 行定位
        * 定位一行 : x; /patten/
        * 定位几行 : x,y; /patten/,x;
        * 定位间隔几行: first~step
    + -a 新增行 / -i 插入行
    + -c 替代行
    + -d 删除行
