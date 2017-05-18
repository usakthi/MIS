IndentReceivableEntryController.$inject = ['$scope', '$filter', '$route', '$routeParams', 'IndentReceivableDataService', 'SupplierList', 'RackList', 'ManufacturerList', 'UnitList', 'DueList', 'PharmacyIdEnc', '$location'];

function IndentReceivableEntryController($scope, $filter, $route, $routeParams, IndentReceivableDataService, suppList, rackList, mfgList, unitList, dueList, PharmacyIdEnc, $location) {
    $scope.purchaseHeader = {};
    $scope.suppliers = suppList;
    $scope.editMode = false;
    $scope.racks = rackList;
    $scope.manufacturers = mfgList;
    $scope.units = unitList;
    $scope.dues = dueList;
    $scope.taxes = [{ value: 5.5, text: '5.5' }, { value: 14.5, text: '14.5' }];
    $scope.purchaseOrders = [];
    $scope.pIdEnc = PharmacyIdEnc;
    $scope.purchaseId = 0;
    $scope.selectedVal = 0;
    $scope.purchaseHeader.CreditPeriod = 0;
    $scope.purchaseHeader.NetAmount = 0;
    $scope.purchaseHeader.TotalVAT = 0;
    $scope.purchaseHeader.GrnDate = new Date();
    $scope.purchaseHeader.SupplierInvDate = new Date();
    
    if ($routeParams.id && $routeParams.id > 0) {
        $scope.editMode = true;
    }
    $scope.updateDueDate = function (date, days) {
        if (angular.isDate(date)) {
            var copiedDate = new Date(date.getTime());
            copiedDate.setDate(copiedDate.getDate() + days);
            $scope.purchaseHeader.CreditDate = copiedDate;
        }

    }
   
    $scope.productMaster = [];
    $scope.manfMaster = [];
    $scope.inserted = {};
    $scope.purchaseHeader.DiscountPercent = 0;
    $scope.dataLoading = true;
    $scope.authorized = false;
    $scope.validatingCredentials = false;
    $scope.purchaseHeader.SavedUser = { PlainPwd: '' };
    $("body").addClass("aside-collapsed");
    if ($routeParams.id && $routeParams.id > 0) {
        IndentReceivableDataService.getPurchaseInfo($routeParams.id)
                                .then(function (purchase) {
                                    $scope.purchaseHeader = purchase;
                                    $scope.purchaseOrders = purchase.IndentReceivableItems;
                                },
                                      function () { alert('error while loading purchase info') }
                               ).finally(function () {
                                   $scope.dataLoading = false;
                               })
    }
    else {
        $scope.dataLoading = false;
    }

    $scope.purchaseHeader.PatientName = '';
    $scope.purchaseHeader.Age = '';
    $scope.purchaseHeader.RegNo = '';
    $scope.purchaseHeader.PayMode = '';
    $scope.purchaseHeader.Ward = '';
    $scope.purchaseHeader.Consultant = '';
    $scope.$watch('purchaseHeader.BillCode', function (scope) {
        if (scope > 0) {
            IndentReceivableDataService.getIndentInfo(scope)
                                    .then(function (purchase) {
                                        $scope.purchaseHeader = purchase;
                                        $scope.purchaseHeader.PatientName = purchase.PatientName;
                                        $scope.purchaseOrders = purchase.IndentReceivableItems;
                                    },
                                          function () { alert('error while loading Due List info') }
                                   ).finally(function () {
                                       $scope.dataLoading = false;
                                   })
        }
        $scope.upCalcAmount();
    });

    
    $scope.$watch('purchaseHeader.SupplierId', function (newValue, oldValue, scope) {
        if (newValue != oldValue) {
            var selected = $filter('filter')($scope.suppliers, { Id: parseInt(newValue, 10) }, true)[0];
        }
    });

    $scope.SetAmount = function () {
        var totAmt = $scope.purchaseHeader.TotalAmount;
        var paid = $scope.purchaseHeader.NetAmount;
        var bal = $scope.purchaseHeader.Balance;
        var scope = $scope.purchaseHeader.PaidAmount;
        if (scope > 0) {
            var pay = 0;
            for (var i = 0; i < $scope.purchaseOrders.length; i++) {
                //if (isFinite($scope.purchaseOrders[i].Payable)) {
                var balitem = $scope.purchaseOrders[i].TotalMRP;
                //pay = scope;

                if (scope < balitem) {

                    $scope.purchaseOrders[i].Payable = scope; // scope - balitem;
                    bal = balitem - scope;
                    $scope.purchaseOrders[i].Balance = $scope.purchaseOrders[i].NetAmount - $scope.purchaseOrders[i].Payable;
                    scope = 0;
                }
                else {
                    pay = balitem - scope;
                    $scope.purchaseOrders[i].Payable = balitem;
                    $scope.purchaseOrders[i + 1].Payable = scope - $scope.purchaseOrders[i].Payable;
                    bal = scope - balitem;
                    $scope.purchaseOrders[i].Balance = $scope.purchaseOrders[i].NetAmount - $scope.purchaseOrders[i].Payable
                    scope = scope - $scope.purchaseOrders[i].Payable;
                    //$scope.purchaseOrders[i].Balance = balitem;

                }

                //pay = scope - $scope.purchaseOrders[1].Payable;
            }
        }
    }

    $scope.savePurchase = function () {

        var valid = $scope.validateOrders();
        if ($scope.authorized) {
            $scope.purchaseHeader.PharmacyIdEnc = $scope.pIdEnc;
            $scope.purchaseHeader.IndentReceivableItems = $scope.purchaseOrders;

            IndentReceivableDataService.savePurchase($scope.purchaseHeader)
            .then(function (data) {
                if (data.status === true) {
                    if (data.mode == "add") {
                        $scope.purchaseHeader.Id = data.id;
                        alert('Data Saved Successfully');
                    }
                    $scope.authorized = false;
                    $location.path('');
                }
            },
                 function () { alert('error while saving Bill'); $scope.authorized = false; }
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
                IndentReceivableDataService.authorizeUser($scope.purchaseHeader.SavedUser)
                            .then(function (data) {
                                $scope.validatingCredentials = false;
                                if (data.LoginStatus === 5) {

                                    $scope.purchaseHeader.SavedUser.UserId = data.UserId;
                                    $scope.authorized = true;


                                    $('#show-purchase-login').modal('hide');
                                    $scope.savePurchase();
                                }
                                if (data.LoginStatus === 2) {
                                    alert('invalid password');
                                }
                            },
                              function () { alert('error while deleting purchase') }
                            );
            });//end of one
    };

    $scope.savePurchaseItem = function (data, id, rowform, idx) {
        var selected = [];
        var idx = -1;
        selected = $filter('filter')($scope.purchaseOrders, { Id: id }, true)[0];
        idx = $scope.purchaseOrders.indexOf(selected);
        $scope.purchaseOrders[idx].ProductId = data.ProductId;
        $scope.purchaseOrders[idx].ManufacturerId = data.ManufacturerId;

        $scope.purchaseOrders[idx].CostPrice = data.CostPrice;
        $scope.purchaseOrders[idx].MRP = data.MRP;
        $scope.purchaseOrders[idx].TaxPercent = data.TaxPercent;

        $scope.purchaseOrders[idx].TaxAmount = data.VATAmount;
        $scope.purchaseOrders[idx].DiscPercent = data.DiscPercent;
        $scope.purchaseOrders[idx].Discount = data.Discount;
        $scope.purchaseOrders[idx].TotalCostPrice = data.TotalCostPrice;
        $scope.purchaseOrders[idx].TotalMRP = data.TotalMRP;
        $scope.purchaseOrders[idx].savedLocal = true;
        $scope.updateCalcAmount();
    }

    $scope.checkProductName = function (data, rowform) {
        if (data === "" || typeof (data) === 'undefined' || data == null) {
            return "Please enter product name";
        }
    }

    $scope.updateCalcAmount = function (data) {
        var amt = 0;
        var bal = 0;
        var paid = 0;
        for (var i = 0; i < $scope.purchaseOrders.length; i++) {
            if (isFinite($scope.purchaseOrders[i].TotalMRP)) {
                amt = amt + parseFloat($scope.purchaseOrders[i].NetAmount);
                paid = paid + parseFloat($scope.purchaseOrders[i].PaidAmount);
                bal = bal + parseFloat($scope.purchaseOrders[i].Balance);
            }
        }
        $scope.purchaseHeader.TotalAmount = amt;
        $scope.purchaseHeader.NetAmount = paid;
        $scope.purchaseHeader.Balance = bal;
    }

    $scope.upCalcAmount = function () {
        var amt = 0;
        var bal = 0;
        var paid = 0;
        for (var i = 0; i < $scope.purchaseOrders.length; i++) {
            if (isFinite($scope.purchaseOrders[i].TotalMRP)) {
                amt = amt + parseFloat($scope.purchaseOrders[i].NetAmount);
                paid = paid + parseFloat($scope.purchaseOrders[i].PaidAmount);
                bal = bal + parseFloat($scope.purchaseOrders[i].Balance);
            }
        }
        $scope.purchaseHeader.TotalAmount = amt;
        $scope.purchaseHeader.NetAmount = paid;
        $scope.purchaseHeader.Balance = bal;
    }

    $scope.cancelProduct = function (order, rowform) {
        if (order.savedLocal == false) {
            $scope.removeProduct(order);
        }
        else {        

            rowform.$cancel();
        }
        $scope.updateCalcAmount();
    }
    $scope.removeProduct = function (order) {

        var selected = [];
        var idx = -1;

        selected = $filter('filter')($scope.purchaseOrders, { Id: order.Id }, true)[0];
        idx = $scope.purchaseOrders.indexOf(selected);
        if (idx > -1) {
            $scope.purchaseOrders.splice(idx, 1);
        }
        $scope.updateCalcAmount();
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
}

IndentReceivableListController.$inject = ['$scope', '$filter', '$route', 'IndentReceivableDataService'];

function IndentReceivableListController($scope, $filter, $route, IndentReceivableDataService) {
    $scope.purchases = [];

    $scope.cdate = new Date();
    IndentReceivableDataService.getPurchaseList()
        .then(function (purchaseList) { $scope.purchases = purchaseList },
              function () { alert('error while fetching purchaseList from server') }
         );
    $scope.delete = function (id) {
        $('#confirm-purchase-delete').modal({ backdrop: false, keyboard: false })
            .one('click', '#delete', function () {
                IndentReceivableDataService.deletePurchase(id)
                            .then(function (data) {
                                if (data.status === true) {
                                    $route.reload();
                                }
                            },
                              function () { alert('error while deleting purchase') }
                            );
            });
    };

    $scope.getTotal = function () {
        var total = 0;
        for (var i = 0; i < $scope.purchases.length; i++) {
            var purchase = $scope.purchases[i];
            total += (purchase.TotalAmount);
        }
        return total;
    }

    $scope.getBalance = function () {
        var balance = 0;
        for (var i = 0; i < $scope.purchases.length; i++) {
            var purchase = $scope.purchases[i];
            balance += (purchase.Balance);
        }
        return balance;
    }
}