## join 算法
### Nested-Loop Join(NLJ)重点
### Block Nested-Loop Join(BNLJ)重点
### Batched Key Access Join(BKA)了解
### HASH JOIN 了解

## join 调优
* 用小表驱动大表
* 如果有where条件,应当要能够使用索引,并尽可能减少外层循环的数据量
* join的字段尽量创建索引
* 尽量减少扫描的行数(explain-rows)
* 参与join的表不要太多
* 如果被驱动表的join字段用不了索引,且内存较为充足,可以考虑把 `join buffer`设置得大一些