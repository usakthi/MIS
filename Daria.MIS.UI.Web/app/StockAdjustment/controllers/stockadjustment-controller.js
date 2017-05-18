StockAdjustmentEntryController.$inject = ['$scope', '$filter', '$route', '$routeParams', 'StockAdjustmentDataService', 'ManufacturerList', 'PharmacyIdEnc', '$location', 'hotkeys'];

function StockAdjustmentEntryController($scope, $filter, $route, $routeParams, StockAdjustmentDataService, mfgList, PharmacyIdEnc, $location, hotkeys) {
    $scope.stockadjustmentHeader = {};
    $scope.editMode = false;
    $scope.manufacturers = mfgList;
    $scope.purchaseOrders = [];
    $scope.pIdEnc = PharmacyIdEnc;
    $scope.purchaseId = 0;
    $scope.selectedVal = 0;
   
    $scope.productMaster = [];
    $scope.manfMaster = [];
    $scope.inserted = {};
    $scope.dataLoading = true;
    $scope.authorized = false;
    $scope.validatingCredentials = false;
    $scope.stockadjustmentHeader.SavedUser = { PlainPwd: '' };
    $("body").addClass("aside-collapsed");
    //if ($routeParams.id && $routeParams.id > 0) {
    //    StockAdjustmentDataService.getPurchaseInfo($routeParams.id)
    //                            .then(function (stockadjustment) {
    //                                $scope.stockadjustmentHeader = stockadjustment;
    //                                $scope.purchaseOrders = stockadjustment.StockAdjustmentItems;
    //                            },
    //                                  function () { alert('error while loading purchase info') }
    //                           ).finally(function () {
    //                               $scope.dataLoading = false;
    //                           })
    //}
    //else {
        $scope.dataLoading = false;
    //}

    $scope.saveStockAdjustment = function () {
        var valid = $scope.validateOrders();
        if ($scope.authorized) {
            $scope.stockadjustmentHeader.PharmacyIdEnc = $scope.pIdEnc;
            $scope.stockadjustmentHeader.StockAdjustmentItems = $scope.purchaseOrders;
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
                 function () { alert('error while saving StockAdjustment'); $scope.authorized = false; }
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
                
                StockAdjustmentDataService.authorizeUser($scope.stockadjustmentHeader.SavedUser)
                            .then(function (data) {
                                $scope.validatingCredentials = false;
                                if (data.LoginStatus === 5) {

                                    $scope.stockadjustmentHeader.SavedUser.UserId = data.UserId;
                                    $scope.authorized = true;

                                    $('#show-purchase-login').modal('hide');
                                    $scope.saveStockAdjustment();
                                }
                                if (data.LoginStatus === 2) {
                                    alert('invalid password');
                                }
                            },
                              function () { alert('error while Saving StockAdjustments') }
                            );
            });//end of one
    };
    
    $scope.saveStockAdjustmentItem = function (data, id, rowform, idx) {
        var selected = [];
        var idx = -1;
        selected = $filter('filter')($scope.purchaseOrders, { Id: id }, true)[0];
        idx = $scope.purchaseOrders.indexOf(selected);
        $scope.purchaseOrders[idx].ProductId = data.ProductId;        
        $scope.purchaseOrders[idx].Qty = data.Qty;
        
        $scope.purchaseOrders[idx].savedLocal = true;
    }

    $scope.checkNewProductRow = function (data, Id, rowform, index) {
        $scope.saveStockAdjustmentItem(rowform.$data, Id, rowform, index);
        $scope.addNewProduct();
    }

    $scope.checkProductName = function (data, rowform) {
        if (data === "" || typeof (data) === 'undefined' || data == null) {
            return "Please enter product name";
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

    $scope.addNewProduct = function () {
        $scope.inserted = {
            isNew: true, Id: getUniqueId(),savedLocal:false,
            BatchNo: '', Qty: 1, PurQty: 0, PurRetQty: 0, SalQty: 0, SalRetQty: 0, OpenStk:0, CurStk: 0,StkAdj:0, PurDetId: 0, ProductName: '', ProductId: 0, ManufacturerId: 0, ManufacturerName: '',
            ExpiryDate: '', Packing: 1, MRP: 0, PreMRP: 0, CostPrice: 0, GRN: ''
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
    }
    $scope.removeProduct = function (order) {
        var selected = [];
        var idx = -1;

        selected = $filter('filter')($scope.purchaseOrders, { Id: order.Id }, true)[0];
        idx = $scope.purchaseOrders.indexOf(selected);
        if (idx > -1) {
            $scope.purchaseOrders.splice(idx, 1);
        }
    };
    $scope.showSelectedMfg = function (order) {
        var selected = [];
        selected = $filter('filter')($scope.manufacturers, { Id: order.ManufacturerId });
        return selected.length ? selected[0].Name : '';
    };
    
    $scope.productList = function (q) {
        var def = StockAdjustmentDataService.getProductList(q);
        $scope.productMaster = def.resolve;
        return def.promise;
    };

    $scope.manfList = function (q) {
        var def = StockAdjustmentDataService.getManufacturerList(q);
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
        $scope.purchaseOrders[idx].BatchNo = $item.batchNo;
        $scope.purchaseOrders[idx].Qty = $item.Qty
        $scope.purchaseOrders[idx].ExpDate = $item.expDate;
        $scope.purchaseOrders[idx].MRP = $item.mrp;
        $scope.purchaseOrders[idx].CostPrice = $item.costPrice;
        $scope.purchaseOrders[idx].ManfId = $item.manfId;
        $scope.purchaseOrders[idx].Manufacturer = $item.manf;
        $scope.purchaseOrders[idx].CurStk = $item.CurStk;
        $scope.purchaseOrders[idx].GRNNo = $item.grnNo;
        $scope.purchaseOrders[idx].PurDetId = $item.purDetId;
        $scope.purchaseOrders[idx].Pur = $item.Pur;
        $scope.purchaseOrders[idx].PurRet = $item.PurRet;
        $scope.purchaseOrders[idx].Sal = $item.Sal;
        $scope.purchaseOrders[idx].SalRet = $item.SalRet;
        $scope.purchaseOrders[idx].OpenStk = $item.OpenStk;
        $scope.purchaseOrders[idx].StkAdj = $item.StkAdj;
        $scope.purchaseOrders[idx].PreMRP = $item.PreMRP;
        var drugElement = $filter('filter')($rowform.$editables, { name: 'ProductName'}, true)[0];
        drugElement.scope.$data = $item.label;

        var ExpiryElement = $filter('filter')($rowform.$editables, { name: 'checkExpDate' }, true)[0];
        ExpiryElement.scope.$data = $item.expDate;

        var MRPEditable = $filter('filter')($rowform.$editables, { name: 'MRP' }, true)[0];
        MRPEditable.scope.$data = $item.mrp;

        var CostEditable = $filter('filter')($rowform.$editables, { name: 'CostPrice' }, true)[0];
        CostEditable.scope.$data = $item.costPrice;

        var ManufEditable = $filter('filter')($rowform.$editables, { name: 'ManfId' }, true)[0];
        ManufEditable.scope.$data = $item.manfId;

        var QtyEditable = $filter('filter')($rowform.$editables, { name: 'Qty' }, true)[0].inputEl[0].focus();
        QtyEditable.scope.$data = $item.Qty;
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

    StockAdjustmentDataService.getStockAdjustmentList()
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