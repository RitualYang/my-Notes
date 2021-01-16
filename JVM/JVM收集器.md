# JVM收集器

## 新生代收集器

### Serial收集器

* 最基本的、发展历史最悠久的收集器
* 复制算法
* 特点：
  * 单线程
  * 简单、高效
  * 收集过程全程Stop The World
* 使用场景
  * 客户端程序，应用以`-client`模式运行时，默认使用的就说`Serial`
  * 单核机器

### ParNew收集器

* Serial收集器的多线程版本，除使用了多线程以外，其他和Serial收集器一样，包括：JVM参数、Stop The World的表现、垃圾收集算法都是一样的
* 特点：
  * 多线程
  * 可以使用`-XX:ParallelGCThreads`设置垃圾收集的线程数
* 使用场景
  * 主要用来和CMS收集器配合使用

### Parallel Scavenge收集器

* 也叫吞吐量优先收集器
* 采用的也是复制算法
* 也是并行的多线程收集器，和ParNew类似
* 特点：
  * 可以达到一个可控制的吞吐量
    * `-XX:MaxGCPauseMillis` : 控制最大的垃圾收集停顿时间（尽力）
    * `-XX:GCTimeRatio` : 设置吞吐量的大小，取值0-100，系统花费不超过1/（1 + n）的时间用于垃圾收集
  * 自适应GC策略
    * 可用`-XX:UseAdptiveSizePolicy`打开
    * 打开自适应策略后，无需手动设置新生代的大小(`-Xmn`)、`Eden`与`Survivor`区的比例（`-XX:SurvivorRatio`）等参数
    * 虚拟机会自动根据系统的运行状况收集性能监控信息，动态地调整这些参数，从而达到最优的停顿时间以及最高的吞吐量
* 使用场景
  * 注重吞吐量的场景



## 老年代收集器

### Serial Old 收集器

* Serial收集器的老年代版本
* 标记-整理算法
* 使用场景
  * 可以和Serial/ParNew/Parallel Scavenge 这三个新生代的垃圾收集器配合使用
  * CMS收集器出现故障的时候，会用Servial Old作为后备

### Parallel Old收集器

* Parallel Scavenge收集器的老年代版本
* 标记-整理算法
* 特点：
  * 只能和Parallel Scavenge配合使用
* 使用场景
  * 关注吞吐量的场景

### CMS收集器

* CMS： Concurrent Mark Sweep （并发标记清除）
* 并发收集器
* 标记-清除算法
* 流程
  * :zap:初始标记（initial mark）
    * 标记GC Roots能直接关联到的对象
    * Stop The World
  * :zap:并发标记（concurrent mark）
    * 找出所有GC Roots能关联到的对象
    * 并发执行，无Stop The World
  * 并发预清理（concurrent-preclean）
    * 重新标记那些在并发标记阶段，引用被更新的对象，从而减少后面重新标记阶段的工作量
    * 并发执行，无Stop The World
    * 可使用`XX:-CMSPrecleaningEnabled`关闭并发预清理阶段，默认打开
  * 并发可中止的预清理阶段（concurrent-abortable-preclean）
    * 允许我们能够控制预清理阶段的结束时机。比如扫描多长时间（CMSMaxAbortablePrecleanTime，默认5秒）或者Eden区使用占比达到一定阈值（CMSScheduleRermarkEdenPenetration，默认50%）就结束本阶段
    * 和并发预清理做的事情一样
    * 并发执行，无Stop The World
    * 当Eden的使用量大于CMSScheduleRermarkEdenSizeThreashold的阈值（默认2M）时，才会执行该阶段
  *  :zap:  重新标记（remark）
    * 修正并发标记期间，因为用户程序继续运行，导致标记发生变动的那些对象的标记
    * 一般来说，重新标记花费的时间会比初始标记阶段长一些，但是比并发标记的时间短
    * 存在Stop The World
  * :zap:并发清除（concurrent sweep）
    * 基于标记结果，清除掉要清除前面标记出来的垃圾
    * 并发执行，无Stop The World
  * :zap:并发重置（concurrent reset）
    * 清理本次CMS GC的上下文信息，为下一次GC做准备
