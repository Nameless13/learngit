title: reload_UDF
categories: [CDH,Test]
date: 2017-05-24
---
步骤就是 
先在beeline drop对应函数
然后本地(每个hiveserver 和hivemetastore机器上) 替换对应jar包 
然后 beeline 里面 打reload;
最后重新create