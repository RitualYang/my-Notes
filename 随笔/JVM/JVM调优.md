# JVM调优

## full gc优化

* full gc 是对整个JVM堆跟方法区进行一次清洗的操作，会暂停当前所有线程的运行。
  
  * oom
  

可优化的地方：full gc的运行次数，暂停时的时长
