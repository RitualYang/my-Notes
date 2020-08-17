# sql语句

* `desc` 查询列的类型

```sql
select 查询列表
from 表1
【连接类型：inner|left|right】 join 表2 on 连接条件
 【where 筛选条件】
 【group by 分组】
 【having 筛选条件】
 【order by 排序列表】
 limit 起始索引,数目;
```

```sql
INSERT INTO 表名 VALUES (属性,属性...),(属性,属性...)...;
```

```sql
-- 单表
UPDATE 表名 SET 字段=属性 WHERE 筛选条件
-- 多表
UPDATE 表名 
inner|left|right join 表名2 on 连接条件
SET 字段=属性 WHERE 筛选条件
```

```sql
-- 单表
DELETE from 表名 where 筛选条件
-- 多表
DELETE 表名 
inner|left|right join 表名2 on 连接条件
WHERE 筛选条件
-- other
truncate table 表名; -- 清空数据
```

## 函数

* `CONCAT(str1,str2,...)` : 拼接数据。
* `IFNULL(expr1,expr2)`     : 如果expr1字段数据为null，将数据替换为expr2返回。
* `LENGTH(str)`                      : 获取该字符数据长度。
* `LCASE(str),LOWER(str)` : 字符转换为小写。
* `UCASE(str),UPPER(str)` : 字符转换为大写。
* `SUBSTR`: 截取字符串
  * `(str,pos)`
  * `(str,pos,len)`
  * `(str FROM pos)`
  * `(str FROM pos FOR len)`
* `INSTR(str,substr)`           : 返回substr在str第一次出现的索引，没有返回0。
* `TRIM([remstr FROM] str)`: 去除str中的remstr字符，无【remstr from】时默认去除空格。
* `LPAD(str,len,padstr)`      : 用padstr字符左填充指定长度的str。长度小于str时会截取字符。
* `REPLACE(str,from_str,to_str)`: 将str字符串中全部的from_str字段替换为to_str字段。

### 数字函数

* `SELECT ROUND(X[,D])` :  获取x的四舍五入结果，保留D个小数位，无【，D】时默认无小数。
* `CEIL(X)`： 向上取整。
* `FLOOR(X)` ： 向下取整。
* `TRUNCATE(X,D)`： 截断取D个小数位。
* `MOD(N,M)`: 取余。

### 日期函数

* `NOW()` ： 返回当前系统日期+时间。（例：`2020-06-19 13:23:52`）
* `CURDATE()` ： 返回当前系统日期。（例：`2020-06-19`）
* `CURTIME()` ： 返回当前系统时间。（例：`13:25:21`）
* (`TIME()`),(`TIMENAME()`): 获取对应的数据，如月(mouth)日(day)年(year),后者取英文名结果。
* `STR_TO_DATE(str,format)` : 将字符串转换为对应的日期格式。（例：`STR_TO_DATE('6-19 2020','%c-%d %Y')`）
* `DATE_FORMAT(date,format)`: 将日期格式转换为字符串。（例：`DATE_FORMAT('2020-06-19','%Y年%c月%d日')`）
* `DATEDIFF(expr1,expr2)`:  求两个日期的差值。

### 流程控制函数

* `IF(expr1,expr2,expr3)`: 判断expr1的结果，true返回expr2，false返回expr3。

### 聚合函数

* `SUM([DISTINCT] expr)` : 求和。（【DISTINCT】 去除相同数据后进行计算）
* `AVG([DISTINCT] expr)`: 求平均值。同上。
* `MAX([DISTINCT] expr)`: 求最大值。同上。
* `MIN([DISTINCT] expr)`: 求最小值。同上。
* `COUNT(DISTINCT expr,[expr...])`: 求数量默认去除null值。同上。

### 连接查询

* `inner` : 内连接
* `left [outer]` ： 左外连接
* `right [outer]`： 右外连接
* `full [outer]` ：全外连接（oracle）
* `cross` ： 交叉连接

## 关键字

* `DISTINCT` ： 去重

## 条件查询

* 条件运输符： `<` ,`>` ,`=` ,`>=` ,`<=` ,`!=` ,`<>`, `<=>`

* 逻辑运算符:    `&&` ,`||` ,`!`,`AND`,`OR`,`NOT`

* 模糊查询

  * `like` : 格式`like '%a_'` , `%` 匹配任意个字符。`_`匹配固定长度字符。特殊使用`\_`,` \%`进行转义

  * `between and`

  * `in`

  * `is null`

### DDL语言

* 常用关键字
  * 创建： `create`
  * 修改： `alter`
  * 删除： `drop`

   * 库的管理

         * `create database [if not exists] 库名;` : 创建库，【if not exists】如果库不存在。
         * `alter database 库名 character set 字符集;` : 修改库的字符集。
         * `drop database [if exists] 库名;` : 删除库，【if exists】如果库存在。

* 表的管理

  * ```sql
    create table [if not exists] 表名(
    	列名 列的类型【(长度) 约束】 【COMMENT '属性解释'】,
    	列名 列的类型【(长度) 约束】,
    	列名 列的类型【(长度) 约束】,
    	...
    	列名 列的类型【(长度) 约束】
    );
    -- 复制表
create table 表名 like 被复制的表名;
    -- 复制表及数据
    create table 表名
    select * from 被复制的表名;
    ```
    
  * ```sql
    -- 修改列名
    alter table 表名 change column 旧列名 新列名 类型;
    -- 修改列的类型或约束
    alter table 表名 modify column 列名 新类型;
  -- 添加新列
    alter table 表名 add column 列名 类型;
    -- 删除列
    alter table 表名 drop column 列名;
    -- 修改表名
  alter table 旧表名 rename to 新表名;
    ```
    
  * ```
    drop table [if exists] 表名;
    ```
    
    
    
    
    




