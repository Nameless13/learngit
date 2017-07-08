title: hive创建表语句详解
categories: 
- CDH
- Hive
date: 2017-06-23
---
创建表的语句：
Create [EXTERNAL] TABLE [IF NOT EXISTS] table_name 
[(col_name data_type [COMMENT col_comment], ...)] 
[COMMENT table_comment] 
[PARTITIONED BY (col_name data_type [COMMENT col_comment], ...)] 
[CLUSTERED BY (col_name, col_name, ...) [SORTED BY (col_name [ASC|DESC],...)]INTO num_buckets BUCKETS]
[ROW FORMAT row_format] 
[STORED AS file_format] 
[LOCATION hdfs_path]

CREATE TABLE 创建一个指定名字的表。如果相同名字的表已经存在，则抛出异常；用户可以用 IF NOT EXIST 选项来忽略这个异常。
EXTERNAL 关键字可以让用户创建一个外部表，在建表的同时指定一个指向实际数据的路径（LOCATION），Hive创建内部表时，会将数据移动到数据仓库指向的路径；若创建外部表，仅记录数据所在的路径，不对数据的位置做任何改变。在删除表的时候，内部表的元数据和数据会被一起删除，而外部表只删除元数据，不删除数据。
如果文件数据是纯文本，可以使用 STORED AS TEXTFILE。如果数据需要压缩，使用 STORED AS SEQUENCE 。
有分区的表可以在创建的时候使用 PARTITIONED BY 语句。一个表可以拥有一个或者多个分区，每一个分区单独存在一个目录下。而且，表和分区都可以对某个列进行 CLUSTERED BY 操作，将若干个列放入一个桶（bucket）中。也可以利用SORT BY 对数据进行排序。这样可以为特定应用提高性能。



创建普通的表：
create table test_table (

id int,

name string,

no int) 

row formatdelimited 

fieldsterminated by ',' 

stored astextfile;//指定了字段的分隔符，hive只支持单个字符的分隔符。hive默认的分隔符是\001



创建带有partition的表：
create table test_partition (

id int,

name string,

no int)

partitioned by(dt string) 

row formatdelimited 

fieldsterminated by ',' 

stored astextfile;


load data local inpath '/home/zhangxin/hive/test_hive.txt' overwrite intotabletest_partition partition (dt='2012-03-05');



创建带有Bucket的表：
create table test_bucket (

id int,

name string,

no int)

partitioned by(dt string) 

clustered by(id) into 10 buckets --将id这一列分到10个桶中。

row formatdelimited 

fieldsterminated by ',' 

stored astextfile;

关于分桶：对列进行分桶，本质上，在进行reduce的时候，会对列的值进行hash，然后将hash的值放到特定的桶中（有点像distribute by）。

注意在写入分桶数据的时候，需要指定：

sethive.enforce.bucketing=true;


创建external表：
create external table test_external (

id int,

name string,

no int)

row formatdelimited 

fieldsterminated by ',' 

location'/home/zhangxin/hive/test_hive.txt';


创建与已知表相同结构的表Like：

只复制表的结构，而不复制表的内容。
create table test_like_table like test_bucket;