# mybatis使用存储过程

* 创建存储过程

  ```mysql
  CREATE DEFINER=`root`@`localhost` PROCEDURE `select_user_count`(out userCount INTEGER,OUT postCount INTEGER)
  BEGIN
  	#Routine body goes here...
  	SELECT count(*) as userCount from tb_sys_user into userCount;
  	SELECT count(*) as postCount from tb_posts_post into postCount;
  END
  ```

* 创建对象

  ```java
  public class CountVo implements Serializable {
      private static final long serialVersionUID = 1481563278090175522L;
      private Integer userCount;
      private Integer postCount;
      //toString,get,set........
  }
  ```

* 注解使用（不可设置数据为只读，不然out会报错的）

```java
@Select({"call select_user_count(#{userCount,mode=OUT,jdbcType=INTEGER},#{postCount,mode=OUT,jdbcType=INTEGER})"})
    @Options(statementType = StatementType.CALLABLE)
    void getCount(CountVo countVo);
```
* xml调用

  ```xml
  <select id="getCount" parameterType="com.base.CountVo" statementType="CALLABLE">
  		{call select_user_count(
  		#{userCount,mode=OUT,jdbcType=INTEGER},
      	#{postCount,mode=OUT,jdbcType=INTEGER})}
  </select>
  ```

* service层调用

  ```java
  CountVo countVo = new CountVo();
  tbSysUserMapper.getCount(countVo);
  System.out.println(countVo.toString());
  ```

  