# tomcat日志

* tomcat 日志配置文件

  * 位置： tomcat目录下的/conf/logging.properties 
  
  * 日志输出级别： SEVERE (最高级别) > WARNING > INFO > CONFIG > FINE > FINER(精心) > FINEST (所有内容,最低级别) 
  
    *输出的日志不会输出比当前日志输出级别低的日志*
  * 日志类型： catalina、localhost、manager、admin、host-manager
logging.properties
```properties
#可配置项(5类日志)：catalina、localhost、manager、admin、host-manager
handlers = 1catalina.org.apache.juli.FileHandler, 2localhost.org.apache.juli.FileHandler,
3manager.org.apache.juli.FileHandler, 4host-manager.org.apache.juli.FileHandler, java.util.logging.ConsoleHandler

#日志输出为输出到文件和输出到控制台
handlers = 1catalina.org.apache.juli.FileHandler, java.util.logging.ConsoleHandler

#配置文件使catalina日志输出级别为FINE
1catalina.org.apache.juli.FileHandler.level = FINE
#catalina文件输出位置
1catalina.org.apache.juli.FileHandler.directory = ${catalina.base}/logs
#catalina日志前缀为catalina
1catalina.org.apache.juli.FileHandler.prefix = catalina.

#配置文件使localhost日志输出级别为FINE
2localhost.org.apache.juli.FileHandler.level = FINE
#localhost文件输出位置
2localhost.org.apache.juli.FileHandler.directory = ${catalina.base}/logs
#localhost日志前缀为localhost
2localhost.org.apache.juli.FileHandler.prefix = localhost.

#配置文件使manager日志输出级别为FINE
3manager.org.apache.juli.FileHandler.level = FINE
#manager文件输出位置
3manager.org.apache.juli.FileHandler.directory = ${catalina.base}/logs
#manager日志前缀为manager
3manager.org.apache.juli.FileHandler.prefix = manager.

#配置文件使host-manager日志输出级别为FINE
4host-manager.org.apache.juli.FileHandler.level = FINE
#host-manager文件输出位置
4host-manager.org.apache.juli.FileHandler.directory = ${catalina.base}/logs
#host-manager日志前缀为host-manager
4host-manager.org.apache.juli.FileHandler.prefix = host-manager.

#配置文件使控制台日志输出级别为FINE
java.util.logging.ConsoleHandler.level = FINE
#控制台日志输出格式
java.util.logging.ConsoleHandler.formatter = java.util.logging.SimpleFormatter

#localhost日志文件输出级别为INFO
org.apache.catalina.core.ContainerBase.[Catalina].[localhost].level = INFO
#localhost日志文件输出处理类2localhost.org.apache.juli.FileHandler
org.apache.catalina.core.ContainerBase.[Catalina].[localhost].handlers = 2localhost.org.apache.juli.FileHandler

#manager日志文件输出级别为INFO
org.apache.catalina.core.ContainerBase.[Catalina].[localhost].[/manager].level = INFO
#manager日志文件输出处理类3manager.org.apache.juli.FileHandler
org.apache.catalina.core.ContainerBase.[Catalina].[localhost].[/manager].handlers = 3manager.org.apache.juli.FileHandler
 
#host-manager日志文件输出级别为INFO
org.apache.catalina.core.ContainerBase.[Catalina].[localhost].[/host-manager].level = INFO
#host-manager日志文件输出处理类4host-manager.org.apache.juli.FileHandler
org.apache.catalina.core.ContainerBase.[Catalina].[localhost].[/host-manager].handlers = 4host-manager.org.apache.juli.FileHandler
```

## 日志类型详解

1. catalina.out
   *  catalina.out即标准输出和标准出错，所有输出到这两个位置的都会进入catalina.out，这里包含tomcat运行自己输出的日志以及应用里向console输出的日志。默认这个日志文件是不会进行自动切割的，我们需要借助其他工具进行切割。*注意：catalina.out文件如果过大会影响* 
2. catalina.YYYY-MM-DD.log
   *  catalina.{yyyy-MM-dd}.log是tomcat自己运行的一些日志，这些日志还会输出到catalina.out，但是应用向console输出的日志不会输出到catalina.{yyyy-MM-dd}.log,它是tomcat的启动和暂停时的运行日志。*注意：它和catalina.out是里面的内容是不一样的。* 
3. localhost.YYYY-MM-DD.log
   *  localhost.{yyyy-MM-dd}.log主要是应用初始化(listener, filter, servlet)未处理的异常最后被tomcat捕获而输出的日志,它也是包含tomcat的启动和暂停时的运行日志,但它没有catalina.{yyyy-MM-dd}.log 日志全。它只是记录了部分日志。 
4. localhost_access_log**.**YYYY-MM-DD.txt
   * localhost_access_log.{yyyy-MM-dd}.txt：这个是访问tomcat的日志，请求时间和资源，状态码都有记录。 
5. host-manager.YYYY-MM-DD.log
   * host-manager.{yyyy-MM-dd}.log：存放tomcat的自带的manager项目的日志信息的，没有重要的日志信息 
6. manager.YYYY-MM-DD.log
   *  manager.{yyyy-MM-dd}.log ：这个是tomcat manager项目专有的日志文件. 

##  catalina.out 切割

### 通过插件实现切割

1. 下载cronolog

   `wget http://cronolog.org/download/cronolog-1.6.2.tar.gz`
   
2. 解压

   ```shell
   tar xvf cronolog-1.6.2.tar.gz
   ./configure
   make
   make install
   ```

3. 查看状态

   ```shell
   which cronolog
   显示结果：/usr/local/sbin/cronolog
   ```

4. 修改tomcat启动脚本

   `vim tomcat/bin/catalina.sh`

   - 修改生成catalina文件格式

     ```shell
     if [ -z "$CATALINA_OUT" ] ; then
     CATALINA_OUT="$CATALINA_BASE"/logs/catalina.out
     fi
     改为：
     if [ -z "$CATALINA_OUT" ] ; then
     CATALINA_OUT="$CATALINA_BASE"/logs/catalina.$(date +%Y-%m-%d).out
     fi
     ```

   - 删除生成日志

     ```shell
     touch "$CATALINA_OUT"
     改为：
     # touch "$CATALINA_OUT"
     ```


   - 修改启动脚本参数

     ```shell
     org.apache.catalina.startup.Bootstrap "$@" start \
       >> "$CATALINA_OUT" 2>&1 "&"
     改为：
     org.apache.catalina.startup.Bootstrap "$@" start 2>&1 \
     | /usr/local/sbin/cronolog "$CATALINA_OUT" >> /dev/null &
     ```

  5. 重启tomcat