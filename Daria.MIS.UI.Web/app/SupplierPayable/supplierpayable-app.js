(function () {
    'use strict';

    config.$inject = ['$routeProvider', '$locationProvider'];

    angular.module('supplierpayableApp', [
        'ngRoute', 'supplierpayableService', 'ui.bootstrap', 'xeditable'
    ]).config(config);

    function config($routeProvider, $locationProvider) {
        $routeProvider
            .when('/', {
                templateUrl: '/app/supplierpayable/views/supplierpayable-list.html',
                controller: 'SupplierPayableListController'
            })
            .when('/add', {
                templateUrl: '/app/supplierpayable/views/supplierpayable-entry.html',
                controller: 'SupplierPayableEntryController'
            })
             .when('/edit/:id', {
                templateUrl: '/app/supplierpayable/views/supplierpayable-entry.html',
                controller: 'SupplierPayableEntryController'
             })
    }

    angular
      .module('supplierpayableApp')
      .controller('SupplierPayableListController', SupplierPayableListController)
      .controller('SupplierPayableEntryController', SupplierPayableEntryController)
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
