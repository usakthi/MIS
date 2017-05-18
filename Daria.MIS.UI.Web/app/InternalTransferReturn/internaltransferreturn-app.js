(function () {
    'use strict';

    config.$inject = ['$routeProvider', '$locationProvider'];

    angular.module('internaltransferreturnApp', [
        'ngRoute', 'internaltransferreturnService', 'ui.bootstrap', 'xeditable'
    ]).config(config);

    function config($routeProvider, $locationProvider) {
        $routeProvider
            .when('/', {
                templateUrl: '/app/internaltransferreturn/views/internaltransferreturn-list.html',
                controller: 'BillListController'
            })
            .when('/add', {
                templateUrl: '/app/internaltransferreturn/views/internaltransferreturn-entry.html',
                controller: 'BillEntryController'
            })
             .when('/edit/:id', {
                 templateUrl: '/app/internaltransferreturn/views/internaltransferreturn-entry.html',
                 controller: 'BillEntryController'
             })

    }

    angular
      .module('internaltransferreturnApp')
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
