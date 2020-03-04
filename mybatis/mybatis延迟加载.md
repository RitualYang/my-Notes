# Mybatis延时加载

### 介绍

*  延迟加载又叫懒加载，也叫按需加载，也就是说先加载主信息，需要的时候，再去加载从信息。代码中有查询语句，当执行到查询语句时，并不是马上去DB中查询，而是根据设置的延迟策略将查询向后推迟。 

* 延时加载的目的

  > 减轻DB服务器的压力,因为我们延迟加载只有在用到需要的数据才会执行查询操作。 

* 使用场景

  * 直接加载

    > 数据关系：一对一，多对一

  * 延迟加载

    > 数据关系：一对多，多对多

### 延迟加载策略

* 直接加载

  > 遇到代码中查询语句，马上到DB中执行select语句进行查询。（这种只能用于多表单独查询） 

*  侵入式延迟加载

  > 将关联对象的详情（具体数据，如id、name）侵入到主加载对象，作为主加载对象的详情的一部分出现。当要访问主加载对象的详情时才会查询主表，但由于关联对象详情作为主加载对象的详情一部分出现，所以这个查询不仅会查询主表，还会查询关联表。

*  深度延迟加载 

  > 将关联对象的详情（具体数据，如id、name）侵入到主加载对象，作为主加载对象的详情的一部分出现。当要访问主加载对象的详情时才会查询主表，但由于关联对象详情作为主加载对象的详情一部分出现，所以这个查询不仅会查询主表，还会查询关联表。
  

#### 注解开发

```java
@select("select * from user")
@Result(property = "userInfoMap",
			many = @Many(select = "com.wty.mapper.UserInfoMapper.findAllByUid",
			            fetchType = FetchType.LAZY))
// fetchType:加载类型。LAZY：延时加载。EAGER：立即加载。DEFAULT：默认。 
```

#### xml开发

* 配置

```xml
<setting name="lazyLoadingEnabled" value="true" />  <!--开启懒加载-->
<setting name="aggressiveLazyLoading" value="false" /> <!--true：调用时加载，false：主对象调用加载-->
```



