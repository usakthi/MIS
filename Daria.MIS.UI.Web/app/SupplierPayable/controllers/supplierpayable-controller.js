SupplierPayableEntryController.$inject = ['$scope', '$filter', '$route', '$routeParams', 'SupplierPayableDataService', 'SupplierList', 'DueList', 'PharmacyIdEnc', '$location'];

function SupplierPayableEntryController($scope, $filter, $route, $routeParams, SupplierPayableDataService, suppList, dueList, PharmacyIdEnc, $location) {
    $scope.purchaseHeader = {};
    $scope.suppliers = suppList;
    $scope.editMode = false;
    $scope.dues = dueList;
    $scope.purchaseOrders = [];
    $scope.pIdEnc = PharmacyIdEnc;
    $scope.purchaseId = 0;
    $scope.selectedVal = 0;
    $scope.purchaseHeader.NetAmount = 0;
    $scope.purchaseHeader.GrnDate = new Date();
    $scope.toggleSelect = true;

    $scope.$watch("toggleSelect", function (selected) {
        $scope.purchaseOrders.forEach(function (item) {
            item.isChecked = selected;
        });
    });

    if ($routeParams.id && $routeParams.id > 0) {
        $scope.editMode = true;
    }
   
    $scope.inserted = {};
    $scope.purchaseHeader.DiscountPercent = 0;
    $scope.dataLoading = true;
    $scope.authorized = false;
    $scope.validatingCredentials = false;
    $scope.purchaseHeader.SavedUser = { PlainPwd: '' };
    $("body").addClass("aside-collapsed");

    if ($routeParams.id && $routeParams.id > 0) {
        SupplierPayableDataService.getPurchaseInfo($routeParams.id)
                                .then(function (purchase) {
                                    $scope.purchaseHeader = purchase;
                                    $scope.purchaseOrders = purchase.SupplierPayableItems;
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

    $scope.$watch('toggleSelect', function (selected) {
        $scope.purchaseOrders.forEach(function (item) {
            item.isChecked = selected;
        });
    });
    
    $scope.$watch('purchaseHeader.SupplierId', function (scope, newValue, oldValue) {
        if (newValue > 0) {
            SupplierPayableDataService.getIndentInfo(newValue)
                                    .then(function (purchase) {
                                        $scope.purchaseHeader = purchase;
                                        $scope.purchaseHeader.SupplierName = purchase.Name;
                                        $scope.purchaseOrders = purchase.SupplierPayableItems;
                                    },
                                          function () { alert('error while loading Due List info') }
                                   ).finally(function () {
                                       $scope.dataLoading = false;
                                   })
            var selected = $filter('filter')($scope.suppliers, { Id: parseInt(newValue, 10) }, true)[0];
        }

        //$scope.upCalcAmount();

        //if (newValue != oldValue) {
        //    var selected = $filter('filter')($scope.suppliers, { Id: parseInt(newValue, 10) }, true)[0];
        //}
    });

    $scope.SetAmount = function () {
        var totAmt = round($scope.purchaseHeader.TotalAmount, 2);
        var paid = round($scope.purchaseHeader.NetAmount, 2);
        var bal = round($scope.purchaseHeader.Balance, 2);
        var scope = round($scope.purchaseHeader.PaidAmount, 2);
        if (scope > 0) {
            var pay = 0;
            for (var i = 0; i < $scope.purchaseOrders.length; i++) {
                var balitem = round($scope.purchaseOrders[i].Balance, 2);
                var paidamt = round($scope.purchaseOrders[i].PaidAmount, 2);
                var netpaid = round($scope.purchaseOrders[i].NetAmount, 2);

                if ($scope.purchaseOrders[i].isChecked) {
                    if (scope < balitem) {
                        $scope.purchaseOrders[i].Payable = round(scope, 2);
                        bal = round(balitem, 2) - round(scope, 2);
                        $scope.purchaseOrders[i].Balance = round($scope.purchaseOrders[i].NetAmount - $scope.purchaseOrders[i].Payable - paidamt, 2);
                        scope = 0;
                    }
                    else {
                        pay = round(balitem, 2) - round(scope, 2);
                        $scope.purchaseOrders[i].Payable = round(balitem, 2);
                        $scope.purchaseOrders[i + 1].Payable = round(scope - $scope.purchaseOrders[i].Payable, 2);
                        bal = round(scope, 2) - round(balitem, 2);
                        $scope.purchaseOrders[i].Balance = round($scope.purchaseOrders[i].NetAmount - $scope.purchaseOrders[i].Payable - paidamt, 2);
                        scope = scope - round($scope.purchaseOrders[i].Payable, 2);
                    }
                }
                else {
                    $scope.purchaseOrders[i].Payable = 0;
                    $scope.purchaseOrders[i].Balance = round($scope.purchaseOrders[i].NetAmount - $scope.purchaseOrders[i].Payable - paidamt, 2);
                }
            }
            $scope.upCalcAmount();
        }
    }

    //$scope.saveSupplierPayable = function () {
    //    var valid = $scope.validateOrders();
    //    if ($scope.authorized) {
    //        $scope.purchaseHeader.PharmacyIdEnc = $scope.pIdEnc;
    //        $scope.purchaseHeader.SupplierPayableItems = $scope.purchaseOrders;
            
    //        SupplierPayableDataService.saveSupplierPayable($scope.purchaseHeader)
    //        .then(function (data) {
    //            if (data.status === true) {
    //                if (data.mode == "add") {
    //                    $scope.purchaseHeader.Id = data.id;
    //                    alert('Data Saved Successfully');
    //                }
    //                $scope.authorized = false;
    //                $location.path('');
    //            }
    //        },
    //             function () { alert('error while saving Supplier Payable'); $scope.authorized = false; }
    //        );
    //    }
    //    else {
    //        $scope.showLoginForm();
    //    }
    //}

    $scope.purchaseHeader.PharmacyIdEnc = $scope.pIdEnc;

    //$scope.showLoginForm = function () {
    //    $('#show-purchase-login').modal({ backdrop: false, keyboard: false })
    //        .one('click', '#authorize', function () {
    //            $scope.validatingCredentials = true;
    //            SupplierPayableDataService.authorizeUser($scope.purchaseHeader.SavedUser)
    //                        .then(function (data) {
    //                            $scope.validatingCredentials = false;
    //                            if (data.LoginStatus === 5) {

    //                                $scope.purchaseHeader.SavedUser.UserId = data.UserId;
    //                                $scope.authorized = true;

    //                                $('#show-purchase-login').modal('hide');
    //                                $scope.saveSupplierPayable();
    //                            }
    //                            if (data.LoginStatus === 2) {
    //                                alert('invalid password');
    //                            }
    //                        },
    //                          function () { alert('error while deleting purchase') }
    //                        );
    //        });//end of one
    //};

    //$scope.savePurchaseItem = function (data, id, rowform, idx) {
    //    var selected = [];
    //    var idx = -1;
    //    selected = $filter('filter')($scope.purchaseOrders, { Id: id }, true)[0];
    //    idx = $scope.purchaseOrders.indexOf(selected);
    //    $scope.purchaseOrders[idx].ProductId = data.ProductId;
    //    $scope.purchaseOrders[idx].ManufacturerId = data.ManufacturerId;

    //    $scope.purchaseOrders[idx].CostPrice = data.CostPrice;
    //    $scope.purchaseOrders[idx].MRP = data.MRP;
    //    $scope.purchaseOrders[idx].TaxPercent = data.TaxPercent;

    //    $scope.purchaseOrders[idx].TaxAmount = data.VATAmount;
    //    $scope.purchaseOrders[idx].DiscPercent = data.DiscPercent;
    //    $scope.purchaseOrders[idx].Discount = data.Discount;
    //    $scope.purchaseOrders[idx].TotalCostPrice = data.TotalCostPrice;
    //    $scope.purchaseOrders[idx].TotalMRP = data.TotalMRP;
    //    $scope.purchaseOrders[idx].savedLocal = true;
    //    $scope.updateCalcAmount();
    //}

    $scope.HandleAction = function (action) {
        switch (action) {
            case 'exit':
                $scope.purchaseOrders = [];
                break;
            case 'save':
                var data = $scope.purchaseOrders.filter(function (item) {
                    if (item.isChecked) {
                        return item;
                    }
                });
                SupplierPayableDataService.saveSupplierPayable(data).then(function () {
                    alert("Saved Successfully");
                    $location.path('');
                },
                function (e) {
                    alert(e);
                });
                break;
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
            if (isFinite($scope.purchaseOrders[i].Balance)) {
                amt = round(amt, 2) + round(parseFloat($scope.purchaseOrders[i].NetAmount), 2);
                paid = round(paid, 2) + round(parseFloat($scope.purchaseOrders[i].PaidAmount), 2);
                bal = round(bal, 2) + round(parseFloat($scope.purchaseOrders[i].Balance), 2);
            }
        }
        $scope.purchaseHeader.TotalAmount = round(amt, 2);
        $scope.purchaseHeader.NetAmount = round(paid, 2);
        $scope.purchaseHeader.Balance = round(bal, 2);
    }

    $scope.cancelProduct = function (order, rowform) {
        if (order.savedLocal == false) {
            $scope.removeProduct(order);
        }
        else {        

            rowform.$cancel();
        }
    }
    $scope.removeProduct = function (order) {
        var selected = [];
        var idx = -1;

        selected = $filter('filter')($scope.purchaseOrders, { Id: order.Id }, true)[0];
        idx = $scope.purchaseOrders.indexOf(selected);
        if (idx > -1) {
            $scope.purchaseOrders.splice(idx, 1);
        }
        $scope.upCalcAmount();
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

SupplierPayableListController.$inject = ['$scope', '$filter', '$route', 'SupplierPayableDataService'];

function SupplierPayableListController($scope, $filter, $route, SupplierPayableDataService) {
    $scope.purchases = [];
    $("body").addClass("aside-collapsed");
    $scope.cdate = new Date();
    SupplierPayableDataService.getPurchaseList()
        .then(function (purchaseList) { $scope.purchases = purchaseList },
              function () { alert('error while fetching purchaseList from server') }
         );
    $scope.delete = function (id) {
        $('#confirm-purchase-delete').modal({ backdrop: false, keyboard: false })
            .one('click', '#delete', function () {
                SupplierPayableDataService.deletePurchase(id)
                            .then(function (data) {
                                if (data.status === true) {
                                    $route.reload();
                                }
                            },
                              function () { alert('error while deleting purchase') }
                            );
            });
    };

    //$scope.getTotal = function () {
    //    var total = 0;
    //    for (var i = 0; i < $scope.purchases.length; i++) {
    //        var purchase = $scope.purchases[i];
    //        round(total,2) += (purchase.TotalAmount);
    //    }
    //    return total;
    //}

    //$scope.getBalance = function () {
    //    var balance = 0;
    //    for (var i = 0; i < $scope.purchases.length; i++) {
    //        var purchase = $scope.purchases[i];
    //        round(balance,2) += (purchase.Balance);
    //    }
    //    return balance;
    //}
}