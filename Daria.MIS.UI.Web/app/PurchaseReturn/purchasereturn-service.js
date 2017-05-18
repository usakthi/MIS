(function () {
    'use strict';

    angular
        .module('purchasereturnService', ['ngResource'])        
        .factory('PurchaseDataService', PurchaseDataService);

    PurchaseDataService.$inject = ['$http', '$q'];

    function PurchaseDataService($http, $q) {
        var baseUrl = '/purchasereturn/';
        return {
            getPurchaseList: function () {
                // Get the deferred object
                var deferred = $q.defer();
                // Initiates the AJAX call
                $http({ method: 'POST', url: baseUrl + 'GetPurchaseList' }).success(deferred.resolve).error(deferred.reject);
                // Returns the promise - Contains result once request completes
                return deferred.promise;
            },
            getProductList: function (q) {
                
                var deferred = $q.defer();                
                $http({ method: 'GET', url: baseUrl + 'GetProductsForPurchaseReturnAutoComplete?q=' + q }).success(deferred.resolve).error(deferred.reject);
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
            },
            getPurchasedInfo: function (userInfo) {
                var deferred = $q.defer();
                $http({ method: 'POST', url: baseUrl + 'GetPurchasedItems', data: { no: userInfo } }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            },
            getSupplierInfo: function (q) {
                var deferred = $q.defer();
                $http({ method: 'POST', url: baseUrl + 'GetSupplierInvoices', data: { q: q } }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            }
        }
    }


})();