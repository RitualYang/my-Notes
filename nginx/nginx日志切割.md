1. 创建一个shell可执行文件： cut_my_log.sh ，内容为：

  ```shell
  #!/bin/bash
  LOG_PATH="/var/log/nginx/"
  RECORD_TIME=$(date -d "yesterday" +%Y-%m-%d+%H:%M)
  PID=/var/run/nginx/nginx.pid
  mv ${LOG_PATH}/access.log ${LOG_PATH}/access.${RECORD_TIME}.log
  mv ${LOG_PATH}/error.log ${LOG_PATH}/error.${RECORD_TIME}.log
  #向Nginx主进程发送信号，用于重新打开日志文件
  kill -USR1 `cat $PID`
  ```

2. 为cut_my_log.sh 添加可执行的权限：

  ```shell
  chmod +x cut_my_log.sh
  ```

3. 测试日志切割后的结果:

  ```shell
  ./cut_my_log.sh
  ```

  

### Nginx 日志切割-定时

1. 安装定时任务：
`yum  install  crontabs`

2.  `crontab  -e `编辑并且添加一行新的任务：

`*/1  *  *  *  *  /usr/local/nginx/sbin/cut_my_log.sh`


3. 重启定时任务：

`service  crond  restart`












