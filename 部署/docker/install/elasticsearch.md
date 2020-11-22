# elasticsearch

## 安装

```shell
docker pull elasticsearch:7.4.2
docker pull kibana:7.4.2
```

* 创建挂载目录

  ```shell
  mkdir -p /mydata/elasticsearch/config
  mkdir -p /mydata/elasticsearch/data
  # 修改配置文件
  vi /mydata/elasticsearch/config/elasticsearch.yml
  # http.host: 0.0.0.0
  # http.cors.enabled: true
  # http.cors.allow-origin: "*"
  # 为挂在目录 修改访问权限
  chmod -R 777 /mydata/elasticsearch/
  ```
  
* 启动容器

  ```shell
  docker run --name elasticsearch -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" -e ES_JAVA_OPTS="-Xms256m -Xmx512m" -v /mydata/elasticsearch/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml -v /mydata/elasticsearch/data:/usr/share/elasticsearch/data -v /mydata/elasticsearch/plugins:/usr/share/elasticsearch/plugins -d elasticsearch:7.4.2
  ```

  

# kibana

* 启动容器

  ```shell
  docker run --name kibana --link=elasticsearch  -p 5601:5601 -d kibana:7.4.2
  ```

  

* 数据地址：[https://raw.githubusercontent.com/elastic/elasticsearch/master/docs/src/test/resources/accounts.json]

## ik分词器

* 进入es容器内部的plugins目录

  `docker exec -it elasticsearch /bin/bash`

* 安装elasticsearch-analyis-ik

```shell
wget https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v7.4.2/elasticsearch-analysis-ik-7.4.2.zip
```




* 解压删除下载的文件,下载到plugins/ik下

  ```shell
  unzip elasticsearch-analysis-ik-7.4.2.zip
  rm -rf *.zip
  ```

* 进入容器内部，通过插件安装

  ```shell
  cd bin/
  elasticsearch-plugin -h
  elasticsearch-plugin list
  ## 重启es
  docker restart elasticsearch
  ```

  