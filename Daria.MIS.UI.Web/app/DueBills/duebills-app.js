(function () {
    'use strict';

    config.$inject = ['$routeProvider', '$locationProvider'];

    angular.module('duebillsApp', [
        'ngRoute', 'duebillsService', 'ui.bootstrap', 'xeditable', 'cfp.hotkeys'
    ]).config(config);

    function config($routeProvider, $locationProvider) {
        $routeProvider
            .when('/', {
                templateUrl: '/app/duebills/views/duebills-list.html',
                controller: 'StockAdjustmentListController'
            })
            .when('/add', {
                templateUrl: '/app/duebills/views/duebills-entry.html',
                controller: 'StockAdjustmentEntryController'
            })

    }

    angular
      .module('duebillsApp')
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
