title: hive impala  培训
categories: [CDH,Notes]
date: 2017-06-23
---
$ADIR is a shortcut that points to the /home/training/training_materials/
analyst directory

Click Select files to bring up a file browser. By default, the
/home/training/Desktop folder displays. Click the home directory button
(training) then navigate to the course data directory:
training_materials/analyst/data.


Note the /dualcore directory. Most of your work in this course will be in that
directory. Try creating a temporary subdirectory in /dualcore:


---
hive 默认路径warehouse

创建xx表后 会在warehouse下创建xx.db

让hive管理整个结构

partition建议每个分区的数据保证一定的量(不要有很多小数据)

beeline set方法打开partition 参数


orcfile 文件 优于rcfile 

impala 推荐使用parquet 文件format 
CDH 对parquet 支持比较好


---
partition 
冷数据 热数据 上线流文件兼容性

impala join 大表放在第一个 会


profile impala调优

