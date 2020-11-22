# 安装gitlab

## 安装gitlab

* 搜索镜像：`docker search gitlab`

* 下拉镜像：英文版：`docker pull gitlab/gitlab-ce`，中文版：`docker pull twang2218/gitlab-ce-zh `

## 启动gitlab

### docker原生启动

```shell
# 英文
docker run -d  -p 443:443 -p 80:80 -p 222:22 --name gitlab --restart always -v /home/gitlab/config:/etc/gitlab -v /home/gitlab/logs:/var/log/gitlab -v /home/gitlab/data:/var/opt/gitlab gitlab/gitlab-ce
# 中文
docker run -d  -p 443:443 -p 80:80 -p 222:22 --name gitlab-zh --restart always -v /home/gitlabzh/config:/etc/gitlab -v /home/gitlabzh/logs:/var/log/gitlab -v /home/gitlabzh/data:/var/opt/gitlab twang2218/gitlab-ce-zh
```

#### 配置

```shell
vim /home/gitlab/config/gitlab.rb



# 配置http协议所使用的访问地址,不加端口号默认为80
external_url 'http://192.168.199.231'

# 配置ssh协议所使用的访问地址和端口
gitlab_rails['gitlab_ssh_host'] = '192.168.199.231'
gitlab_rails['gitlab_shell_ssh_port'] = 222 # 此端口是run时22端口映射的222端口
:wq #保存配置文件并退出
# 重启服务
docker restart gitlab
```