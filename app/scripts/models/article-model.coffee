# 定义文章模型
define [
    'underscore'
    'backbone'
],(_, Backbone)->
    'use strict'

    ArticleModel = Backbone.Model.extend
        defaults: 
            title:'默认标题'
            description:'没有描述'
            content:''
            tag:['none']
            path:''
            date:new Date()
            # 是否选择了
            done:false
            loading:true
            hide:false
        toggle:()->
            @save done:not @get 'done'
        hide:()->
            @save hide:true
        show:()->
            @save hide:false
        loading:()->
           @save loading:true 

    ArticleModel
