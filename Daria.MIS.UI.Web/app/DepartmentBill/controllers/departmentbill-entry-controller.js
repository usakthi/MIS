IndentBillEntryController.$inject = ['$scope', '$filter', '$route', '$routeParams', 'IndentBillDataService', 'SupplierList', 'RackList', 'ManufacturerList', 'UnitList', 'IndentList', 'PharmacyIdEnc', '$location'];

function IndentBillEntryController($scope, $filter, $route, $routeParams, IndentBillDataService, suppList, rackList, mfgList, unitList, indentList, PharmacyIdEnc, $location) {
    $scope.purchaseHeader = {};
    $scope.suppliers = suppList;
    $scope.editMode = false;
    $scope.racks = rackList;
    $scope.manufacturers = mfgList;
    $scope.units = unitList;
    $scope.indents = indentList;
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
        IndentBillDataService.getPurchaseInfo($routeParams.id)
                                .then(function (purchase) {
                                    $scope.purchaseHeader = purchase;
                                    $scope.purchaseOrders = purchase.IndentBillItems;
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
    $scope.$watch('purchaseHeader.IndentId', function (scope) {
        if (scope > 0) {
            IndentBillDataService.getIndentInfo(scope)
                                    .then(function (purchase) {
                                        $scope.purchaseHeader = purchase;
                                        $scope.purchaseHeader.PatientName = purchase.PatientName;
                                        $scope.purchaseOrders = purchase.IndentBillItems;
                                    },
                                          function () { alert('error while loading Indent info') }
                                   ).finally(function () {
                                       $scope.dataLoading = false;
                                   })
        }
        $scope.upCalcAmount();
        
    });

    
    $scope.$watch('purchaseHeader.SupplierId', function (newValue, oldValue, scope) {
        if (newValue != oldValue) {
            var selected = $filter('filter')($scope.suppliers, { Id: parseInt(newValue, 10) }, true)[0];
            $scope.purchaseHeader.CreditPeriod = selected.DueDays;
        }
    });

    $scope.$watch('purchaseHeader.SupplierInvDate', function (newValue, oldValue, scope) {
        if (angular.isDate(newValue) && newValue != oldValue) {
            $scope.updateDueDate(newValue, $scope.purchaseHeader.CreditPeriod);
        }
    });
    $scope.$watch('purchaseHeader.CreditPeriod', function (newValue, oldValue, scope) {
        if (angular.isNumber(newValue) && newValue != oldValue) {
            $scope.updateDueDate($scope.purchaseHeader.SupplierInvDate, newValue);
        }
    });

    $scope.$watch('purchaseHeader.PaidAmount', function (scope) {
        var totAmt = $scope.purchaseHeader.NetAmount;
        var discount = $scope.purchaseHeader.Discount;
        var balance = (totAmt - discount) - scope;
        if (balance < 0) {
            $scope.purchaseHeader.PaidAmount = totAmt;
            $scope.purchaseHeader.Balance = 0;
            alert('Paid Amount is more than Total Amount Please Enter Proper Amount.');
        }
        else {
            $scope.purchaseHeader.Balance = balance;
        }
    });

    $scope.$watch('purchaseHeader.Discount', function (scope) {
        var netAmt = $scope.purchaseHeader.NetAmount;
        var totAmt = $scope.purchaseHeader.TotalAmount;
        var paid = $scope.purchaseHeader.PaidAmount;
        var balance = (netAmt - paid) - scope;
        if (balance < 0) {
            $scope.purchaseHeader.PaidAmount = totAmt;
            $scope.purchaseHeader.Balance = 0;
            $scope.purchaseHeader.Discount = 0;
            alert('Paid Amount is more than Total Amount Please Enter Proper Amount.');
        }
        else {
            $scope.purchaseHeader.Balance = balance;
            $scope.purchaseHeader.NetAmount = totAmt - scope;
        }
    });

    $scope.savePurchase = function () {

        var valid = $scope.validateOrders();
        if ($scope.authorized) {
            $scope.purchaseHeader.PharmacyIdEnc = $scope.pIdEnc;
            $scope.purchaseHeader.BillItems = $scope.purchaseOrders;

            IndentBillDataService.savePurchase($scope.purchaseHeader)
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
                IndentBillDataService.authorizeUser($scope.purchaseHeader.SavedUser)
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
        var vat = 0;
        for (var i = 0; i < $scope.purchaseOrders.length; i++) {
            if (isFinite($scope.purchaseOrders[i].TotalMRP)) {
                amt = amt + parseFloat($scope.purchaseOrders[i].TotalMRP);
                vat = vat + parseFloat($scope.purchaseOrders[i].VATAmount);
            }
        }
        $scope.purchaseHeader.NetAmount = amt;
        $scope.purchaseHeader.TotalAmount = amt;
        $scope.purchaseHeader.PaidAmount = amt;
        $scope.purchaseHeader.TotalVAT = vat;
    }

    $scope.upCalcAmount = function () {
        var amt = 0;
        var vat = 0;
        for (var i = 0; i < $scope.purchaseOrders.length; i++) {
            if (isFinite($scope.purchaseOrders[i].TotalMRP)) {
                amt = amt + parseFloat($scope.purchaseOrders[i].TotalMRP);
                vat = vat + parseFloat($scope.purchaseOrders[i].VATAmount);
            }
        }
        $scope.purchaseHeader.NetAmount = amt;
        $scope.purchaseHeader.TotalAmount = amt;
        $scope.purchaseHeader.PaidAmount = amt;
        $scope.purchaseHeader.TotalVAT = vat;
    }

    $scope.checkUnit = function (data, rowform) {
        if (data === 0 || data === "" || typeof (data) === 'undefined' || data == null) {
            return "Please select unit";
        }
    }

    $scope.checkManufacturer = function (data, rowform) {
        if (data === 0 || data === "" || typeof (data) === 'undefined' || data == null) {
            return "Please select manufacturer";
        }
    }
    $scope.checkExpDate = function (data, rowform) {
        if (data === "" || typeof (data) === 'undefined' || data == null) {
            return;
        }
        if (!isValidExpDate(data)) {
            return "Please enter valid date";
        }

    }

    $scope.setDiscPercentToAll = function (data, tableform) {
        for (var i = 0; i < tableform.$editables.length; i++) {
            if (tableform.$editables[i].name === 'user.status') {
                tableform.$editables[i].scope.$data = data;

            }
        }
    };
    $scope.$watch('purchaseHeader.DiscountPercent', function (newValue, oldValue, scope) {

        for (var i = 0; i < $scope.purchaseOrders.length; i++) {
            if (!isNaN($scope.purchaseHeader.DiscountPercent)) {
                $scope.purchaseOrders[i].DiscountPercentage = $scope.purchaseHeader.DiscountPercent;
                $scope.purchaseOrders[i].DiscountAmount = $scope.calculateDiscountAmount($scope.purchaseOrders[i]);
            }
        }
    });
    $scope.addNewProduct = function () {
        $scope.inserted = {
            isNew: true, Id: getUniqueId(),savedLocal:false,
            BatchNo: '', Qty: 1, FreeQty: 0, ProductName: '', ProductId: 0, ManufacturerId: 0, ManufacturerName: '',
            ExpiryDate: '', Packing: 1, AssortedQty: 0, VAT: 5.5, DiscountPercentage: $scope.purchaseHeader.DiscountPercent, MRP: 0,
            DiscApplicable: '0', VATOnDiscount: '0',
            VATOnFreeQty: '0', DiscOnFreeQty: '0', AssortedCostPrice: 0, AssortedMRPPrice: 0,
            FreeQtyVATAmount: 0, DiscountAmount: 0, RackId: 0, UnitId: 0, TaxMode: 'COST', TaxType: 'EXCL'
        };


        $scope.purchaseOrders.push($scope.inserted);
    };
    $scope.addNewProduct();

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
    $scope.showSelectedMfg = function (order) {
        var selected = [];
        selected = $filter('filter')($scope.manufacturers, { Id: order.ManufacturerId });
        return selected.length ? selected[0].Name : '';
    };
    $scope.showSelectedRack = function (order) {
        var selected = [];
        selected = $filter('filter')($scope.racks, { Id: order.RackId });
        return selected.length ? selected[0].Name : '';
    };
    $scope.showSelectedUnit = function (order) {
        var selected = [];
        selected = $filter('filter')($scope.units, { Id: order.UnitId });
        return selected.length ? selected[0].Name : '';
    };

    $scope.productList = function (q) {
        var def = IndentBillDataService.getProductList(q);
        $scope.productMaster = def.resolve;
        return def.promise;
        
    };

    $scope.manfList = function (q) {
        var def = IndentBillDataService.getManufacturerList(q);
        $scope.manfMaster = def.resolve;
        return def.promise;
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

    $scope.onManfSelect = function ($item, $model, $label, $rowform, order) {
        $rowform.$data.ManufacturerId = $item.id;
        var selected = [];
        var idx = -1;
        selected = $filter('filter')($scope.purchaseOrders, { Id: order.Id }, true)[0];
        idx = $scope.purchaseOrders.indexOf(selected);
        $scope.purchaseOrders[idx].ManufacturerId = $item.id;
    };

    $scope.showProductName = function (model) {
        return model.ProductName;
    };
    $scope.showManfName = function (model) {
        return model.ManufacturerName;
    };
    $scope.getStats = function (q) {
        return $scope.states;

    };

    $scope.showSelectedVAT = function (order) {

        var selected = [];
        selected = $filter('filter')($scope.taxes, { Tax: order.VAT });

        return selected.length ? selected[0].value : $scope.taxes[0].value;
    };
 
    $scope.calculateNetMRP = function (order) {
        var totalMrp = isFinite(order.TotalMRP) ? order.TotalMRP : 0;
        var totalVat = isFinite(order.TotalVatAmount) ? order.TotalVatAmount : 0;
        var totalDisc = isFinite(order.TotalDiscountAmount) ? order.TotalDiscountAmount : 0;
        var amount = totalMrp - totalVat - totalDisc;
        order.NetMRP = isFinite(amount) ? round(amount, 2) : 0;
        return order.NetMRP;
    }

    $scope.calculateVatOnDiscountAmount = function (order) {
        var totalVat = isFinite(order.TotalVatAmount) ? order.TotalVatAmount : 0;
        var amount = totalVat * (parseFloat(order.DiscountPercentage) / 100);
        order.VatOnDiscountAmount = isFinite(amount) ? round(amount, 2) : 0;
        return order.VatOnDiscountAmount;
    }
    

    $scope.calculateDiscountAmount = function (order) {
        var discPerc = isFinite(order.DiscountPercentage) ? order.DiscountPercentage : 0;
        var amount = 0;
        amount = (parseFloat(order.TotalMRP)) * (discPerc / 100);

        order.DiscountAmount = isFinite(amount) ? round(amount, 2) : 0;
        return order.DiscountAmount;
    }
    
    $scope.calculateTotalDiscountAmountt = function (order) {

        var discAmt = isFinite(order.DiscountAmount) ? order.DiscountAmount : 0;
        var discFreqtyAmt = isFinite(order.DiscOnFreeQtyAmount) ? order.DiscOnFreeQtyAmount : 0;
        var amount = discAmt + discFreqtyAmt;
        order.TotalDiscountAmount = isFinite(amount) ? round(amount, 2) : 0;
        return order.TotalDiscountAmount;
    }
    $scope.calculateTotalVatAmount = function (order) {

        var vatAmt = isFinite(order.VATAmount) ? order.VATAmount : 0;
        var vatFreqtyAmt = isFinite(order.FreeQtyVATAmount) ? order.FreeQtyVATAmount : 0;
        var amount = vatAmt + vatFreqtyAmt;
        order.TotalVatAmount = isFinite(amount) ? round(amount, 2) : 0;
        return order.TotalVatAmount;
    }
    $scope.calculateNetVATAmount = function (order) {

        var totVatAmt = isFinite(order.TotalVatAmount) ? order.TotalVatAmount : 0;
        var vatOnDiscAmt = isFinite(order.VatOnDiscountAmount) ? order.VatOnDiscountAmount : 0;
        var amount = totVatAmt - vatOnDiscAmt;
        order.NetVATAmount = isFinite(amount) ? round(amount, 2) : 0;
        return order.NetVATAmount;
    }
    
    $scope.calculateVATAmount = function (order) {
        var vat = isFinite(order.VAT) ? order.VAT : 0;
        var amount = 0;
        
        amount = order.TotalMRP - (order.TotalMRP / ((vat / 100) + 1));
        
        order.VATAmount = isFinite(amount) ? round(amount, 2) : 0;
        return order.VATAmount;
    }

    $scope.calculateTotalCostPrice = function (order) {
        var amount = parseFloat(order.CostPrice) * (order.Qty);
        order.TotalCostPrice = isFinite(amount) ? round(amount, 2) : 0;
        return order.TotalCostPrice;
    }
    $scope.calculateNetCostPrice = function (order) {
        var amount = parseFloat(order.TotalCostPrice) - (isFinite(order.TotalDiscountAmount) ? order.TotalDiscountAmount : 0);
        order.NetCostPrice = isFinite(amount) ? round(amount, 2) : 0;
        return order.NetCostPrice;
    }
    $scope.calculateTotalMRP = function (order) {
        var amount = (order.Qty) * (isFinite(order.MRP) ? order.MRP : 0)
        order.TotalMRP = isFinite(amount) ? round(amount, 2) : 0;
        return order.TotalMRP;
    }
    $scope.checkAvailableStock = function (order) {
        var stk = order.Stock ? order.Stock : 0;
        var qty = order.Qty ? order.Qty : 0;
        if (qty > stk) {
        }
        else {
        }
    }
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

IndentBillListController.$inject = ['$scope', '$filter', '$route', 'IndentBillDataService'];

function IndentBillListController($scope, $filter, $route, IndentBillDataService) {

    $scope.purchases = [];

    $scope.cdate = new Date();

    IndentBillDataService.getPurchaseList()
        .then(function (purchaseList) {
            $scope.purchases = purchaseList
            //console.log(JSON.stringify(purchaseList));
        },
              function () { alert('error while fetching purchaseList from server') }
         );
    $scope.delete = function (id) {
        $('#confirm-purchase-delete').modal({ backdrop: false, keyboard: false })
            .one('click', '#delete', function () {
                IndentBillDataService.deletePurchase(id)
                            .then(function (data) {
                                if (data.status === true) {
                                    $route.reload();
                                }
                            },
                              function () { alert('error while deleting purchase') }
                            );
            });
    };
}