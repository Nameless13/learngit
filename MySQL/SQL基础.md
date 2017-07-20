title: SQL基础
categories: [MySQL]
date: 2017-05-24
---
# SQL基础
- DDL (Data Definition Languages):数据定义语音,这些语句定义了不同的数据段,数据库,表,列,索引等数据库对象.常用的语句关键字主要包括create,drop,alter等;
- DML (Data Manipulation Languages): 数据操纵语句,用于添加,删除,更新和查询数据库记录,并检查数据完整性,常用的语句关键字主要包括 insert,delete,update,select等;
- DCL (Data Control Language): 数据控制语句,用于控制不同数据段直接的许可和访问级别的语句.这些语句定义了数据库,表,字段,用户的访问权限和安全级别.主要的语句关键字包括grant,revoke
## DDL
对数据库内部的对象进行创建.删除,修改等操作的语音.和DML最大的差别是DML只是对表内部数据操作,而不涉及表的定义,结构的修改,更不涉及其他对象,DDL语句更多地由数据库管理员(DBA)使用
### 创建数据库
`create database test1;`
### 删除数据库
`drop database test1;`
  drop操作语句的结果都显示'0 rows affected'
### 创建表
`create table emp(ename varchar(10),hiredate date,sal decimal(10,2),deptno int(2));`
#### 查看表 
`desc emp;`
####  查看创建表的SQL语句
`show create table emp \G;`
```
    MariaDB [test1]> show create table emp \G;
    *************************** 1. row ***************************
           Table: emp
    Create Table: CREATE TABLE `emp` (
      `ename` varchar(20) DEFAULT NULL,
      `hiredate` date DEFAULT NULL,
      `sal` decimal(10,2) DEFAULT NULL,
      `deptno` int(2) DEFAULT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=latin1
    1 row in set (0.00 sec)

    ERROR: No query specified
```
----

除了可以看到表定义以外,还可以看到表的engine(存储引擎)和charset(字符集)等信息."\G"选项的含义是使得记录能够按照字段竖向排列,以便更好地显示内容较长的记录.
### 删除表
`drop table emp;`
### 修改表
#### 1. 修改表类型:
`ALTER TABLE tablename MODIFY [COLUMN] column_definition [FIRST|AFTER col_name]`

`alter table emp modify ename varchar(20);`

#### 2. 增加表字段:
`ALTER TABLE tablename ADD [COLUMN] column_definition [FIRST|AFTER col_name]`

`alter table emp add [column] age int(3);`

#### 3. 删除表字段
`ALTER TABLE tablename DROP[COLUMN] column_name`

`alter table emp drop [column] age;`

#### 4. 字段改名
`ALTER TABLE tablename CHANGE [COLUMN] old_col_name column_definition  [FIRST|AFTER col_name]`

`alter table emp change age age1 int(4);`

change和modify都可以修改表的定义,不同的是change后面需要两次列名,不方便,但是change的优点是可以修改列名称,modify则不能.

#### 5. 修改字段排列顺序
  前面介绍的极端增加和修改语法(ADD/CHANGE/MODIFY)中,都有一个可选项first|after column name,这个选项可以用来修改字段在表中的位置,ADD增加的新字段默认是加载标的最后位置,而CHANGE/MODIFY 默认不会改变字段的位置.

将新增的字段birth date 加在ename之后:

`alter table emp add birth date after ename;`

修改字段age,将他放在最前面:

`alter table emp modify age int(3) first;`

#### 6. 更改表名
`ALTER TABLE tablename RENAME [TO] new_tablename`
将
`alter table emp rename emp1`

## DML
DML操作是指对数据库中表记录的操作,主要包括表记录的插入(insert),更新(update),删除(delete)和查询(select),是开发人员日常使用最为频繁的操作.
 
### 插入记录
`INSERT INTO tablename(field1,field2,...fieldn) VALUES(value1,value2,...,valuen);`

`insert into emp(ename,hiredate,sal,deptno) values('zzzx1','2000-01-01','2000',1);`
 
`insert into dept values(5,'dept5'),(6,'dept6');`

### 更新记录
`UPDATE tablename SET field1=value1,field2=value2,...,fieldn=valuen [WHERE CONDITION]`

将wmp表中ename 为'lisa'的薪水(sal)从3000改为4000:

`update emp set sal=4000 where ename='lisa';`

### 删除记录
`DELETE FROM tablename [WHERE CONDITION]`

在MySQL中可以一次删除多个表的数据,

