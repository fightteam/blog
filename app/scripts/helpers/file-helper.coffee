# ajax获取文件 辅助方法 采用jquery
define [
    'jquery'
],($)->
	'use strict'
	FileHelper = {}

	# 根据路径获取文件
	FileHelper.getFile = (path)->
		console.log '暂未实现'

	# 根据路径获取json数据 content 指定回调函数的this
	FileHelper.getJSON = (path,callback,context)->
		$.ajax
			url:"#{path}.json"
			dataType:"json"
			success:(data)->

				callback.call context,data


	FileHelper
