# redis服务

## 主从模式

主库写，从库读，减轻读压力。

* 从库命令：`SLAVEOF ip:port`

* `redis.conf`配置：
  
  ```shell
  # 主从复制配置
  replicaof 192.168.37.138 6379 # 从ip192.168.37.138:6379的redis实例复制数据
  replica‐read‐only yes
  # 持久化，日志，端口 配置
  port 6380
  pidfile /var/run/redis_6380.pid
  logfile "6380.log"
  dir /usr/local/redis‐5.0.3/data/6380
  ```

## 哨兵模式

* sentinel.conf配置：
  
  ```shell
  port 26379
  daemonize yes
  pidfile "/var/run/redis‐sentinel‐26379.pid"
  logfile "26379.log"
  dir "/usr/local/redis‐5.0.9/data"
  # 哨兵监听主节点
  # sentinel monitor <master‐name> <ip> <redis‐port> <quorum>
  # quorum是一个数字，指明当有多少个sentinel认为一个master失效时(值一般为：sentinel总数/2 +1)，master才算真正失效
  sentinel monitor mymaster 192.168.37.138 6379 2
  ```

* 启动：
  
  `redis-sentinel sentinel.conf`

## 集群模式

* `redis.conf`配置：
  
  ```shell
  daemonize yes
  port 8001 #分别对每个机器的端口号进行设置
  dir /usr/local/redis‐cluster/8001/  #指定数据文件存放位置，必须要指定不同的目录位置，不然会丢失数据
  cluster‐enabled yes #启动集群模式
  cluster‐config‐file nodes‐8001.conf #集群节点信息文件，这里800x最好和port对应上
  cluster‐node‐timeout 5000
  # bind 127.0.0.1 #去掉bind绑定访问ip信息
  protected‐mode no #关闭保护模式
  appendonly yes
  
  #如果要设置密码需要增加如下配置：
  requirepass rediscluster #设置redis访问密码
  masterauth rediscluster #设置集群节点间访问密码，跟上面一致
  ```

* `redis-cli`命令：
  
  ```shell
  /usr/local/redis‐5.0.9/src/redis‐cli 
  ‐a rediscluster 
  ‐‐cluster create 
  ‐‐cluster‐replicas 1 
  192.168.37.138:8001 192.168.37.138:8002 192.168.37.138:8003 192.168.37.138:8004 192.168.37.138:8005 192.168.37.138:8006
  ```