`DELETE t1,t2,...,tn FROM t1,t2,...tn [WHERE CONDITION]`

同时删除表emp和dept中deptno为3的记录:

`delete a,b from emp a,dept b where a.deptno=b.deptno and a.deptno=3;`

### 查询记录
`SELECT * FROM tablename [WHERE CONDITION]`

#### 1 查询不重复的记录
`select distinct deptno from emp;`
#### 2 条件查询
`select * from emp where deptno=1;`

上面例子中,where后面的条件是一个字段的=比较,除了=之外,还可以使用<,>,>=,<=,!=等比较运算符;多个条件之间还可以使用*or,and*等逻辑运算符进行多条件联合查询.

    MariaDB [test1]> select * from emp where deptno=1 and sal<3000;
    +-------+------------+---------+--------+
    | ename | hiredate   | sal     | deptno |
    +-------+------------+---------+--------+
    | zzx   | 2000-01-01 | 2000.00 |      1 |
    +-------+------------+---------+--------+
    1 row in set (0.00 sec)

#### 排序和限制
取出按照某个字段进行排序后的记录结果集,用到了数据库的排序操作,用关键字*ORDER BY*来实现

`SELECT * FROM tablename [WHERE CONDITION] [ORDER BY field1 [DESC|ASC],field2 [DESC|ASC],...,fieldn[DESC|ASC]]`

其中DESC和ASC是排序顺序关键字,DESV表示按照字段进行降序排列,ASC则表示升序序列，如果不写此关键字默认是升序排列．ORDER BY 后面可以跟多个不同的排序字段，并且每个排序字段可以有不同的排序顺序．

例如，把emp表中的记录按照工资高低进行显示:

    MariaDB [test1]> select * from emp order by sal;
    +--------+------------+---------+--------+
    | ename  | hiredate   | sal     | deptno |
    +--------+------------+---------+--------+
    | zzx    | 2000-01-01 | 2000.00 |      1 |
    | dony   | 2005-02-05 | 2000.00 |      4 |
    | lisa   | 2003-02-01 | 4000.00 |      2 |
    | bjguan | 2004-04-02 | 5000.00 |      1 |
    +--------+------------+---------+--------+
如果排序字段的值一样,则值相同的字段按照第二个排序字段进行排序,依次类推.如果只有一个排序字段,则这些字段相同的记录将会无序排列
    
    MariaDB [test1]> select * from emp order by deptno;
    +--------+------------+---------+--------+
    | ename  | hiredate   | sal     | deptno |
    +--------+------------+---------+--------+
    | zzx    | 2000-01-01 | 2000.00 |      1 |
    | bjguan | 2004-04-02 | 5000.00 |      1 |
    | lisa   | 2003-02-01 | 4000.00 |      2 |
    | dony   | 2005-02-05 | 2000.00 |      4 |
    +--------+------------+---------+--------+
对于deptno相同的前两条记录,如果要按照工资由高到低排序,可以使用以下命令:
    
    MariaDB [test1]> select * from emp order by deptno,sal desc;
    +--------+------------+---------+--------+
    | ename  | hiredate   | sal     | deptno |
    +--------+------------+---------+--------+
    | bjguan | 2004-04-02 | 5000.00 |      1 |
    | zzx    | 2000-01-01 | 2000.00 |      1 |
    | lisa   | 2003-02-01 | 4000.00 |      2 |
    | dony   | 2005-02-05 | 2000.00 |      4 |
    +--------+------------+---------+--------+
对于排序后的记录,如果希望只显示一部分,而不是全部,这时,就可以使用LIMIT关键字来实现

`SELECT ...[LIMIT offset_start,roe_count]`

其中*offset_start*表示记录的起始偏移量,*row_count*表示显示的行数.在默认情况下,起始偏移量为0,只需要写记录行数就可以,这时实际显示的是前n条记录.例如显示emp表中按照sal排序后的前3条记录:

    MariaDB [test1]> select * from emp order by sal limit 3;
    +-------+------------+---------+--------+
    | ename | hiredate   | sal     | deptno |
    +-------+------------+---------+--------+
    | zzx   | 2000-01-01 | 2000.00 |      1 |
    | dony  | 2005-02-05 | 2000.00 |      4 |
    | lisa  | 2003-02-01 | 4000.00 |      2 |
    +-------+------------+---------+--------+
