## order by 调优
* 可以使用索引避免排序
  * limit
    * mysql优化器发现全表扫描开销更低时，会直接用全表扫描
  * where

* 无法利用索引避免排序
  * 排序字段存在多个索引
  * 升降序不一致
  * 使用key_part1范围查询，使用key_part2排序

## 排序模式
* rowid排序(常规排序)
* 全字段排序(优化排序)
* 打包字段排序

## 优化
* 松散索引扫描(Loose Index Scan)
* 紧凑索引扫描(Tight Index Scan)
* 临时表(Temporary table)
* 性能依次递减