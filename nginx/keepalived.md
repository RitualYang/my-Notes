```shell
http {
	upstream myserver {
        server 192.168.37.139:8801 weight=1;
        server 192.168.37.139:8802 weight=1;
        keepalive 32;
	}
	server {
		location / {
			proxy_pass http://myserver;
			proxy_connect_timeout 10;
			# 配合keepalive
			proxy_http_version 1.1;   
			proxy_set_header Connection "";
		}
	}
}
```

