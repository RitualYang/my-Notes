# Spring常用注解

* 根据用途进行划分。

### 创建对象

 * 作用与XML配置文件中编写一个`<bean>`标签实现的功能相同。

 * `Component`:

     * 作用：用于把当前类对象存入spring容器中
     * 属性：
     * value：用于指定bean的id。当我们不写时，它的默认值是当前类名，且首字母改小写。

 * `Controller`：一般用在表现层

 * `Service`：一般用在业务层

 * `Repository`：一般用在持久层

    > 以上三个注解他们的作用和属性与Component是一模一样。
    > 他们三个是spring框架为我们提供明确的三层使用的注解，使我们的三层对象更加清晰

### 注入数据

 * 作用与xml配置文件中的bean标签中写一个`<property>`标签的作用相同。

 * `Autowired`:

     * 作用：自动按照类型注入。只要容器中有唯一的一个bean对象类型和要注入的变量类型匹配，就可以注入成功

         * 如果ioc容器中没有任何bean的类型和要注入的变量类型匹配，则报错。

     * 注意：

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

 * 作用与xml配置中bean标签中使用scope属性实现的功能相同。

 * `Scope`：
* 作用：用于指定bean的作用范围
  
* 属性：
  
    * value：指定范围的取值。常用取值：`singleton` ， `prototype`。

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
  * 作用：通过注解，指定spring在创建容器时要扫描的包
  * 属性：
  * * basePackages：指定创建容器时扫描的包。
    * value：同上。
* `bean`:
  * 作用：将当前方法 返回值作为bean对象存入到spring的ioc容器中。
  * 属性：
    * name：指定bean的id。默认值是当前方法的名称。
  * 注意：当使用注解配置方法时，如果方法有参数，spring框架会去容器中查找有没有可用的bean对象。查找的方法和AutoWired注解的作用一样。
* `Import`:
  * 作用：导入其他的配置类。
* `PropertySources`:
  * 作用：指定properties文件的位置
  * 属性：
    * value：指定文件的名称和路径。

