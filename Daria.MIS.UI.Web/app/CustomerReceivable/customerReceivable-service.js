(function () {
    'use strict';

    angular
        .module('customerreceivableService', ['ngResource'])
        .factory('CustomerReceivableDataService', CustomerReceivableDataService);

    CustomerReceivableDataService.$inject = ['$http', '$q'];

    function CustomerReceivableDataService($http, $q) {
        var baseUrl = '/customerreceivable/';
        return {
            getCustomerReceivableList: function () {
                var deferred = $q.defer();
                $http({ method: 'POST', url: baseUrl + 'GetCustomerReceivableList' }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            },
            GetAllDueLists: function () {
                var deferred = $q.defer();
                $http({ method: 'POST', url: baseUrl + 'getCustomerDueList' }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            },

            getCustomerDueInfo: function (pId) {
                var deferred = $q.defer();
                $http({ method: 'POST', url: baseUrl + 'GetCustomerDueInfo', data: { id: pId } }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            },

            saveCustomerReceivable: function (purchase) {
                var deferred = $q.defer();
                $http({ method: 'POST', url: baseUrl + 'SaveCustomerReceivable', data: { model: purchase } }).success(deferred.resolve).error(deferred.reject);
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
            getCustomerList: function (q) {
                var deferred = $q.defer();
                $http({ method: 'GET', url: '/admin/GetCustomerAutoComplete?q=' + q }).success(deferred.resolve).error(deferred.reject);
                return deferred;
            },
            saveDueReceivable: function (q) {
                var deferred = $q.defer();
                $http({ method: 'POST', url: baseUrl + 'SaveDueReceivable', data: {q : q} }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            }
        }
    }


})();