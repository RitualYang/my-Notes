

### JavaAgent插件介绍
JavaAgent插件化、可插拔的。Skywalking的插件分为三种：
* 引导插件：在agent的bootstrap-plugins目录下
* 内置插件：在agent的plugins目录下
* 可选插件：在agent的optional-plugins目录下

JavaAgent只会启用plugins目录下的所有插件，bootstrap-plUgins目录以及optional-plugins目录下的插件不会启用。如需
启用引导插件或可选插件，只需将JAR移到plugins目录下，如需禁用某款插件，只需从plugins目录中移除即可。

### 插件生态
#### 引导插件
目前只有两款引导插件：
* apm—jdk—http—plugin用来是．监氵则HttpURLConnection；
* apm—jdk—threading—plugin用来监氵则Callable以及Runnabl有关引导插件的功能描述，可详见：https://github.com/apach
e/skywaIking/bl0b/v6.6.O/docs/en/setup/service-agent/java—agent/README.md#bootstrap—cIass—plugins

#### 内置插件
内置插件主要用来为业界主流的技术与框架提供支持。所支持的技术&框架，详见https://github.com/apache/skywalking/blob/v6.6.0/docs/en/setup/service—agent/java—agent/Supported—list.md
#### 可选插件
关于可选插件的功能描述，可详见https://github.com/apache/skywaIking/bIob/v6.6.0/docs/en/setup/service—agent/java—agent/README.md


### 插件扩展
Skywalking生态还有一些插件扩展，例如Oracle、Resin插件等。这部分插件主要是由于许可证不兼容/限制，Skywalking无法将这部分插件直接打包到Skywalking安装包内，于是托管在这个地址：https://github.com/SkyAPM/java—plugin—extensions，前往https://github.com/SkyAPM/java—plugin—extensions/releases，下载插件JAR包
* 将JAR包挪到plugins目录即可启用。
