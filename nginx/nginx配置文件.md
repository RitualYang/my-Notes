# nginx配置文件

* 全局块
	
> 设置影响nginx服务器运行的配置命令配置运行Nginx服务器的用户（组）,运行生成的worker_process数进程PID存放路径，日志存放路径，类型以及配置文件的引入。

* events块
	
  > 主要影响 Nginx 服务器与用户的网络连接，常用的设置包括是否开启对多 work process 下的网络连接进行序列化，是否允许同时接收多个网络连接，选取哪种事件驱动模型来处理连接请求，每个 word process 可以同时支持的最大连接数等。
  
  * http块
  
    > 代理、缓存和日志定义等绝大多数功能和第三方模块的配置。
    
    * http全局块
    
      > 文件引入、MIME-TYPE 定义、日志自定义、连接超时时间、单链接请求数上限等
    
    * server块
      * 全局server块
      
        > 本虚拟机主机的监听配置和本虚拟主机的名称或IP配置。
      
      * location块
      
        >基于 Nginx 服务器接收到的请求字符串（例如 server_name/uri-string），对虚拟主机名称（也可以是IP别名）之外的字符串（例如 前面的 /uri-string）进行匹配，对特定的请求进行处理。地址定向、数据缓存和应答控制等功能，还有许多第三方模块的配置也在这里进行。

```shell
#user  nobody;
# 全局块
# 处理并发数的配置
worker_processes  1;

# error_log logs/error_log;
# error_log logs/error_log notice;
# error_log logs/error_log info;

# pid 		logs/nginx.pid;

# events块
events {
	# 支持的最大连接数
    worker_connections  1024;
}

# http块
http {
# http全局块
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
   
    keepalive_timeout  65;

    gzip  on;
	
	# server块：
	server {
		# 全局server块
        listen       80;
        server_name  www.manage.com;

        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Server $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		
		# location块
        location / {
			proxy_pass http://127.0.0.1:9001;
			proxy_connect_timeout 600;
			proxy_read_timeout 600;
        }
    }
}
```



#### location指令说明

```shell
location [ = | ~ | ~* | ^~ ] url {
}
```

1. `=` ：用于不含正则表达式的 url 前，要求请求字符串与 url 严格匹配，如果匹配成功，就停止继续向下搜索并立即处理该请求。

2. `~`：用于表示 url 包含正则表达式，并且区分大小写。 

3. `~*`：用于表示 url 包含正则表达式，并且不区分大小写。 

4. `^~`：用于不含正则表达式的 url 前，要求 Nginx 服务器找到标识 uri 和请求字符串匹配度最高的 location 后，立即使用此 location 处理请求，而不再使用 location 块中的正则 url 和请求字符串做匹配。

* 注意：如果 url 包含正则表达式，则必须要有 `~ `或者 `~*`标识。

