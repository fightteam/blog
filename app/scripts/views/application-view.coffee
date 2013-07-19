# 主页面控制
define [
    'jquery'
    'underscore'
    'backbone'
    'templates'
    'views/article-view'
    'app'
    'views/totop-view'
],($, _, Backbone, JST, ArticleView,global)->
	'use strict'

	ApplicationView = Backbone.View.extend
		
		el: 'body'	
		template: JST['app/scripts/templates/application.ejs']
		events:
			'submit #searchForm':'searchKey'
		initialize:()->
			# 获取主要结点
			@$content = @$ '#content'
			@$searchForm = @$ '#searchForm'
			@$menu = @$ '#tag-menu'
			@tags = []
			# 监听文章集合
			@listenTo global.articles,'add',@addOne
			this.listenTo global.articles, 'filter', @filterAll
			global.app.totop = new Backbone.UI.ToTop()
		render:()->
			
			@
		# 增加一个文章显示	
		addOne:(article)->
			# 文章默认
			articleView = new ArticleView model:article
			@$content.append articleView.render().el
			# menu
			# 获取已经添加的tag
			temp = @tags
			@tags = _.union @tags,article.get 'tag'
			u_tags = @tags
			for tag in temp
				u_tags = _.without u_tags, tag

			for tag in u_tags
				@$menu.append('<li><a href="#'+tag+'">'+tag+'</a></li>')
		# 搜索
		search:(key)->
			
			# 隐藏没有tag的文章
			@hideArticles(key)
			# 显示有tag的文章
			@showArticles(key)
			# 防止form 跳转
			false
		searchKey:(form)->
			if form.target.searchKey.value is ''
				global.articles.showAll()
				return false
			@search form.target.searchKey.value
		filterOne:(article)->
			article.trigger 'visible'
		filterAll:()->
			global.articles.each @filterOne, @
		hideArticles:(tag)->
			_.invoke(global.articles.notHasTag(tag),"hide")
		showArticles:(tag)->
			_.invoke(global.articles.hasTag(tag),"show")
	ApplicationView
