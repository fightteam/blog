# 定义totop
define [
    'jquery'
    'underscore'
    'backbone'
    'templates'
],($, _, Backbone, JST)->
	'use strict'
	if _.isUndefined(Backbone.UI)
		Backbone.UI = {}
	
	Backbone.UI.ToTop = Backbone.View.extend
		# 默认属性
		options:
			parentEl:'body'
		el: ()->
			$ @options.parentEl
		template: JST['app/scripts/templates/totop.ejs']
		events:
			"scroll" : "pageScroll"
			"click .ui-totop" : "backToTop"
		# scroll处理
		pageScroll:()->
			scrollThreshold = $(window).height()
			
			if $(window).scrollTop() > scrollThreshold
				@$el.find('.ui-totop').show();
			else
				@$el.find('.ui-totop').hide();
		# 回到顶部处理
		backToTop:()->
			$("html, body").animate
				scrollTop: 0
			, 1000
			false
		# 渲染视图
		render:()->
			@$el.append @template()
			@
		# 初始化
		initialize:(model, options)->
			_.bindAll @, 'render', 'pageScroll'
			
			$(window).scroll @pageScroll
			@render()
	Backbone
