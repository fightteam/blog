/*global require*/
'use strict';
require.config({
    shim: {
        underscore: {
            exports: '_'
        },
        backbone: {
            deps: [
                'underscore',
                'jquery'
            ],
            exports: 'Backbone'
        },
        bootstrap: {
            deps: ['jquery'],
            exports: 'jquery'
        }
    },
    paths: {
        jquery: '../bower_components/jquery/jquery',
        backbone: '../bower_components/backbone-amd/backbone',
        underscore: '../bower_components/underscore-amd/underscore',
        bootstrap: 'vendor/bootstrap',
        showdown:'../bower_components/showdown/src/showdown',
        'backbone.localStorage':'../bower_components/backbone.localStorage/backbone.localStorage'
    }
});

require([
    'backbone',
    'routes/application-router'
], function (Backbone,Workspace) {
    new Workspace();
    Backbone.history.start();
   
});