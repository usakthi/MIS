(function () {
    'use strict';

    config.$inject = ['$routeProvider', '$locationProvider'];

    angular.module('departmentstockApp', [
        'ngRoute', 'departmentstockService', 'ui.bootstrap', 'xeditable', 'ui.grid', 'ui.grid.pagination'
    ]).config(config);

    function config($routeProvider, $locationProvider) {
        $routeProvider
            .when('/', {
                templateUrl: '/app/departmentstock/views/departmentstock-list.html',
                controller: 'DepartmentStockListController'
            })
    }

    angular
      .module('departmentstockApp')
      .controller('DepartmentStockListController', DepartmentStockListController)
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