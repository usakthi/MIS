(function () {
    'use strict';

    angular
        .module('editedbillService', ['ngResource'])        
        .factory('EditedBillDataService', EditedBillDataService);

    EditedBillDataService.$inject = ['$http', '$q'];

    function EditedBillDataService($http, $q) {
        var baseUrl = '/editedbill/';
        return {
            
            SearchPurchases: function (searchParams) {
                // Get the deferred object
                var deferred = $q.defer();
                // Initiates the AJAX call
                $http({ method: 'POST', url: baseUrl + 'SearchPurchases', data: { model: searchParams } }).success(deferred.resolve).error(deferred.reject);
                // Returns the promise - Contains result once request completes
                return deferred.promise;
            },

            authorizeUser: function (userInfo) {
                var deferred = $q.defer();
                $http({ method: 'POST', url: baseUrl + 'ValidateUserLogin', data: { user: userInfo } }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            }

        }
    }


})();