

### cat

### ps

`ps -ef|grep name` :筛选 查找name的进程

### cd

### ls

### ll

### mkdir

### cp

### find

### chmod

### chattr

### tar/untar

### zip/unzip

### top

`top` 显示管理执行中的程序

### netstat

* 查看端口开放

`netstat -ap|grep LISTEN`

### systemctl

* 临时关闭防火墙

```shell
systemctl stop firewalld        # centos7
#然后reboot 永久关闭
systemctl disable firewalld
```

* 查看防火墙状态

`systemctl status firewalld`



### cat

`cat log_info.log | grep 'terimalShopStock: startDate'`

`sed -n '/2021-12-13 15:25:40/,/2021-12-13 15:25:43/p' log_info.log`