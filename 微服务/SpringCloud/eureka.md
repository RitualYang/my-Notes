# Eureka

## 核心功能

* Service Registry（服务注册）
* Service Discovery（服务发现）

## 基础架构

Eureka由三个角色组成。

* Eureka Server：提供服务注册与发现

* Eureka Client：服务客户端

  * Service Provider：服务提供方，将自身服务注册到Eureka Server上，从而让Eureka Server持有服务的元信息，让其他服务消费方能够找到当前服务。
  * Service Consumer：服务消费方，从Eureka Server上获取注册服务列表，从而能够消费服务。 

  ![服务调用](..\..\images\eureka服务调用.png)

## 高可用

问题：单节点的Eureka Server 虽然能够实现基础功能，但是存在单点故障的问题，不能实现高可用。因为Eureka Server 中存储了整个系统中所有的微服务的元数据信息，单节点一点挂掉，所有的服务信息都会丢失，造成整个系统的瘫痪。

解决方法：搭建Eureka Server 集群，让各个Server 节点之间相互注册，从而实现微服务元数据的复制/备份，即使单个节点失效，其他的Server 节点仍可以继续提供服务

![服务调用](..\..\images\Eureka集群调用.png)

## 单节点搭建

### pom文件依赖

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
</dependency>
```

### application配置

```yaml
eureka:
  instance:
    hostname: localhost
  client:
    # 标识是否从 Eureka Server 获取注册信息, 默认是 true. 如果这是一个单节点的 Eureka Server
    # 不需要同步其他节点的数据, 设置为 false
    fetch-registry: false
    # 是否将自己注册到 Eureka Server, 默认是 true. 由于当前应用是单节点的 Eureka Server
    # 需要设置为 false
    register-with-eureka: false
    # 设置 Eureka Server 所在的地址, 查询服务和注册服务都需要依赖这个地址
    service-url:
      defaultZone: http://${eureka.instance.hostname}:${server.port}/eureka/
```

### 启动类

```java
@EnableEurekaServer// 启动Eureka服务
@SpringBootApplication
public class EurekaApplication {
    public static void main(String[] args) {
        SpringApplication.run(EurekaApplication.class, args);
    }
}
```

