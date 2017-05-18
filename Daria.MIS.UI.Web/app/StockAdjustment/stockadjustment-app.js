(function () {
    'use strict';

    config.$inject = ['$routeProvider', '$locationProvider'];

    angular.module('stockadjustmentApp', [
        'ngRoute', 'stockadjustmentService', 'ui.bootstrap', 'xeditable', 'cfp.hotkeys'
    ]).config(config);

    function config($routeProvider, $locationProvider) {
        $routeProvider
            .when('/', {
                templateUrl: '/app/stockadjustment/views/stockadjustment-list.html',
                controller: 'StockAdjustmentListController'
            })
            .when('/add', {
                templateUrl: '/app/stockadjustment/views/stockadjustment-entry.html',
                controller: 'StockAdjustmentEntryController'
            })

    }

    angular
      .module('stockadjustmentApp')
      .controller('StockAdjustmentListController', StockAdjustmentListController)
      .controller('StockAdjustmentEntryController', StockAdjustmentEntryController)
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
