# redis：5种数据类型
* 针对key的命令
    ```shell
    keys       (keys pattern)             # 根据指定规则返回符合条件的key
    del        (del key1 key2)            # 删除指定的key
    exists     (exists key)               # 判断是否存在指定的key
    move       (move key db)              # 将指定的key移入到指定的数据库中
    rename     (rename key newkey)        # 对key进行重命名
    renamenx   (renamenx key newkey)      # 仅当newkey不存在时，将key改名为newkey
    type       (type key)                 # 返回key的类型
    expire     (expire key second)        # 给指定的key设置失效时间
    expireat   (expireat key timestamp)   # 以时间戳的形式设置key的失效时间。
    pexpireat  (prxpireat key timestamp)  # 以毫秒为单位设置key的失效时间
    persist    (persist key)              # 移除key的失效时间
    ttl        (ttl key)                  # 以秒为单位返回key的剩余时间（-2表示key不存在,返回-1表示永远不过时）
    pttl       (pttl key)                 # 以毫秒为单位返回key的失效时间
    randomkey  (randomkey)                # 随机返回一个key
    dump       (dump key)                 # 序列化给定key
    ```
## 字符串string
* 介绍

  >字符串类型是Redis中最为基础的数据存储类型，是一个由字节组成的序列，他在Redis中是二进制安全的，这便意味着该类型可以接受任何格式的数据，如JPEG图像数据货Json对象描述信息等，是标准的key-value，一般来存字符串，整数和浮点数。Value最多可以容纳的数据长度为512MB
* 应用场景
  >很常见的场景用于统计网站访问数量，当前在线人数等,incr命令(++操作)。redis对于KV的操作效率很高，可以直接用作计数器。例如，统计在线人数等等，另外string类型是二进制存储安全的，所以也可以使用它来存储图片，甚至是视频等。
* 底层实现
  * 简单动态字符串SDS
    * 属性
     >1. len buf中已经占有的长度(表示此字符串的实际长度)    
     >2. free buf中未使用的缓冲区长度     
     >3. buf[] 实际保存字符串数据的地方
* 特性
   >1. redis为字符分配空间的次数是小于等于字符串的长度N，而原C语言中的分配原则必为N。降低了分配次数提高了追加速度，代价就是多占用一些内存空间，且这些空间不会自动释放。    
   >2. 二进制安全的    
   >3. 高效的计算字符串长度(时间复杂度为O(1))
   >4. 高效的追加字符串操作
* 操作命令
    ```shell
    set        (set key value)                  # 添加key与对应的value
    get        (get key)                        # 根据key获取对应value
    setnx      (setnx key value)                #
    setrange   (setrange key startIndex value)  # 替换字符串
    mset       (mset key1 value1 key2 value2)   # 批量设置键值对(可覆盖)
    msetnx     (msetnx key1 value1 key2 value2) # 如果key已经存在会设置失败(不可覆盖)
    getset     (getset key newValue)            # 获取key的value然后设置新的value
    getrange   (getrange key startIndex endIndex)# 获取指定位置的数据
    mget       (mget key1 key2 key3)            # 批量获取
    inr        (incr key)                       # 自增1
    incrby     (incrby key num)                 # 指定自增的数量
    decr       (decr key)                       # 自减1
    decrby     (decrby key num)                 # 指定自减的数量
    append     (append key value)               # 给指定的字符串追加value的值
    strlen     (strlen key)                     # 获取指定的key对应的值的长度
    ```
## 列表list
* 介绍
   >Redis的列表允许用户从序列的两端推入或者弹出元素，列表由多个字符串值组成的有序可重复的序列，是链表结构，所以向列表两端添加元素的时间复杂度为0(1)，获取越接近两端的元素速度就越快。这意味着即使是一个有几千万个元素的列表，获取头部或尾部的10条记录也是极快的。List中可以包含的最大元素数量是4294967295。
* 应用场景
   >列表类型，可以用于实现消息队列，也可以使用它提供的range命令，做分页查询功能。1.最新消息排行榜。2.消息队列，以完成多程序之间的消息交换。可以用push操作将任务存在list中（生产者），然后线程在用pop操作将任务取出进行执行。（消费者）
