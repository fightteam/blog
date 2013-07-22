# 全局定义
define [
	'jquery'
	'underscore'
	'backbone'
	'collections/article-collection'
	'helpers/file-helper'
	'views/loading-view'
],($,_,Backbone, Articles,FileHelper, LoadingView)->
	'use strict'

	global = {}
	_.extend global,Backbone.Events
	# 主要处理获取配置文档数据
	global.articles = new Articles()
	global.app = {}
	
	# 获取配置文件 分2种情况
	# 直接获取local storage 如果有将不会获取config
	if global.articles.localStorage.records.length == 0
		# 增加载入动画
		loadingView = new LoadingView()
		$('#content').append loadingView.render().el
		s_config = FileHelper.getJSON 'config',(data)->
			for article in data.articles
				global.articles.create article
			# 移除动画
			loadingView.remove()
		,global
	
	

	global
