
DepartmentStockListController.$inject = ['$scope', '$filter', '$route', 'DepartmentStockDataService', 'SupplierList', 'ManufacturerList', 'UnitList', 'PharmacyIdEnc', 'uiGridConstants'];

function DepartmentStockListController($scope, $filter, $route, DepartmentStockDataService, suppList, mfgList, unitList, PharmacyIdEnc, uiGridConstants) {

    $scope.purchaseHeader = {};
    $scope.suppliers = suppList;
    $scope.manufacturers = mfgList;
    $scope.units = unitList;
    $scope.pIdEnc = PharmacyIdEnc;

    $scope.purchases = [];

    $scope.cdate = new Date();

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
        paginationPageSize: 10,
        useExternalPagination: true,
        useExternalSorting: true,
        
        ////{
        ////    field: 'Id', displayName: '', enableSorting: false, useExternalSorting: false,  enableColumnMenu:false,
        ////    cellTemplate: '<div class="form-control"> <a href="#/edit/{{row.entity[col.field]}}" class="btn btn-labeled btn-purple btn-xs"> <span class="btn-label"><i class="fa fa-edit"></i></span> <span class="hidden-xs">Edit</span></a> <a ng-click="grid.appScope.delete(COL_FIELD)" class="btn btn-labeled btn-danger btn-xs"><span class="btn-label"><i class="fa fa-times"></i></span><span class="hidden-xs">Delete</span> </a></div>'
        ////},
        //{ name: 'Unit Cost', field: 'CostPrice' },
        //{ name: 'Total Cost', field: 'TotalCost' },
        //{ name: 'MRP', field: 'Mrp' },
        //{ name: 'Total Mrp', field: 'TotalMrp' },
        //{ name: 'VAT', field: 'Vat' }
        //{ name: 'Code', field: 'Id', enableSorting: true },

        filterOptions: $scope.filterOptions,
        columnDefs: [
          {
              name: 'S.No', field: 'SNo', enableSorting: true, useExternalSorting: true
          },
          {
              name: 'Item Name', field: 'DrugName', width:150, enableFiltering: true, filter: {
                  noTerm: true
              }
          },
          { name: 'Qty', field: 'Qty' },
          { name: 'Batch', field: 'BatchNo' },
          { name: 'Mfg', field: 'Manufacturer.Name' },
          { name: 'Department', field: 'Category.Name' }
        ],
        onRegisterApi: function (gridApi) {
            $scope.gridApi = gridApi;

            $scope.gridApi.core.on.sortChanged($scope, function (grid, sortColumns) {
                if (sortColumns.length == 0) {
                    paginationOptions.sort = null;
                } else {                    
                    paginationOptions.sort = sortColumns[0].field+'_'+sortColumns[0].sort.direction;
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
        $('#confirm-purchase-delete').modal({ backdrop: false, keyboard: false })
            .on('click', '#delete', function () {
                DepartmentStockDataService.deletePurchase(id)
                            .then(function (data) {
                                if (data.status === true) {
                                    $route.reload();
                                }
                            },
                              function () { alert('error while deleting purchase') }
                            );
            });//end of one
    };

    $scope.openDatePicker = function ($event, opened) {
        $event.preventDefault();
        $event.stopPropagation();

        $scope[opened] = true;
    };
    $scope.dateOptions = {
        formatYear: 'yy',
        startingDay: 1
    };



    $scope.search = function () {

        var params = {
            GrnNo: $scope.purchaseHeader.GrnNo,
            GrnDate: $scope.purchaseHeader.GrnDate,
            SupplierInvNo: $scope.purchaseHeader.SupplierInvNo,
            SupplierId: $scope.purchaseHeader.SupplierId,            
            PageNo: paginationOptions.pageNumber,
            PageSize: paginationOptions.pageSize,
            OrderBy: paginationOptions.sort,
            AddedTo: $scope.purchaseHeader.AddedTo,
            AddedFrom: $scope.purchaseHeader.AddedFrom
        };


        DepartmentStockDataService.RptCurrentStock(params)
           .then(function (purchaseList) {
               $scope.gridOptions.data = purchaseList.data;
               $scope.gridOptions.totalItems = purchaseList.total;
           },
             function () { alert('error while fetching purchases from server') }
        );
    }

    $scope.search();
}