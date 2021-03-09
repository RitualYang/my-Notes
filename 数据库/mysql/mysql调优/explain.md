





### using fileSort(重点优化)

俗称“文件排序”，在数据量大的时候几乎是“九死一生”，在`order by`或者在`group by`排序的过程中，`order by`的字段不是索引字段，或者select查询字段存在不是索引字段，或者select查询字段都是索引字段，但是`order by`字段和select索引字段的顺序不一致，都会导致fileSort

### using temporary（重点优化）

使用临时表保存中间结果，常见于`order by`和`group by`中。

### filesort出现的情况

* order by字段不是索引字段
* order by是索引字段，但是select 中没有使用覆盖索引，如`select * from staffs order by age asc;`
* order by中同时存在ASC升序排序和DESC降序排序，如：`select a,b from staffs order by a desc,b asc; `
* order by 多个字段排序时，不是按照索引顺序进行order by，既不是按照最左前缀原则，如：`select a,b from staffs order by b asc,a asc;`