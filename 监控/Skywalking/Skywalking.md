

#### 下载
* 前往`http：//skywalking.apache.org/downloads/ `找对自己的操作系统，下载即可。

#### 环境需求
* JDK版本在JDK8-JDK12之间
    * 注意．如使用ElasticSearch7的版本，那么需要JDK11+
* 确保如下端囗可用：
    * 11800：和Skywalkmg通信的gRPC端囗
    * 12800：和Skywalking通信的HTTPj%囗
  * 8080：UI所占用的端囗

可使用如下命令查询端囗是否被占用。
```
#Linux/mac0S
netstat —an|grep 8080
#windows
netstat—ano|findstr 8080
如果没有结果，就说明8080端囗没有被占用。其他端囗也是一样，以此类推。
```
#### 安装&启动

```
Linux或macOS
执行：
cdapache—skywalking—apm—bin/bin
shstartup.sh

Windows
执行：
cdapache—skywalking—apm—bin/bin
startup.bat
```

#### 首页
访问`http://localhost:8080`
停止
```
# jps
72844 OAPServerStartUp
72849 skywalking-webapp.jar
# kill 72844 72849
```
参考文档
https://github.com/apache/skywalking/blob/master/docs/en/setup/backend/backend-ui-setup.md

## 详细使用

使用用Skywalking监控应用。
Skywalking有多种使用方式，目前最流行（也是最强大）的使用方式是基于Javaagent的。
Javaagent支持的框架、中间件等，可在https：//github.com/apache/skywaIking/b10b/v6.6.O/docs/en/setup/service—agent/java—agent/Supported—Iist.md查看·
* 除Javaagent方式外，Skywalking还支持其他语言的agent，详见`https：//github.com/apache/skywalking/blob/v6.6.0/docs/en/setup/README.md#language—agents—in—service`
。此外，Skywalking还支持基于ServiceMesh（例如Istio详见`https：//github.com/apache/skywalking/blob/v6.6.O/dOCS/en/setup/README.md#service—mesh`）、Proxy〈例如EnvoyProxy,详见`https://github.com/apache/skywaIking/blob/v6.6.0/docs/en/setup/README.md#service—mesh`）不过这两种使用方式目前还不是特别流行，故此不做赘述，其实也比较简单。感兴趣的童鞋也可以研究一下。
### 配置javaagent

找到Skywalking包中的`agent`目录，`agent`目录结构如下
```
+一一agent
    activations
        apm—tooIkit—Iog4j一1．x—act．jar
        apm—toolkit—Iog4j一2．x—act．jar
        apm—toolkit—logback—l.x—activation．jar
        ...
config
    agent.config
plugins
    apm—dubbo—plugin.jar
    apm—feign—default—http—9。x．jar
    apm—httpClient—4.x—plugin．jar
    skywalking-agent.jar
```
* 将`agent`目录拷贝到任意位置
* 配置`config/agent.config`
    * 将agent.service-name修改成你的微服务名称；
    * 如果Skywalking和微服务部署在不同的服务器，还需修改`collector.backend_servxce`的值，该配置用来指定微服务和Skywalking通信的地址，默认是`127.0.1:11800`，按需配置即可。`agent.config`文件里面有很多的配置，本文下面的表格有详细讲解。
### 启动应用
* `java-jar`启动的应用
    例如，有Boot应用，则修改完agent目录后：
    * 执行如下命令启动：
    ```
    # 注意一javaagent得在—jar之前哦
    java—javaagent：/opt/agent/skywalking—agent.jar jar spring—boot.jar
    ```

* 传统Tomcat应用
Linux Tomcat 7-9
修改`tomcat/bin/catalina.sh`的第一行：
```
CATALINA_OPTS='$CATALINA_OPTS —javaagent:/opt/agent/skywalking—agent.jar"; exportCATALINAOPTS
```
windows Tomcat 7-9
修改`tomcat/bin/Catalina.bat`的第一行：
```
set "CATALINA_OPTS= -javaagent：/opt/agent/skywalking—agent．jar"
```


### 警告
### 动态配置
### 集群配置