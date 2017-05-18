(function () {
    'use strict';

    config.$inject = ['$routeProvider', '$locationProvider'];

    angular.module('departmentusageApp', [
        'ngRoute', 'departmentusageService', 'ui.bootstrap', 'xeditable'
    ]).config(config);

    function config($routeProvider, $locationProvider) {
        $routeProvider
            .when('/', {
                templateUrl: '/app/departmentusage/views/departmentusage-list.html',
                controller: 'IndentBillListController'
            })
            .when('/add', {
                templateUrl: '/app/departmentusage/views/departmentusage-entry.html',
                controller: 'IndentBillEntryController'
            })
             .when('/edit/:id', {
                 templateUrl: '/app/departmentusage/views/departmentusage-entry.html',
                 controller: 'IndentBillEntryController'
             })

    }

    angular
      .module('departmentusageApp')
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
