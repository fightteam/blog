### 什么是 Todos?
按照翻译来说就是一个计划清单！<br>
它的效果图如下:<br>
<img src="images/todos_a.png" alt="">
[访问观看效果](http://fightteam.github.io/open/todos)

### 分析需求
为了是用backbone开发所以我们要分析出todo所需要的模型、模型数据、页面等。
分析的时候最好是自顶向下分析，也就是说由页面呈现的效果开始分析，然后得出模板、模型数据、模型等。

* 根据这个图片来看，这个页面一开始应该有一个输入框，之下有一个list表，输入框之前有一个选择按钮，list表中的每一行也有一个选择按钮，之下有一组什么计数的显示，状态显示的选择和清除计数的选择。
* 为了达到保存这个todo模型，应该有记录录入结果，记录选中状态。
* 以事件来驱动，当一个用户点击输入框时输入完成后按enter键list表中将会产生一行记录。

### 代码组织结构
```
  todos/      -------------------------------项目主目录
  ├── coffee/   -----------------------------CofeeScript 编写目录
  │   ├── config.coffee ---------------------根目录配置文件（requirejs）所有页面可以读取
  │   ├── namespace.coffee ------------------全局命名空间 （放全局定义）
  │   ├── models/  --------------------------自定义源码文件，可以放一些通用的工具与插件(coffee的)
  │   ├── collections/ ----------------------自定义源码文件，可以放一些通用的工具与插件(coffee的)
  │   ├── views/   --------------------------自定义源码文件，可以放一些通用的工具与插件(coffee的)
  │   ├── routers/  -------------------------自定义源码文件，可以放一些通用的工具与插件(coffee的)
  │   ├── test/  ----------------------------自定义测试文件(coffee的)
  ├── less/
  │   └── styles/  --------------------------该目录下的.less会编译成css 所以要编译的css全部放入该目录
  │   
  ├── src/ -----------------------------------该目录下放相应代码（javascript、css等）
  │    ├── models/  --------------------------自定义源码文件(javascript的)
  │    ├── collections/ ----------------------自定义源码文件(javascript的)
  │    ├── views/   --------------------------自定义源码文件(javascript的)
  │    ├── routers/  -------------------------自定义源码文件(javascript的)
  │    ├── templates/  -----------------------模板文件(javascript的)
  │    ├── styles/  --------------------------css
  │    ├── img/  -----------------------------图片
  │    ├── font/  ----------------------------字体
  │    ├── components/  ----------------------控件（jquery库等）
  │    ├── test/  ----------------------------测试文件
  │    │   
  │    └── index.html
  │
  └── Gruntfile.coffee ----------------------grunt配置文件

```

### Models层的Todo编写
根据分析来看，这个todo模型应该有录入内容(content)、选中与否(done)，改变选中状态(toggle)。<br>
todo测试代码全部如下：

```
# 定义测试 todo model 模块
require [
  'models/todo'
  ]
  ,(TodoModel)->
    module '测试Model的Todo'
    ,setup:()->
      @todoModel = new TodoModel()

    test '测试Model的content',()->
      @todoModel.set content:'test-content'
      
      equal 'test-content',@todoModel.get('content'),'todo的content属性设置获取正常'
    test '测试Model的done',()->      
      @todoModel.set done:true
      ok @todoModel.get('done'),'todo的done属性设置获取正常'

    test '测试Model的toggle方法',()->
      @todoModel.toggle()
      ok @todoModel.get('done'),'todo的toggle()方法正常'

```
运行该测试：
  <img src="images/todos_2.jpg" alt="">

为跑通测试我们来完成todo模型代码。<br>
todo代码全部如下：

```
# 定义todo数据对象
define [
  'backbone'
  ]
  ,(Backbone)->
    Todo = Backbone.Model.extend
      defaults:
        content:'空的内容...' # 任务清单的内容
        done:false  # 是否选中
      initialize:()->
      # 置换选中状态
      toggle:()->
        @save done:not @get 'done'
```
继续运行测试：
<img src="images/todos_3.jpg" alt="">
可以看到，测试都通过了！可以进行下一步了。

### Collections层的Todos编写
todos测试代码全部如下：
```
# 定义todos数据集合 测试
define [
  'collections/todos'
  ]
  ,(Todos)->
    module '测试Collections的Todos'
    ,setup:()->
      @todos = new Todos()
      @todos.add
        content:'list one'
      @todos.add
        content:'list two'
        done:true
      @todos.add
        content:'list three'
      @todos.add
        content:'list four'
      @todos.add
        content:'list five'
        done:true
      @todos.add
        content:'list six'
      @todos.add
        content:'list seven'
      @todos.add
        content:'list eight'
        done:true
      @todos.add
        content:'list nine'
        done:true

    test '测试Collections的done方法',()->
      
      equal 4,@todos.done().length,"todos集合done()方法正常"
      
    test '测试Collections的notDone方法',()-> 

      console.log @todos.notDone()    
      equal 5,@todos.notDone().length,"todos集合notDone()方法正常"
      
    
        

```
运行该测试：
<img src="images/todos_4.jpg" alt="">
同样为了测试通过我们编写todo的集合！<br>
todos代码全部如下：

```
# 定义todos 集合对象
define [
  'backbone'
  'models/todo'
  'backbone.localStorage'
  ]
  ,(Backbone,TodoModel,LocalStorage)->
    Todos = Backbone.Collection.extend
      # 集合中对象类型
      model:TodoModel
      # 集合储存方式
      localStorage:new Store 'todos'

      initialize:()->
      # 返回集合中done 是true的对象
      done:()->
        @filter (todo)->
          todo.get 'done'
      # 返回集合最中done 为false的方法
      notDone:()->
        # 返回@done()中没有的对象
        @without.apply @,@done()
      


    # 返回集合  如果想单例的话 new 对象返回  
    Todos

```
继续运行测试：
<img src="images/todos_5.jpg" alt="">
可以看到，测试都通过了！可以进行下一步了。

### Views层的TodoView编写
todoView代码全部如下：

```
# 定义todo 视图
define [
  'backbone'
  'text!templates/todo.html'
  'namespace'
  ]
  ,(Backbone,TodoTpl,gobal)->
    TodoView = Backbone.View.extend
      # @$el依赖结点(该结点未添加在浏览器中)
      tagName:'li'
      # 该视图依赖的模板
      template:_.template TodoTpl
      initialize:()->
        console.log '44'
        # 监听数据模型 如果数据改变重新渲染视图
        @listenTo @model,'change',@render
        # 监听数据模型 如果该模型被销毁移除该视图
        @listenTo @model,'destroy',@remove
        # 监听对象的显示与隐藏转换
        @listenTo @model,'visible',@toggleVisible


      # 该视图的事件代理
      events:
        'click .toggle':'toggleDone' # 点击选择按钮  改变选择状态
        'dblclick label':'edit'   # 双击内容进行编辑
        'click .destroy': 'clear' # 点击删除
        'keypress .edit': 'updateOnEnter' # 在录入框中按enter更新
        'blur .edit':   'close' # 离开碌碌框 更新数据
      # 视图渲染方法  该渲染是指在@$el中(也并未添加在浏览器中) 
      render:()->
        @$el.html @template @model.toJSON()
        @$el.toggleClass 'completed', this.model.get('done')
        @$input = @$ '.edit'
        # 必须返回这个对象 以方便吧该结点添加在浏览器中 
        
        @
      # 置换该视图的隐藏遇显示
      toggleVisible:()->
        @$el.toggleClass 'hidden', @isHidden()
      # 根据属性判别是否隐藏
      isHidden:()->
        isDone = @model.get 'done'
        (not isDone and gobal.app.TodoFilter is 'completed') or (isDone and gobal.app.TodoFilter is 'active')
      # 改变该对象的选中状态
      toggleDone:()->
        @model.toggle()

      # 内容编辑，其实默认的时候有一个录入框了的，这时候我们让label隐藏，那个隐藏的input显示。
      edit:()->
        # 增加一个editing css类 标识正在编辑
        @$el.addClass 'editing'
        # 让录入框获得焦点
        @$input.focus()
      # 删除该模型数据 与视图 
      clear:()->
        @model.destroy()
      # 当按下enter是的操作
      updateOnEnter:(e)->
        # enter 全局定义 为了以后方便修改
        if e.keyCode is gobal.app.ENTER_KEY
          @close()
      # 录入框关闭进行的操作
      close:()->
        # 获取输入的数据
        value = @$input.val().trim()
        # 如果值不为空 那么为数据模型保存值，否则(就是值为空)进行删除记录
        if value
          @model.save content:value
        else
          @clear()
        # 清除css 标识的编辑状态
        @$el.removeClass 'editing'

```

### Views层的TodoView编写
todoView代码全部如下：

```
# 主视图 
define [
  'jquery'
  'backbone'
  'namespace'
  'text!templates/stats.html'
  'collections/todos'
  'views/todo'
  ]
  ,($,Backbone,gobal,statsTemplate,todos,TodoView)->

    AppView = Backbone.View.extend
      # 该el是已经产生的dom结点
      el:'#todoapp'
      statsTemplate:_.template statsTemplate

      events:
        'keypress #new-todo':   'createOnEnter' # 录入时候enter
        'click #clear-completed': 'clearDoned' # 点击清除
        'click #toggle-all':    'toggleAllComplete' #改变选择状态
      render:()->
  
        @$footer.html @statsTemplate
          remaining:todos.notDone().length
          completed:todos.done().length
        @$('#filters li a')
          .removeClass('selected')
          .filter('[href="#/' + (gobal.app.TodoFilter || '') + '"]')
          .addClass('selected')


        # 如果没有done 为 false的数据 就吧allCheckbox设为选中
        @$allCheckbox.checked = not todos.notDone().length              
        @
      initialize:()->
        @$input = @$ '#new-todo'
        @$list = @$ '#todo-list'
        @$allCheckbox = @$('#toggle-all')[0]
        @$footer = @$ '#footer'

        # 监听集合中数据 如果有数据添加 调用addOne方法
        @listenTo todos, 'add', @addOne
        # 监听集合中数据 当重新设置时 调用addAll方法
        @listenTo todos, 'reset', @addAll
        # 监听集合中数据 当对象done属性改变时 调用filterOne方法
        @listenTo todos, 'change:done', @filterOne
        @listenTo todos, 'filter', @filterAll
        # 监听集合中数据 当任何改变时 调用render方法
        @listenTo todos, 'all', @render
        # 读取存储的数据
        todos.fetch()
      # 添加一个记录到视图
      addOne:(todo)->     
        todoView = new TodoView
          model: todo
        @$list.append todoView.render().el


      # 添加所有记录到视图
      addAll:()->
        # 清空list
        @$list.html ''
        # 依次调用添加
        todos.each @addOne, @
      # enter 录入数据
      createOnEnter:(e)->
        if e.which isnt gobal.app.ENTER_KEY or not @$input.val().trim() 
          return
        

        todos.create @newAttributes()
        @$input.val ''
      # 创建一个新数据对象 01
      newAttributes:()->
        content: @$input.val().trim()
        done: false
      # 转化全部list的选中状态 
      toggleAllComplete:()->
        done = @$allCheckbox.checked

        todos.each (todo)->
          todo.save 
            done:done
      # 改变一个todo视图的状态
      filterOne:(todo)->
        todo.trigger 'visible'
      # 改变一个todo全部视图的状态
      filterAll:()->

        todos.each @filterOne, @

    # 返回对外的该对象
    new AppView()
```

### Routers层的router编写
router代码全部如下：

```
# 定义router
define [
  'underscore'
  'backbone'
  'namespace'
  'collections/todos']
  ,(_,Backbone,gobal,todos)->
  Workspace = Backbone.Router.extend
    routes:
      '*filter': 'setFilter'
    # 根据uri参数 设置filter的属性
    setFilter:(param)->
      gobal.app.TodoFilter = param or ''
      todos.trigger 'filter'


  gobal.app.TodoRouter = new Workspace()

```

### 完整代码
[源码](https://github.com/excalibur/seajs-demo)
         
                