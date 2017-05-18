BillEntryController.$inject = ['$scope', '$filter', '$route', '$routeParams', 'BillDataService', 'PatientList', 'RackList', 'ManufacturerList', 'UnitList', 'PharmacyIdEnc', '$location'];

function BillEntryController($scope, $filter, $route, $routeParams, BillDataService, patientList, rackList, mfgList, unitList, PharmacyIdEnc, $location) {
    $scope.purchaseHeader = {};
    $scope.patients = patientList;
    $scope.editMode = false;
    $scope.racks = rackList;
    $scope.manufacturers = mfgList;
    $scope.units = unitList;
    $scope.taxes = [{ value: 5.5, text: '5.5' }, { value: 14.5, text: '14.5' }];
    $scope.purchaseOrders = [];
    $scope.admissionOrders = [];
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
                                    $scope.purchaseOrders = purchase.IndentItems;
                                },
                                      function () { alert('error while loading purchase info') }
                               ).finally(function () {
                                   $scope.dataLoading = false;
                               })
    }
    else {
        $scope.dataLoading = false;
    }
    
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

    $scope.$watch('purchaseHeader.SupplierId', function (newValue, oldValue, scope) {
        if (newValue != oldValue) {
            var selected = $filter('filter')($scope.suppliers, { Id: parseInt(newValue,10) }, true)[0];
            $scope.purchaseHeader.CreditPeriod = selected.DueDays;
        }
    });

    $scope.purchaseHeader.PatientName = '';
    $scope.purchaseHeader.IPNo = '';
    $scope.purchaseHeader.Age = '';
    $scope.purchaseHeader.RegNo = '';
    $scope.purchaseHeader.PayMode = '';
    $scope.purchaseHeader.Ward = '';
    $scope.purchaseHeader.Consultant = '';
    $scope.$watch('purchaseHeader.IPId', function (order) {
        if (order != 0) {
            var selected = $filter('filter')($scope.patients, { Id: order.PatientId });
            $scope.purchaseHeader.PatientName = selected[order - 1].PatientName;
            $scope.purchaseHeader.IPNo = selected[order - 1].Name;
            $scope.purchaseHeader.Age = selected[order - 1].Age;
            $scope.purchaseHeader.RegNo = selected[order - 1].RegNo;
            $scope.purchaseHeader.PayMode = selected[order - 1].PayMode;
            $scope.purchaseHeader.Ward = selected[order - 1].Ward;
            $scope.purchaseHeader.Consultant = selected[order - 1].Consultant;
        }
    });

    $scope.checkNewProductRow = function (data, Id, rowform, index) {
        $scope.savePurchaseItem(rowform.$data, Id, rowform, index);
        $scope.addNewProduct();
    }

    $scope.savePurchase = function () {

        var valid = $scope.validateOrders();
        if ($scope.authorized) {
            $scope.purchaseHeader.PharmacyIdEnc = $scope.pIdEnc;
            $scope.purchaseHeader.IndentItems = $scope.purchaseOrders;

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
                 function () { alert('error while saving Indent'); $scope.authorized = false; }
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
        $scope.purchaseOrders[idx].ProductId = data.ProductId;
        
        $scope.purchaseOrders[idx].manfId = data.ManufacturerId;
        $scope.purchaseOrders[idx].batchNo = data.BatchNo;
        $scope.purchaseOrders[idx].Qty = data.Qty;
        $scope.purchaseOrders[idx].stock = data.Stock;
        $scope.purchaseOrders[idx].expDate = data.ExpDate;
        $scope.purchaseOrders[idx].grnNo = data.GRNNo;
        $scope.purchaseOrders[idx].purDetId = data.PurDetId;
        
        $scope.purchaseOrders[idx].savedLocal = true;
        //$scope.updateCalcAmount();
    }

    $scope.checkProductName = function (data, rowform) {
        if (data === "" || typeof (data) === 'undefined' || data == null) {
            return "Please enter product name";
        }
    }
    
    //$scope.updateCalcAmount = function (data) {
    //    var amt = 0;
    //    for (var i = 0; i < $scope.purchaseOrders.length; i++) {
    //        //CHANGE IN LOGIC
    //        if (isFinite($scope.purchaseOrders[i].TotalCostPrice)) {
    //            amt = amt + parseFloat($scope.purchaseOrders[i].TotalCostPrice);
    //        }
    //    }

    //    $scope.purchaseHeader.NetAmount = amt;
    //}
    
    $scope.$watch('purchaseHeader.TotalAmount', function (newValue, oldValue, scope) {
            $scope.totalBillAmountEntered = true;
    });

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
            BatchNo: '', Qty: 1, ProductName: '', ProductId: 0, ManufacturerName: '',ExpiryDate: ''
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
        $scope.purchaseOrders[idx].Manufacturer = $item.manf;
        $scope.purchaseOrders[idx].Name = $item.label;
        $scope.purchaseOrders[idx].BatchNo = $item.batchNo;
        $scope.purchaseOrders[idx].ExpDate = $item.expDate;
        $scope.purchaseOrders[idx].Stock = $item.stock;
        $scope.purchaseOrders[idx].GRNNo = $item.grnNo;
        $scope.purchaseOrders[idx].PurDetId = $item.purDetId;
        $scope.purchaseOrders[idx].ManufacturerId = $item.manfId;

        var drugElement = $filter('filter')($rowform.$editables, { name: 'ProductName' }, true)[0]; //.inputEl[0].focus();
        drugElement.scope.$data = $item.label;

        var batchElement = $filter('filter')($rowform.$editables, { name: 'BatchNo' }, true)[0]; //.inputEl[0].focus();
        batchElement.scope.$data = $item.batchNo;

        var manfEditable = $filter('filter')($rowform.$editables, { name: 'Manufacturer' }, true)[0];
        manfEditable.scope.$data = $item.manf;

        var manfIdEditable = $filter('filter')($rowform.$editables, { name: 'ManufacturerId' }, true)[0];
        manfIdEditable.scope.$data = $item.manfId;

        var ExpiryElement = $filter('filter')($rowform.$editables, { name: 'ExpDate' }, true)[0];
        ExpiryElement.scope.$data = $item.expDate;

        var QtyEditable = $filter('filter')($rowform.$editables, { name: 'Qty' }, true)[0].inputEl[0].focus();
        QtyEditable.scope.$data = 1;

        var StockEditable = $filter('filter')($rowform.$editables, { name: 'Stock' }, true)[0].inputEl[0].focus();
        StockEditable.scope.$data = $item.stock;

        var GrnNoEditable = $filter('filter')($rowform.$editables, { name: 'GRNNo' }, true)[0].inputEl[0].focus();
        GrnNoEditable.scope.$data = $item.grnNo;

        var PurDetIdEditable = $filter('filter')($rowform.$editables, { name: 'PurDetId' }, true)[0].inputEl[0].focus();
        PurDetIdEditable.scope.$data = $item.purDetId;
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
   
}

BillListController.$inject = ['$scope', '$filter', '$route', 'BillDataService'];

function BillListController($scope, $filter, $route, BillDataService) {
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
}