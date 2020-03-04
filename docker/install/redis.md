# 安装redis

## 安装redis

* 搜索镜像：`docker search redis`

* 下拉镜像：`docker pull redis:version`

## 启动redis

### docker原生启动

* 基础版：

  ```shell
  docker run -p 6379:6379 --name redis -d redis:latest redis-server
  # -p 6379:6379 :将主机的6379端口映射到容器的6379端口
  # --name redis :设置容器名为redis
  # -d  : 后台启动（redis.conf中daemonize必须设置为no，否则会无法启动）
  # redis:lastest :挂载运行的镜像
  # redis-server :在容器中执行redis-server命令(在后面追加命令可修改启动配置，可自由组合)如下：
  				# redis-server --appendonly yes  启动aof持久化
  				# redis-server --requirepass "123456" 将密码设置为123456
  
  # 使用
  docker exec -it redis /bin/bash # 进入redis容器
  redis-cli   # 使用redis客户端
  ```

* 进阶版：

  * 准备工作：

    ```shell
    mkdir /usr/docker
    mkdir /usr/docker/redis
    mkdir /usr/docker/redis/data
    touch /usr/docker/redis/redis.conf # 配置文件看文章底部
    ```

  ```shell
  docker run -p 6379:6379 --name redis -v /usr/docker/redis/redis.conf:/etc/redis/redis.conf -v /usr/docker/redis/data:/data -d redis:latest redis-server /etc/redis/redis.conf
    
  # -v /usr/docker/redis/redis.conf:/etc/redis/redis.conf
    	# 将本地/usr/docker/redis/redis.conf文件挂载到容器中/etc/redis/redis.conf
  # -v /usr/docker/redis/data:/data
    	# 关联本地/docker/redis/data文件到容器中/data（redis数据存储位置，方便迭戈与持久化）
  # redis-server /etc/redis/redis.conf
    	# 在容器中执行redis-server命令，加载/etc/redis/redis.conf配置
  ```

### docker-compose启动

* 准备工作：

  ```shell
  vim /usr/docker/redis/docker-compose.yml
  
  version: "3"
  services:
    redis:
      image: redis
      container_name: redis
      ports:
        # 端口映射
        - 6379:6379
      volumes:
        # 目录映射
        - ./redis.conf:/etc/redis/redis.conf
        - ./data:/data
      command:
        # 执行的命令
        redis-server /etc/redis/redis.conf
  ```
  
  
  
  
  
#### redis.conf常用配置

```shell
# Redis 配置文件

################################## 网络 #####################################

# 如果您确定希望实例侦听所有接口，只需注释以下行即可。
bind 0.0.0.0

# 监听端口号，默认为 6379，如果你设为 0，redis 将不在 socket 上监听任何客户端连接。
port 6379

# 连接超时时间，解决长期占用不释放的问题。
timeout 0

################################# 基础 #####################################

# 默认Rdis不会作为守护进程运行。如果需要的话配置成'yes'
# 注意配置成守护进程后Redis会将进程号写入文件/var/run/redis.pid
# 是否默认使用后台启动
daemonize no

# 日志级别
loglevel notice

# 指定日志文件的位置
logfile ""

# 要想把日志记录到系统日志，就把它改成 yes，
# 也可以可选择性的更新其他的syslog 参数以达到你的要求
# syslog-enabled no

# 设置 syslog 的 identity.
# syslog-ident redis

# 设置 syslog 的 facility，必须是 USER 或者是 LOCAL0-LOCAL7 之间的值。
# syslog-facility local0

# 设置数据库的数量。默认数据库是DB 0，您可以使用select <dbid>在每个连接的
# 基础上选择一个不同的数据库，其中dbid是0和'databases'-1之间的一个数字。
# redis 数据库数量
databases 16

################################ RDB持久化  ################################
#
# 存 DB 到磁盘：
#
# 格式：save <间隔时间（秒）> <写入次数>
#
# 根据给定的时间间隔和写入次数将数据保存到磁盘
#
# 下面的例子的意思是：
# 900 秒内如果至少有 1 个 key 的值变化，则保存
# 300 秒内如果至少有 10 个 key 的值变化，则保存
# 60 秒内如果至少有 10000 个 key 的值变化，则保存
#　　
# 注意：你可以注释掉所有的 save 行来停用保存功能。
# 也可以直接一个空字符串来实现停用：
#   save ""

save 900 1
save 300 10
save 60 10000

# 默认情况下，如果 redis 最后一次的后台保存失败，redis 将停止接受写操作，
# 这样以一种强硬的方式让用户知道数据不能正确的持久化到磁盘，
# 否则就会没人注意到灾难的发生。
#
# 如果后台保存进程重新启动工作了，redis 也将自动的允许写操作。
#
# 然而你要是安装了靠谱的监控，你可能不希望 redis 这样做，那你就改成 no 好了。
stop-writes-on-bgsave-error yes

# 是否在 dump .rdb 数据库的时候使用 LZF 压缩字符串?
# 默认都设为 yes。
# 如果你希望保存子进程节省点 cpu ，你就设置它为 no，但是这个数据集可能就会比较大
rdbcompression yes

# 设置RDB持久化的文件名
dbfilename dump.rdb

# 设置RDB持久化存放的目录。
dir ./

################################## 安全 ###################################
# 设置认证密码
# requirepass 123456

################################### 客户端 ####################################
# 一旦达到最大限制，redis 将关闭所有的新连接
# 并发送一个‘max number of clients reached’的错误。
# maxclients 10000

############################## 内存管理 ################################

# 如果你设置了这个值，当缓存的数据容量达到这个值， redis 将根据你选择的
# eviction 策略来移除一些 keys。
# 如果 redis 不能根据策略移除 keys ，或者是策略被设置为 ‘noeviction’，
# redis 将开始响应错误给命令，如 set，lpush 等等，
# 并继续响应只读的命令，如 get
# 最大使用内存
# maxmemory <bytes>

# 最大内存策略，有5个选择：
# volatile-lru -> 使用 LRU 算法移除，具有过期设置的 key 。
# allkeys-lru -> 根据 LRU 算法移除所有的 key 。
# volatile-lfu -> Evict using approximated LFU among the keys with an expire set.
# allkeys-lfu -> Evict any key using approximated LFU.
# volatile-random -> 随机移除，具有过期设置的key。
# allkeys-random -> 随机移除 key。
# volatile-ttl -> Remove the key with the nearest expire time (minor TTL)
# noeviction -> 不让任何 key 过期，只是给写入操作返回一个错误。
#
# 默认设置:
# maxmemory-policy noeviction
############################## aof持久化 ###############################

# 是否启动aof持久化模式
appendonly yes

# 设置aof持久化的文件名
appendfilename "appendonly.aof"

# 持久化写入模式
# appendfsync always
appendfsync everysec
# appendfsync no

# 表示当前 aof文件大小超过上一次 aof 文件大小的百分之多少的时候会进行重写。
# 如果之前没有重写过，以启动时 aof 文件大小为准
auto-aof-rewrite-percentage 100
# 限制允许重写最小 aof 文件大小，也就是文件大小小于 64mb 的时候，不需要进行优化。
auto-aof-rewrite-min-size 64mb

# 加载持久化时，是否忽略出现问题的命令
aof-load-truncated yes
# 开启混合持久化模式
aof-use-rdb-preamble yes
```

