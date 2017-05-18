(function () {
    'use strict';

    config.$inject = ['$routeProvider', '$locationProvider'];

    angular.module('billApp', [
        'ngRoute', 'billService', 'ui.bootstrap', 'xeditable', 'ui.grid', 'ui.grid.pagination', 'cfp.hotkeys'
    ]).config(config);

    function config($routeProvider, $locationProvider) {
        $routeProvider
            .when('/', {
                templateUrl: '/app/bill/views/bill-list.html',
                controller: 'BillListController'
            })
            .when('/add', {
                templateUrl: '/app/bill/views/bill-entry.html',
                controller: 'BillEntryController'
            })
             .when('/edit/:id', {
                 templateUrl: '/app/bill/views/bill-entry.html',
                 controller: 'BillEntryController'
             })
            .when('/print/:id', {
                templateUrl: '/app/bill/views/bill-print.html',
                controller: 'BillPrintController'
            })
    }

    angular
      .module('billApp')
      .controller('BillListController', BillListController)
      .controller('BillEntryController', BillEntryController)
      .controller('BillPrintController', BillPrintController)
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
