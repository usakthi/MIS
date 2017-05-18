BillEntryController.$inject = ['$scope', '$filter', '$route', '$routeParams', 'BillDataService', 'DepartmentList', 'RackList', 'ManufacturerList', 'UnitList', 'PharmacyIdEnc', '$location', 'hotkeys'];

function BillEntryController($scope, $filter, $route, $routeParams, BillDataService, deptList, rackList, mfgList, unitList, PharmacyIdEnc, $location, hotkeys) {

    $scope.purchaseHeader = {};
    $scope.departments = deptList;
    $scope.editMode = false;
    $scope.racks = rackList;
    $scope.manufacturers = mfgList;
    $scope.units = unitList;
    $scope.taxes = [{ value: 5.5, text: '5.5' }, { value: 14.5, text: '14.5' }];
    $scope.purchaseOrders = [];
    $scope.pIdEnc = PharmacyIdEnc;
    $scope.purchaseId = 0;
    $scope.selectedVal = 0;
    $scope.purchaseHeader.CreditPeriod = 0;
    $scope.purchaseHeader.NetAmount = 0;
    $scope.purchaseHeader.GrnDate = new Date();
    $scope.purchaseHeader.SupplierInvDate = new Date();
    $scope.totalBillAmountEntered = false;
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
        BillDataService.getPurchaseInfo($routeParams.id)
                                .then(function (purchase) {
                                    $scope.purchaseHeader = purchase;
                                    $scope.purchaseOrders = purchase.IntTransItems;
                                },
                                      function () { alert('error while loading purchase info') }
                               ).finally(function () {
                                   $scope.dataLoading = false;
                               })
    }
    else {
        $scope.dataLoading = false;
    }

    $scope.purchaseHeader.DType = 'C';

    $scope.$watch('purchaseHeader.Type', function (newValue, oldValue, scope) {
        if (newValue === 'Cost') {
            $scope.purchaseHeader.DType = 'C';
        }
        else {
            $scope.purchaseHeader.DType = 'M';
        }
    });

    $scope.$watch('purchaseHeader.SupplierId', function (newValue, oldValue, scope) {
        if (newValue != oldValue) {
            var selected = $filter('filter')($scope.departments, { Id: parseInt(newValue, 10) }, true)[0];
            $scope.purchaseHeader.Customer = selected.Name;
        }
    });


    $scope.savePurchase = function () {

        var valid = $scope.validateOrders();
        if ($scope.authorized) {
            $scope.purchaseHeader.PharmacyIdEnc = $scope.pIdEnc;
            $scope.purchaseHeader.IntTransItems = $scope.purchaseOrders;

            BillDataService.savePurchase($scope.purchaseHeader)
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
                BillDataService.authorizeUser($scope.purchaseHeader.SavedUser)
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
        if (data.Qty > data.Stock) {
            alert('Please enter the Available Stock');
            $scope.removeProduct(order);
        }
        else {
            $scope.purchaseOrders[idx].ProductId = data.ProductId;

            $scope.purchaseOrders[idx].batchNo = data.BatchNo;
            $scope.purchaseOrders[idx].Qty = data.Qty;
            //$scope.purchaseOrders[idx].Stock = data.Stock;
            $scope.purchaseOrders[idx].CostPrice = data.CostPrice;
            $scope.purchaseOrders[idx].MRP = data.MRP;
            //$scope.purchaseOrders[idx].VAT = data.VAT;

            //$scope.purchaseOrders[idx].VATAmount = data.VATAmount;
            $scope.purchaseOrders[idx].TotalCostPrice = data.TotalCostPrice;
            $scope.purchaseOrders[idx].TotalMRP = data.TotalMRP;
            $scope.purchaseOrders[idx].savedLocal = true;
            $scope.updateCalcAmount();
        }
    }

    $scope.checkProductName = function (data, rowform) {
        if (data === "" || typeof (data) === 'undefined' || data == null) {
            return "Please enter product name";
        }
    }

    $scope.updateCalcAmount = function (data) {
        var amt = 0;
        //if (purchaseHeader.DType === 'C') {
            for (var i = 0; i < $scope.purchaseOrders.length; i++) {   
                if (isFinite($scope.purchaseOrders[i].TotalCostPrice)) {
                    amt = amt + parseFloat($scope.purchaseOrders[i].TotalCostPrice);
                }
            }
            $scope.purchaseHeader.NetAmount = amt;
        //}
        //else {
        //    for (var i = 0; i < $scope.purchaseOrders.length; i++) {
        //        if (isFinite($scope.purchaseOrders[i].TotalMRP)) {
        //            amt = amt + parseFloat($scope.purchaseOrders[i].TotalMRP);
        //        }
        //    }
        //    $scope.purchaseHeader.NetAmount = amt;
        //}
        
    }

    $scope.totalBillAmountEntered = true;
    //$scope.$watch('purchaseHeader.TotalAmount', function (newValue, oldValue, scope) {
    //    //if (isFinite(newValue) && newValue > 0) {
    //    //    $scope.updateCalcAmount();
    //        $scope.totalBillAmountEntered = true;
    //    //}
    //});

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
    $scope.ExpDate = function (data, rowform) {
        if (data === "" || typeof (data) === 'undefined' || data == null) {
            return;
        }
        if (!isValidExpDate(data)) {
            return "Please enter valid date";
        }

    }

   
    $scope.addNewProduct = function () {
        $scope.inserted = {
            isNew: true, Id: getUniqueId(),savedLocal:false,
            BatchNo: '', Qty: 1, ProductName: '', ProductId: 0, ManufacturerId: 0, ManufacturerName: '',
            ExpiryDate: '', VAT: 5.5, MRP: 0, CostPrice: 0
        };

        $scope.purchaseOrders.push($scope.inserted);
    };
    $scope.addNewProduct();

    $scope.checkNewProductRow = function (data, Id, rowform, index) {
        //$scope.savePurchaseItem(rowform.$data, Id, rowform, index);
        //$scope.addNewProduct();

        $scope.savePurchaseItem(rowform.$data, Id, rowform, index);
        if ($scope.purchaseOrders.length - 1 == index)
            $scope.addNewProduct();
        else {
            alert('123');
            document.getElementById('ProductName' + (index + 1)).focus();
        }
    }

    $scope.checkMinimumFields = function (rowform) {
        if (rowform.$data.ProductId && rowform.$data.BatchNo && angular.isNumber(rowform.$data.MRP) && rowform.$data.MRP > 0) {
            return true;
        }
        return false;
    }

    $scope.focusProductName = function (rowform) {
        rowform.$activate("ProductName");
    }

    $scope.repeaterRefreshed = function () {
        // if(!!$scope.latestRowForm)
        //   $scope.focusProductName($scope.latestRowForm);
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
    $scope.showSelectedMfg = function (order) {
        var selected = [];
        selected = $filter('filter')($scope.manufacturers, { Id: order.ManufacturerId });
        return selected.length ? selected[0].Name : '';
    };
    $scope.productList = function (q) {
        var def = BillDataService.getProductList(q);
        $scope.productMaster = def.resolve;
        return def.promise;
        
    };

    $scope.manfList = function (q) {
        var def = BillDataService.getManufacturerList(q);
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

    $scope.onProductSelect = function ($item, $model, $label, $rowform, order) {
        $rowform.$data.ProductId = $item.id;
        var selected = [];
        var idx = -1;
        selected = $filter('filter')($scope.purchaseOrders, { Id: order.Id }, true)[0];
        idx = $scope.purchaseOrders.indexOf(selected);
        $scope.purchaseOrders[idx].UnitId = $item.unitId;
        $scope.purchaseOrders[idx].BatchNo = $item.batchNo;
        $scope.purchaseOrders[idx].Qty = $item.Qty;
        $scope.purchaseOrders[idx].ExpDate = $item.expDate;
        $scope.purchaseOrders[idx].MRP = $item.mrp;
        $scope.purchaseOrders[idx].CostPrice = $item.costPrice;
        $scope.purchaseOrders[idx].ManufacturerId = $item.manfId;
        $scope.purchaseOrders[idx].Manufacturer = $item.manf;
        $scope.purchaseOrders[idx].Stock = $item.stock;
        $scope.purchaseOrders[idx].GRNNo = $item.grnNo;
        $scope.purchaseOrders[idx].PurDetId = $item.purDetId;
        $scope.purchaseOrders[idx].VAT = $item.vat;

        var drugElement = $filter('filter')($rowform.$editables, { name: 'ProductName' }, true)[0];
        drugElement.scope.$data = $item.label;

        var ExpiryElement = $filter('filter')($rowform.$editables, { name: 'ExpDate' }, true)[0];
        ExpiryElement.scope.$data = $item.expDate;

        var MRPEditable = $filter('filter')($rowform.$editables, { name: 'MRP' }, true)[0];
        MRPEditable.scope.$data = $item.mrp;

        var CostEditable = $filter('filter')($rowform.$editables, { name: 'CostPrice' }, true)[0];
        CostEditable.scope.$data = $item.costPrice;

        var StockEditable = $filter('filter')($rowform.$editables, { name: 'Stock' }, true)[0];
        StockEditable.scope.$data = $item.stock;

        var ManufEditable = $filter('filter')($rowform.$editables, { name: 'ManfId' }, true)[0];
        ManufEditable.scope.$data = $item.manfId;

        var QtyEditable = $filter('filter')($rowform.$editables, { name: 'Qty' }, true)[0].inputEl[0].focus();
        QtyEditable.scope.$data = $item.Qty;

        var VATEditable = $filter('filter')($rowform.$editables, { name: 'VAT' }, true)[0];
        VATEditable.scope.$data = $item.vat;

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

    $scope.calculateVATAmount = function (order) {
        
        var amount = 0;
        var vat = isFinite(order.VAT) ? order.VAT : 0;
        
            amount = order.TotalCostPrice * (vat / 100);
       
         //   amount = order.TotalMRP - (order.TotalMRP / ((vat / 100) + 1));
        
        order.VATAmount = isFinite(amount) ? round(amount, 2) : 0;
        return order.VATAmount;
    }

    $scope.calculateTotalCostPrice = function (order) {
        var amount = parseFloat(order.CostPrice) * (order.Qty);
        order.TotalCostPrice = isFinite(amount) ? round(amount, 2) : 0;
        return order.TotalCostPrice;
    }
    
    $scope.calculateTotalMRP = function (order) {
        var amount = (order.Qty) * (isFinite(order.MRP) ? order.MRP : 0)
        order.TotalMRP = isFinite(amount) ? round(amount, 2) : 0;
        return order.TotalMRP;
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

    hotkeys.bindTo($scope)
    .add({
        combo: 'f3',
        description: 'Save InternalTransfer',
        callback: function (e) {
            e.preventDefault();
            $scope.savePurchase();
        }
    })
    .add({
        combo: 'f4',
        description: 'Clear InternalTransfer',
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

BillListController.$inject = ['$scope', '$filter', '$route', 'BillDataService', 'hotkeys', '$location'];

function BillListController($scope, $filter, $route, BillDataService, hotkeys, $location) {
   
    $scope.purchases = [];

    $scope.cdate = new Date();

    BillDataService.getPurchaseList()
        .then(function (purchaseList) { $scope.purchases = purchaseList },
              function () { alert('error while fetching purchaseList from server') }
         );
    $scope.delete = function (id) {
        $('#confirm-purchase-delete').modal({ backdrop: false, keyboard: false })
            .one('click', '#delete', function () {
                BillDataService.deletePurchase(id)
                            .then(function (data) {
                                if (data.status === true) {
                                    $route.reload();
                                }
                            },
                              function () { alert('error while deleting purchase') }
                            );
            });//end of one
    };

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
        description: 'AddNew InternalTransfer',
        callback: function (e) {
            e.preventDefault();
            $location.path('/add');
        }
    });
   
}