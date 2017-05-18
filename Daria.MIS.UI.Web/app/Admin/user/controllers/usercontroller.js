
    SupplierListController.$inject = ['$scope', '$route', 'MasterData'];

    function SupplierListController($scope, $route, MasterData) {
        $scope.suppliers = [];

        MasterData.getAllSuppliers()
            .then(function (suppliers) { $scope.suppliers = suppliers },
                  function () { alert('error while fetching Supplier from server') }
             );
        $scope.delete = function (id) {
            $('#confirm-supplier-delete').modal({ backdrop: false, keyboard: false })
                .one('click', '#delete', function () {
                    MasterData.deleteSupplier(id)
                                .then(function (data) {
                                    if (data.status === true) {
                                        $route.reload();
                                    }
                                },
                                  function () { alert('error while deleting Supplier') }
                                );
                });//end of one
        };

    }


    SupplierAddController.$inject = ['$scope', 'MasterData', '$location'];
    function SupplierAddController($scope, MasterData, $location) {

        $scope.supplier = {};

        $scope.add = function () {
            MasterData.addSupplier($scope.supplier)
           .then(function (data) {
               if (data.status === true) {
                   $location.path('/supplier');
               }
           },
                 function () { alert('error while adding supplier') }
            );
        };
        $scope.Types = [];
        MasterData.getAllDrugTypes()
            .then(function (Types) { $scope.Types = Types },
                                      function () { alert('error while fetching type from server') }
                           );

        $scope.$watch('supplier.Name', function (scope) {
            var supp = scope;
            alert(supp);
            if (supp === 'undefined') {
                //alert('123');
            }
        });
    }

    SupplierEditController.$inject = ['$scope', '$routeParams', '$location', 'MasterData'];

    function SupplierEditController($scope, $routeParams, $location, MasterData) {
        $scope.supplier = {};
        MasterData.getSupplier($routeParams.id)
                                 .then(function (supplier) { $scope.supplier = supplier },
                                       function () { alert('error while updating supplier') }
                                );
        $scope.edit = function () {
            MasterData.editSupplier($scope.supplier)
           .then(function (data) {
               if (data.status === true) {
                   $location.path('/supplier');
               }
           },
                 function () { alert('error while editing supplier') }
           );
        };
        $scope.Types = [];
        MasterData.getAllDrugTypes()
            .then(function (Types) { $scope.Types = Types },
                                      function () { alert('error while fetching type from server') }
            );
    }

