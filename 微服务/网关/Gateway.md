1.客户端向网关发送Http请求，会到达DispatcherHandler接受请求，匹配到

RoutePredicateHandlerMapping。

\1. 根据RoutePredicateHandlerMapping匹配到具体的路由策略。

\2. FilteringWebHandler获取的路由的GatewayFilter数组，创建 GatewayFilterChain 处理过滤请求

\3. 执行我们的代理业务逻辑访问。

![img](file:///C:/Users/ADMINI~1/AppData/Local/Temp/msohtmlclip1/01/clip_image002.jpg)

 

 

常用配置类说明：

\1. GatewayClassPathWarningAutoConfiguration 检查是否有正确的配置webflux

\2. GatewayAutoConfiguration 核心配置类

\3. GatewayLoadBalancerClientAutoConfiguration 负载均衡策略处理

\4. GatewayRedisAutoConfiguration Redis+lua整合限流



源码分析：

 

 

SpringBoot项目源码的入口

 

\1. GatewayClassPathWarningAutoConfiguration 作用检查是否配置我们webfux依赖。

\2. GatewayAutoConfiguration加载了我们Gateway需要的注入的类。

\3. GatewayLoadBalancerClientAutoConfiguration 网关需要使用的负载均衡

Lb//mayikt-member// 根据服务名称查找真实地址

\4. GatewayRedisAutoConfiguration  网关整合Redis整合Lua实现限流

\5. GatewayDiscoveryClientAutoConfiguration 服务注册与发现功能

 

 

 

 

微服务中跨域的问题 不属于前端解决 jsonp 只能支持get请求。

 

核心点就是在我们后端。

 

解决跨域的问题

\1. HttpClient转发

\2. 使用过滤器允许接口可以跨域 响应头设置

\3. Jsonp 不支持我们的post 属于前端解决

\4. Nginx解决跨域的问题保持我们域名和端口一致性

\5. Nginx也是通过配置文件解决跨域的问题

\6. 基于微服务网关解决跨域问题，需要保持域名和端口一致性

\7. 使用网关代码允许所有的服务可以跨域的问题

\8. 使用SpringBoot注解形式@CrossOrigin