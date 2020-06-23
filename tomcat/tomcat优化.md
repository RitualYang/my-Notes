# tomcat优化

## 内存

1.  Tomcat内存优化主要是对 tomcat 启动参数优化，可以在 Tomcat_HOME/bin/catalina.sh 中设置 java_OPTS 参数。

   ```shell
    JAVA_OPTS参数说明
    	　　-server 启用jdk 的 server 版
    	　　-Xms java虚拟机初始化时的最小内存
    	　　-Xmx java虚拟机可使用的最大内存
    	　　-XX:PermSize 内存永久保留区域
    	　　-XX:MaxPermSize 内存最大永久保留区域
   
   例（根据服务器的实际内存进行配置）：
    JAVA_OPTS=’-Xms1024m -Xmx2048m -XX: PermSize=256M -XX:MaxNewSize=256m -XX:MaxPermSize=256m’
   ```

## 并发

1.  Tomcat并发优化主要是提高连接器connector的并发处理能力，可以在Tomcat_HOME/conf/server.xml中修改相关配置。 

    ```xml
    <Connector  port="8080"
    protocol="HTTP/1.1"                           
    URIEncoding="UTF-8"					# 使得tomcat可以解析含有中文名的文件的url
    minSpareThreads="25"				# 最小备用线程数，tomcat启动时的初始化的线程数，默认10
    maxSpareThreads="75"				# 最大备用线程数，tomcat启动时的初始化的线程数
    enableLookups="false"				# 调用request、getRemoteHost()执行DNS查询，以返回远程主机的主机名，如果设置为false，则直接返回IP地址，提高处理能力
    disableUploadTimeout="true"			# 允许Servlet容器，正在执行使用一个较长的连接超时值，以使Servlet有较长的时间来完成它的执行，默认值为false
    connectionTimeout="20000"			# 设置连接的超时值，以毫秒为单位
    acceptCount="300"					# 当所有的可能处理的线程都正在使用时，在队列中排队请求的最大数目。当队列已满，任何接收到的请求都会被拒绝，默认值为100。
    maxThreads="200"					# 最大线程数，即同时处理的任务个数，默认值为200 , Tomcat使用线程来处理接收的每个请求。这个值表示Tomcat可创建的最大的线程数，即最大并发数，根据服务器性能配置
    maxProcessors="1000"				# 服务器同时最大处理线程数，默认为75
    minProcessors="5"					# 服务器创建时的最小处理线程数，默认为10
    useURIValidationHack="false"		# 减少它对一些url的不必要的检查从而减省开销，为提供性能可以设置为false
    compression="on"					# 设置是否开启GZip压缩。off：禁止压缩、on：允许压缩force：所有情况下都进行压缩，默认值为off
    compressionMinSize="2048"			# 启用压缩的输出内容大小，默认为2KB
    compressableMimeType="text/html,text/xml,text/JavaScript,text/css,text/plain"
               # 哪些资源类型需要压缩
    connectionTimeout="20000"			# 定义建立客户连接超时的时间. 如果为 -1, 表示不限制建立客户连接的时间
    redirectPort="8443"					# 如连接器不支持SSL请求，如收到SSL请求，Catalina容器将会自动重定向指定的端口号，让其进行处理							
    />
    ```

## 缓存

1. Tomcat缓存优化

   ```xml
   <Connector port="8080" protocol="HTTP/1.1"
   connectionTimeout="20000"
   redirectPort="8443"
   ```

	maxThreads="800"									# 缓存优化，作用参照上面。
	acceptCount="1000"									# 缓存优化，作用参照上面。
/>  
   ```
   
   



**参考**：[菲宇的Tomcat优化（内存，并发，缓存，安全，网络，系统等）](https://cloud.tencent.com/developer/article/1444703)


   ```