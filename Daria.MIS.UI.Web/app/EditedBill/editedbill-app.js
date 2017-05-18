(function () {
    'use strict';

    config.$inject = ['$routeProvider', '$locationProvider'];

    angular.module('editedbillApp', [
        'ngRoute', 'editedbillService', 'ui.bootstrap', 'xeditable', 'ui.grid', 'ui.grid.pagination', 'cfp.hotkeys'
    ]).config(config);

    function config($routeProvider, $locationProvider) {
        $routeProvider
            .when('/', {
                templateUrl: '/app/editedbill/views/editedbill-list.html',
                controller: 'EditedBillListController'
            })
           
    }

    angular
      .module('editedbillApp')
      .controller('EditedBillListController', EditedBillListController)
      
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
