# 反向代理

```json
server {
	listen		80;
	server_name	www.123.com;
	
	location / {
		proxy_pass 	http://127.0.0.1:8080;
		index		index.html index.htm index.jsp;
	}
}
```

```json
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

