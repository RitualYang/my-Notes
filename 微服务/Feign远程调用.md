Feign调用流程

1. 构建请求数据，将对象转为json

   `RequestTemplate template = buildTemplateFromArgs.create(argv);`

2. 发送请求执行（执行成功会解码响应数据）

   `executeAndDecode(template);`

3. 执行请求发生异常会有重试机制

   ```java
   while(true){
       try{
           executeAndDecode(template);
       }catch(){
           try{
              retryer.continueOrPropagate(e); 
           }catch(){
               throw ex;
           }
           continue;
       }
   }
   ```

