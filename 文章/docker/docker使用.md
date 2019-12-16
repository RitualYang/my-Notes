# docker

## docker介绍

 Docker 是一个开源的应用容器引擎，让开发者可以打包他们的应用以及依赖包到一个可移植的镜像中，然后发布到任何流行的 Linux或Windows 机器上，也可以实现虚拟化。容器是完全使用沙箱机制，相互之间不会有任何接口。 

## docker安装

### windows

### MAC

### Linux



##  docker命令

1. 设置开机自动启动。

   `
   systemctl enable docker
   `

2. docker的启动、停止、重启

   ```shell
   service docker restart    # 重启
   service docker stop       # 停止
   service docker start      # 启动
   ```

### docker镜像

1. 镜像搜索` docker search <image> `，用于搜索远程源上的镜像仓库。

   ```shell
   docker search redis 	# 搜索redis相关镜像
   docker search tomcat	# 搜索tomcat相关镜像
   docker search mysql	# 搜索mysql相关镜像
   ```

2. 拉取镜像` docker pull <image>`，拉取远程源上镜像仓库里的镜像 。*不指定版本，默认拉取最新版本。（版本号可通过[dockerhub](https://hub.docker.com/)搜索需要拉取的镜像查看Tags）*

   ```shell
   docker pull redis		# 拉取redis最新版本镜像
   docker pull tomcat		# 拉取tomcat最新版本镜像
   docker pull mysql		# 拉取mysql最新版本镜像
   docker pull redis:3.2	# 拉取redis3.2版本镜像
   ```

3. 查看本地镜像

   ```shell
   docker images            # 列出images
   docker images -a         # 列出所有的images（包含历史）
   docker images --tree     # 显示镜像的所有层(layer)
   docker rmi  <image ID>   # 删除一个或多个image
   ```

### docker容器

1. 创建容器`docker run 命令格式`

   ```shell
   Usage: docker run [OPTIONS] IMAGE [COMMAND] [ARG...]  
    
     -d, --detach=false         指定容器运行于前台还是后台，默认为false   
     -i, --interactive=false   打开STDIN，用于控制台交互  
     -t, --tty=false            分配tty设备，该可以支持终端登录，默认为false  
     -u, --user=""              指定容器的用户  
     -a, --attach=[]            标准输入输出流和错误信息（必须是以非docker run -d启动的容器）
     -w, --workdir=""           指定容器的工作目录 
     -c, --cpu-shares=0        设置容器CPU权重，在CPU共享场景使用  
     -e, --env=[]               指定环境变量，容器中可以使用该环境变量  
     -m, --memory=""            指定容器的内存上限  
     -P, --publish-all=false    指定容器暴露的端口  
     -p, --publish=[]           指定容器暴露的端口 
     -h, --hostname=""          指定容器的主机名  
     -v, --volume=[]            给容器挂载存储卷，挂载到容器的某个目录  
     --volumes-from=[]          给容器挂载其他容器上的卷，挂载到容器的某个目录
     --cap-add=[]               添加权限，权限清单详见：http://linux.die.net/man/7/capabilities  
     --cap-drop=[]              删除权限，权限清单详见：http://linux.die.net/man/7/capabilities  
     --cidfile=""               运行容器后，在指定文件中写入容器PID值，一种典型的监控系统用法  
     --cpuset=""                设置容器可以使用哪些CPU，此参数可以用来容器独占CPU  
     --device=[]                添加主机设备给容器，相当于设备直通  
     --dns=[]                   指定容器的dns服务器  
     --dns-search=[]            指定容器的dns搜索域名，写入到容器的/etc/resolv.conf文件  
     --entrypoint=""            覆盖image的入口点  
     --env-file=[]              指定环境变量文件，文件格式为每行一个环境变量  
     --expose=[]                指定容器暴露的端口，即修改镜像的暴露端口  
     --link=[]                  指定容器间的关联，使用其他容器的IP、env等信息  
     --lxc-conf=[]              指定容器的配置文件，只有在指定--exec-driver=lxc时使用  
     --name=""                  指定容器名字，后续可以通过名字进行容器管理，links特性需要使用名字  
     --net="bridge"             容器网络设置:
                                   bridge 使用docker daemon指定的网桥     
                                   host     //容器使用主机的网络  
                                   container:NAME_or_ID  >//使用其他容器的网路，共享IP和PORT等网络资源  
                                   none 容器使用自己的网络（类似--net=bridge），但是不进行配置 
     --privileged=false         指定容器是否为特权容器，特权容器拥有所有的capabilities  
     --restart="no"             指定容器停止后的重启策略:
                                   no：容器退出时不重启  
                                   on-failure：容器故障退出（返回值非零）时重启 
                                   always：容器退出时总是重启  
     --rm=false                 指定容器停止后自动删除容器(不支持以docker run -d启动的容器)  
     --sig-proxy=true           设置由代理接受并处理信号，但是SIGCHLD、SIGSTOP和SIGKILL不能被代理
   ```

   ```shell
   简易启动nginx实例：
   docker run -p 8080:80 -d nginx
   # -p 将80端口映射为8080，不可以不写。
   # -d 实例化哪一个镜像。
   
   启动修改配置文件后的nginx实例：
   docker run --name nginx -p 8080:80 -v /home/docker-nginx/nginx.conf:/etc/nginx/nginx.conf -d nginx
   # --name 给启动后的容器设置一个名字
   # -v 将本地文件替代容器上指定文件。（一般替代日志，配置文件等）
   ```

2. 查看docker容器。

   ```shell
   docker ps      	# 查看正在运行的容器
   docker ps -a	# 查看所有容器
   ```

3. 启动、停止、重启、删除docker容器

   ```shell
   docker start <ContainerId(或者name)> 		# 启动容器
   docker stop <ContainerId(或者name)> 		# 停止容器
   docker restart <ContainerId(或者name)>	# 重启容器
   docker rm <ContainerId(或者name)>			# 删除容器
   docker rm $(docker ps -a -q)			 # 删除所有容器
   
   例：
   docker start redis
   docker start e173a4c70fb7
   ```

4. 进入docker容器

   ```
   docker exec -it containerID /bin/bash	# 进入容器
   # ctrl+d 退出容器且关闭
   # ctrl+p+q 退出容器但不关闭
   ```

5. 查看容器日志。

   ```shell
   docker logs -f -t --tail 行数 容器名
   docker logs -f -t --tail 10 redis # 查看容器最后10行日志
   ```

### docker网络

```shell
# 在主机上创建一个网络
docker network create mynet

# 查看自定义bridge网络
docker network inspect mynet

# 移除网络要求网络中所有的容器关闭或断开与此网络的连接时，才能够使用移除命令
docker network disconnet mynet 容器ID

# 移除网络
docker network rm mynet
```



## docker-compse



## dockerfile



## docker私有仓库