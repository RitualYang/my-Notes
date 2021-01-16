## count调优
* 使用 count(*)
  * 当没有非主键索引时,会使用主键索引.
  * 如果存在非主键索引的话,会使用非主键索引
  * 如果存在多个非主键索引,会使用一个最小的非主键索引
* 原因
  * innodb非主键索引，叶子节点存储的是: 索引+主键
  * 主键索引，叶子节点存储的是：主键+表数据
  * 在一个page里面，非主键索引可以存储更多的条目。
    * 如果一张表数据1000000条，使用非主键索引只需扫描100个page,而主键索引扫描500个page


* 使用count(字段)
  * 只会准对该字段统计，使用这个字段上面的索引(如果有的话)，没有索引时,会进行全表扫描
  * 会排除掉该字段值为null的行
  
* 使用count(1)
  * count(1)与count(*)没有区别


### 调优
* 创建一个更小的非主键索引
* 把数据库引擎缓存MyISAM (不常用)
* 汇总表
  * 好处：结果比较准确
  * 缺点：增加维护成本
* sql_calc_found_rows
  ```
  select sql_calc_found_rows * from users limit 0,10;
  select found_rows() as users_count;
  ```
  * 缺点：mysql 8.0.17已经废除，后续版本会删除
* 缓存
  * 优点: 性能比较高；结果比较准确。有误差但是比较小(除非在缓存更新期间，新增或删除了大量数据)
  * 缺点：引入额外的组件，增加了架构的复杂度
* information_schema.tables
  ```
  select *
  from `information_schema`.TABLES
  where TABLE_SCHEMA = 'test'
  and TABLE_NAME = 'users'
  ```
  * 好处：不操作users表，不管users表有多少数据，都可以迅速返回结果
  * 缺点: 估算值,并不是准确值

* show table status
  ```
  show table status where Name = 'users'
  ```
  * 特点同上·information_schema.tables

* explain
  * 特点同上show table status