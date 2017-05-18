(function () {
    'use strict';

    config.$inject = ['$routeProvider', '$locationProvider'];

    angular.module('departmentbillApp', [
        'ngRoute', 'departmentbillService', 'ui.bootstrap', 'xeditable'
    ]).config(config);

    function config($routeProvider, $locationProvider) {
        $routeProvider
            .when('/', {
                templateUrl: '/app/departmentbill/views/departmentbill-list.html',
                controller: 'IndentBillListController'
            })
            .when('/add', {
                templateUrl: '/app/departmentbill/views/departmentbill-entry.html',
                controller: 'IndentBillEntryController'
            })
             .when('/edit/:id', {
                 templateUrl: '/app/departmentbill/views/departmentbill-entry.html',
                 controller: 'IndentBillEntryController'
             })

    }

    angular
      .module('departmentbillApp')
      .controller('IndentBillListController', IndentBillListController)
      .controller('IndentBillEntryController', IndentBillEntryController)
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
