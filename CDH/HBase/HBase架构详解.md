title: HBase架构详解
categories: [CDH,HBase]
date: 2017-05-24
---
# HBase架构详解
## Hbase架构
### Hbase组件
#### client
- 整个Hbase集群的入口
- 使用Hbase RPC机制与HMaster和HRegionserver通信
- 与HMaster通信进行管理类的操作
- 与HRegionserver通信进行读写类操作
- 包含访问HBase的接口,并维护cache来加快对HBase的访问,与HRegionserver交互

#### 程序协调服务ZooKeeper
- 保证任何时候,集群中只有一个Master(HA)
- 存贮所有Region的寻址入口
- 实时监控Region server的上线和下线信息.并实时通知给Master
- 存储Hbase的schema和table元数据

#### Hbase主节点Master
- 管理用户对Table的增删改查操作
- 管理HRegionServer的负载均衡,调整Region分布
- 在Region Split后,负责新Region的分配
- 在HRegionServer停机后,负责失效HRegionServer上的Region迁移
- HHMaster失效仅会导致所有元数据无法被修改,表的数据读写还是可以正常进行

#### HRegionServer节点
- 维护Hregion并往HDFS中写数据
- 当表的大小超过设置值的时候,Split Hregion
- 在HRegionServer停机后,负责失效HRegionServer上的Region迁移


### Hbase架构
#### Hbase与ZooKeeper
- Hbase元数据存储在ZooKeeper中
- 默认情况下,HBase管理ZooKeeper实例,比如,启动或者停止ZooKeeper
- Zookeeper解决HBase单节点故障问题
- HMaster与HRegionserver启动时会向Zookeeper注册

#### 寻找RegionServer过程详解
- ZooKeeper (读取Zookeeper找到-ROOT-表的位置)
- -ROOT-(-ROOT-表包含.METAA.表所在的region列表,该表只会有一个Region;Zookeeper中记录了-ROOT-表的location)
- .META.(.META.表包含所有的用户空间region列表,以及RegionServer的服务器地址)
- 用户表
- Client第一次操作后,会将-ROOT-和.META.缓存到本地,不需要再访问Zookeeper




### Hbase容错性

- Master容错: Zookeeper 重新选择一个新的Master
    + 无Master过程中,数据读取仍照正常进行
    + 无Master过程中,region切分,负载均衡等无法进行
- RegionServer容错: 定时向Zookeeper汇报心跳,如果一段时间内出现心跳
    + Master将该RegionServer上的Region重新分配到其他RegionServer上
    + 失效服务器上"预写"日志由主服务器进行分割并派送给新的RegionServer
- Zookeeper容错
    + Zookeeper高可靠的服务,不存在单点故障

## Hbase数据存储
- HBase中的所有数据文件都存储在Hadoop HDFS文件系统上,格式主要有两种:
    + HFile: HBase中KeyValue数据的存储格式,HFile是Hadoop的二进制格式文件,实际上StoreFile就是对HFile做了轻量级包装,即StoreFile底层就是HFile
    + HLog File: HBase 中WAL(Write Ahead Log)的存储格式,物理上是Hadoop的Sequence File带项目符号的内容 


### HRegionServer
- HRegionServer管理一些列HRegion对象
- 每个HRegion对应Table中的一个Region,HRegion由多个HStore组成
- 每个HStore对应Table中一个Column Family的存储
- Column Family就是一个集中的额存储单元,故将具有相同IO特性的Column放在一个Column Family会更高效


### HStore (MemStore 和 StoreFile)
- Client写入 -> 存储MemStore,一直到MemStore满 -> Flush成一个StoreFile,直至增长到一定阈值 -> 触发Compact合并操作 -> 多个StoreFile合并成一个StoreFile,同时进行版本合并和数据删除 -> 当StoreFiles Compact后,逐步形成越来越大的StoreFile -> 单个StoreFile大小超过一定阈值后,触发Split操作,把当前Region Split成2个Region,被分割的Region会下线,新Split出2个子Region会被HMaster分配到相应的HRegionServer上,使得原先1个Region的压力得以分流到2个Region上
- HBase只是增加数据,所有的更新和删除操作,都是在Compact阶段做的,所以,用户写操作只需要进入到内存即可立即返回,从而保证I/O高性能

#### StoreFile文件结构
- StoreFile以HFile格式保存在HDFS上
- Data Block段:保存表中的额数据,这部分可以被压缩
- Meta Block段(可选的):保存用户自定义的kv对,可以被压缩
- File Info 段:Hfile的元信息,不压缩 ,用户也可以在这一部分添加自己的元信息
- Data Block Index 段:Data Block的索引.每条索引的key是被索引的block的第一条记录的key
- Meta Block Index段(可选的):Meta Block的索引
- Trailer:这一段是定长的,保存的是每一段的偏移量

#### 压缩
- HFile的Data Block,Meta Block通常采用压缩方式存储
    + 好处: 压缩之后可以大大减小网络IO和磁盘IO
    + 坏处: 需要花费CPU进行压缩和解压缩
- Hfile支持的压缩格式: Gzip,Lzo,Snappy...
 
### KeyValue 存储结构
- HFile里面的每个KeyValue对就是一个简单的byte数组
- KeyLength和ValueLength: 两个固定的长度,分别代表key和value的长度
- Key部分: RowLength是固定长度的数值,表示RowKey的长度,Row就是RowKey
- Column Family Length是固定长度的数值,表示Family的长度,接着就是Column Family,再接着就是Qualifier,然后是两个固定长度的数值,表示Time Stamp和Key Type(Put/Delete)
- Value部分没有这么复杂的结构,就是纯粹的二进制数据

### HLog文件结构
- HLog文件就是一个普通的Hadoop sequence File,Sequence File 的Key就是HLogKey对象,HLogkey中记录了写入数据的归属信息,除了table和region名字外,同时还包括sequence number和timestamp,timestamp是"写入时间",sequence number的起始值为0,或者是最近一次存入文件系统中sequence number.
- HLog Sequece File的Value是HBase的KeyValue对象,即对应HFile中的KeyValue

## Hbase内部表
### Hbase内部表
- -ROOT-表
    + 存储.meta.表信息,-ROOT-表中仅有一行数据
    + Zookeeper中存储了-ROOT-表的位置信息
- .META.表
    + 主要存储HRegin的列表和HRegionServer的服务器地址
- Namespace表
    + 存储命名空间


### hbck修复错误表
hbase hbck -fix
## Hbase管理命令
### Flush
把内存中的数据写入硬盘
### Compact 

### Region