* 底层实现
  * ziplist
    * 属性
     >1. 由表头和N个entry节点和压缩列表尾部标识符zlend组成的一个连续的内存块    
     >2. 插入和删除元素的时候，都需要对内存进行一次扩展或缩减    
     >3. 更新效率低下
  * linkedlist
    * 属性
     >1. 双向链表  
     >2. 查询的效率是O(n)    
     >3. 插入和删除效率很高
  * quicklist(3.2版本后)
    * 属性
     >1. 双向链表结构   
     >2. 插入删除效率很高，查询的效率是O(n)     
     >3. 访问两端的元素的时间复杂度是O(1)
     >4. 每个quicklist节点就是一个ziplist，具备压缩列表的特性
* 特性
   >1. 列表类型    
   >2. 有序性

* 操作命令
   ```shell
   lpush       (lpush key value1 value2)  # 从集合开头往list添加value
   rpush       (rpush key value)          # 从集合末尾往list添加value
   linsert     (linsert key before/after value newValue) # 再指定的value前后者后插入新value
   lset        (lset key index newValue)  # 设置指定下表的新value
   lrem        (lrem key count value)     # 删除count个与value相同的value，count>0从开始位置进行删除
                                          # count<0从末尾开始删除，count=0删除全部
   ltrim       (ltrim key startIndex endIndex) # 删除指定范围内意外的元素，保留指定范围内的元素
   lpop        (lpop key)                 # 从list头部开始删除
   rpop        (lpop key)                 # 从list尾部开始删除
   lindex      (lindex key index)         # 返回指定索引处的元素
   llen        (llen key)                 # 返回list的长度
   rpoplpush   (rpoplpush key1 key2)      # 从key1的list弹出最后一个value添加到key2的list中
   ```
## 散列hash
* 介绍
   >Redis中的散列可以看成具有String key和String value的map容器，可以将多个key-value存储到一个key中。每一个Hash可以存储4294967295个键值对。
* 应用场景
   >例如存储、读取、修改用户属性（name，age，pwd等）。一般可以用来存某个对象的基本属性信息，例如，用户信息，商品信息等，另外，由于hash的大小在小于配置的大小的时候使用的是ziplist结构，比较节约内存，所以针对大量的数据存储可以考虑使用hash来分段存储来达到压缩数据量，节约内存的目的，例如，对于大批量的商品对应的图片地址名称。比如：商品编码固定是10位，可以选取前7位做为hash的key,后三位作为field，图片地址作为value。这样每个hash表都不超过999个，只要把redis.conf中的hash-max-ziplist-entries改为1024，即可。
* 底层实现
  * ziplist
    * 属性
     >1. 由表头和N个entry节点和压缩列表尾部标识符zlend组成的一个连续的内存块    
     >2. 插入和删除元素的时候，都需要对内存进行一次扩展或缩减    
     >3. 更新效率低下 
  * hashtable
    * 属性
     >1. 时间复杂度为O(1)    
     >2. 消耗比较多的内存空间    
* 特性
   >1. 存储多个键值对    
* 操作命令
   ```shell
   hset              (hset key field value)  # 给指定的key添加key-value元素
   hmset             (hmset key field1 value1 field2 value2)# 同时设置多个键值对数据
   hget              (hget key field)        # 获取指定的key中filed字段
   hmget             (hmget key field1 field2)# 获取指定的key中指定字段的值
   hsetnx            (hsetnx key field value)# 如果key不存在进行插入，如果key和field都不存在不进行插入
   hexists           (hexists key field)     # 判断指定的key中是否存在field这个字段
   hlen              (hlen key)              # 获取指定的key中field的数量
   hdel              (hdel key field1 field2)# 删除指定的key中的指定字段与对应的value
   hgetall           (hgetall key)           # 获取key中所有的键值对，返回的是一个field一个value
   hkeys             (hkeys key)             # 获取指定的key中所有字段
   hvals             (hvals key)             # 获取指定的key中所有的value
   hincrby           (hincrby key filed count)# 给指定的key的field的字段添加或者减去count这个值
   hincrbyfloat      (hincrbyfloat key field value)# 给指定的字段添加浮点数的值
   ```
## 集合set
* 介绍
   >Redis的集合是无序不可重复的，和列表一样，在执行插入和删除和判断是否存在某元素时，效率是很高的。集合最大的优势在于可以进行交集并集差集操作。Set可包含的最大元素数量是4294967295。
