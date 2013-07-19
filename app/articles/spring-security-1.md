## 基于方法级别的权限控制
spring security通过用户角色的URL来限制访问,通常是用来保护Web应用程序的。然而，它也可以用在方法和类上，使编码或配置错误不允许后门进入受限制的数据。构建安全系统深入而不弄乱代码。它还允许额外的灵活性，如允许用户只能访问与他们相关的信息，而不是其他用户的信息。

下面的代码演示了基于方法基本的一部分Spring Security的展示，这个应用程序还演示各种功能和技术在后面的文章中说明。

### 基本环境
本示例基于前面搭建的环境，详情请点击。。。。。

### applicationContext-security.xml
修改applicationContext-security.xml以支持最小的spring security运行环境。
配置如下：
<!-- lang: xml -->

    <debug/>
    <http auto-config="true" use-expressions="true">
        <intercept-url pattern="/**" access="permitAll"/>
    </http>

    <authentication-manager>
        <authentication-provider>
            <user-service>
                <user name="user" password="user" authorities="ROLE_USER"/>
                <user name="admin" password="admin" authorities="ROLE_ADMIN"/>
            </user-service>
        </authentication-provider>
    </authentication-manager>

### app-servlet.xml
修改app-servlet.xml以支持Spring mvc 在这设置了global-method-security 这设置必须在spring 基本类扫描之前不然产生的对象会没有该注解效果。
配置如下：
<!-- lang: xml -->

<!-- 不过滤静态资源 -->
    <mvc:resources mapping="/resources/**" location="/resources/" order="0" />
    <mvc:resources mapping="/favicon.ico" location="/resources/img/favicon.ico" order="0"/>

    <sec:global-method-security secured-annotations="enabled" jsr250-annotations="enabled" pre-post-annotations="enabled"/>

    <!-- 自动扫描 -->
    <context:component-scan base-package="org.excalibur" ></context:component-scan>

    <!-- 定义JSP文件的位置 -->
    <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
        <property name="viewClass" value="org.springframework.web.servlet.view.JstlView" />
        <property name="prefix" value="/WEB-INF/views/jsp/"/>
        <property name="suffix" value=".jsp"/>
    </bean>

    <!-- 默认的注解映射的支持 -->
    <tx:annotation-driven />
    <mvc:annotation-driven />

### AppController
增加AppController,定义了调用业务逻辑层的代码。
代码如下：

    @Controller
    public class AppController {

    @Autowired
    private UserService userService;
    @RequestMapping(value = "/")

    public String index(){
        System.out.println("进入首页");
        return "index";
    }

    @RequestMapping(value = "/login")
    public String login(){
        System.out.println("进入首页");
        userService.login("excalibur","123456");
        return "home";
    }
    }

### web.xml
web.xml中增加spring security的过滤器
如下：

    <filter>
        <filter-name>springSecurityFilterChain</filter-name>
        <filter-class>org.springframework.web.filter.DelegatingFilterProxy</filter-class>
    </filter>
    <filter-mapping>
        <filter-name>springSecurityFilterChain</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>

### 运行
浏览器`http://localhost:8080/login`测试运行结果。

### 源码
[spring security web demo](https://github.com/excalibur/springsecuritydemo/tree/master/web-demo)



