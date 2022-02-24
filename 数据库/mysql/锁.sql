# 查看当前连接
show processlist;
show full processlist;
SELECT * FROM INFORMATION_SCHEMA.PROCESSLIST;
# 查看当前未提交的事务（如果死锁等待超时,事务可能还没有关闭）
SELECT * FROM INFORMATION_SCHEMA.INNODB_TRX;

# 查看正在被访问的表
show OPEN TABLES where In_use > 0;
# 查看最近的死锁记录
SHOW ENGINE INNODB STATUS;
# 死锁日志
show variables like 'innodb_print_all_deadlocks';

# 若一直请求不到资源，默认50秒则出现锁等待超时。
show variables like 'innodb_lock_wait_timeout';
# 设置全局变量 锁等待超时为60秒（新的连接生效）
set session innodb_lock_wait_timeout=50;
set global innodb_lock_wait_timeout=60;
#上面测试中，当事务中的某个语句超时只回滚该语句，事务的完整性属于被破坏了。为了回滚这个事务，启用以下参数：
show variables like 'innodb_rollback_on_timeout';
show processlist;
SELECT trx_mysql_thread_id,trx_state,trx_started,trx_weight FROM INFORMATION_SCHEMA.INNODB_TRX;
# 表锁级别
# NEVER：加了读锁之后，不允许其他 session 并发插入。
# AUTO：加了读锁之后，如果表里没有删除过数据，其他 session 就可以并发插入。
# ALWAYS：加了读锁之后，允许其他 session 并发插入。
show global variables like '%concurrent_insert%';

show master logs;
