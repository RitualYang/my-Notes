# 安装nginx

## 安装nginx

* 搜索镜像：`docker search nginx`

* 下拉镜像：`docker pull nginx:version`

## 启动nginx

### docker原生启动

* 基础版：

  ```shell
  docker run -p 80:80 --name nginx -d nginx
  # -p 80:80 :将主机的80端口映射到容器的80端口
  # --name nginx :设置容器名为nginx
  # -d  : 后台启动
  # 使用
  访问 : ip:80   或  ip
  ```
  
* 进阶版：

  * 准备工作：

    ```shell
    docker container cp nginx:/etc/nginx .
    mv nginx conf
    mkdir nginx
    mv conf nginx/
    
  ```
  
  ```shell
  docker run -p 80:80 --name nginx -v /mydata/nginx/nginx.conf:/etc/nginx -v /mydata/nginx/logs:/var/log/nginx -v /mydata/nginx/html:/usr/share/nginx/html -d nginx
  ```

### docker-compose启动

* 准备工作：

  ```shell
  vim /mydata/nginx/docker-compose.yml
  
  version: "3"
  services:
    nginx:
      image: nginx
      container_name: nginx
      ports:
        # 端口映射
        - 80:80
      volumes:
        # 目录映射
        - ./conf:/etc/nginx
        # - ./www:/usr/share/nginx/html
  ```
  
  
  
  
  
#### nginx.conf常用配置

```shell
#user  nobody;
worker_processes  1;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #gzip  on;
    # 配置负载均衡
    #upstream service-name{
    #weight         参数用于制定轮询的几率，weight默认值为1；weight的数值和被访问的几率成正比。
    #fail_timeout	与max_fails结合使用
	#max_fails	    设置在fail_timeout参数设置的时间内最大失败次数，如果在这个时间内，所有针对该服务器的请求都失败了，那么认为该服务器会被认为是停机了
    #fail_time	    服务器会被认为停机的时间长度,默认为10s。
    #backup	        标记该服务器为备用服务器。当主服务器停止时，请求会被发送到它这里。
    #down	        标记服务器永久停机了。
    #    server 192.168.37.133:8001 weight=2;
    #    server 192.168.37.133:8002 backup;
    #    server 192.168.37.133:8003 max_fails=3 fail_timeout=20s;
    #}
    server {
        listen       80;
        server_name  localhost;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {
            root   html;
            index  index.html index.htm;
        }
        #与负载均衡配置连用
        #location / {
        #   proxy_pass http://service-name;
        #}

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }

        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
        #
        #location ~ \.php$ {
        #    proxy_pass   http://127.0.0.1;
        #}

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        #location ~ \.php$ {
        #    root           html;
        #    fastcgi_pass   127.0.0.1:9000;
        #    fastcgi_index  index.php;
        #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        #    include        fastcgi_params;
        #}

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #    deny  all;
        #}
    }


    # another virtual host using mix of IP-, name-, and port-based configuration
    #
    #server {
    #    listen       8000;
    #    listen       somename:8080;
    #    server_name  somename  alias  another.alias;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}


    # HTTPS server
    #
    #server {
    #    listen       443 ssl;
    #    server_name  localhost;

    #    ssl_certificate      cert.pem;
    #    ssl_certificate_key  cert.key;

    #    ssl_session_cache    shared:SSL:1m;
    #    ssl_session_timeout  5m;

    #    ssl_ciphers  HIGH:!aNULL:!MD5;
    #    ssl_prefer_server_ciphers  on;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}
}
```

