(function () {
    'use strict';

    angular
        .module('purchaseService', ['ngResource'])        
        .factory('PurchaseDataService', PurchaseDataService);

    PurchaseDataService.$inject = ['$http', '$q'];

    function PurchaseDataService($http, $q) {
        var baseUrl = '/purchase/';
        return {
            getPurchaseList: function () {
                // Get the deferred object
                var deferred = $q.defer();
                // Initiates the AJAX call
                $http({ method: 'POST', url: baseUrl + 'GetPurchaseList' }).success(deferred.resolve).error(deferred.reject);
                // Returns the promise - Contains result once request completes
                return deferred.promise;
            },

            SearchPurchases: function (searchParams) {
                // Get the deferred object
                var deferred = $q.defer();
                // Initiates the AJAX call
                $http({ method: 'POST', url: baseUrl + 'SearchPurchases', data: { model: searchParams } }).success(deferred.resolve).error(deferred.reject);
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

            getSupplierList: function (q) {
                var deferred = $q.defer();
                $http({ method: 'GET', url: '/admin/GetSupplierAutoComplete?q=' + q }).success(deferred.resolve).error(deferred.reject);
                return deferred;
            },

            getPurchaseInfo: function (pId) {

                var deferred = $q.defer();                
                $http({ method: 'POST', url: baseUrl + 'GetPurchase', data: { id: pId } }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;

            },
            getPurchaseItems: function (prodId) {

                var deferred = $q.defer();
                $http({ method: 'POST', url: baseUrl + 'GetPurchaseItems', data: { prodId: prodId } }).success(deferred.resolve).error(deferred.reject);
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
            uploadOpenStocksFile: function (file, desc) {
                var formData = new FormData();
                formData.append("file", file);

                var deferred = $q.defer();
                $http.post(baseUrl + 'SaveOpenStockFromFile', formData, { headers: { 'Content-Type': undefined }, transformRequest: angular.identity }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            },
            addManufacturer: function (q) {
                var deferred = $q.defer();
                $http({ method: 'POST', url: 'admin/AddManufacturer', data: { manuf: q } }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            },
            addSupplier: function (q) {
                var deferred = $q.defer();
                $http({ method: 'POST', url: 'admin/AddSupplier', data: { supplier: q } }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            },
            addRack: function (q) {
                var deferred = $q.defer();
                $http({ method: 'POST', url: 'admin/AddRack', data: { rack: q } }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            },
            addProduct: function (q) {
                var deferred = $q.defer();
                $http({ method: 'POST', url: 'admin/AddProduct', data: { product: q } }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            },
            getAllDrugTypes: function () {
                var deferred = $q.defer();
                $http({ method: 'POST', url: 'admin/GetAllDrugTypes' }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            },
            getAllDrugCategories: function () {
                var deferred = $q.defer();
                $http({ method: 'POST', url: 'admin/GetAllDrugCategories' }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            },
            getAllDrugContents: function () {
                var deferred = $q.defer();
                $http({ method: 'POST', url: 'admin/GetAllDrugContents' }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            },
            getAllDrugGenerics: function () {
                var deferred = $q.defer();
                $http({ method: 'POST', url: 'admin/GetAllDrugGenerics' }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            },
            getAllManufacturers: function () {
                var deferred = $q.defer();
                $http({ method: 'POST', url: 'admin/GetAllManufacturers' }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            },
            getAllDrugUnits: function () {
                var deferred = $q.defer();
                $http({ method: 'POST', url: 'admin/GetAllDrugUnits' }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            },
            getAllRacks: function () {
                var deferred = $q.defer();
                $http({ method: 'POST', url: 'admin/GetAllRacks' }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            },
            getAllTaxs: function () {
                var deferred = $q.defer();
                $http({ method: 'POST', url: 'admin/GetAllTaxs' }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            },
             getSupplierInfo: function (q) {
                var deferred = $q.defer();
                $http({ method: 'POST', url: 'purchasereturn/GetSupplierInvoices', data: { q: q } }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            },
             getInvoiceList: function (q) {
                 var deferred = $q.defer();
                 $http({ method: 'GET', url: baseUrl + 'GetSupplierInvoicesAutoComplete?q=' + q }).success(deferred.resolve).error(deferred.reject);
                 return deferred;
             }
        }
    }


})();