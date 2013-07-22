# 定义文章集合

define [
    'underscore'
    'backbone'
    'models/article-model'
    'backbone.localStorage'
],(_, Backbone, ArticleModel,Store)->
	'use strict'

	ArticleCollection = Backbone.Collection.extend
		model: ArticleModel
		# 集合储存方式
		localStorage:new Store 'articles'
		# 返回集合中tags中有tag的article
		hasTag:(tag)->
			@filter (article)->
				tags = article.get 'tag'
				if _.contains(tags,tag) or _.contains(tags,tag.toUpperCase())
					true	
		notHasTag:(tag)->
			@without.apply @,@hasTag(tag)
		showAll:()->
			@each (article)->
				article.show()
		hideAll:()->
			@each (article)->
				article.hide()
		# 设置载入文章
		setLoading:()->
			@each (article)->
				article.loading()
	ArticleCollection
