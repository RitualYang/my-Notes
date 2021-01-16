## limit优化
* 使用覆盖索引
* 覆盖索引+join
* 覆盖索引+子查询
* 范围查询+limit语句
* 如果能够获取起始主键值&结束主键值
  ```
  select *
  from employees
  where emp_no between 2000 and 2010;
  ```
* 禁止传入过大的页码