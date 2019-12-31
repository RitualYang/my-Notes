# tomcat优化

## 内存

1.  Tomcat内存优化主要是对 tomcat 启动参数优化，可以在 Tomcat_HOME/bin/catalina.sh 中设置 java_OPTS 参数。

   ```shell
    JAVA_OPTS参数说明
    	　　-server 启用jdk 的 server 版
    	　　-Xms java虚拟机初始化时的最小内存
    	　　-Xmx java虚拟机可使用的最大内存
    	　　-XX: PermSize 内存永久保留区域
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
    enableLookups="false"				# 调用request、getRemoteHost()执行DNS查询，以返回远程主机的主机名，如果设置为false，则直接返回IP地址
    disableUploadTimeout="true"			# 允许Servlet容器，正在执行使用一个较长的连接超时值，以使Servlet有较长的时间来完成它的执行，默认值为false
    connectionTimeout="20000"			# 设置连接的超时值，以毫秒为单位
    acceptCount="300"					# 当所有的可能处理的线程都正在使用时，在队列中排队请求的最大数目。当队列已满，任何接收到的请求都会被拒绝，默认值为10
    maxThreads="300"					# 最大线程数，即同时处理的任务个数，默认值为200 , Tomcat使用线程来处理接收的每个请求。这个值表示Tomcat可创建的最大的线程数，即最大并发数
    maxProcessors="1000"				# 服务器同时最大处理线程数
    minProcessors="5"					# 服务器创建时的最小处理线程数
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

~~~xml
```xml
<Connector port="8080" protocol="HTTP/1.1"
connectionTimeout="20000"
redirectPort="8443"
maxThreads="800"									# 缓存优化，作用参照上面。
acceptCount="1000"									# 缓存优化，作用参照上面。
/>  
```
~~~

2. **这两个值如何起作用，请看下面三种情况**

情况1：接受一个请求，此时tomcat起动的线程数没有到达maxThreads，tomcat会起动一个线程来处理此请求。

情况2：接受一个请求，此时tomcat起动的线程数已经到达maxThreads，tomcat会把此请求放入等待队列，等待空闲线程。

情况3：接受一个请求，此时tomcat起动的线程数已经到达maxThreads，等待队列中的请求个数也达到了acceptCount，此时tomcat会直接拒绝此次请求，返回connection refused

3. **如何配置**

一般的服务器操作都包括量方面：1计算（主要消耗cpu），2等待（io、数据库等）

第一种极端情况，如果我们的操作是纯粹的计算，**那么系统响应时间的主要限制就是cpu的运算能力，此时maxThreads应该尽量设的小，降低同一时间内争抢cpu的线程个数，**可以提高计算效率，提高系统的整体处理能力。
第二种极端情况，**如果我们的操作纯粹是IO或者数据库，那么响应时间的主要限制就变为等待外部资源，此时maxThreads应该尽量设的大，这样才能提高同时处理请求的个数，从而提高系统整体的处理能力。**此情况下因为tomcat同时处理的请求量会比较大，所以需要关注一下tomcat的虚拟机内存设置和linux的open file限制。
我在测试时遇到一个问题，**maxThreads**我设置的比较大比如3000，当服务的线程数大到一定程度时，一般是2000出头，单次请求的响应时间就会急剧的增加，
百思不得其解这是为什么，四处寻求答案无果，最后我总结的原因可能是**cpu在线程切换时消耗的时间随着线程数量的增加越来越大，**
cpu把大多数时间都用来在这2000多个线程直接切换上了，当然cpu就没有时间来处理我们的程序了。
以前一直简单的认为多线程=高效率。。其实多线程本身并不能提高cpu效率，线程过多反而会降低cpu效率。
当cpu核心数<线程数时，cpu就需要在多个线程直接来回切换，以保证每个线程都会获得cpu时间，即通常我们说的并发执行。
所以**maxThreads**的配置绝对不是越大越好。
现实应用中，我们的操作都会包含以上两种类型（计算、等待），所以maxThreads的配置并没有一个最优值，一定要根据具体情况来配置。
最好的做法是：在不断测试的基础上，不断调整、优化，才能得到最合理的配置。
***\*acceptCount\**的配置**，我一般是设置的跟maxThreads一样大，这个值应该是主要根据应用的访问峰值与平均值来权衡配置的。
**如果设的较小，可以保证接受的请求较快相应，但是超出的请求可能就直接被拒绝**
**如果设的较大，可能就会出现大量的请求超时的情况，因为我们系统的处理能力是一定的。**
maxThreads 配置要结合 JVM -Xmx 参数调整，也就是要考虑内存开销。

## 安全

## 网络

## 系统





**参考**：[菲宇的Tomcat优化（内存，并发，缓存，安全，网络，系统等）](https://cloud.tencent.com/developer/article/1444703)

