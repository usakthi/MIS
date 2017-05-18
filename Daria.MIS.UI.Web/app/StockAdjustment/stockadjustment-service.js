(function () {
    'use strict';

    angular
        .module('stockadjustmentService', ['ngResource'])        
        .factory('StockAdjustmentDataService', StockAdjustmentDataService);

    StockAdjustmentDataService.$inject = ['$http', '$q'];

    function StockAdjustmentDataService($http, $q) {
        var baseUrl = '/stockadjustment/';
        return {
            getStockAdjustmentList: function () {
                // Get the deferred object
                var deferred = $q.defer();
                // Initiates the AJAX call
                $http({ method: 'POST', url: baseUrl + 'GetStockAdjustmentList' }).success(deferred.resolve).error(deferred.reject);
                // Returns the promise - Contains result once request completes
                return deferred.promise;
            },
            getProductList: function (q) {
                
                var deferred = $q.defer();                
                $http({ method: 'GET', url: '/admin/GetProductsForBillAutoComplete?q=' + q }).success(deferred.resolve).error(deferred.reject);
                return deferred;
            },

            getManufacturerList: function (q) {
                
                var deferred = $q.defer();                
                $http({ method: 'GET', url: '/admin/GetManufacturesAutoComplete?q=' + q }).success(deferred.resolve).error(deferred.reject);
                return deferred;
            },
            //getPurchaseInfo: function (pId) {

            //    var deferred = $q.defer();                
            //    $http({ method: 'POST', url: baseUrl + 'GetPurchase', data: { id: pId } }).success(deferred.resolve).error(deferred.reject);
            //    return deferred.promise;
            //},
            saveStockAdjustment: function (stockadjustment) {
                var deferred = $q.defer();
                $http({ method: 'POST', url: baseUrl + 'SaveStockAdjustment', data: { model: stockadjustment } }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            },
            //deletePurchase: function (pId) {
            //    var deferred = $q.defer();
            //    $http({ method: 'POST', url: baseUrl + 'DeletePurchase', data: { id: pId } }).success(deferred.resolve).error(deferred.reject);
            //    return deferred.promise;
            //},
            authorizeUser: function (userInfo) {
                var deferred = $q.defer();
                $http({ method: 'POST', url: baseUrl + 'ValidateUserLogin', data: { user: userInfo } }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            }

        }
    }

})();