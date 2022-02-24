## 缓存淘汰策略

### 介绍

* 当 Redis 内存超出物理内存限制时，内存的数据会开始和磁盘产生频繁的交换 (swap)。交换会让 Redis 的性能急剧下降，对于访问量比较频繁的 Redis 来说，这样龟速的存取效率基本上等于不可用。

* 在生产环境中我们是不允许 Redis 出现交换行为的，为了限制最大使用内存，Redis 提供了配置参数 maxmemory 来限制内存超出期望大小。 

* 当实际内存超出 maxmemory 时，Redis 提供了几种可选策略 (maxmemory-policy) 来让用户自己决定该如何腾出新的空间以继续提供读写服务。
  
  ## 删除策略

* 定时删除(主动)
  
  * 定时随机的检查过期的key，如果过期则清理删除。(每秒检查次数在redis.conf中的hz配置)

* 惰性删除(被动)
  
  * 当客户端请求一个已经过期的key的时候，那么redis会检查这个key是否过期，如果过期了，则删除，然后返回一个nil。这种策略对cpu比较友好，不会有太多的损耗，但是内存占用会比较高。 

redis提供的缓存淘汰机制：`MEMORY MANAGEMENT`

```shell
noeviction # 不会继续服务写请求 (DEL 请求可以继续服务)，读请求可以继续进行。这样可以保证不会丢失数据，但是会让线上的业务不能持续进行。这是默认的淘汰策略。
volatile-lru # 尝试淘汰设置了过期时间的 key，最少使用的 key 优先被淘汰。没有设置过期时间的 key 不会被淘汰，这样可以保证需要持久化的数据不会突然丢失。
volatile-ttl # 跟上面一样，除了淘汰的策略不是 LRU，而是 key 的剩余寿命 ttl 的值，ttl 越小越优先被淘汰。
volatile-random # 跟上面一样，不过淘汰的 key 是过期 key 集合中随机的 key。
# volatile策略只会针对带过期时间的 key 进行淘汰
allkeys-lru #区别于 volatile-lru，这个策略要淘汰的 key 对象是全体的 key 集合，而不只是过期的 key 集合。这意味着没有设置过期时间的 key 也会被淘汰。
allkeys-random #跟上面一样，不过淘汰的策略是随机的 key。
allkeys #策略会对所有的 key 进行淘汰。
```

```shell
# 新八种
noeviction         #当内存使用超过配置的时候会返回错误，不会驱逐任何键

allkeys-lru        #加入键的时候，如果过限，首先通过LRU算法驱逐最久没有使用的键

volatile-lru    #加入键的时候如果过限，首先从设置了过期时间的键集合中驱逐最久没有使用的键

allkeys-random    #加入键的时候如果过限，从所有key随机删除

volatile-random    #加入键的时候如果过限，从过期键的集合中随机驱逐

volatile-ttl    #从配置了过期时间的键中驱逐马上就要过期的键

volatile-lfu    #从所有配置了过期时间的键中驱逐使用频率最少的键

allkeys-lfu        #从所有键中驱逐使用频率最少的键
```

### 使用

* 修改redis.conf的`maxmemory`，设置最大使用内存：
  
  `maxmemory  1024000`

* 修改redis.conf的`maxmemory-policy`，设置redis缓存淘汰机制：
  
  `maxmemory-policy  noeviction`

### 使用场景

* 如果你只是拿 Redis 做缓存，那应该使用 allkeys下的淘汰策略，客户端写缓存时不必携带过期时间。
* 如果你还想同时使用 Redis 的持久化功能，那就使用 volatile下的淘汰策略，这样可以保留没有设置过期时间的 key，它们是永久的 key 不会被 LRU 算法淘汰。