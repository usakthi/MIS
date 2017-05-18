(function () {
    'use strict';

    config.$inject = ['$routeProvider', '$locationProvider'];

    angular.module('purchaseApp', [
        'ngRoute', 'purchaseService', 'ui.bootstrap', 'xeditable', 'ui.grid', 'ui.grid.pagination', 'cfp.hotkeys'
    ]).config(config);

    function config($routeProvider, $locationProvider) {
        $routeProvider
            .when('/', {
                templateUrl: '/app/purchase/views/purchase-list.html',
                controller: 'PurchaseListController'
            })
            .when('/add', {
                templateUrl: '/app/purchase/views/purchase-entry.html',
                controller: 'PurchaseEntryController'
            })
             .when('/edit/:id', {
                 templateUrl: '/app/purchase/views/purchase-entry.html',
                 controller: 'PurchaseEntryController'
             })
             .when('/print/:id', {
                 templateUrl: 'app/purchase/views/purchase-print.html',
                 controller: 'PurchasePrintController'
             })
        .when('/openstock', {
            templateUrl: '/app/purchase/views/open-stock.html',
            controller: 'OpenStockController'
        })
    }

    angular
      .module('purchaseApp')
      .controller('PurchaseListController', PurchaseListController)
      .controller('PurchaseEntryController', PurchaseEntryController)
      .controller('PurchasePrintController', PurchasePrintController)
      .controller('OpenStockController', OpenStockController)
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