### SpringMVC流程

![img](https://img-blog.csdn.net/20181012144614991?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3hoZjg1Mjk2Mw==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

1、 用户发送请求至前端控制器`DispatcherServlet`。

2、 `DispatcherServlet`收到请求调用`HandlerMapping`处理器映射器。

3、 处理器映射器找到具体的处理器(可以根据`xml`配置、注解进行查找)，生成处理器对象及处理器拦截器(如果有则生成)一并返回给`DispatcherServlet`。

4、 `DispatcherServlet`调用`HandlerAdapter`处理器适配器。

5、 `HandlerAdapter`经过适配调用具体的处理器(`Controller`，也叫后端控制器)。

6、 `Controller`执行完成返回`ModelAndView`。

7、 `HandlerAdapter`将`controller`执行结果`ModelAndView`返回给`DispatcherServlet`。

8、 `DispatcherServlet`将`ModelAndView`传给`ViewReslover`视图解析器。

9、 `ViewReslover`解析后返回具体`View`。

10、`DispatcherServlet`根据`View`进行渲染视图（即将模型数据填充至视图中）。

11、`DispatcherServlet`响应用户。



### 请求转发与重定向

* `forword`(请求转发): 

  1、属于转发，也是服务器跳转，相当于方法调用，在执行当前文件的过程中转向执行目标文件，两个文件(当前文件和目标文件)属于同一次请求，前后页共用一个request，可以通过此来传递一些数据或者session信息，request.setAttribute()和request.getAttribute()。

  2、在前后两次执行后，地址栏不变，仍是当前文件的地址。

  3、不能转向到本web应用之外的页面和网站，所以转向的速度要快。

  4、URL中所包含的“/”表示应用程序(项目)的路径。  

* `redirect`(重定向):

  1、属于重定向，也是客户端跳转，相当于客户端向服务端发送请求之后，服务器返回一个响应，客户端接收到响应之后又向服务端发送一次请求，一共是2次请求，前后页不共用一个request，不能读取转向前通过request.setAttribute()设置的属性值。

  2、在前后两次执行后，地址栏发生改变，是目标文件的地址。

  3、可以转向到本web应用之外的页面和网站，所以转向的速度相对要慢。

  4、URL种所包含的"/"表示根目录的路径。