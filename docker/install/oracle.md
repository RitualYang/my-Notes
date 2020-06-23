# orcale
安装：

```shell
docker pull jaspeen/oracle-11g
```

运行容器：


```shell
docker run --privileged --name oracle11g -p 1521:1521 -v /install/database:/install jaspeen/oracle-11g
```

需要安装https://www.oracle.com/database/technologies/oracle-database-software-downloads.html。