* 特点
  * Stop The World的时间比较短
  * 大多数过程并发执行
  * CPU资源比较敏感
    * 并发阶段可能导致应用吞吐量的降低
  * 无法处理浮动垃圾
  * 不能等到老年代几乎满了才开始收集
    * 预留的内存不够 - > Concurrent Mode Failure - > Serial Old 作为后备
    * 可使用`CMSInitiatingOccupancyFraction`设置老年代占比达到多少就触发垃圾收集，默认68%
  * 内存碎片
    * 标记-清除导致碎片的产生
    * `UseCMSCompactAtFullCollection`:在完成Full GC后是否要进行内存碎片整理，默认开启
    * `CMSFullGCsBeforeCompaction`:在进行几次Full GC后进行一次内存碎片整理，默认0
* 使用场景
  * 希望系统停顿时间短，相应速度快的场景，比如各种服务器应用程序

## 主流收集器

### G1收集器

* Gardge First
* 面前服务器端应用的垃圾收集器
* 通过参数`-XX:G1HeapRegionSize`指定Region的大小
  * 取值范围为1MB~32MB，应为2的N次幂
* 设计思想
  * 内存分块（Region）
  * 跟踪每个Region里面的垃圾堆积的价值大小
  * 构建一个优先列表，根据允许的收集时间，优先回收价值高的Region

#### G1收集器-垃圾收集机制

* Young GC
  * 所有Eden Region都满了的时候，就会触发Young GC
  * eden里面的对象就会转换到Survivor Region里面去
  * 原先Survivor Region中的对象转移到新的Survivor Region中，或者晋升到Old Region
  * 空闲的Region会被放入空闲列表中，等待下次被使用
* Mixed GC
  * 老年代大小占整个堆的百分比达到一定阈值（可用`-XX:InitiatingHeapOccupancyPercent`指定，默认45%）就触发
  * Mixed GC会回收所有Young Region，同时回收部分Old Region
  * 复制算法
  * 执行过程
    * 初始标记（Initial Marking）
      * 标记GC Roots能直接关联到的对象，和CMS类似
      * 存在Stop The World
    * 并发标记（Concurrent Marking）
      * 同CMS的并发标记
      * 并发执行，没有Stop The World
    * 最终标记（Final Marking）
      * 修正在并发标记期间引起的变动
      * 存在Stop The World
    * 筛选回收（Live Data Counting and Evacuation）
      * 对各个Region的回收价值和成本进行排序
      * 根据用户所期望的停顿时间（MaxGCPauseMillis）来指定回收计划，并选择一些Region回收
      * 回收过程
        * 选择一系列Region构成一个回收集
        * 把决定回收的Region中的存活对象复制到空的Region中
        * 删除掉需回收的Region - > 无内存碎片
      * 存在Stop The World
* Full GC
  * 复制对象内存不够，或者无法分配足够内存（比如巨型对象没有足够的连续分区分配）时，会触发Full GC
  * Full GC模式下，使用 Serial Old模式
  * 优化原则：尽量减少Full GC的发生
    * 增加预留内存（增大`-XX:G1ReservePercent`，默认为堆的10%）
    * 更早地回收垃圾（减少`-XX:InitiatingHeapOccupancyPercent`，老年代达到该值就会触发Mixed GC，默认是45%）
    * 增加并发阶段使用的线程数（增大`-XX:ConcGCThreads`）
  * 特点
    * 可以作用在整个堆
    * 可控的停顿 
      * MaxGCPauseMillis=200
    * 无内存碎片
  * 使用场景
    * 占用内存比较大的应用（6G以上）
    * 替换CMS垃圾收集器

## 其他垃圾收集器

### Shenandoah垃圾收集器

* 低延迟垃圾收集器
* 启用参数
  * `-XX:-UnlockExperimentalVMOptions` , `-XX:+UseShenandoahGC`
* 与G1类似
  * 基于Region的内存布局，有用于存放大对象的Humongous Region，回收策略也是同样是优先处理回收价值最大的Region
  * 并发的整理算法，Shenandoah默认是不适用分代收集的。解决跨region引用的机制不同，G主要基于Rememberd Set、CardTable，而Shenandoah是基于连接矩阵
* 工作步骤
  * 初始标记
  * :zap: 并发标记
  * 最终标记
  * 并发清理
  * :zap:并发回收
  * 初始引用更新
  * :zap:并发引用更新
  * 最终引用更新
  * 并发清理
* 使用场景
  * 低延迟、响应快的业务场景

### ZGC垃圾收集器

* 使用场景
  * 低延迟、响应快的业务场景
* 启用参数
  * `-XX:UnlockExperimentalVMOptions`,`-XX:+UseZGC`

### Epsilon垃圾收集器