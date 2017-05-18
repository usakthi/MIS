(function () {
    'use strict';

    config.$inject = ['$routeProvider', '$locationProvider'];

    angular.module('customerreceivableApp', [
        'ngRoute', 'customerreceivableService', 'ui.bootstrap', 'xeditable'
    ]).config(config);

    function config($routeProvider, $locationProvider) {
        $routeProvider
            .when('/', {
                templateUrl: '/app/customerreceivable/views/customerreceivable-list.html',
                controller: 'CustomerReceivableListController'
            })
            .when('/add', {
                templateUrl: '/app/customerreceivable/views/customerreceivable-entry.html',
                controller: 'CustomerReceivableEntryController'
            })
             .when('/edit/:id', {
                 templateUrl: '/app/customerreceivable/views/customerreceivable-entry.html',
                 controller: 'CustomerReceivableEntryController'
             })
    }

    angular
      .module('customerreceivableApp')
      .controller('CustomerReceivableListController', CustomerReceivableListController)
      .controller('CustomerReceivableEntryController', CustomerReceivableEntryController)
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
