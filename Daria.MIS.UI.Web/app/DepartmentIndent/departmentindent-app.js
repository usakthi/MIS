(function () {
    'use strict';

    config.$inject = ['$routeProvider', '$locationProvider'];

    angular.module('departmentindentApp', [
        'ngRoute', 'departmentindentService', 'ui.bootstrap', 'xeditable'
    ]).config(config);

    function config($routeProvider, $locationProvider) {
        $routeProvider
            .when('/', {
                templateUrl: '/app/departmentindent/views/departmentindent-list.html',
                controller: 'BillListController'
            })
            .when('/add', {
                templateUrl: '/app/departmentindent/views/departmentindent-entry.html',
                controller: 'BillEntryController'
            })
             .when('/edit/:id', {
                 templateUrl: '/app/departmentindent/views/departmentindent-entry.html',
                 controller: 'BillEntryController'
             })

    }

    angular
      .module('departmentindentApp')
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
