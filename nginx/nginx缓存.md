## nginx缓存
```shell
# 设置缓存保存的目录 
#levels	   ⽬录分级
#keys_zone 设置共享内存以及占用的空间大小,开启的keys空间名字:空间⼤⼩(1m可以存放8000个key)
# max_size 设置缓存大小,⽬录最⼤⼤⼩(超过时，不常⽤的将被删除)
# inactive 超过此时间，没有被访问的缓存将清理
# use_temp_path 设置临时目录。 off关闭临时目录
proxy_cache_path /usr/local/nginx/upstearm_cache 
	levels=1:2 #⽬录分级
	keys_zone=mycache:5m 
	max_size=1G 
	inactive=30s 
	use_temp_path=off;

server {
	listen 80;
	server_name localhost;
	
	# 开启并且使用缓存
	proxy_cache mycache;
	# 针对200和304状态码的缓存设置过期时间
	proxy_cache_valid 		200 304 8h;
	proxy_cache_valid any 10m; #其他状态缓存10⼩时
	proxy_cache_key $host$uri$is_args$args; #设置key值
	add_header Nginx-Cache "$upstream_cache_status";
    location / {
           root /home;
           # 设置缓存过期时间
           expires 10s;
	}	
}
```

### 命令

* expires [time] : 设置缓存过期时间
* expires @[time] : 设置缓存刷新时间。
  * `expires @22h30m` : 每天22点30分刷新。
* expires -[time]: 缓存在多少时间前已经失效了。
* expires epoch ： 不使用缓存。
* expires off ： 默认配置，关闭nginx 缓存配置。
* expires max ： 设置缓存最大过期时间。