# redis：5种数据类型
* 针对key的命令
    ```shell
    keys
    del
    exists
    move
    rename
    renamenx
    type
    expire
    expireat
    pexpireat
    persist
    ttl
    pttl
    randomkey
    dump
    ```
## 字符串string
* 介绍

  >字符串类型是Redis中最为基础的数据存储类型，是一个由字节组成的序列，他在Redis中是二进制安全的，这便意味着该类型可以接受任何格式的数据，如JPEG图像数据货Json对象描述信息等，是标准的key-value，一般来存字符串，整数和浮点数。Value最多可以容纳的数据长度为512MB
* 应用场景
  
  >很常见的场景用于统计网站访问数量，当前在线人数等。incr命令(++操作)
* 操作命令
    ```shell
    set
    get
    setrange
    mset
    msetnx
    getset
    getrange
    mget
    inr
    incrby
    decr
    decrby
    append
    strlen
    ```
## 列表list
* 介绍
   >Redis的列表允许用户从序列的两端推入或者弹出元素，列表由多个字符串值组成的有序可重复的序列，是链表结构，所以向列表两端添加元素的时间复杂度为0(1)，获取越接近两端的元素速度就越快。这意味着即使是一个有几千万个元素的列表，获取头部或尾部的10条记录也是极快的。List中可以包含的最大元素数量是4294967295。
* 应用场景
   >应用场景：1.最新消息排行榜。2.消息队列，以完成多程序之间的消息交换。可以用push操作将任务存在list中（生产者），然后线程在用pop操作将任务取出进行执行。（消费者）
* 操作命令
   ```shell
   lpush
   linsert
   lset
   lrem
   ltrim
   lpop
   lindex
   llen
   rpush
   rpop
   rpoplpush
   ```
## 散列hash
* 介绍
   >Redis中的散列可以看成具有String key和String value的map容器，可以将多个key-value存储到一个key中。每一个Hash可以存储4294967295个键值对。
* 应用场景
   >例如存储、读取、修改用户属性（name，age，pwd等）
* 操作命令
   ```shell
   hset
   hget
   hsetnx
   hexists
   hlen
   hdel
   hincrby
   hgetall
   hkeys
   hmget
   hmset
   hvals
   hincrbyfloat
   ```
## 集合set
* 介绍
   >Redis的集合是无序不可重复的，和列表一样，在执行插入和删除和判断是否存在某元素时，效率是很高的。集合最大的优势在于可以进行交集并集差集操作。Set可包含的最大元素数量是4294967295。
* 应用场景
   >1.利用交集求共同好友。2.利用唯一性，可以统计访问网站的所有独立IP。3.好友推荐的时候根据tag求交集，大于某个threshold（临界值的）
* 操作命令
   ```shell
   sadd
   scard
   sismember
   smembers
   spop
   srandmember
   srem
   smove
   sdiff
   sdiffstore
   sinter
   sinterstore
   sunion
   sunionstore
   ```
## 有序集合sorted set
* 介绍
   >和set很像，都是字符串的集合，都不允许重复的成员出现在一个set中。他们之间差别在于有序集合中每一个成员都会有一个分数(score)与之关联，Redis正是通过分数来为集合中的成员进行从小到大的排序。尽管有序集合中的成员必须是卫衣的，但是分数(score)却可以重复。

* 应用场景
    >可以用于一个大型在线游戏的积分排行榜，每当玩家的分数发生变化时，可以执行zadd更新玩家分数(score)，此后在通过zrange获取几分top ten的用户信息
* 操作命令
   ```shell
   zadd
   zcard
   zincrby
   zcount
   zrange
   zrevrange
   zrangebyscore
   zrevrangebyscore
   zrank
   ```