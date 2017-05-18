(function () {
    'use strict';

    angular
        .module('currentstockService', ['ngResource'])        
        .factory('CurrentStockDataService', CurrentStockDataService);

    CurrentStockDataService.$inject = ['$http', '$q'];

    function CurrentStockDataService($http, $q) {
        var baseUrl = '/currentstock/';
        return {
            getPurchaseList: function () {
                // Get the deferred object
                var deferred = $q.defer();
                // Initiates the AJAX call
                $http({ method: 'POST', url: baseUrl + 'GetPurchaseList' }).success(deferred.resolve).error(deferred.reject);
                // Returns the promise - Contains result once request completes
                return deferred.promise;
            },

            RptCurrentStock: function (searchParams) {
                // Get the deferred object
                var deferred = $q.defer();
                // Initiates the AJAX call
                $http({ method: 'POST', url: baseUrl + 'RptCurrentStock', data: { model: searchParams } }).success(deferred.resolve).error(deferred.reject);
                // Returns the promise - Contains result once request completes
                return deferred.promise;
            },

            getProductList: function (q) {
                
                var deferred = $q.defer();                
                $http({ method: 'GET', url: '/admin/GetProductsAutoComplete?q='+q }).success(deferred.resolve).error(deferred.reject);
                return deferred;
            },

            getManufacturerList: function (q) {
                
                var deferred = $q.defer();                
                $http({ method: 'GET', url: '/admin/GetManufacturesAutoComplete?q=' + q }).success(deferred.resolve).error(deferred.reject);
                return deferred;
            },
            getPurchaseInfo: function (pId) {

                var deferred = $q.defer();                
                $http({ method: 'POST', url: baseUrl + 'GetPurchase', data: { id: pId } }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;

            },

            savePurchase: function (purchase) {
                var deferred = $q.defer();
                $http({ method: 'POST', url: baseUrl + 'SavePurchase', data: { model: purchase } }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            },
            deletePurchase: function (pId) {
                var deferred = $q.defer();
                $http({ method: 'POST', url: baseUrl + 'DeletePurchase', data: { id: pId } }).success(deferred.resolve).error(deferred.reject);
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