如果要显示emp表中按照sal排序后从第二条记录开始的3条记录

    MariaDB [test1]> select * from emp order by sal limit 1,3;
    +--------+------------+---------+--------+
    | ename  | hiredate   | sal     | deptno |
    +--------+------------+---------+--------+
    | dony   | 2005-02-05 | 2000.00 |      4 |
    | lisa   | 2003-02-01 | 4000.00 |      2 |
    | bjguan | 2004-04-02 | 5000.00 |      1 |
    +--------+------------+---------+--------+
#### 聚合
`SELECT [field1,field2,...,fieldn] fun_name FROM tablename [WHERE where_contition] [GROUP BY field1,field2,...,fieldn [WITH ROLLUP]][HAVING where_contition]`

- fun_name 表示要做的聚合操作,也就是聚合函数,常用的有sum(求和),count(*)(记录数),max(最大值),min(最小值).
- GROUP BY 关键字表示要进行分类聚合的字段,比如要按照部门分类统计员工数量,部门就应该写在group by后面.
- WITH ROLLUP [可选语法] 表明是否分类聚合后的结果进行在汇总.
- HAVING 关键字表示对分类后的结果再进行条件的过滤.

having 和 where 的区别在于,having是对聚合后的结果进行条件的过滤,而where实在聚合前就对记录进行过滤,如果逻辑允许,我们尽可能用where先过滤记录,这样因为结果集减小,将对聚合的效率大大提高,最后在根据逻辑看是否用having进行再过滤.

在emp表中统计公司总人数:

    MariaDB [test1]> select count(1) from emp;
    +----------+
    | count(1) |
    +----------+
    |        4 |
    +----------+
在此基础上要统计各个部门人数:

    MariaDB [test1]> select deptno,count(1) from emp group by deptno;
    +--------+----------+
    | deptno | count(1) |
    +--------+----------+
    |      1 |        2 |
    |      2 |        1 |
    |      4 |        1 |
    +--------+----------+
既要统计各部门人数,又要统计总人数:
    
    MariaDB [test1]> select deptno,count(1) from emp group by deptno with rollup;
    +--------+----------+
    | deptno | count(1) |
    +--------+----------+
    |      1 |        2 |
    |      2 |        1 |
    |      4 |        1 |
    |   NULL |        4 |
    +--------+----------+

统计人数大于1的部门:

    MariaDB [test1]> select deptno,count(1) from  emp group by deptno having count(1)>1;
    +--------+----------+
    | deptno | count(1) |
    +--------+----------+
    |      1 |        2 |
    +--------+----------+
统计公司所有员工的薪水总额,最高和最低薪水:

    MariaDB [test1]> select sum(sal),max(sal),min(sal) from emp;
    +----------+----------+----------+
    | sum(sal) | max(sal) | min(sal) |
    +----------+----------+----------+
    | 13000.00 |  5000.00 |  2000.00 |
    +----------+----------+----------+
### 表连接
当需要同时显示多个表中的字段时,就可以用表连接来实现这样的功能.从大类上分,表连接分为内连接和外连接,他们之间的最主要区别是,内连接仅选出两张表中互相匹配的记录,而外连接胡选出其他不匹配的记录.我们最常用的是内连接.

查询出所有雇员的名字和所在部门名称,因为雇员名称和部门分别存放在表emp和dept中,因此,需要使用表连接来查询:

    MariaDB [test1]> select ename,deptname from emp,dept where emp.deptno=dept.deptno;
    +--------+----------+
    | ename  | deptname |
    +--------+----------+
    | zzx    | tech     |
    | lisa   | sale     |
    | bjguan | tech     |
    | dony   | hr       |
    +--------+----------+

外连接又分为**左连接**和**右连接**

- 左连接:包含所有的左边表中的记录甚至是右边表中没有和它匹配的记录;
- 右连接:包含所有的右边表中的记录甚至是左边表中没有和它匹配的记录;
  查询emp中所有用户名和所在部门名称:

        MariaDB [test1]> select ename,deptname from emp left join dept on emp.deptno=dept.deptno;
        +--------+----------+
        | ename  | deptname |
        +--------+----------+
        | zzx    | tech     |
        | bjguan | tech     |
        | lisa   | sale     |
        | dzshen | hr       |
        | dony   | NULL     |
        +--------+----------+

        MariaDB [test1]> select ename,deptname from dept right join emp on dept.deptno=emp.deptno;
        +--------+----------+
        | ename  | deptname |
        +--------+----------+
        | zzx    | tech     |
        | bjguan | tech     |
        | lisa   | sale     |
        | dzshen | hr       |
        | dony   | NULL     |
        +--------+----------+
