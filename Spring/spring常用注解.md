# Spring常用注解

* 根据用途进行划分。

### 创建对象

 * 作用与XML配置文件中编写一个`<bean>`标签实现的功能相同。

 * `Component`:

     ```java
     @Component
     public class SpringComponent {
     }
     ```

     * 作用：用于把当前类对象存入spring容器中
     * 属性：
       * value：用于指定bean的id。当我们不写时，它的默认值是当前类名，且首字母改小写。

 * `Controller`：一般用在表现层

    ```java
    @Controller
    public class SpringController {
    }
    ```

 * `Service`：一般用在业务层

    ```java
    @Service
    public class SpringService {
    }
    ```

 * `Repository`：一般用在持久层

    ```java
    @Repository
    public class SpringDao {
    }
    ```
    
    > 以上三个注解他们的作用和属性与Component是一模一样。
    > 他们三个是spring框架为我们提供明确的三层使用的注解，使我们的三层对象更加清晰
    >
    > 需要让Spring的@ComponentScan扫描到，才能加载到Spring容器中。

### 注入数据

 * 作用与xml配置文件中的bean标签中写一个`<property>`标签的作用相同。

 * `Autowired`:

     ```java
     @Autowired
     private SpringService springService;
     ```

     * 作用：自动按照类型注入。只要容器中有唯一的一个bean对象类型和要注入的变量类型匹配，就可以注入成功

         * 如果ioc容器中没有任何bean的类型和要注入的变量类型匹配，则报错。

         * 在使用注解注入时，set方法就不是必须的了。

 * `Qualifier`:

     * 作用：在按照类中注入的基础之上再按照名称注入。它在给类成员注入时不能单独使用(与`Autowired`连用)。但是在给方法参数注入时可以。

     * 属性：

         * value：用于指定注入bean的id。

 * `Resource`:

     * 作用：直接按照bean的id注入。它可以独立使用

     * 属性：

         * name：用于指定bean的id。

    > 以上三个注入都只能注入其他bean类型的数据，而基本类型和String类型无法使用上述注解实现。
    > 集合类型的注入只能通过XML来实现。

 * `Value`:

     * 作用：用于注入基本类型和String类型的数据。

     * 属性：

         * value：用于指定数据的值。它可以使用`${表达式}`。

### 改变作用范围

 * `Scope`：
    * 作用：用于指定bean的作用范围
      
    * 属性：
      * `value`：指定范围的取值。常用取值：`singleton` ， `prototype`。

* `Profile`:

    * 作用：根据不同的环境加载配置类或bean。

        * `@Profile`标识在类上，那么只有当前环境匹配，整个配置类才会生效
        * `@Profile`标识在Bean上 ，那么只有当前环境的Bean才会被激活
        * 没有标志为`@Profile`的bean不管在什么环境都可以被激活

    * ```java
        //标识为测试环境才会被装配
        @Bean
        @Profile(value = "test")
        public DataSource testDs() {
        return buliderDataSource(new DruidDataSource());
        }
        //标识开发环境才会被激活
        @Bean
        @Profile(value = "dev")
        public DataSource devDs() {
        return buliderDataSource(new DruidDataSource());
        }
        //标识生产环境才会被激活
        @Bean
        @Profile(value = "prod")
        public DataSource prodDs() {
        return buliderDataSource(new DruidDataSource());
        }
        ```

### 生命周期方式

 * 作用与xml配置中bean标签中使用`init-method`和`destroy-methode`的作用相同。

 * `PreDestroy`：
     * 作用：用于指定销毁方法

 * `PostConstruct`：
     *          作用：用于指定初始化方法

### 指定配置

* 作用将类设置为配置类

* `Configuration`:
  
  * 作用：指定当前类是一个配置类。
  
* `ComponentScan`:
  
  ```java
  @Configuration
  @ComponentScan(basePackages = {"com.wty.spring"},
                 excludeFilters = {
  @ComponentScan.Filter(type = FilterType.ANNOTATION,value = {Controller.class})},
                 includeFilters = {
  @ComponentScan.Filter(type = FilterType.ANNOTATION,value = {Repository.class})})
  public class SpringConfig {
  }
  ```
  
  
  
  * 作用：通过注解，指定spring在创建容器时要扫描的包
  * 属性：
  * * `basePackages`：指定创建容器时扫描的包。
    * `value`：同上。
    * `excludeFilters`: `ComponentScan`扫描时排除该注解。
    * `includeFilters`: 将注解添加到`ComponentScan`扫描的范围内。（需要把`useDefaultFilters`属性设置为`false`（`true`表示扫描全部的））
  
* `bean`:
  * 作用：将当前方法 返回值作为bean对象存入到spring的IOC容器中。
  
  * 属性：
    
    * `name`：指定bean的id。默认值是当前方法的名称。
    * `initMethod`: bean初始化时调用的方法。(实现`InitializingBean`接口)(`@PostConstruct`标注的方法)
    * `destroyMethod`：bean销毁时调用的方法。(实现`DisposableBean`接口)(`@ProDestory`标注的方法)
    
  * 注意：
  
    >当使用注解配置方法时，如果方法有参数，spring框架会去容器中查找有没有可用的bean对象。查找的方法和`AutoWired`注解的作用一样。
    >
    >针对单实例bean的话，容器启动的时候，bean的对象就创建了，而且容器销毁的时候，也会调用Bean的销毁方法.
    >针对多实例bean的话,容器启动的时候，bean是不会被创建的而是在获取bean的时候被创建，而且bean的销毁不受IOC容器的管理.
  
* `Import`:
  
  * 作用：导入其他的配置类。
  
* `PropertySources`:
  * 作用：指定properties文件的位置
  * 属性：
    * value：指定文件的名称和路径。

