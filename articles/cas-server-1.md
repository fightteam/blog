### 项目背景
其实都没什么背景。主要是为了达到下面的要求。

* 别的系统可以很方便的进行单点登录与登出。
* 单点的服务端可以进行管理，可以方便的进行权限限制。
* 为了方便别的系统可以自定义登录页面
* 。。。。。。

### 参考资料
参考了一些注意的技术网站，最坑的是CAS官网被墙······，这是不是有点···。不过还好文档网站没被墙，源码也在github上。

* [CAS源码](https://github.com/Jasig/cas)
* [技术参考](https://wiki.jasig.org/display/JSG/Home)
* [CAS-server文档](https://wiki.jasig.org/display/CASUM/Home)
* [CAS-client文档](https://wiki.jasig.org/display/CASC/Home)

### 技术选择
为了追求快速构建开发，我们采用了一些成熟的开源框架。如下：

* SSO选择了Yale大学的CAS4.0.0-RC1(最新).
* 前端样式采用bootstrap(可能会扩展一下，方便我们使用的样式).
* 权限采用CAS使用的spring security。
* 别的小工具等等。

### 项目结构方式
开发的时候采用maven+jetty插件开发测试，正式使用会打包放入tomcat使用。

### 构建步骤
我会省略掉很多基础的知识。如果不知道的请`baidu`，`google`。开发人员“要会用google”。

#### 项目结构
基于maven的结构，采用一个父工程包含子项目的工程。

```
 system-integration/
              ├── server/        提供基于CAS的SSO服务
              ├── management/    管理CAS的SSO服务
              ├── client-1/      需要集成的项目
              └── client-2/      需要集成的项目  
```

#### 基础依赖
主要列出了CAS的依赖，别的依赖请参考源码。<br>

* cas-server-webapp
* cas-server-core
* cas-server-support-generic
* cas-management-webapp
* cas-server-webapp-support
* cas-server-support-oauth
* cas-server-support-jdbc       不是必须，我们采用spring data
* cas-client-core 

版本依赖的关系。一不小心就会有各种异常，建议：采用和`cas-server-webapp`相同的版本。

* spring 3.2.2.RELEASE
* hibernate 4.1.0.Final

#### server编写
server想最简的跑起来是非常简单的。
如下，修改`web.xml`:采用`cas-server-webapp`的默认
修改`deployerConfigContext.xml`，修改：
```
<bean id="primaryAuthenticationHandler"
          class="org.jasig.cas.authentication.AcceptUsersAuthenticationHandler">
        <property name="users">
            <map>
                <!-- key是用户名，value是密码 -->
                <entry key="faith" value="123456"/>
            </map>
        </property>
    </bean>
```

然后`jetty：run`测试

#### client-1编写
基于filter的配置，`web.xml`:

```
<!-- 单点登出，必须在最开头 -->
  <filter>
        <filter-name>CAS Single Sign Out Filter</filter-name>
        <filter-class>org.jasig.cas.client.session.SingleSignOutFilter</filter-class>
    </filter>
<!-- 单点登录 -->
    <filter>
        <filter-name>CAS Authentication Filter</filter-name>
        <filter-class>org.jasig.cas.client.authentication.AuthenticationFilter</filter-class>
        <init-param>
            <param-name>casServerLoginUrl</param-name>
            <param-value>http://localhost:8080/cas/login</param-value>
        </init-param>
        <init-param>
            <param-name>serverName</param-name>
            <param-value>http://localhost:8080</param-value>
        </init-param>
    </filter>
<!-- ticket验证 -->
    <filter>
        <filter-name>CAS Validation Filter</filter-name>
        <filter-class>org.jasig.cas.client.validation.Cas20ProxyReceivingTicketValidationFilter</filter-class>
        <init-param>
            <param-name>casServerUrlPrefix</param-name>
            <param-value>http://localhost:8080/cas</param-value>
        </init-param>
        <init-param>
            <param-name>serverName</param-name>
            <param-value>http://localhost:8080</param-value>
        </init-param>
    </filter>
    <!-- 客户端可以采用request.getUserPrincipal获取信息 -->
    <filter>
        <filter-name>CAS HttpServletRequest Wrapper Filter</filter-name>
        <filter-class>org.jasig.cas.client.util.HttpServletRequestWrapperFilter</filter-class>
    </filter>
 <!-- 客户端存放Assertion到ThreadLocal中 -->
    <filter>
        <filter-name>CAS Assertion Thread Local Filter</filter-name>
        <filter-class>org.jasig.cas.client.util.AssertionThreadLocalFilter</filter-class>
    </filter>


    <filter-mapping>
        <filter-name>CAS Single Sign Out Filter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>

    <filter-mapping>
        <filter-name>CAS Authentication Filter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>

    <filter-mapping>
        <filter-name>CAS Validation Filter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>

    <filter-mapping>
        <filter-name>CAS HttpServletRequest Wrapper Filter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>

    <filter-mapping>
        <filter-name>CAS Assertion Thread Local Filter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>

    <listener>
        <listener-class>org.jasig.cas.client.session.SingleSignOutHttpSessionListener</listener-class>
    </listener>

```

#### client-2编写
基于spring的配置，配置同client-1，增加了spring mvc。`web.xml`:

```
 <context-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>classpath:applicationContext.xml</param-value>
    </context-param>

    <filter>
        <filter-name>CAS Single Sign Out Filter</filter-name>
        <filter-class>org.springframework.web.filter.DelegatingFilterProxy</filter-class>
        <init-param>
            <param-name>targetBeanName</param-name>
            <param-value>casSingleSignOutFilter</param-value>
        </init-param>
    </filter>

    <filter>
        <filter-name>CAS Authentication Filter</filter-name>
        <filter-class>org.springframework.web.filter.DelegatingFilterProxy</filter-class>
        <init-param>
            <param-name>targetBeanName</param-name>
            <param-value>authenticationFilter</param-value>
        </init-param>
    </filter>

    <filter>
        <filter-name>CAS Validation Filter</filter-name>
        <filter-class>org.springframework.web.filter.DelegatingFilterProxy</filter-class>
        <init-param>
            <param-name>targetBeanName</param-name>
            <param-value>validationFilter</param-value>
        </init-param>
    </filter>

    <filter>
        <filter-name>CAS HttpServletRequest Wrapper Filter</filter-name>
        <filter-class>org.springframework.web.filter.DelegatingFilterProxy</filter-class>
        <init-param>
            <param-name>targetBeanName</param-name>
            <param-value>wrapperFilter</param-value>
        </init-param>
    </filter>


    <filter-mapping>
        <filter-name>CAS Single Sign Out Filter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>

    <filter-mapping>
        <filter-name>CAS Authentication Filter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>

    <filter-mapping>
        <filter-name>CAS Validation Filter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>

    <filter-mapping>
        <filter-name>CAS HttpServletRequest Wrapper Filter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>
    <listener>
        <listener-class>org.jasig.cas.client.session.SingleSignOutHttpSessionListener</listener-class>
    </listener>
    <listener>
        <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
    </listener>

    <listener>
        <listener-class>org.springframework.web.util.IntrospectorCleanupListener</listener-class>
    </listener>



    <!-- UTF-8 encoding filter -->
    <filter>
        <filter-name>encodingFilter</filter-name>
        <filter-class>
            org.springframework.web.filter.CharacterEncodingFilter
        </filter-class>
        <init-param>
            <param-name>encoding</param-name>
            <param-value>UTF-8</param-value>
        </init-param>
        <init-param>
            <param-name>forceEncoding</param-name>
            <param-value>true</param-value>
        </init-param>
    </filter>
    <filter-mapping>
        <filter-name>encodingFilter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>


    <!-- Web App Dispatcher -->
    <servlet>
        <servlet-name>app</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
        <load-on-startup>1</load-on-startup>
    </servlet>

    <servlet-mapping>
        <servlet-name>app</servlet-name>
        <url-pattern>/</url-pattern>
    </servlet-mapping>
```

#### server management编写
简单运行，修改`managementConfigContext.xml`:

```
<!-- name是帐号 -->
 <sec:user-service id="userDetailsService">
        <sec:user name="@@THIS SHOULD BE REPLACED@@" password="notused" authorities="ROLE_ADMIN" />
    </sec:user-service>
```

注意management编写依赖于cas服务的登录，请把cas服务放在cas/的contentpath下。management在cas-management下。

完成上面的工作，一个完整的简单cas就算完成了。






