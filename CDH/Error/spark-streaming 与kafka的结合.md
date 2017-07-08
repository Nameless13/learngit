title: spark-streaming 与kafka的结合
categories: 
- CDH
- Error
date: 2017-05-24
---
# spark-streaming 与kafka的结合

升级CDH到5.10后 spark-steaming 从kafka获取消息就报错

**原因:高版本的kafka从低版本的kafka server端连接不兼容**

因为在使用spark-streaming调用kafka的时候,会由cloudera来调用相应的组件,其中就有kafka的客户端,并且优先级较高,继而不会调用我们自己的kafka客户端,导致报错
后来原厂的人重新编译路径指向后解决