define [
    'jquery'
    'backbone'
    'views/application-view'
    'app'
],($, Backbone,AppView,global)->
    'use strict'

    ApplicationRouter = Backbone.Router.extend
        initialize:()->
            

        routes:
            '':'show'
            ':search':'search'

        show:()->
            
            global.appView = new AppView();
            # 显示全部 修复回退bug
            global.articles.showAll()
            global.appView.render(); 
        search:(search)->
            if global.appView is undefined
                @navigate('/',{trigger: true, replace: true})
            global.appView.search(search)
            global.app.totop.backToTop()
    ApplicationRouter