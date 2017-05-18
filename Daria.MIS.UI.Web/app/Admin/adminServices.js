(function () {
    'use strict';

    angular
        .module('adminServices', ['ngResource'])
        .factory('MasterData', MasterData);

    MasterData.$inject = ['$http', '$q'];

    function MasterData($http, $q) {
        var baseUrl = '/admin/';
        return {
            getAllDrugUnits: function () {
                // Get the deferred object
                var deferred = $q.defer();
                // Initiates the AJAX call
                $http({ method: 'POST', url: baseUrl + 'GetAllDrugUnits' }).success(deferred.resolve).error(deferred.reject);
                // Returns the promise - Contains result once request completes
                return deferred.promise;
            },

            getDrugUnit: function (unitId) {
                var deferred = $q.defer();
                $http({ method: 'POST', url: baseUrl + 'GetDrugUnit', data: { id: unitId } }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            },

            addDrugUnit: function (drugUnit) {
                var deferred = $q.defer();
                $http({ method: 'POST', url: baseUrl + 'AddDrugUnit', data: { unit: drugUnit } }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            },

             editDrugUnit: function (drugUnit) {
                var deferred = $q.defer();
                $http({ method: 'POST', url: baseUrl + 'EditDrugUnit', data: { unit: drugUnit } }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
             },
             deleteDrugUnit: function (unitId) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'DeleteDrugUnit', data: { id: unitId } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             getAllTaxs: function () {
                 // Get the deferred object
                 var deferred = $q.defer();
                 // Initiates the AJAX call
                 $http({ method: 'POST', url: baseUrl + 'GetAllTaxs' }).success(deferred.resolve).error(deferred.reject);
                 // Returns the promise - Contains result once request completes
                 return deferred.promise;
             },

             getTax: function (taxId) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'GetTax', data: { id: taxId } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },

             addTax: function (Tax) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'AddTax', data: { tax: Tax } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },

             editTax: function (Tax) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'EditTax', data: { tax: Tax } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             deleteTax: function (taxId) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'DeleteTax', data: { id: taxId } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             getAllRacks: function () {
                 // Get the deferred object
                 var deferred = $q.defer();
                 // Initiates the AJAX call
                 $http({ method: 'POST', url: baseUrl + 'GetAllRacks' }).success(deferred.resolve).error(deferred.reject);
                 // Returns the promise - Contains result once request completes
                 return deferred.promise;
             },

             getRack: function (rackId) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'GetRack', data: { id: rackId } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },

             addRack: function (Rack) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'AddRack', data: { rack: Rack } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },

             editRack: function (Rack) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'EditRack', data: { rack: Rack } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             deleteRack: function (rackId) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'DeleteRack', data: { id: rackId } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             getAllManufacturers: function () {
                 // Get the deferred object
                 var deferred = $q.defer();
                 // Initiates the AJAX call
                 $http({ method: 'POST', url: baseUrl + 'GetAllManufacturers' }).success(deferred.resolve).error(deferred.reject);
                 // Returns the promise - Contains result once request completes
                 return deferred.promise;
             },

             getManufacturer: function (manfId) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'GetManufacturer', data: { id: manfId } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },

             addManufacturer: function (manufacturer) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'AddManufacturer', data: { manuf: manufacturer } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },

             editManufacturer: function (manufacturer) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'EditManufacturer', data: { manuf: manufacturer } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             deleteManufacturer: function (manfId) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'DeleteManufacturer', data: { id: manfId } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             getAllDrugTypes: function () {
                 // Get the deferred object
                 var deferred = $q.defer();
                 // Initiates the AJAX call
                 $http({ method: 'POST', url: baseUrl + 'GetAllDrugTypes' }).success(deferred.resolve).error(deferred.reject);
                 // Returns the promise - Contains result once request completes
                 return deferred.promise;
             },

             getDrugType: function (typeId) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'GetDrugType', data: { id: typeId } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },

             addDrugType: function (Type) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'AddDrugType', data: { type: Type } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },

             editDrugType: function (Type) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'EditDrugType', data: { type: Type } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             deleteDrugType: function (typeId) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'DeleteDrugType', data: { id: typeId } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             getAllDepartments: function () {
                 // Get the deferred object
                 var deferred = $q.defer();
                 // Initiates the AJAX call
                 $http({ method: 'POST', url: baseUrl + 'GetAllDepartments' }).success(deferred.resolve).error(deferred.reject);
                 // Returns the promise - Contains result once request completes
                 return deferred.promise;
             },

             getDepartment: function (deptId) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'GetDepartment', data: { id: deptId } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },

             addDepartment: function (Deparmtent) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'AddDepartment', data: { dept: Deparmtent } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },

             editDepartment: function (Deparmtent) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'EditDepartment', data: { dept: Deparmtent } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             deleteDepartment: function (deptId) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'DeleteDepartment', data: { id: deptId } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },

             getAllConsultants: function () {
                 // Get the deferred object
                 var deferred = $q.defer();
                 // Initiates the AJAX call
                 $http({ method: 'POST', url: baseUrl + 'GetAllConsultants' }).success(deferred.resolve).error(deferred.reject);
                 // Returns the promise - Contains result once request completes
                 return deferred.promise;
             },

             getConsultant: function (consId) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'GetConsultant', data: { id: consId } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },

             addConsultant: function (Consultant) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'AddConsultant', data: { con: Consultant } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },

             editConsultant: function (Consultant) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'EditConsultant', data: { con: Consultant } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             deleteConsultant: function (consId) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'DeleteConsultant', data: { id: consId } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },

             getAllDrugContents: function () {
                 // Get the deferred object
                 var deferred = $q.defer();
                 // Initiates the AJAX call
                 $http({ method: 'POST', url: baseUrl + 'GetAllDrugContents' }).success(deferred.resolve).error(deferred.reject);
                 // Returns the promise - Contains result once request completes
                 return deferred.promise;
             },

             getDrugContent: function (contId) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'GetDrugContent', data: { id: contId } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },

             addDrugContent: function (Content) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'AddDrugContent', data: { cont: Content } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },

             editDrugContent: function (Content) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'EditDrugContent', data: { cont: Content } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             deleteDrugContent: function (contId) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'DeleteDrugContent', data: { id: contId } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             getAllDrugCategories: function () {
                 // Get the deferred object
                 var deferred = $q.defer();
                 // Initiates the AJAX call
                 $http({ method: 'POST', url: baseUrl + 'GetAllDrugCategories' }).success(deferred.resolve).error(deferred.reject);
                 // Returns the promise - Contains result once request completes
                 return deferred.promise;
             },

             getDrugCategory: function (catId) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'GetDrugCategory', data: { id: catId } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },

             addDrugCategory: function (category) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'AddDrugCategory', data: { cat: category } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },

             editDrugCategory: function (category) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'EditDrugCategory', data: { cat: category } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             deleteDrugCategory: function (catId) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'DeleteDrugCategory', data: { id: catId } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             getAllBanks: function () {
                 // Get the deferred object
                 var deferred = $q.defer();
                 // Initiates the AJAX call
                 $http({ method: 'POST', url: baseUrl + 'GetAllBanks' }).success(deferred.resolve).error(deferred.reject);
                 // Returns the promise - Contains result once request completes
                 return deferred.promise;
             },

             getBank: function (banId) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'GetBank', data: { id: banId } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },

             addBank: function (bank) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'AddBank', data: { ban: bank } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },

             editBank: function (bank) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'EditBank', data: { ban: bank } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },

             deleteBank: function (banId) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'DeleteBank', data: { id: banId } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             getAllCreditAuths: function () {
                 // Get the deferred object
                 var deferred = $q.defer();
                 // Initiates the AJAX call
                 $http({ method: 'POST', url: baseUrl + 'GetAllCreditAuths' }).success(deferred.resolve).error(deferred.reject);
                 // Returns the promise - Contains result once request completes
                 return deferred.promise;
             },

             getCreditAuth: function (creditauthId) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'GetCreditAuth', data: { id: creditauthId } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },

             addCreditAuth: function (creditauth) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'AddCreditAuth', data: { creditauth: creditauth } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },

             editCreditAuth: function (creditauth) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'EditCreditAuth', data: { creditauth: creditauth } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             deleteCreditAuth: function (creditauthId) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'DeleteCreditAuth', data: { id: creditauthId } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             getAllDrugGenerics: function () {
                 // Get the deferred object
                 var deferred = $q.defer();
                 // Initiates the AJAX call
                 $http({ method: 'POST', url: baseUrl + 'GetAllDrugGenerics' }).success(deferred.resolve).error(deferred.reject);
                 // Returns the promise - Contains result once request completes
                 return deferred.promise;
             },

             getDrugGeneric: function (druggenericId) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'GetDrugGeneric', data: { id: druggenericId } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },

             addDrugGeneric: function (DrugGeneric) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'AddDrugGeneric', data: { druggeneric: DrugGeneric } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },

             editDrugGeneric: function (DrugGeneric) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'EditDrugGeneric', data: { druggeneric: DrugGeneric } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             deleteDrugGeneric: function (druggenericId) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'DeleteDrugGeneric', data: { id: druggenericId } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             //getAllProducts: function () {
             //    var deferred = $q.defer();
             //    $http({ method: 'POST', url: baseUrl + 'GetAllProducts' }).success(deferred.resolve).error(deferred.reject);
             //    return deferred.promise;
             //},
             getProduct: function (productId) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'GetProduct', data: { id: productId } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             addProduct: function (product) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'AddProduct', data: { product: product } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             editProduct: function (product) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'EditProduct', data: { product: product } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             deleteProduct: function (productId) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'DeleteProduct', data: { id: productId } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             getAllPurchaseRequestDetails: function () {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'GetAllPurchaseRequestDetails' }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             getPurchaseRequestDetail: function (purchaserequestId) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'GetPurchaseRequestDetail', data: { id: purchaserequestId } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             addPurchaseRequestDetails: function (PurchaseRequestDetails) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'AddPurchaseRequestDetails', data: { purchaserequest: PurchaseRequestDetails } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             editPurchaseRequestDetails: function (PurchaseRequestDetails) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'EditPurchaseRequestDetails', data: { purchaserequest: PurchaseRequestDetails } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             deletePurchaseRequestDetails: function (purchaserequestId) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'DeletePurchaseRequestDetails', data: { id: purchaserequestId } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             getAllSuppliers: function () {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'GetAllSuppliers' }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             getSupplier: function (supplierId) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'GetSupplier', data: { id: supplierId } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },

             addSupplier: function (Supplier) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'AddSupplier', data: { supplier: Supplier } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },

             editSupplier: function (Supplier) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'EditSupplier', data: { supplier: Supplier } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             deleteSupplier: function (supplierId) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'DeleteSupplier', data: { id: supplierId } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             getAllPatients: function () {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'GetAllPatients' }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             getPatient: function (patientId) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'GetPatient', data: { id: patientId } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },

             addPatient: function (Patient) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'AddPatient', data: { patient: Patient } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },

             editPatient: function (Patient) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'EditPatient', data: { patient: Patient } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             deletePatient: function (patientId) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'DeletePatient', data: { id: patientId } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             SearchProducts: function (searchParams) {
                var deferred = $q.defer();
                $http({ method: 'POST', url: baseUrl + 'SearchProducts', data: { model: searchParams } }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
             },

             getAllRoles: function () {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'GetAllRoles' }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             getRole: function (roleId) {
                 if (roleId == null) { roleId = 0; }
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'GetRole', data: { id: roleId } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             saveRole: function (RoleViewModel) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'SaveRole', data: { viewModel: RoleViewModel } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },
             deleteRole: function (roleId) {
                 var deferred = $q.defer();
                 $http({ method: 'POST', url: baseUrl + 'DeleteRole', data: { id: roleId } }).success(deferred.resolve).error(deferred.reject);
                 return deferred.promise;
             },

            getAllUsers: function () {
                var deferred = $q.defer();
                $http({ method: 'POST', url: baseUrl + 'GetAllUsers' }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            },
            getUser: function (userId) {
                var deferred = $q.defer();
                $http({ method: 'POST', url: baseUrl + 'GetUser', data: { id: userId } }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            },

            addUser: function (User) {
                var deferred = $q.defer();
                $http({ method: 'POST', url: baseUrl + 'AddUser', data: { user: User } }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            },

            editUser: function (User) {
                var deferred = $q.defer();
                $http({ method: 'POST', url: baseUrl + 'EditUser', data: { user: User } }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            },
            deleteUser: function (userId) {
                var deferred = $q.defer();
                $http({ method: 'POST', url: baseUrl + 'DeleteUser', data: { id: userId } }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            },

            getManufacturerList: function (q) {
                var deferred = $q.defer();
                $http({ method: 'GET', url: baseUrl + 'GetManufacturesAutoComplete?q=' + q }).success(deferred.resolve).error(deferred.reject);
                return deferred;
            },
            getAllCustomers: function () {
                var deferred = $q.defer();
                $http({ method: 'POST', url: baseUrl + 'GetAllCustomers' }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            },
            getCustomer: function (customerId) {
                var deferred = $q.defer();
                $http({ method: 'POST', url: baseUrl + 'GetCustomer', data: { id: customerId } }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            },

            addCustomer: function (Customer) {
                var deferred = $q.defer();
                $http({ method: 'POST', url: baseUrl + 'AddCustomer', data: { customer: Customer } }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            },

            editCustomer: function (Customer) {
                var deferred = $q.defer();
                $http({ method: 'POST', url: baseUrl + 'EditCustomer', data: { customer: Customer } }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            },
            deleteCustomer: function (CustomerId) {
                var deferred = $q.defer();
                $http({ method: 'POST', url: baseUrl + 'DeleteCustomer', data: { id: CustomerId } }).success(deferred.resolve).error(deferred.reject);
                return deferred.promise;
            }
        }
    }


})();