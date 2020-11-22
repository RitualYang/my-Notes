# nginx配置文件

* 全局块
	
> 设置影响nginx服务器运行的配置命令配置运行Nginx服务器的用户（组）,运行生成的worker_process数进程PID存放路径，日志存放路径，类型以及配置文件的引入。

* events块
	
  > 主要影响 Nginx 服务器与用户的网络连接，常用的设置包括是否开启对多 work process 下的网络连接进行序列化，是否允许同时接收多个网络连接，选取哪种事件驱动模型来处理连接请求，每个 word process 可以同时支持的最大连接数等。（设置工作模式，连接数上限）
  
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
# 全局块
#user  nobody; # worker进程的运行用户

# 处理并发数的配置,建议设置为等于CPU总核心数
worker_processes  2;
# 全局错误日志定义类型。日志级别：dubug info notice warn error crit
# error_log logs/error_log;
# error_log logs/error_log notice;
# error_log logs/error_log info;

# 进程文件
# pid 		logs/nginx.pid;
#⼀个nginx进程打开的最多⽂件描述符数⽬,理论值应该是最多打开⽂件数（系统的值ulimit -n）与nginx进程数相除,但是nginx分配请求并不均匀,所以建议与ulimit -n 相同
worker_rlimit_nofile 65535;

# events块
events {
# 参考事件模型,use [ kqueue | rtsig | epoll | /dev/poll | select | poll ]; epoll模型是Linux 2.6以上版本内核中的⾼性能⽹络I/O模型,如果跑在FreeBSD上⾯,就⽤use epoll;
	# 默认使用epoll
	use epoll;
	# 每个worker允许连接的客户端最大连接数(最大连接数= 连接数 * 进程数)
    worker_connections  1024;
}

