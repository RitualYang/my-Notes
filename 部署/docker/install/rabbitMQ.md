安装rabbitmq

## 安装rabbitmq

* 搜索镜像：`docker search rabbitmq`

* 下拉镜像：`docker pull rabbitmq:management`(带有ui的版本)

## 启动rabbitmq

### docker原生启动

* 自带管理ui界面：

  ```shell
  docker run -d --name rabbitmq -p 5671:5671 -p 5672:5672 -p 4369:4369 -p 25672:25672 -p 15671:15671 -p 15672:15672 rabbitmq:management
  ```
  

