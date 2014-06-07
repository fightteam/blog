[apache-license2]:http://www.apache.org/licenses/LICENSE-2.0
# blog

基于yeoman结构，采用backbone、requirejs、bootstrap、sass等的静态blog。其中包括搜索等等。

## System Requirements
+ [nodejs](http://nodejs.org/)
+ [grunt](http://gruntjs.com/)
+ [yeoman](http://yeoman.io/)

## Getting Started

####安装nodejs

####安装grunt
>如果你安装过yeoman，那么你可以直接运行'@run.bat',观看效果。
>如果你曾经安装过grunt的老版本请先卸载
>```
>$ npm uninstall -g grunt
>```
>
>然后安装grunt
>```
>
>$ npm install -g grunt-cli
>```
>
>然后安装yo
>```
>
>$ npm install -g yo
>```
>


## 文档
主页显示的问文章在`config.json`中配置，path是文章的载入路径。

## 例子
[例子博客](http://fightteam.github.io/blog/)

## change log
### 0.0.1
初始化文章

### 0.0.2
* 完善搜索
* 增加tag功能

### 0.0.3
* 增加了文章的载入动画
* 增加了loaclStorage缓存文章，防止重复读取

## Release History
0.0.1——2013.7.10
0.0.2——2013.7.21
0.0.3——2013.7.22


## License
Copyright (c) 2013 excalibur 
Licensed under the [Apache License2][apache-license2]. 