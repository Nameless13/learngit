- DDL 数据定义语言
- TPL 事务处理语言
- DCL 数据控制语言
- DML 数据操作语言

+ 增加数据库处理效率,减少应用响应时间
+ 减少数据库服务器负载,增加服务器稳定性
+ 减少服务器间通讯的网络流量

---
## join
- 内连接 inner
    + 内连接 inner join 基于连接谓词将两张表(a,b)的列组合在一起,产生新的结果表
- 全外连接 full outer
    + mysql 不支持full join 但是可以用union all 通过左右连接来代替
- 左外连接 left outer
    + 保留左表所有数据
- 右外连接 right outer
- 交叉连接 cross
    + 交叉连接(cross join),又称笛卡尔连接(cartesian join)或叉乘(product),如果A和B是两个集合,他们的交叉连接就记为:A x B

### 与join相关的SQL技巧
- 更新使用过滤条件中包括自身的表
    ```
    UPDATE user1 a join(
        SELECT b.`user_name`
        FROM user1 a INNER JOIN user2 b ON
        a.`user_name`=b.`user_name`
        ) b ON a.user_name=b.user_name
        SET a.over='齐天大圣';
    ```

- 使用join 优化子查询
    ```
    SELECT a.user_name,a.`over`,(SELECT over FROM user2 b)
    WHERE a.user_name=b.user_name) AS
    over2
    FROM user1 a;
    ```
    优化后
    ```
    SELECT a.user_name,a.over,b.over AS over2
    FROM user1 a
    LEFT JOIN user2 b ON
    a.user_name=b.user_name;
    ```


- 使用join优化子查询

    ```
    SELECT a,user_name,b.timestr,b.kills
    FROM user1 a
    JOIN user_kills b ON a.id = b.user_id
    JOIN user_kills c ON c.user_id = b.user_id
    GROUP BY a.user_name,b.timestr,b.kliis
    HAVING b.kills = MAX(c.kills);
    ```

- 实现分组选择
    普通查询的问题:
    1. 如果分类或者用户很多的情况下则需要多次执行同一查询
    2. 增加应用程序同数据库的交互次数
    3. 增加了数据库执行查询的次数,不符合批处理的原则
    4. 增加了网络流量

---

### 进行行列转换
#### 需要行行转列的场景
- 报表统计
    + 使用cross join
    + 使用case
- 汇总显示

#### 需要行列转行的场景
- 属性拆分
- 使用UNION方式

### 生成唯一序列号
- 需要使用唯一序列号的场景
- 数据库主键
- 业务序列号如发票号,车票号,订单号
- 生成序列号的方法
    + MySQL:AUTO_INCREMENT
    + SQLServer:IDENTITY/SEQUENCE
    + Oracle:SEQUENCE
    + PgSQL:SEQUENCE
- 优先选择系统提供的序列号生成方式

### 如何删除重复数据
利用group 不用 和having从句处理