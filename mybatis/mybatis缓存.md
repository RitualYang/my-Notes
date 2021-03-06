# mybatis缓存

### 介绍

* 什么是缓存

  > 存在于内存中的临时数据。
  
* 为什么使用缓存

  > 减少和数据库的交互次数，提高执行效率。

* 缓存的适用

  * 适用于缓存

    > 1. 经常查询并且不经常改变的。
    > 2. 数据的正确与否对最终结果影响不大的。

  * 不适用于缓存

    > 1. 经常改变的数据。
    >
    > 2. 数据的正确与否对最终结果影响很大的。
    >
    >    例如（商品的库存，银行的汇率，股市的牌价）

* Mybatis缓存介绍

  * 一级缓存

    > **指代的是Mybatis中SqlSession对象的缓存。**
    >
    > 1. 当我们执行查询之后，查询的结果会同时存入到SqlSession为我们提供的一块区域中，该区域的结构是一个Map。当我们再次查询同样的数据，Mybatis会先去SqlSession中查询是否有，有的话直接拿出来用。
    > 2. 当sqlSession对象消失时，Mybatis的一级缓存也就消失了。
    >3. 当sqlSession执行commit操作（插入，更新，删除），清空sqlSession对象中的一级缓存。
    > 
    
  * 二级缓存
  
    > **指代的是Mybatis中mapper映射文件缓存。**
    >
    > 1. 二级缓存默认没有开启，需要手动设置启动二级缓存。
    > 2. 二级缓存可以被多个一级缓存调用。
    > 3. 二级缓存存储的是数据而不是对象，所以需要将对应的实体类实现序列化接口。

### 使用

#### xml开发



#### 注解开发





