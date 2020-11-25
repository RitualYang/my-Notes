# 反向代理

```shell
#在nginx中配置proxy_pass代理转发时，如果在proxy_pass后⾯的url加/，表⽰绝对根路径；如果没有/，表⽰相对路径，把匹配的路径部分也给代理
server {
	listen		80;
	server_name	www.123.com;
	
	location / {
		proxy_pass 	http://127.0.0.1:8080;
		index		index.html index.htm index.jsp;
    	proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr; #获取客⼾端真实IP
        proxy_connect_timeout 30; #超时时间
        proxy_send_timeout 60;
        proxy_read_timeout 60;
        proxy_buffer_size 32k;
        proxy_buffering on; #开启缓冲区,减少磁盘io
        proxy_buffers 4 128k;
        proxy_busy_buffers_size 256k;
        proxy_max_temp_file_size 256k; #当超过内存允许储蓄⼤⼩，存到⽂件
	}
}
```

```shell
server {
	listen		800;
	location ~ /www/ {
		proxy_pass http://localhost:8001;
	}
	location ~ /web/ {
		proxy_pass http://localhost:8002;
	}
}
```
### nginx解决跨域
```shell
#允许跨域请求的域，*代表所有
add_header 'Access-control-allow-0rigin' *;
#允许带上cookie请求
add header 'Access-control-allow-credentials' 'true';
#允许请求的方法，比如GET/POST/PUT/ DELETE
add header 'Access-control-allow-methods' *;
#允许请求的 header
add header 'Access-control-allow-headers' *;
```

### nginx防盗链配置支持
```shell
#对源站点验证
valid_referers *.taobao.com
#非法引入会进入下方判断
if ($invalid_referer) {
return 404
}
```
