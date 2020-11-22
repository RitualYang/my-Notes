

# 图形化管理界面

* 安装：

  ```shell
  docker pull portainer/portainer
  ```
运行镜像：
  ```shell
  docker run -d -p 9000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v /home/portainer_data:/data portainer/portainer
  ```

  