比较这个查询和上例中的查询,都是查询用户名和部门名,两者的区别在于本例中列出来所有的用户名,即使有的用户名(dony)并不存在合法的部门名称;而上例中仅仅列出了存在合法部门的用户名和部门名称.
#### 子查询
某些情况下,当进行查询的时候,需要的条件是另外一个select语句的结果,这个时候就要用到子查询.用于子查询的关键字主要包括in,not in,=,!=,exitst,not exists等.

        MariaDB [test1]> select * from emp where deptno in(select deptno from dept);
        +--------+------------+---------+--------+
        | ename  | hiredate   | sal     | deptno |
        +--------+------------+---------+--------+
        | zzx    | 2000-01-01 | 2000.00 |      1 |
        | lisa   | 2003-02-01 | 4000.00 |      2 |
        | bjguan | 2004-04-02 | 5000.00 |      1 |
        | dzshen | 2005-04-01 | 4000.00 |      3 |
        +--------+------------+---------+--------+
如果子查询记录数唯一,还可以用=代替in:
        
        MariaDB [test1]> select * from emp where deptno = (select deptno from dept limit 1);
        +--------+------------+---------+--------+
        | ename  | hiredate   | sal     | deptno |
        +--------+------------+---------+--------+
        | zzx    | 2000-01-01 | 2000.00 |      1 |
        | bjguan | 2004-04-02 | 5000.00 |      1 |
        +--------+------------+---------+--------+
某些情况下子查询可以转化(等效)为表连接,

        MariaDB [test1]> select * from emp where deptno in(select deptno from dept);
        +--------+------------+---------+--------+
        | ename  | hiredate   | sal     | deptno |
        +--------+------------+---------+--------+
        | zzx    | 2000-01-01 | 2000.00 |      1 |
        | lisa   | 2003-02-01 | 4000.00 |      2 |
        | bjguan | 2004-04-02 | 5000.00 |      1 |
        | dzshen | 2005-04-01 | 4000.00 |      3 |
        +--------+------------+---------+--------+
转化为表连接后:

        MariaDB [test1]> select emp.* from emp,dept where emp.deptno=dept.deptno;
        +--------+------------+---------+--------+
        | ename  | hiredate   | sal     | deptno |
        +--------+------------+---------+--------+
        | zzx    | 2000-01-01 | 2000.00 |      1 |
        | lisa   | 2003-02-01 | 4000.00 |      2 |
        | bjguan | 2004-04-02 | 5000.00 |      1 |
        | dzshen | 2005-04-01 | 4000.00 |      3 |
        +--------+------------+---------+--------+
子查询和表连接之间的转换主要应用在两个方面
- MySQL 4.1 以前的版本不支持子查询,需要用表连接来实现子查询的功能
- 表连接在很多情况下用于优化子查询

#### 记录联合
将两个表的数据按照一定的查询条件查询出来后,将结果合并到一起显示出来,这个时候就需要union和union all 关键字来实现这样的功能

`SELECT * FROM t1  UNION|UNION ALL  SELECT * FROM t2 ...UNION|UNION ALL SELECT * FROM tn;`

    MariaDB [test1]> select deptno from emp
        -> union all
        -> select deptno from dept;
    +--------+
    | deptno |
    +--------+
    |      1 |
    |      2 |
    |      1 |
    |      4 |
    |      3 |
    |      1 |
    |      2 |
    |      3 |
    |      5 |
    +--------+
将结果去掉重复记录后显示如下:

    MariaDB [test1]> select deptno from emp union  select deptno from dept;
    +--------+
    | deptno |
    +--------+
    |      1 |
    |      2 |
    |      4 |
    |      3 |
    |      5 |
    +--------+

## DCL
DCL主要是DBA用来管理系统中的对象权限时使用

创建一个数据库用户z1,具有对sakila数据库中所有表的SELECT/INSERT权限:
    
    MariaDB [test1]> grant select,insert on sakila.* to 'z1'@'localhost' identified by '123';
    Query OK, 0 rows affected (0.00 sec)

    MariaDB [test1]> exit
    Bye
    [root@CentOS3 bin]# mysql -uz1 -p

收回z1,INSERT,只能对数据进行SELECT操作:

    MariaDB [(none)]> revoke insert on sakila.* from 'z1'@'localhost';
    Query OK, 0 rows affected (0.00 sec)


