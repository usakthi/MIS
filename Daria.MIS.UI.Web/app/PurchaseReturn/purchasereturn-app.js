(function () {
    'use strict';

    config.$inject = ['$routeProvider', '$locationProvider'];

    angular.module('purchasereturnApp', [
        'ngRoute', 'purchasereturnService', 'ui.bootstrap', 'xeditable', 'cfp.hotkeys'
    ]).config(config);

    function config($routeProvider, $locationProvider) {
        $routeProvider
            .when('/', {
                templateUrl: '/app/purchasereturn/views/purchasereturn-list.html',
                controller: 'PurchaseListController'
            })
            .when('/add', {
                templateUrl: '/app/purchasereturn/views/purchasereturn-entry.html',
                controller: 'PurchaseEntryController'
            })
             .when('/edit/:id', {
                 templateUrl: '/app/purchasereturn/views/purchasereturn-entry.html',
                 controller: 'PurchaseEntryController'
             })

    }

    angular
      .module('purchasereturnApp')
      .controller('PurchaseListController', PurchaseListController)
      .controller('PurchaseEntryController', PurchaseEntryController)
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
