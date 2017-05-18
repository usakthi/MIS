IndentBillEntryController.$inject = ['$scope', '$filter', '$route', '$routeParams', 'IndentBillDataService', 'DepartmentList', 'PatientList', 'ManufacturerList', 'UnitList', 'IndentList', 'PharmacyIdEnc', '$location'];

function IndentBillEntryController($scope, $filter, $route, $routeParams, IndentBillDataService, deptList, patientList, mfgList, unitList, indentList, PharmacyIdEnc, $location) {
    $scope.purchaseHeader = {};
    $scope.departments = deptList;
    $scope.editMode = false;
    $scope.patients = patientList;
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
   
    $scope.purchaseHeader.CostAmount = 0;
    $scope.purchaseHeader.MRPAmount = 0;

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
                                      function () { alert('error while loading Department Usage info') }
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
    $scope.$watch('purchaseHeader.DeptList', function (newValue, oldValue, scope) {
        
        if (newValue > 0) {
            var selectedDept = $filter('filter')($scope.departments, { Id: parseInt(newValue, 10) }, true)[0];
            $scope.purchaseHeader.DeptName = selectedDept.Name;
            $scope.purchaseHeader.DeptCode = selectedDept.Id;

            IndentBillDataService.getIndentInfo(newValue)
                                    .then(function (purchase) {
                                        //$scope.purchaseHeader = purchase;
                                        //$scope.purchaseHeader.PatientName = purchase.PatientName;
                                        //$scope.purchaseOrders = purchase.IndentBillItems;
                                    },
                                          function () { alert('error while loading Indent info') }
                                   ).finally(function () {
                                       $scope.dataLoading = false;
                                   })
        }
        $scope.upCalcAmount();
        
    });

    $scope.purchaseHeader.DType = 'D';

    $scope.hidePatientDetails = function () {
        $scope.purchaseHeader.IPNo = false;
        $scope.purchaseHeader.PatientName = false;
        $scope.purchaseHeader.Age = false;
        $scope.purchaseHeader.PayMode = false;
        $scope.purchaseHeader.Ward = false;
            $scope.purchaseHeader.IPList = false;
            $scope.purchaseHeader.DType = 'D';
    }
    $scope.ShowPatientDetails = function () {
        $scope.purchaseHeader.IPNo = true;
        $scope.purchaseHeader.PatientName = true;
        $scope.purchaseHeader.Age = true;
        $scope.purchaseHeader.PayMode = true;
        $scope.purchaseHeader.Ward = true;
            $scope.purchaseHeader.IPList = true;
            $scope.purchaseHeader.DType = 'P';
    }

    $scope.$watch('purchaseHeader.IPList', function (newValue, oldValue, scope) {
        if (newValue != oldValue) {
            var selectedIP = $filter('filter')($scope.patients, { Id: parseInt(newValue, 10) }, true)[0];
            $scope.purchaseHeader.IPNo = selectedIP.Name;
            $scope.purchaseHeader.PatientName = selectedIP.PatientName;
            $scope.purchaseHeader.Age = selectedIP.Age;
            $scope.purchaseHeader.PayMode = selectedIP.PayMode;
            $scope.purchaseHeader.Ward = selectedIP.Ward;
        }
    });

    $scope.savePurchase = function () {
        var valid = $scope.validateOrders();
        if ($scope.authorized) {
            $scope.purchaseHeader.PharmacyIdEnc = $scope.pIdEnc;
            $scope.purchaseHeader.IndentBillItems = $scope.purchaseOrders;

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
        $scope.purchaseOrders[idx].manfId = data.ManufacturerId;
        $scope.purchaseOrders[idx].batchNo = data.BatchNo;
        $scope.purchaseOrders[idx].Qty = data.Qty;
        $scope.purchaseOrders[idx].stock = data.Stock;
        $scope.purchaseOrders[idx].expDate = data.ExpDate;
        $scope.purchaseOrders[idx].purDetId = data.PurDetId

        $scope.purchaseOrders[idx].savedLocal = true;
        $scope.updateCalcAmount();
    }

    $scope.updateCalcAmount = function (data) {
        var mrp = 0;
        for (var i = 0; i < $scope.purchaseOrders.length; i++) {
            if (isFinite($scope.purchaseOrders[i].TotalMRP)) {
                mrp = mrp + parseFloat($scope.purchaseOrders[i].TotalMRP);
            }
        }
        $scope.purchaseHeader.NetAmount = mrp;
    }

    $scope.checkProductName = function (data, rowform) {
        if (data === "" || typeof (data) === 'undefined' || data == null) {
            return "Please enter product name";
        }
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

    $scope.checkNewProductRow = function (data, Id, rowform, index) {
        $scope.savePurchaseItem(rowform.$data, Id, rowform, index);
        $scope.addNewProduct();
    }

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

    $scope.productList = function (q,c) {
        var def = IndentBillDataService.getProductList(q, c);
        
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
        
        var drugElement = $filter('filter')($rowform.$editables, { name: 'ProductName' }, true)[0];
        drugElement.scope.$data = $item.label;

        var batchElement = $filter('filter')($rowform.$editables, { name: 'BatchNo' }, true)[0];
        batchElement.scope.$data = $item.batchNo;

        var manfEditable = $filter('filter')($rowform.$editables, { name: 'Manufacturer' }, true)[0];
        manfEditable.scope.$data = $item.manf;

        var manfIdEditable = $filter('filter')($rowform.$editables, { name: 'ManufacturerId' }, true)[0];
        manfIdEditable.scope.$data = $item.manfId;

        var ExpiryElement = $filter('filter')($rowform.$editables, { name: 'ExpDate' }, true)[0];
        ExpiryElement.scope.$data = $item.expDate;

        var StockEditable = $filter('filter')($rowform.$editables, { name: 'Stock' }, true)[0];
        StockEditable.scope.$data = $item.stock;

        var PurDetIdEditable = $filter('filter')($rowform.$editables, { name: 'PurDetId' }, true)[0];
        PurDetIdEditable.scope.$data = $item.purDetId;

        var QtyEditable = $filter('filter')($rowform.$editables, { name: 'Qty' }, true)[0].inputEl[0].focus();
        QtyEditable.scope.$data = 1;
    };

    //$scope.purchaseOrders[idx].MRP = $item.mrp;
    //$scope.purchaseOrders[idx].CostPrice = $item.costPrice;

    //var MRPEditable = $filter('filter')($rowform.$editables, { name: 'MRP' }, true)[idx];
    //MRPEditable.scope.$data = $item.mrp;

    //var CostEditable = $filter('filter')($rowform.$editables, { name: 'CostPrice' }, true)[idx];
    //CostEditable.scope.$data = $item.costPrice;

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