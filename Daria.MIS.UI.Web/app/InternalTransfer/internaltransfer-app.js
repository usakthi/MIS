(function () {
    'use strict';

    config.$inject = ['$routeProvider', '$locationProvider'];

    angular.module('internaltransferApp', [
        'ngRoute', 'internaltransferService', 'ui.bootstrap', 'xeditable', 'cfp.hotkeys'
    ]).config(config);

    function config($routeProvider, $locationProvider) {
        $routeProvider
            .when('/', {
                templateUrl: '/app/internaltransfer/views/internaltransfer-list.html',
                controller: 'BillListController'
            })
            .when('/add', {
                templateUrl: '/app/internaltransfer/views/internaltransfer-entry.html',
                controller: 'BillEntryController'
            })
             .when('/edit/:id', {
                 templateUrl: '/app/internaltransfer/views/internaltransfer-entry.html',
                 controller: 'BillEntryController'
             })
        .when('/print/:id', {
            templateUrl: '/app/internaltransfer/views/internaltransfer-print.html',
            controller: 'BillEntryController'
        })

    }

    angular
      .module('internaltransferApp')
      .controller('BillListController', BillListController)
      .controller('BillEntryController', BillEntryController)
      .filter('jsonDate', function ($filter) {
          return function (input, format) {
              return $filter('date')(parseInt(input.substr(6)), format);
          };
      })
      .directive('converttonumber', function () {
            return {
                require: 'ngModel',
                link: function (scope, element, attrs, ngModel) {
                    ngModel.$parsers.push(function (val) {
                        return parseInt(val, 10);
                    });
                    ngModel.$formatters.push(function (val) {
                        return '' + val;
                    });
                }
            };
      });

})();
