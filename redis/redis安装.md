# redis安装

```shell
下载地址：http://redis.io/download
安装步骤：
# 安装gcc
yum install gcc

# 把下载好的redis‐5.0.3.tar.gz放在/usr/local文件夹下，并解压
wget http://download.redis.io/releases/redis‐5.0.3.tar.gz
tar xzf redis‐5.0.3.tar.gz
cd redis‐5.0.3

# 进入到解压好的redis‐5.0.3目录下，进行编译与安装
make

# 启动并指定配置文件
src/redis‐server redis.conf
（注意要使用后台启动，所以修改redis.conf里的daemonize改为yes)

# 验证启动是否成功
ps ‐ef | grep redis

# 进入redis客户端
src/redis‐cli

# 退出客户端
quit

# 退出redis服务：
（1）pkill redis‐server
（2）kill 进程号
（3）src/redis‐cli shutdown
```

