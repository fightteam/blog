# 定义文章的显示
define [
    'jquery'
    'underscore'
    'backbone'
    'templates'
    'showdown'
],($, _, Backbone, JST)->
	'use strict'

	ArticleView = Backbone.View.extend
		
		tagName:'article'	
		className:'well article'
		template: JST['app/scripts/templates/article.ejs']
		# 初始化 主要是模型的数据监听
		initialize:()->
			

			# 监听content 数据变化
			@listenToOnce @model,'change:content',@renderMD
			# 监听选择变化
			@listenTo @model,'change:done',@toggleContent
			# 监听时候隐藏
			@listenTo @model,'change:hide',@toggleArticle
		# 渲染
		render:()->
			@$el.html @template(@model.toJSON())
			@$section = @$('> section')
			@

		events:
			'click':'loadingArticle'
		# 将markdown 转化为 html
		process:(markdown)->
			converter = new Showdown.converter()
			process = converter.makeHtml
			process markdown 
		# 获取markdown 文件 
		getContent:()->
			@loading()
			$.ajax
				url:"#{@model.get('path')}.md"
				dataType:"text"
				context:@
				success:(data)->
					# 计划是采用markdown生成title与description的，可是为了性能这些指定在config里
					# header = data.match /^(#+)([^#]*)(#+)/i
					# s_title = header[2].match /^[^\r\n]{0,}/i
					# @model.set title:s_title[0]
					# @model.set description:header[2].substr(s_title[0].length)
					@model.set content:@process(data)
		# 自定义loading动画
		loading:()->
			@$loading = $ '<div class="progress progress-striped active"><div class="bar" style="width: 0%;"></div></div>'
			$.ajaxSetup
				beforeSend:->
					@$el.append @$loading
					@$loadingBar = @$loading.find '.bar'
					@$loadingBar.width 0
					# 定时调用
					_this = @
					@progressValue = 0
					setInterval ((_this)->    
						()->
							_this.progress() 
					)(@)           
					,300
				complete:->	
					@$loadingBar.width "100%"
					@$loading.remove()
		# 增加进度条
		progress:()->
			@progressValue = @progressValue%100+10 
			@$loadingBar.width @progressValue+"%"
		# 渲染文章						
		renderMD:()->

		
			@$section.append @model.get 'content'

		# 载入文章
		loadingArticle:()->
			if @model.get 'loading'
				@getContent()
				@model.set loading:false

			# 转换选择状态
			@model.toggle()	
		# 转换文章主体显示状态
		toggleContent:(model)->
			@$section.toggleClass 'hide'
			
		toggleArticle:(model)->
			@$el.toggleClass 'hide'
	ArticleView
