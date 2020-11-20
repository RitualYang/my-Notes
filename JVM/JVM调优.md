# JVM调优

## full gc优化

* full gc 是对整个JVM堆跟方法区进行一次清洗的操作，会暂停当前所有线程的运行。
  
  * oom
  

可优化的地方：full gc的运行次数，暂停时的时长

```
-Xms / -Xmx — 堆的初始大小 / 堆的最大大小
-Xmn — 堆中年轻代的大小
-XX:-DisableExplicitGC — 让 System.gc()不产生任何作用
-XX:+PrintGCDetails — 打印 GC 的细节
-XX:+PrintGCDateStamps — 打印 GC 操作的时间戳
-XX:NewSize / XX:MaxNewSize — 设置新生代大小/新生代最大大小
-XX:NewRatio — 可以设置老生代和新生代的比例
-XX:PrintTenuringDistribution — 设置每次新生代 GC 后输出幸存者乐园中对象年龄的分布
-XX:InitialTenuringThreshold / -XX:MaxTenuringThreshold：设置老年代阀值的初始值和最大值
-XX:TargetSurvivorRatio：设置幸存区的目标使用率
```