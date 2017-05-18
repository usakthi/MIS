StockAdjustmentEntryController.$inject = ['$scope', '$filter', '$route', '$routeParams', 'StockAdjustmentDataService', 'ManufacturerList', 'PharmacyIdEnc', '$location', 'hotkeys'];

function StockAdjustmentEntryController($scope, $filter, $route, $routeParams, StockAdjustmentDataService, mfgList, PharmacyIdEnc, $location, hotkeys) {
    $scope.stockadjustmentHeader = {};
    $scope.editMode = false;
    $scope.purchaseOrders = [];
    $scope.pIdEnc = PharmacyIdEnc;
    $scope.selectedVal = 0;
   
    $scope.productMaster = [];
    $scope.manfMaster = [];
    $scope.inserted = {};
    $scope.dataLoading = true;
    $scope.authorized = false;
    $scope.validatingCredentials = false;
    $scope.stockadjustmentHeader.SavedUser = { PlainPwd: '' };
    
    $("body").addClass("aside-collapsed");
        $scope.dataLoading = false;

    $scope.sshow = function () {
        var BillNo = $scope.purchaseHeader.BillNo;
        StockAdjustmentDataService.getDueBillInfo(BillNo)
                                .then(function (bill) {
                                    $scope.stockadjustmentHeader = bill;
                                    $scope.purchaseHeader.PatientName = bill.Customer;
                                    $scope.purchaseHeader.BillNumber = bill.BillNo;
                                    $scope.purchaseHeader.BillDt = bill.BillDate;
                                    $scope.purchaseHeader.Consultant = bill.ConsultantName;
                                    $scope.purchaseHeader.TotalAmount = bill.TotalAmount;
                                    $scope.purchaseHeader.Discount = bill.Discount;
                                    $scope.purchaseHeader.NetAmount = bill.NetAmount;
                                    $scope.purchaseHeader.PaidAmount = bill.PaidAmount;
                                    $scope.purchaseHeader.Balance = bill.Balance;
                                    $scope.purchaseHeader.BillCode = bill.BillCode;
                                },
                                      function () { alert('error while loading bill info') }
                               ).finally(function () {
                                   $scope.dataLoading = false;
                               })
    }

    $scope.getbalance = function () {
        var duePaidAmount = $scope.purchaseHeader.DuePaidAmount;
        var paidamount = $scope.purchaseHeader.PaidAmount;
        var netamount = $scope.purchaseHeader.NetAmount;
        var balance = parseFloat(netamount) - (parseFloat(paidamount) + parseFloat(duePaidAmount));
        $scope.purchaseHeader.DueAmount = round(balance, 2);
    }

    $scope.saveStockAdjustment = function () {
        var valid = $scope.validateOrders();
        if ($scope.authorized) {
            $scope.stockadjustmentHeader.PharmacyIdEnc = $scope.pIdEnc;
            $scope.stockadjustmentHeader.DuePaidAmount = $scope.purchaseHeader.DuePaidAmount;
            $scope.stockadjustmentHeader.DueAmount = $scope.purchaseHeader.DueAmount;
            //$scope.stockadjustmentHeader.DueBillsItems = $scope.purchaseOrders;
            //console.log(JSON.stringify($scope.stockadjustmentHeader));
            
            StockAdjustmentDataService.saveStockAdjustment($scope.stockadjustmentHeader)
            .then(function (data) {
                if (data.status === true) {
                    if (data.mode == "add") {
                        $scope.stockadjustmentHeader.Id = data.id;
                        alert('Data Saved Successfully');
                    }
                    $scope.authorized = false;
                    $location.path('');
                }
                alert('Data Saved Successfully');
                $location.path('');
            },
                 function () { alert('error while saving DueReceivable'); $scope.authorized = false; }
            );
        }
        else {
            $scope.showLoginForm();
        }
    }
    $scope.showLoginForm = function () {
        $('#show-purchase-login').modal({ backdrop: false, keyboard: false })
            .one('click', '#authorize', function () {
                $scope.validatingCredentials = true;
                $scope.saveStockAdjustment();

                //StockAdjustmentDataService.authorizeUser($scope.stockadjustmentHeader.SavedUser)
                //            .then(function (data) {
                //                $scope.validatingCredentials = false;
                //                if (data.LoginStatus === 5) {

                //                    $scope.stockadjustmentHeader.SavedUser.UserId = data.UserId;
                //                    $scope.authorized = true;

                //                    $('#show-purchase-login').modal('hide');
                //                    $scope.saveStockAdjustment();
                //                }
                //                if (data.LoginStatus === 2) {
                //                    alert('invalid password');
                //                }
                //            },
                //              function () { alert('error while Saving StockAdjustments') }
                //            );
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

    $scope.getStats = function (q) {
        return $scope.states;
    };

    function round(value, decimals) {
        return Number(Math.round(value + 'e' + decimals) + 'e-' + decimals);
    }

    $scope.validateOrders = function () {

    }
    function getUniqueId() {
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) { var r = Math.random() * 16 | 0, v = c == 'x' ? r : r & 0x3 | 0x8; return v.toString(16); });
    }

    function isValidExpDate(date) {
        var re = /^(1[0-2]|0[1-9]|\d)\/(20\d{2}|19\d{2}|0(?!0)\d|[1-9]\d)$/;
        var patt = new RegExp(re);
        return patt.test(date);
    }

    $(document).keydown(function(e) {
    var nodeName = e.target.nodeName.toLowerCase();

    if (e.which === 8) {
        if ((nodeName === 'input' && e.target.type === 'number' || e.target.type === 'text') ||
            nodeName === 'textarea') {
        } else {
            e.preventDefault();
        }
    }
    });

    hotkeys.bindTo($scope)

    .add({
        combo: 'f3',
        description: 'Save StockAdjustment',
        callback: function (e) {
            e.preventDefault();
            $scope.saveStockAdjustment();
        }
    })
    .add({
        combo: 'f4',
        description: 'Clear StockAdjustment',
        callback: function (e) {
            e.preventDefault();
            $scope.initPurchase();
        }
    })
    .add({
        combo: 'f9',
        description: 'Close',
        callback: function (e) {
            e.preventDefault();
            $location.path('/');
        }
    });
}

StockAdjustmentListController.$inject = ['$scope', '$filter', '$route', 'StockAdjustmentDataService', 'hotkeys', '$location'];

function StockAdjustmentListController($scope, $filter, $route, StockAdjustmentDataService, hotkeys, $location) {
    $scope.adjusts = [];
    $scope.cdate = new Date();

    StockAdjustmentDataService.getDueBillsList()
        .then(function (adjustList) { $scope.adjusts = adjustList },
              function () { alert('error while fetching StockAdjustmentList from server') }
         );

    hotkeys.bindTo($scope)
    .add({
        combo: 'f1',
        description: 'Help',
        callback: function (e) {
            e.preventDefault();
            $('#help-window').modal({ backdrop: false, keyboard: false });
        }
    })
    .add({
        combo: 'f2',
        description: 'AddNew StockAdjustment',
        callback: function (e) {
            e.preventDefault();
            $location.path('/add');
        }
    });

}