(function () {
    'use strict';

    config.$inject = ['$routeProvider', '$locationProvider'];

    angular.module('salesreturnApp', [
        'ngRoute', 'salesreturnService', 'ui.bootstrap', 'xeditable', 'cfp.hotkeys'
    ]).config(config);

    function config($routeProvider, $locationProvider) {
        $routeProvider
            .when('/', {
                templateUrl: '/app/salesreturn/views/salesreturn-list.html',
                controller: 'IndentBillListController'
            })
            .when('/add', {
                templateUrl: '/app/salesreturn/views/salesreturn-entry.html',
                controller: 'IndentBillEntryController'
            })
             .when('/edit/:id', {
                 templateUrl: '/app/salesreturn/views/salesreturn-entry.html',
                 controller: 'IndentBillEntryController'
             })
        .when('/print/:id', {
            templateUrl: '/app/salesreturn/views/salesreturn-print.html',
            controller: 'IndentBillPrintController'
        })
    }

    angular
      .module('salesreturnApp')
      .controller('IndentBillListController', IndentBillListController)
      .controller('IndentBillEntryController', IndentBillEntryController)
        .controller('IndentBillPrintController', IndentBillPrintController)
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
