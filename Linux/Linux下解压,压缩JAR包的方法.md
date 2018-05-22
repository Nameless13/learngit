# Linux下解压,压缩JAR包的方法
把当前目录下的所有文件打包成project.jar
jar -cvfM0 project.jar ./
-c   创建jar包
-v   显示过程信息
-f    
-M
-0   这个是阿拉伯数字，只打包不压缩的意思


解压project.jar

jar -xvf project.jar
解压到当前目录,注意,不会创建一个game文件夹,而是将所有jar包的内容全部解压到当前文件夹.


