# json-server

* 安装

  `npm install json-server --save -g`

## 使用

* 新建mock文件夹，创建`data.json`,添加测试数据。

  ```json
  {
      "arr":[
      {"id":1,"name":"小明"},
      {"id":2,"name":"小明2"},
      {"id":3,"name":"小明3"},
      {"id":4,"name":"小明4"},
      {"id":5,"name":"小明5"}]
  }
  ```

* 启动：进入mock文件夹下，使用`json-server json数据的文件名 --port=4000`

  * 例： `json-server data.json --port=4000`

