# Springboot-hello（一）

## springboot介绍

1. 什么是SpringBoot

>Spring Boot 是所有基于 Spring 开发的项目的起点。Spring Boot 的设计是为了让你尽可能快的跑起来 Spring 应用程序并且尽可能减少你的配置文件。简单来说就是SpringBoot其实不是什么新的框架，它默认配置了很多框架的使用方式，就像maven整合了所有的jar包，spring boot整合了所有的框架（不知道这样比喻是否合适）。

2. SpringBoot四个主要特性

   1. SpringBoot Starter：他将常用的依赖分组进行了整合，将其合并到一个依赖中，这样就可以一次性添加到项目的Maven或Gradle构建中；
   2. 自动配置：SpringBoot的自动配置特性利用了Spring4对条件化配置的支持，合理地推测应用所需的bean并自动化配置他们；
   3. 命令行接口：（Command-line-interface, CLI）：SpringBoot的CLI发挥了Groovy编程语言的优势，并结合自动配置进一步简化Spring应用的开发；
   4. Actuatir：它为SpringBoot应用的所有特性构建一个小型的应用程序。但首先，我们快速了解每项特性，更好的体验他们如何简化Spring编程模型。

## springboot配置



## springboot入门案例

* 目录结构

  ```
  Springboot-helloworld
  	→src
		→main
  			→com.wty
  				→controller
  					>HelloController.java
  				>HelloApplication.java
  		→resourses
  			>application.yml
  	>pom.xml
  ```
  
* 配置`resourses/application.yml`

  ```yaml
  # 配置服务端口号
  server:
    port: 8081
  # 服务名
  spring:
    application:
      name: springboot-helloworld
  ```

* maven依赖

  ```xml
  <!--父依赖，springboot项目的依赖版本管理-->
  <parent>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-parent</artifactId>
      <version>2.1.3.RELEASE</version>
      <relativePath/>
  </parent>
  ---------------------------------------------------------------------
  <!--web服务依赖，内置了spring，springmvc，tomcat容器-->
  <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-web</artifactId>
  </dependency>
  ```

* controller

  ```java
  @RestController
  public class HelloController {
      @RequestMapping("/hello")
      public String hello(){
          return "Hello World!!!!";
      }
  }
  ```
  
* 启动类

  ```java
  @SpringBootApplication
  public class HelloApplication {
      //项目入口
      public static void main(String[] args) {
          SpringApplication.run(HelloApplication.class);
      }
  }
  ```

  