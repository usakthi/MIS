ProductListController.$inject = ['$scope', '$filter', '$route', 'MasterData', 'uiGridConstants'];

function ProductListController($scope, $filter, $route, MasterData, uiGridConstants) {
    
    $scope.product = {};
    $scope.products = [];

    var paginationOptions = {
        pageNumber: 1,
        pageSize: 25,
        sort: null
    };
    
    $scope.filterOptions = {
        filterText: "",
        useExternalFilter: true
    };
    
    $scope.gridOptions = {
        paginationPageSizes: [10, 25, 50, 75],
        paginationPageSize: 25,
        useExternalPagination: true,
        useExternalSorting: true,
        
        filterOptions: $scope.filterOptions,
        columnDefs: [
          {
              field: 'Id', displayName: '', enableSorting: false, useExternalSorting: false, enableColumnMenu: false,
              cellTemplate: '<div class="form-control" height="500px"> <a href="#/product/edit/{{row.entity[col.field]}}" class="btn btn-labeled btn-purple btn-xs"> <span class="btn-label"><i class="fa fa-edit"></i></span> <span class="hidden-xs"></span></a> <a ng-click="grid.appScope.delete(COL_FIELD)" class="btn btn-labeled btn-danger btn-xs"><span class="btn-label"><i class="fa fa-times"></i></span><span class="hidden-xs"></span> </a></div>'
          },
          {
              name: 'Sl No', field: 'SlNo', enableSorting: false, useExternalSorting: false
          },
          {
              name: 'Drug Name', field: 'DrugName', enableFiltering: false
          },
          {
              name: 'Type', field: 'Type', enableSorting: false
          }
        ],
        onRegisterApi: function (gridApi) {
            $scope.gridApi = gridApi;

            $scope.gridApi.core.on.sortChanged($scope, function (grid, sortColumns) {
                if (sortColumns.length == 0) {
                    paginationOptions.sort = null;
                } else {
                    paginationOptions.sort = sortColumns[0].field + '_' + sortColumns[0].sort.direction;
                }
                $scope.search();
            });

            
            gridApi.pagination.on.paginationChanged($scope, function (newPage, pageSize) {
                paginationOptions.pageNumber = newPage;
                paginationOptions.pageSize = pageSize;
                $scope.search();
                
            });
        }
    };


    $scope.delete = function (id) {
        $('#confirm-product-delete').modal({ backdrop: false, keyboard: false })
            .one('click', '#delete', function () {
                MasterData.deleteProduct(id)
                            .then(function (data) {
                                if (data.status === true) {
                                    $route.reload();
                                }
                            },
                              function () { alert('error while deleting product') }
                            );
            });
    };

    $scope.search = function () {
        var params = {
            DrugName: $scope.product.DrugName,
            Type: $scope.product.Type,
            PageNo: paginationOptions.pageNumber,
            PageSize: paginationOptions.pageSize,
            OrderBy: paginationOptions.sort,
        };


        MasterData.SearchProducts(params)
           .then(function (productList) {
               $scope.gridOptions.data = productList.data;
               $scope.gridOptions.totalItems = productList.total;
               
           },
             function () { alert('error while fetching products from server') }
        );
    }

    $scope.search();

}

    ProductAddController.$inject = ['$scope', '$routeParams', 'MasterData', '$location', '$q'];

    function ProductAddController($scope, $routeParams, MasterData, $location, $q) {
        
        $scope.product = { Name: '', Desc: '', isActive: true };
        
        $scope.add = function () {
            MasterData.addProduct($scope.product)
           .then(function (data) {
               if (data.status === true) {
                   $location.path('/product');
               }
           },
                 function () { alert('error while adding product') }
            );
        };
        $scope.Type = [];
        MasterData.getAllDrugTypes()
            .then(function (Type) { $scope.Type = Type },
                                      function () { alert('error while fetching type from server') }
                           );
        $scope.category = [];
        MasterData.getAllDrugCategories()
            .then(function (category) { $scope.category = category },
                                      function () { alert('error while fetching category from server') }
                                      );
        $scope.Content = [];
        MasterData.getAllDrugContents()
            .then(function (Content) { $scope.Content = Content },
                                      function () { alert('error while fetching content from server') }
                                      );
        $scope.Generic = [];
        MasterData.getAllDrugGenerics()
            .then(function (Generic) { $scope.Generic = Generic },
                                      function () { alert('error while fetching generic from server') }
                                      );

        $scope.Man = [];
        MasterData.getAllManufacturers()
            .then(function (Man) { $scope.Man = Man },
                                         function () { alert('error while fetching manufacturer from server') }
                                         );
        $scope.unit = [];
        MasterData.getAllDrugUnits()
            .then(function (unit) { $scope.unit = unit },
            function () { alert('error while fetching units from server') }
            );
        $scope.rack = [];
        MasterData.getAllRacks()
            .then(function (rack) { $scope.rack = rack },
            function () { alert('error while fetching racks from server') }
            );
        $scope.tax = [];
        MasterData.getAllTaxs()
            .then(function (tax) { $scope.tax = tax },
            function () { alert('error while fetching taxs from server') }
            );

        $scope.manfMaster = [];
        $scope.manfList = function (q) {
            var def = MasterData.getManufacturerList(q);
            $scope.manfMaster = def.resolve;
            var deferred = $q.defer();
            def.promise.then(function (data) {
                if (data.findIndex(function (o) { return o.label === q; }) == -1)
                    data.splice(0, 0, { 'label': 'Add "' + q + '"', 'isNew': true, 'q': q });
                deferred.resolve(data);
            }, deferred.reject);
            return deferred.promise;
        };

        $scope.onManfSelect = function ($item, $model, $label) {
            if (!$item.isNew) {
                $scope.product.ManfId = $item.id;
            }
            else {
                //$scope.addNewMfg($item.q)
            }
        };

    }

    ProductEditController.$inject = ['$scope', '$routeParams', '$location', 'MasterData'];

    function ProductEditController($scope, $routeParams, $location, MasterData) {
        $scope.product = {};
        MasterData.getProduct($routeParams.id)
                                 .then(function (product) { $scope.product = product },
                                       function () { alert('error while updating product') }
                                );
        $scope.edit = function () {
            MasterData.editProduct($scope.product)
           .then(function (data) {
               if (data.status === true) {
                   $location.path('/product');
               }
            },
                 function () { alert('error while editing product') }
           );
        };
        $scope.Type = [];
        MasterData.getAllDrugTypes()
            .then(function (Type) { $scope.Type = Type },
                                      function () { alert('error while fetching type from server') }
                           );
        $scope.category = [];
        MasterData.getAllDrugCategories()
            .then(function (category) { $scope.category = category },
                                      function () { alert('error while fetching category from server') }
                                      );
        $scope.Content = [];
        MasterData.getAllDrugContents()
            .then(function (Content) { $scope.Content = Content },
                                      function () { alert('error while fetching content from server') }
                                      );
        $scope.Generic = [];
        MasterData.getAllDrugGenerics()
            .then(function (Generic) { $scope.Generic = Generic },
                                      function () { alert('error while fetching generic from server') }
                                      );

        $scope.Man = [];
        MasterData.getAllManufacturers()
            .then(function (Man) { $scope.Man = Man },
                                         function () { alert('error while fetching manufacturer from server') }
                                         );
        $scope.unit = [];
        MasterData.getAllDrugUnits()
            .then(function (unit) { $scope.unit = unit },
            function () { alert('error while fetching units from server') }
            );
        $scope.rack = [];
        MasterData.getAllRacks()
            .then(function (rack) { $scope.rack = rack },
            function () { alert('error while fetching racks from server') }
            );
        $scope.tax = [];
        MasterData.getAllTaxs()
            .then(function (tax) { $scope.tax = tax },
            function () { alert('error while fetching taxs from server') }
            );

    }  
