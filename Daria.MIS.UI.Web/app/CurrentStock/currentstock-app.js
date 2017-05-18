(function () {
    'use strict';

    config.$inject = ['$routeProvider', '$locationProvider'];

    angular.module('currentstockApp', [
        'ngRoute', 'currentstockService', 'ui.bootstrap', 'xeditable', 'ui.grid', 'ui.grid.pagination'
    ]).config(config);

    function config($routeProvider, $locationProvider) {
        $routeProvider
            .when('/', {
                templateUrl: '/app/currentstock/views/currentstock-list.html',
                controller: 'CurrentStockListController'
            })
    }

    angular
      .module('currentstockApp')
      .controller('CurrentStockListController', CurrentStockListController)
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