* 应用场景
   >1.利用交集求共同好友。2.利用唯一性，可以统计访问网站的所有独立IP。3.好友推荐的时候根据tag求交集，大于某个threshold（临界值的）整数的有序列表可以直接使用set。可以用作某些去重功能，例如用户名不能重复等。
* 底层实现
  * intset
    * 属性
     >1. 存储整数的有序集合   
     >2. 查找的时间复杂度为O(logN)    
     >3. 升级操作时，时间复杂度就是O(N)
  * hashtable
    * 属性
     >1. 时间复杂度为O(1)    
     >2. 消耗比较多的内存空间 
* 特性
   >1. 不重复性    
* 操作命令
   ```shell
   sadd        (sadd key value1 value2)   # 添加元素
   scard       (scard key)                # 获取成员的数量
   sismember   (sismember key value)      # 判断是否存在value
   smembers    (smembers key)             # 获取所有的元素
   spop        (spop key)                 # 随机弹出一个元素
   srandmember (srandmember key [count])  # 随机获取一个或者多个元素
   srem        (srem key value1 value2)   # 删除一个或者多个元素，如果元素不存在则忽略
   smove       (smove source desition value)# 移动一个元素到指定的set中
   sdiff       (sdiff first-key key1 key2)# 返回给定集合之间的差集。不存在的集合key将视为空集
   sdiffstore  (sdiffstore destionset key1 key2)# 把获取到的差集保存到目标set中
   sinter      (sinter key1 key2)         # 获取交集
   sinterstore (sinterstore destionset key1 key2)# 把获取到的交集存储到目标set中
   sunion      (sunion key1 key2)         # 获取并集
   sunionstore (sunionstore destionset key1 key2)# 把获取到的并集存储到目标set中
   ```
## 有序集合sorted set
* 介绍
   >和set很像，都是字符串的集合，都不允许重复的成员出现在一个set中。他们之间差别在于有序集合中每一个成员都会有一个分数(score)与之关联，Redis正是通过分数来为集合中的成员进行从小到大的排序。尽管有序集合中的成员必须是卫衣的，但是分数(score)却可以重复。
* 应用场景
    >可以用于一个大型在线游戏的积分排行榜，每当玩家的分数发生变化时，可以执行zadd更新玩家分数(score)，此后在通过zrange获取几分top ten的用户信息
* 底层实现
  * ziplist
    * 属性
     >1. 由表头和N个entry节点和压缩列表尾部标识符zlend组成的一个连续的内存块    
     >2. 插入和删除元素的时候，都需要对内存进行一次扩展或缩减    
     >3. 更新效率低下
  * skiplist+dict
    * 属性
     >1. 跳跃表结构    
     >2. 访问时间复杂度为O(1)    
* 特性
   >1. 有序集合   
   >2. 查询速度快
* 操作命令
   ```shell
   zadd           (zadd key score1 value1 score2 value2) # 添加成员
   zcard          (zcard key)                      # 计算元素个数
   zincrby        (zincrby key number member)      # 给指定的member的分数添加或者减去number
   zcount         (zcount key min max)             # 获取分数在min和max之间的成员和数量；默认是闭区间
   zrange         (zrange key start stop [WITHSCORES])# 返回指定排名之间的成员(结果是分数由低到高)
   zrevrange      (zrevrange key start stop [WITHSCORES])# 返回指定排名之间的成员(结果是分数由高到低)
   zrangebyscore  (zrangebyscore key min max [withscores][limit offset count])# 根据分数的范围获取成员
                                                                              # 按照分数：从低到高
   zrevrangebyscore(zrevrangebyscore key max min [withscores][limit offset count])# 根据分数的范围获                                                                          
                                                                           # 取成员,按照分数：从低到高
   zrank          (zrank key member)               # 返回一个成员的排名(从低到高的顺序)
   zrevrank       (zrevrank key member)            # 返回一个成员的排名(从高到低的顺序)
   zscore         (zscore key member)              # 获取一个成员的分数
   zrem           (zrem key member1 member2)       # 删除指定的成员
   zremrangebyrank(zremrangebyrank key start stop) # 根据排名进行删除
   zremrangebyscore(zremrangebyscore key min max)  # 根据分数的范围进行删除
   ```