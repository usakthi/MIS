
EditedBillListController.$inject = ['$scope', '$filter', '$route', 'EditedBillDataService', 'PharmacyIdEnc', 'uiGridConstants', 'hotkeys'];

function EditedBillListController($scope, $filter, $route, EditedBillDataService, PharmacyIdEnc, uiGridConstants, hotkeys) {
    $scope.purchases = [];
    $scope.purchaseHeader = {};

    $scope.pIdEnc = PharmacyIdEnc;

    var paginationOptions = {
        pageNumber: 1,
        pageSize: 10,
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

        filterOptions: $scope.filterOptions,
        columnDefs: [
          {
              field: 'Id', displayName: '', enableSorting: false, useExternalSorting: false, enableColumnMenu: false,
              cellTemplate: '<div class="form-control"> <a href="#/print/{{row.entity[col.field]}}" class="btn btn-labeled btn-pink btn-xs"> <span class="btn-label"><i class="fa fa-print"></i></span></a> </div>'
          },
          {
              name: 'BillNo', field: 'BillNo', enableSorting: false, useExternalSorting: false
          },
          {
              name: 'BillDate', field: 'BillDate', cellFilter: 'jsonDate', enableFiltering: false, filter: {
                  noTerm: true
              }
          },
          {
              name: 'Customer', field: 'Customer', enableSorting: false
          },
          { name: 'NetAmount', field: 'NetAmount' },
          { name: 'PayMode', field: 'PayMode' }
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
            BillNo: $scope.purchaseHeader.BillNo,
            BillDate: $scope.purchaseHeader.BillDate,
            Customer: $scope.purchaseHeader.Customer,
            IPId: $scope.purchaseHeader.IPId,
            PageNo: paginationOptions.pageNumber,
            PageSize: paginationOptions.pageSize,
            OrderBy: paginationOptions.sort,
            EditedTo: $scope.purchaseHeader.EditedTo,
            EditedFrom: $scope.purchaseHeader.EditedFrom
        };

        EditedBillDataService.SearchPurchases(params)
           .then(function (purchaseList) {
               $scope.gridOptions.data = purchaseList.data;
               $scope.gridOptions.totalItems = purchaseList.total;
           },
             function () { alert('error while fetching purchases from server') }
        );
    }

    $scope.search();
}

//EditedBillPrintController.$inject = ['$scope', '$filter', '$timeout', '$route', '$routeParams', 'EditedBillDataService', '$location']

//function EditedBillPrintController($scope, $filter, $timeout, $route, $routeParams, EditedBillDataService, $location) {
//    $scope.dataLoading = true;
//    $scope.purchaseHeader = {};
//    $scope.purchaseOrders = [];
//    $scope.convertedPdf = false;

//    $scope.dateToLocalDateString = function (dt) {
//        var date = new Date(dt);
//        return date.toLocaleDateString();
//    }

//    $scope.getSupplierName = function (supId) {
//        return $scope.suppliers.find(function (supplier) {
//            return supplier.Id == supId;
//        }).Name;
//    };

//    $scope.showSelectedVAT = function (order) {

//        var selected = [];
//        selected = $filter('filter')($scope.taxes, { Tax: order.VAT });

//        return selected.length ? selected[0].value : $scope.taxes[0].value;
//    };

//    $scope.calculateGrandTotal = function (key) {
//        return $scope.purchaseOrders.reduce(function (a, b) { return a + b[key] }, 0);
//    };

//    $scope.convertToPdf = function () {
//        var doc = new jsPDF('p', 'pt', 'letter');

//        doc.addHTML($("#printContent"), function () {
//            var obj = doc.output('datauristring');
//            document.getElementById('pdfWraper').innerHTML = '<embed style="width:100%;height:500px;" name="plugin" id="plugin" src="' + obj + '" type="application/pdf" internalinstanceid="164" title="Bill Receipt">';
//        });
//        $scope.convertedPdf = true;
//    };

//    $scope.closeForm = function () {
//        $location.path("");
//    };

//    $scope.printForm = function () {
//        window.print();
//    }

//    $("body").addClass("aside-collapsed");
//    if ($routeParams.id && $routeParams.id > 0) {
//        PurchaseDataService.getPurchaseInfo($routeParams.id)
//            .then(function (purchase) {
//                $scope.purchaseHeader = purchase;
//                $scope.purchaseOrders = purchase.PurchaseItems;

//                $timeout($scope.convertToPdf, 0);
//            },
//            function () { alert('error while loading purchase info') })
//            .finally(function () {
//                $scope.dataLoading = false;
//            })
//    }
//    else {
//        $scope.dataLoading = false;
//    }
//}
