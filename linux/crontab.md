# crontab定时任务

## 介绍

>linux 系统则是由 cron (crond) 这个系统服务来控制的。Linux 系统上面原本就有非常多的计划性工作，因此这个系统服务是默认启动的。另 外, 由于使用者自己也可以设置计划任务，所以， Linux 系统也提供了使用者控制计划任务的命令 :crontab 命令。
>
>当安装完成操作系统之后，默认便会启动此任务调度命令。
>
>crond 命令每分锺会定期检查是否有要执行的工作，如果有要执行的工作便会自动执行该工作。
>
>而 linux 任务调度的工作主要分为以下两类：
>
>- 1、系统执行的工作：系统周期性所要执行的工作，如备份系统数据、清理缓存
>- 2、个人执行的工作：某个用户定期要做的工作，例如每隔10分钟检查邮件服务器是否有新信，这些工作可由每个用户自行设置

## 使用
1. 安装crontab。

`yum install crontabs`

2. crontab服务操作。

```shell
/sbin/service crond start       # 启动服务
 
/sbin/service crond stop        # 关闭服务
 
/sbin/service crond restart     # 重启服务
 
/sbin/service crond reload      # 重新载入配置
  
crontab -e						#编辑任务
crontab -l                      #查看任务列表
```

3. 查看crontab服务状态。

`service crond status`

4. 查看crontab服务是否已设置为开机启动。

```shell
ntsysv                          # 方法1：界面启动       
chkconfig –level 35 crond on    # 方法2：加入开机自动启动
```
5. 查看编辑定时任务列表
```shell
crontab [-u username]　　　　//省略用户表表示操作当前用户的crontab
    -e [username]：编辑某个用户的crontab文件内容。如果不指定用户，则表示编辑当前用户的crontab文件。
    -l [username]：显示某个用户的crontab文件内容，如果不指定用户，则表示显示当前用户的crontab文件内容。
    -r [username]：从/var/spool/cron目录中删除某个用户的crontab文件，如果不指定用户，则默认删除当前用户的crontab文件。
    -i [username]：在删除用户的crontab文件时给确认提示。
    -v [UserName]:列出用户cron作业的状态
```
   * `/var/spool/cron/` 目录下存放的是每个用户包括root的crontab任务，每个任务以创建者的名字命名
   * `/etc/crontab` 这个文件负责调度各种管理和维护任务。
   * `/etc/cron.d/` 这个目录用来存放任何要执行的crontab文件或脚本。
我们还可以把脚本放在`/etc/cron.hourly`、`/etc/cron.daily`、`/etc/cron.weekly`、`/etc/cron.monthly`目录中，让它每小时/天/星期、月执行一次。

6. 打开日志文件记录。（想要输入日志须开启日志文件记录）
```shell
# 找到cron.log行，取消注释 
sudo vim /etc/rsyslog.d/50-default.conf 
# 重启服务 
sudo service rsyslog restart 
# 查看cron.log 日志默认输出位置
vim /var/log/cron.log
```
## 定时任务案例

* 定时检测服务启动状态，并进行激活。

```shell
crontab -e
添加如下脚本(每分钟运行一次)：
# 分钟 小时 日 月 周（类似cron语法）       自定义脚本       >: 表示输出日志并覆盖     >>: 表示追加输出日志
0/1 * * * * sh /opt/tocmat/timeTask/tesk.sh >> /opt/tomcat/timeTask/logs.test.log    #自定义日志输出位置
```

```shell
# tesk.sh
c=`ps -ef|grep tomcat-8080/conf |grep -v grep |wc -l`
time=$(date +%Y-%m-%d\ %H:%M:%S)
echo $time
echo $c
if [ $c -eq 0 ]
then
        echo "tomcat over"
        echo `/opt/tomcat/bin/startup.sh`
        echo "tomcat start"
elif [ $c -gt 1 ]
then
        echo "tomcat Start the too much"
        echo `/opt/tomcat/bin/shutdown.sh`
        echo "tomcat close"
        echo `/opt/tomcat/bin/startup.sh`
        echo "tomcat start"
else
        echo "tomcat normal running"
fi
```