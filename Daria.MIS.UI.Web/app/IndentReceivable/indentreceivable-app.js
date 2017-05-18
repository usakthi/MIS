(function () {
    'use strict';

    config.$inject = ['$routeProvider', '$locationProvider'];

    angular.module('indentreceivableApp', [
        'ngRoute', 'indentreceivableService', 'ui.bootstrap', 'xeditable'
    ]).config(config);

    function config($routeProvider, $locationProvider) {
        $routeProvider
            .when('/', {
                templateUrl: '/app/indentreceivable/views/indentreceivable-list.html',
                controller: 'IndentReceivableListController'
            })
            .when('/add', {
                templateUrl: '/app/indentreceivable/views/indentreceivable-entry.html',
                controller: 'IndentReceivableEntryController'
            })
             .when('/edit/:id', {
                 templateUrl: '/app/indentreceivable/views/indentreceivable-entry.html',
                 controller: 'IndentReceivableEntryController'
             })

    }

    angular
      .module('indentreceivableApp')
      .controller('IndentReceivableListController', IndentReceivableListController)
      .controller('IndentReceivableEntryController', IndentReceivableEntryController)
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
