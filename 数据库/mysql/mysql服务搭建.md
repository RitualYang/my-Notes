## 主从复制

主机修改配置文件：`vim /etc/my.cnf`

```bash
# 主服务器唯一ID
server.id=1
# 启动二进制日志
log-bin=mysql-bin
#设置不要复制的数据库 可设置多个
binlog-ignore-db=mysql
binlog-ignore-db=information_schema
#设置需要复制的数据库
binlog-do-db=需要复制的主数据库名字
#设置logbin格式STATEMENT,ROW,MIXED
binlog_format=STATEMENT
```

binlog日志格式：
STATEMENT： 复制所有写操作语句到binlog文件中（更新数据不一致）。
ROW ： 记录每一行的改变（全表刷新时 效率太低）。
MIXED ：如果有函数自动选择ROW模式，否则使用STATEMENT模式。系统变量无法识别。

从机配置文件`vim /etc/my.cnf`

```bash
#从服务器唯一ID
server-id=2
#启用中继日志
relay-log=mysql-relay
```

* 重启服务

* 配置防火墙

* 再主机上建立账户并授权slave
  
  ```bash
  #在主机 MySQL 里执行授权命令
  GRANT REPLICATION SLAVE ON *.* TO 'slave'@'%' IDENTIFIED BY '123456'
  ```

* 查询master的状态
  
  ```bash
  # 查询master的状态,执行完此步骤后不要再操作主服务器MySQL防止主服务器状态值变化
  show master status;
  #记录下 File 和 Position 的值# 
  ```

* 在从机上配置需要复制的主机
  
  ```bash
  #复制主机的命令
  CHANGE MASTER TO MASTER_HOST=' 主机的 IP 地址'
  MASTER_USER='slave'
  MASTER_PASSWORD='123456'
  MASTER_LOG_FILE='mysql-bin.具体数字',MASTER_LOG_POS=具体值;
  
  #启动从服务器复制功能
  start slave;
  #查看从服务器状态
  show slave status\G;
  ```

* 上步不成功时 先执行此操作
  
  ```bash
  # 如何重新配置主从
  stop slave;
  reset master;  
  ```