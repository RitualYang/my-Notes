# Zuul

## 介绍

微服务系统中往往包含了很多个功能不同的子系统或微服务，在微服务架构中，后端服务往往不直接开发给调用端，而是通过一个服务网关根据请求的url，路由到响应的服务，即实现请求转发，效果如图所示。

![微服务访问](..\images\微服务访问.png)



Zuul提供了服务网关的功能，可以实现负载均衡、反向代理、动态路由、请求转发等功能。Zuul大部分功能都是通过过滤器实现的，Zuul中定义了四种标准的过滤器类型，同时还支持自定义过滤器。

pre：在请求被路由之前调用

route：在路由请求时被调用

post：在route和error过滤器之后被调用

error：在处理请求时发生错误调用

![微服务访问](..\images\Zuul过滤器.png)

## 实现

### pom依赖

```xml
<!--
Eureka 客户端, 客户端向 Eureka Server 注册的时候会提供一系列的元数据信息, 例如: 主机, 端口, 健康检查url等
Eureka Server 接受每个客户端发送的心跳信息, 如果在某个配置的超时时间内未接收到心跳信息, 实例会被从注册列表中移除
-->
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
</dependency>
<!-- 服务网关 -->
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-zuul</artifactId>
</dependency>
```

### application配置

```yaml
# 配置eureka服务
eureka:
  client:
    service-url:
      defaultZone: http://localhost:8000/eureka/

zuul:
  # 请求访问前缀
  prefix: /wty
  routes:
    # 路由配置定义
    template:
      path: /template/**
      serviceId: eureka-client-template
      strip-prefix: false # 跳过前缀
  host:
    connect-timeout-millis: 15000
    socket-timeout-millis: 60000

ribbon:
  ConnectTimeout: 15000
  ReadTimeout: 15000
```

### 启动类

```java
@EnableZuulProxy
@SpringCloudApplication
public class ZuulGatewayApplication {
    public static void main(String[] args) {
        SpringApplication.run(ZuulGatewayApplication.class, args);
    }
}
```

