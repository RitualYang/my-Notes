## 配置用户组

```shell
#解压缩
tar -zxvf elasticsearch-7.3.2-linux-x86_64.tar.gz

#实现远程访问需要对config/elasticsearch.yml进行配置
network.host: 192.168.37.128   #本地IP地址
http.port: 9200

#配置elasticsearch允许跨域访问
#打开elasticsearch的配置文件elasticsearch.yml，在文件末尾追加下面
http.cors.enabled: true 
http.cors.allow-origin: "*"
node.master: true
node.data: true

#启动elasticsearch
cd /opt/elasticsearch/bin
./elasticsearch

#出现如下错误
Caused by: java.lang.RuntimeException: can not run elasticsearch as root
```



```shell
#创建elsearch用户组及elsearch用户：
groupadd elsearch
useradd elsearch -g elsearch -p  123456


#更改elasticsearch文件夹及内部文件的所属用户及组为elsearch:elsearch
chown -R elsearch:elsearch  elasticsearch

#切换到elsearch用户再启动
su elsearch 
cd /opt/elasticsearch/bin
./elasticsearch

#查看es状态
curl 192.168.37.128:9200
#或者通过浏览器查看
firefox
localhost:9200

#出现如下错误按照处理方法更改配置文件
ERROR: [2] bootstrap checks failed
[1]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
[2]: the default discovery settings are unsuitable for production use; at least one of [discovery.seed_hosts, discovery.seed_providers, cluster.initial_master_nodes] must be configured

[1]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
#处理第一个错误方法：
#配置内存
vim /etc/sysctl.conf
vm.max_map_count=655360
#保存后执行命令生效：
sysctl -p
#重新启动后成功

[2]: the default discovery settings are unsuitable for production use; at least one of [discovery.seed_hosts, discovery.seed_providers, cluster.initial_master_nodes] must be configured
#处理第二个错误方法：
#修改config目录下的 elasticsearch.yml文件
vim elasticsearch.yml
cluster.initial_master_nodes: ["node-1"]

#如还出现下面报错，按照处理方法解决
[3]: max file descriptors [4096] for elasticsearch process is too low, increase to at least [65536]
#处理第三个错误方法：
vim /etc/security/limits.conf
#修改文件最大打开数
elsearch soft nofile 65536
elsearch hard nofile 65536
elsearch soft nproc 4096
elsearch hard nproc 4096

[4] max num of threads [3790] for user [elsticsearch] is too low, increase to at least [4096] 
#处理第四个错误方法：
vim /etc/security/limits.d/20-nproc.conf
elsearch   soft   nproc   4096
 
 #重新启动
 ./elasticsearch
#windows客户端网页输入ip和端口即可登陆linux上的Elasticsearch
  192.168.37.128:9200

#需要可关闭防火墙:systemctl stop firewalld.service
```
```shell
设置JVM启动参数
vim /config/jvm.options

-Xms258m
-Xmx258m
```


## 安装

```shell
# 1. 解压
 unzip elasticsearch-head-master.zip
# 2.下载nodejs 
 tar -xvf node-v12.11.1-linux-x64.tar.xz
#设置node环境变量
#node,NODE_HOME是node绝对安装路径
vim /etc/profile
export NODE_HOME=/moudle/node
export PATH=$PATH:$NODE_HOME/bin
#查看node版本号
node -v 

#3.安装grunt
#grunt离线安装包grunt.tar,可以安装在任意位置
tar -zxvf grunt.tar 
#添加grunt-cli环境变量
vim ~/.bash_profile

# User specific environment and startup programs
PATH=$PATH:$HOME/bin:/moudle/node/bin:/moudle/grunt/bin
export PATH

#查看版本号
grunt-cli v1.3.2
grunt v1.0.4

#修改Gruntfile.js 允许所有IP都可以访问
connect: {
            server: {
                  options: {
                          hostname:'*',
                          port: 9100,
                          base: '.',
                          keepalive: true
                            }
                     }
         }

#防火墙开启9100端口
#firewall-cmd --zone=public --add-port=9100/tcp --permanent
#重启防火墙
#firewall-cmd --reload

#启动elasticsearch,进入elasticsearch-head安装目录
grunt server
#运行成功显示
Running "connect:server" (connect) task
Waiting forever...
Started connect web server on http://localhost:9100

#在浏览器中输入192.168.37.128：9100打开elasticsearch-head
Elasticsearch连接地址为：http://192.168.37.128：9200/
```

