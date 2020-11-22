查看端口开放

`netstat -ap|grep LISTEN`

重命名

`mv a b`

临时关闭防火墙

```shell
systemctl stop firewalld        # centos7
#然后reboot 永久关闭
systemctl disable firewalld
```

查看防火墙状态

`systemctl status firewalld`



`top` 显示管理执行中的程序



`jps`  查看进程