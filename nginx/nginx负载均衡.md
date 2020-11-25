# 负载均衡

随着互联网信息的爆炸性增长，负载均衡（load balance ）已经不再是一个很陌生的话题顾名思义，负载均衡即是将负载分摊到不同的服务单元，既保证服务的可用性，又保证响应足够快，给用户很好的体验。快速增长的访问量和数据流量催生了各式各样的负载均衡产品，很多专业的负载均衡硬件提供了很好的功能，但却价格不菲，这使得负载均衡软件大受欢迎，nginx 就是其中的一个，在 linux 下有Nginx 、 LVS 、 Haproxy 等等服务可以提供负载均衡服务。

```shell
http {
	upstream myserver {
        ip_hash; 
        server 192.168.37.139:8801 weight=1;
        server 192.168.37.139:8802 weight=1;
        #down 不参与负载均衡
        #weight=5; 权重，越⾼分配越多
        #backup; 预留的备份服务器
        #max_fails 允许失败的次数
        #fail_timeout 超过失败次数后，服务暂停时间
        #max_coons 限制最⼤的接受的连接数
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
`ip_hash`:每个请求按访问ip的hash结果分配，这样每个访客固定访问一个后端服务器，可以解决session的问题。`url_hash`:根据每次请求的url地址，hash后访问到固定的服务器节点。
* `least_conn`:哪台服务器的连接数量最少会将新请求转发到该服务器上
注意:不能把后台服务器直接移除，只能标记down 例如：

```shell
 upstream server_pool{ 
     ip_hash; #可以使用 url_hash;
     # 哪台服务器的连接数量最少会将新请求转发到该服务器上
     #least_conn;
     server 192.168.5.21:80; 
     server 192.168.5.22:80; 
 }
```

4、fair（第三方）
按后端服务器的响应时间来分配请求，响应时间短的优先分配。

```shell
 upstream server_pool{ 
     server 192.168.5.21:80; 
     server 192.168.5.22:80; 
     fair; 
 }
```



### upstream指令参数

* `max_conns` : 服务器最大的连接数量（默认为0，不受任何限制）
* `slow_start` : 缓慢提升权重（商业版）
* `down`： 服务关闭(标识服务不可用)
* `backup` : 标识机器为备份机，当某一天机器挂掉后，备份机才会被访问(不能使用在`hash`和`random load balancing`中)
* `max_fails`:最大失败的次数，当达到后，该机器会无法被访问。
* `fail_timeout`：在一定时间内失败达到次数，该机器会宕机15秒。请求会发送到其他机器上，15秒过后，该机器重新被正常访问。

```shell
events {
    use epoll;
    worker_connections 65535;
}
http {
    ##upstream的负载均衡,四种调度算法##
    #调度算法1:轮询.每个请求按时间顺序逐⼀分配到不同的后端服务器,如果后端某台服务器宕机,故障系统被⾃动剔除,使⽤⼾访问不受影响
    upstream webhost {
        server 192.168.0.5:6666 ;
        server 192.168.0.7:6666 ;
    }
    #调度算法2:weight(权重).可以根据机器配置定义权重.权重越⾼被分配到的⼏率越⼤
    upstream webhost {
        server 192.168.0.5:6666 weight=2;
        server 192.168.0.7:6666 weight=3;
    }
    #调度算法3:ip_hash. 每个请求按访问IP的hash结果分配,这样来⾃同⼀个IP的访客固定访问⼀个后端服务器,有效解决了动态⽹⻚存在的session共享问题
    upstream webhost {
        ip_hash;
        server 192.168.0.5:6666 ;
        server 192.168.0.7:6666 ;
    }
    #调度算法4:url_hash(需安装第三⽅插件).此⽅法按访问url的hash结果来分配请求,使每个url定向到同⼀个后端服务器,可以进⼀步提⾼后端缓存服务器的效率.Nginxupstream webhost {
        server 192.168.0.5:6666 ;
        server 192.168.0.7:6666 ;
        hash $request_uri;
    }
    #调度算法5:fair(需安装第三⽅插件).这是⽐上⾯两个更加智能的负载均衡算法.此种算法可以依据⻚⾯⼤⼩和加载时间⻓短智能地进⾏负载均衡,也就是根据后端服#
    #虚拟主机的配置(采⽤调度算法3:ip_hash)
    server {
        listen 80;
        server_name mongo.demo.com;
        #对 "/" 启⽤反向代理
        location / {
            proxy_pass http://webhost;
            proxy_redirect off;
            proxy_set_header X-Real-IP $remote_addr;
            #后端的Web服务器可以通过X-Forwarded-For获取⽤⼾真实IP
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            #以下是⼀些反向代理的配置,可选.
            proxy_set_header Host $host;
            client_max_body_size 10m; #允许客⼾端请求的最⼤单⽂件字节数
            client_body_buffer_size 128k; #缓冲区代理缓冲⽤⼾端请求的最⼤字节数,
            proxy_connect_timeout 90; #nginx跟后端服务器连接超时时间(代理连接超时)
            proxy_send_timeout 90; #后端服务器数据回传时间(代理发送超时)
            proxy_read_timeout 90; #连接成功后,后端服务器响应时间(代理接收超时)
            proxy_buffer_size 4k; #设置代理服务器（nginx）保存⽤⼾头信息的缓冲区⼤⼩
            proxy_buffers 4 32k; #proxy_buffers缓冲区,⽹⻚平均在32k以下的设置
            proxy_busy_buffers_size 64k; #⾼负荷下缓冲⼤⼩（proxy_buffers*2）
            proxy_temp_file_write_size 64k;
            #设定缓存⽂件夹⼤⼩,⼤于这个值,将从upstream服务器传
    	}
	}
}
```

