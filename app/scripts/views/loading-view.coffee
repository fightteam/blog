# 载入动画控制
define [
    'jquery'
    'underscore'
    'backbone'
    'templates'
],($, _, Backbone, JST)->
	'use strict'

	LoadingView = Backbone.View.extend
		tagName:'div'	
		className:'loading'	
		template: JST['app/scripts/templates/loading.ejs']
		events:
			'':''
		initialize:()->
			

		render:()->
			@$el.append @template()

			@
	LoadingView
