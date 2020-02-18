# 安装nacos

## 安装nacos

* 搜索镜像：`docker search nacos`

* 下拉镜像：`docker pull nacos/nacos-server:version`

## 启动nacos

### docker原生启动

* 基础版：

    ```shell
    docker run --name nacos -d -p 8848:8848 -e MODE=standalone nacos/nacos-server
    # -p 8848:8848 :将主机的8848端口映射到容器的8848端口
    # --name nacos :设置容器名为nacos
    # -d  : 后台启动
    # nacos/nacos-server :挂载运行的镜像
    # -e MODE=standalone :使用standalone模式
    
    # 使用
    访问服务 ip:8848/nacos
    账户密码 : nacos/nacos
    ```
  
* 进阶版：

  * 准备工作：

    ```shell
    mkdir /usr/docker
    mkdir /usr/docker/nacos
    mkdir /usr/docker/nacos/logs
    mkdir /usr/docker/nacos/init.d
    touch /usr/docker/nacos/init.d/custom.properties # 配置见文章底部
    ```

  ```shell
  docker run --name nacos -d -p 8848:8848 -e MODE=standalone -v /usr/docker/nacos/init.d/custom.properties:/home/nacos/init.d/custom.properties -v /usr/docker/nacos/logs:/home/nacos/logs nacos/nacos-server
  # -v nacos/init.d/cust... : custom.properties挂载配置文件
  # -v nacos/logs:...       : 挂载日志目录
  ```

### docker-compose启动

* 准备工作：

  ```shell
  vim /usr/docker/nacos/docker-compose.yml
  
  version: "3"
  services:
    nacos:
      image: nacos/nacos-server
      container_name: nacos
      ports:
        # 端口映射
        - 8848:8848
      environment:
        - MODE=standalone
      volumes:
        # 目录映射
        - ./init.d/custom.properties:/home/nacos/init.d/custom.properties
        - ./logs:/home/nacos/logs
  ```
  
  
  
  
  
#### custom.properties常用配置

```shell
#spring.security.enabled=false
#management.security=false
#security.basic.enabled=false
#nacos.security.ignore.urls=/**
#management.metrics.export.elastic.host=http://localhost:9200
# metrics for prometheus
management.endpoints.web.exposure.include=*

# metrics for elastic search
#management.metrics.export.elastic.enabled=false
#management.metrics.export.elastic.host=http://localhost:9200

# metrics for influx
#management.metrics.export.influx.enabled=false
#management.metrics.export.influx.db=springboot
#management.metrics.export.influx.uri=http://localhost:8086
#management.metrics.export.influx.auto-create-db=true
#management.metrics.export.influx.consistency=one
#management.metrics.export.influx.compressed=true
```