# http块
http {
# http全局块
	# 导入外部的配置文件
    include       mime.types;
    # 默认的连接类型
    default_type  application/octet-stream;
    #charset utf-8; #默认编码
	server_names_hash_bucket_size 128; #服务器名字的hash表⼤⼩
	client_header_buffer_size 32k; #上传⽂件⼤⼩限制
	large_client_header_buffers 4 64k; #设定请求缓
	client_max_body_size 8m; #设定请求缓
	
	# 开启⽬录列表访问,合适下载服务器,默认关闭.
	autoindex on; # 显⽰⽬录
	autoindex_exact_size on; # 显⽰⽂件⼤⼩ 默认为on,显⽰出⽂件的确切⼤⼩,单位是bytes 改为off后,显⽰出⽂件的⼤概⼤⼩,单位是kB或者MB或者GB
	autoindex_localtime on; # 显⽰⽂件时间 默认为off,显⽰的⽂件时间为GMT时间 改为on后,显⽰的⽂件时间为⽂件的服务器时间
	
    # 日志格式
    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';
		
	# http日志
    #access_log  logs/access.log  main;
    
    # 开启⾼效⽂件传输模式,sendfile指令指定nginx是否调⽤sendfile函数来输出⽂件,对于普通应⽤设为 on,如果⽤来进⾏下载等应⽤磁盘IO重负载应
    sendfile on; 
    tcp_nopush on; # 防⽌⽹络阻塞，当传输的数据包累计到一定大小后,在进行发送
	tcp_nodelay on; # 防⽌⽹络阻塞

	# 连接超时时间(单位s)设置客⼾端连接保持活动的超时时间,在超过这个时间后服务器会关闭该链接
    keepalive_timeout  65;

	# FastCGI相关参数是为了改善⽹站的性能：减少资源占⽤,提⾼访问速度.下⾯参数看字⾯意思都能理解.
	fastcgi_connect_timeout 300;
	fastcgi_send_timeout 300;
	fastcgi_read_timeout 300;
	fastcgi_buffer_size 64k;
	fastcgi_buffers 4 64k;
	fastcgi_busy_buffers_size 128k;
	fastcgi_temp_file_write_size 128k;


	# gzip模块设置
	gzip on; #开启gzip压缩输出
	gzip_min_length 1k; #允许压缩的⻚⾯的最⼩字节数,⻚⾯字节数从header偷得content-length中获取.默认是0,不管⻚⾯多⼤都进⾏压缩.建议设置成⼤于1k的gzip_buffers 4 16k; #表⽰申请4个单位为16k的内存作为压缩结果流缓存,默认值是申请与原始数据⼤⼩相同的内存空间来存储gzip压缩结果
	gzip_http_version 1.1; #压缩版本（默认1.1,⽬前⼤部分浏览器已经⽀持gzip解压.前端如果是squid2.5请使⽤1.0）
	gzip_comp_level 2; #压缩等级.1压缩⽐最⼩,处理速度快.9压缩⽐最⼤,⽐较消耗cpu资源,处理速度最慢,但是因为压缩⽐最⼤,所以包最⼩,传输速度快
	gzip_types text/plain application/x-javascript text/css application/xml;
#压缩类型,默认就已经包含text/html,所以下⾯就不⽤再写了,写上去也不会有问题,但是会有⼀个warn.
	gzip_vary on;#选项可以让前端的缓存服务器缓存经过gzip压缩的⻚⾯.例如:⽤squid缓存经过nginx压缩的数据
    
    #开启限制IP连接数的时候需要使⽤
	#limit_zone crawler $binary_remote_addr 10m;
	
	# server块：
	server {
		# 全局server块
		# 监听端口
        listen       80;
        # 监听ip：localhost,ip,域名。域名可以有多个,⽤空格隔开
        server_name  www.manage.com;
		# HTTP ⾃动跳转 HTTPS
		# rewrite ^(.*) https://$server_name$1 permanent;
		
		
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Server $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		
		# location块
        location / {
			proxy_pass http://127.0.0.1:9001;
			proxy_connect_timeout 600;
			proxy_read_timeout 600;
        }
        location /mac {
        	root /home;
        }
    }
    server {
        # 监听端⼝ HTTPS
        listen 443 ssl;
        server_name ably.com;
        # 配置域名证书
        ssl_certificate C:\WebServer\Certs\certificate.crt;
        ssl_certificate_key C:\WebServer\Certs\private.key;
        ssl_session_cache shared:SSL:1m;
        ssl_session_timeout 5m;
        ssl_protocols SSLv2 SSLv3 TLSv1;
        ssl_ciphers ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP;
        ssl_prefer_server_ciphers on;
        index index.html index.htm index.php;
        root /data/www/;
        location ~ .*\.(html|HTML)?$ {
            fastcgi_pass 127.0.0.1:9000;
            fastcgi_index index.php;
            include fastcgi.conf;
    	}
    
        # 配置地址拦截转发，解决跨域验证问题
        location /oauth/{
            proxy_pass https://localhost:13580/oauth/;
            proxy_set_header HOST $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
        # 图⽚缓存时间设置
        location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$ {
            expires 10d;
        }
        # JS和CSS缓存时间设置
        location ~ .*\.(js|css)?$ {
            expires 1h;
        }
        # 设定查看Nginx状态的地址.StubStatus模块能够获取Nginx⾃上次启动以来的⼯作状态，此模块⾮核⼼模块，需要在Nginx编译安装时⼿⼯指定才能使⽤
        location /NginxStatus {
            stub_status on;
            access_log on;
            auth_basic "NginxStatus";
            auth_basic_user_file conf/htpasswd;
            #htpasswd⽂件的内容可以⽤apache提供的htpasswd⼯具来产⽣.
        }
	}
}
```

#### alias和root的区别

```shell
location /request_path/image/ {
	root /local_path/image/;
}
#当我们访问 http://xxx.com/request_path/image/cat.png时
#将访问 http://xxx.com/request_path/image/local_path/image/cat.png 下的⽂件
location /request_path/image/ {
	alias /local_path/image/;
}
#当我们访问 http://xxx.com/request_path/image/cat.png时
#将访问 http://xxx.com/local_path/image/cat.png 下的⽂件
```



#### location指令说明

```shell
location [ = | ~ | ~* | ^~ ] url {
}
```

1. `=` ：用于不含正则表达式的 url 前，要求请求字符串与 url 严格匹配，如果匹配成功，就停止继续向下搜索并立即处理该请求。(精准匹配)

2. `~`：用于表示 url 包含正则表达式，并且区分大小写。 

3. `~*`：用于表示 url 包含正则表达式，并且不区分大小写。 

4. `^~`：用于不含正则表达式的 url 前，要求 Nginx 服务器找到标识 uri 和请求字符串匹配度最高的 location 后，立即使用此 location 处理请求，而不再使用 location 块中的正则 url 和请求字符串做匹配。

* 注意：如果 url 包含正则表达式，则必须要有 `~ `或者 `~*`标识。

