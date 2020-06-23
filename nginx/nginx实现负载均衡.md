# 负载均衡

随着互联网信息的爆炸性增长，负载均衡（load balance ）已经不再是一个很陌生的话题顾名思义，负载均衡即是将负载分摊到不同的服务单元，既保证服务的可用性，又保证响应足够快，给用户很好的体验。快速增长的访问量和数据流量催生了各式各样的负载均衡产品，很多专业的负载均衡硬件提供了很好的功能，但却价格不菲，这使得负载均衡软件大受欢迎，nginx 就是其中的一个，在 linux 下有Nginx 、 LVS 、 Haproxy 等等服务可以提供负载均衡服务。

```json
http {
	upstream myserver {
        ip_hash;
        server 192.168.37.139:8801 weight=1;
        server 192.168.37.139:8802 weight=1;
	}
	server {
		location / {
			proxy_pass http://myserver;
			proxy_connect_timeout 10;
		}
	}
}
```



1、轮询（默认）
每个请求按时间顺序逐一分配到不同的后端服务器，如果后端服务器down掉，能自动剔除。
2、weight
weight
代表权 重默认为 1, 权重越高被分配的客户端越多
指定轮询几率，weight和访问比率成正比，用于后端服务器性能不均的情况。 例如：

```
upstream server_pool{ 
	server 192.168.5.21 weight=10; 
	server 192.168.5.22 weight=10; 
}
```

3、ip_hash
每个请求按访问ip的hash结果分配，这样每个访客固定访问一个后端服务器，可以解决session的问题。 例如：

```
 upstream server_pool{ 
     ip_hash; 
     server 192.168.5.21:80; 
     server 192.168.5.22:80; 
 }
```

4、fair（第三方）
按后端服务器的响应时间来分配请求，响应时间短的优先分配。

```json
 upstream server_pool{ 
     server 192.168.5.21:80; 
     server 192.168.5.22:80; 
     fair; 
 }
```



