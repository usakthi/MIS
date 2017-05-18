CustomerReceivableEntryController.$inject = ['$scope', '$filter', '$route', '$routeParams', 'CustomerReceivableDataService', 'SupplierList', 'PharmacyIdEnc', '$q','$location'];

function CustomerReceivableEntryController($scope, $filter, $route, $routeParams, CustomerReceivableDataService, suppList, PharmacyIdEnc, $q, $location) {
    $scope.purchaseHeader = {};
    $scope.suppliers = suppList;
    $scope.editMode = false;
    $scope.purchaseOrders = [];
    $scope.pIdEnc = PharmacyIdEnc;
    $scope.purchaseId = 0;
    $scope.selectedVal = 0;
    $scope.purchaseHeader.NetAmount = 0;
    $scope.purchaseHeader.GrnDate = new Date();
    $scope.toggleSelect = true;
    $scope.customerMaster = [];
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
        CustomerReceivableDataService.getCustomerDueInfo($routeParams.id)
                                .then(function (purchase) {
                                    $scope.purchaseHeader = purchase;
                                    $scope.purchaseOrders = purchase.CustomerReceivableItems;
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
    $scope.purchaseHeader.Mobile = '';

    $scope.$watch('toggleSelect', function (selected) {
        $scope.purchaseOrders.forEach(function (item) {
            item.isChecked = selected;
        });
    });
    
    //$scope.$watch('purchaseHeader.SupplierId', function (scope, newValue, oldValue) {
    //    if (newValue > 0) {
    //        CustomerReceivableDataService.getIndentInfo(newValue)
    //                                .then(function (purchase) {
    //                                    $scope.purchaseHeader = purchase;
    //                                    $scope.purchaseHeader.SupplierName = purchase.Name;
    //                                    $scope.purchaseOrders = purchase.CustomerReceivableItems;
    //                                },
    //                                      function () { alert('error while loading Due List info') }
    //                               ).finally(function () {
    //                                   $scope.dataLoading = false;
    //                               })
    //        var selected = $filter('filter')($scope.suppliers, { Id: parseInt(newValue, 10) }, true)[0];
    //    }

    //    $scope.upCalcAmount();

    //    //if (newValue != oldValue) {
    //    //    var selected = $filter('filter')($scope.suppliers, { Id: parseInt(newValue, 10) }, true)[0];
    //    //}
    //});

    $scope.SetAmount = function () {
        var totAmt = round($scope.purchaseHeader.TotalAmount,2);
        var paid = round($scope.purchaseHeader.NetAmount,2);
        var bal = round($scope.purchaseHeader.Balance, 2);
        var scope = round($scope.purchaseHeader.PaidAmount,2);
        if (scope > 0) {
            var pay = 0;
            for (var i = 0; i < $scope.purchaseOrders.length; i++) {
                var balitem = round($scope.purchaseOrders[i].Balance, 2);
                var paidamt = round($scope.purchaseOrders[i].PaidAmount, 2);
                var netpaid = round($scope.purchaseOrders[i].NetAmount, 2);
                
                if ($scope.purchaseOrders[i].isChecked) {
                    if (scope < balitem) {
                        $scope.purchaseOrders[i].Payable = round(scope,2);
                        bal = round(balitem,2) - round(scope,2);
                        $scope.purchaseOrders[i].Balance = round($scope.purchaseOrders[i].NetAmount - $scope.purchaseOrders[i].Payable - paidamt, 2);
                        scope = 0;
                    }
                    else {
                        pay = round(balitem,2) - round(scope,2);
                        $scope.purchaseOrders[i].Payable = round(balitem,2);
                        $scope.purchaseOrders[i + 1].Payable = round(scope - $scope.purchaseOrders[i].Payable,2);
                        bal = round(scope,2) - round(balitem,2);
                        $scope.purchaseOrders[i].Balance = round($scope.purchaseOrders[i].NetAmount - $scope.purchaseOrders[i].Payable - paidamt, 2);
                        scope = scope - round($scope.purchaseOrders[i].Payable,2);
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

    $scope.purchaseHeader.PharmacyIdEnc = $scope.pIdEnc;

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
                CustomerReceivableDataService.saveDueReceivable(data).then(function () {
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
                amt = round(amt, 2) + round(parseFloat($scope.purchaseOrders[i].NetAmount), 2);
                paid = round(paid, 2) + round(parseFloat($scope.purchaseOrders[i].PaidAmount), 2);
                bal = round(bal, 2) + round(parseFloat($scope.purchaseOrders[i].Balance), 2);
                alert(bal);
            }
        }
        $scope.purchaseHeader.TotalAmount = round(amt, 2);
        $scope.purchaseHeader.NetAmount = round(paid, 2);
        $scope.purchaseHeader.Balance = round(bal, 2);
    }

    $scope.upCalcAmount = function () {
        var amt = 0;
        var bal = 0;
        var paid = 0;
        for (var i = 0; i < $scope.purchaseOrders.length; i++) {
            if (isFinite($scope.purchaseOrders[i].Balance)) {
                amt = round(amt,2) + round(parseFloat($scope.purchaseOrders[i].NetAmount),2);
                paid = round(paid,2) + round(parseFloat($scope.purchaseOrders[i].PaidAmount),2);
                bal = round(bal,2) + round(parseFloat($scope.purchaseOrders[i].Balance),2);
            }
        }
        $scope.purchaseHeader.TotalAmount = round(amt,2);
        $scope.purchaseHeader.NetAmount = round(paid,2);
        $scope.purchaseHeader.Balance = round(bal,2);
    }

    $scope.customerList = function (q) {
        var def = CustomerReceivableDataService.getCustomerList(q);
            $scope.customerMaster = def.resolve;
            var deferred = $q.defer();
            def.promise.then(function (data) {
                deferred.resolve(data);
            }, deferred.reject);
            return deferred.promise;
    };

    $scope.onCustomerSelect = function ($item, $model, $label) {
        if (!$item.isNew) {
            $scope.purchaseHeader.CustomerId = $item.id;
            CustomerReceivableDataService.getCustomerDueInfo($item.id)
                                    .then(function (purchase) {
                                        $scope.purchaseHeader = purchase;
                                        $scope.purchaseOrders = purchase.CustomerReceivableItems;
                                    },
                                          function () { alert('error while loading Customer info') }
                                   ).finally(function () {
                                       $scope.dataLoading = false;
                                   })
        }
        else {
            $scope.purchaseHeader.CustomerId = 0;
        }
    };

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

CustomerReceivableListController.$inject = ['$scope', '$filter', '$route', 'CustomerReceivableDataService'];

function CustomerReceivableListController($scope, $filter, $route, CustomerReceivableDataService) {
    $scope.purchases = [];
    $("body").addClass("aside-collapsed");
    $scope.cdate = new Date();
    CustomerReceivableDataService.getCustomerReceivableList()
        .then(function (purchaseList) { $scope.purchases = purchaseList },
              function () { alert('error while fetching purchaseList from server') }
         );
    $scope.delete = function (id) {
        $('#confirm-purchase-delete').modal({ backdrop: false, keyboard: false })
            .one('click', '#delete', function () {
                CustomerReceivableDataService.deletePurchase(id)
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