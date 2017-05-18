PurchaseEntryController.$inject = ['$scope', '$filter', '$route', '$routeParams', 'PurchaseDataService', 'SupplierList', 'PharmacyIdEnc', '$location', 'hotkeys'];

function PurchaseEntryController($scope, $filter, $route, $routeParams, PurchaseDataService, suppList, PharmacyIdEnc, $location, hotkeys) {
    $scope.purchaseHeader = {};
    $scope.suppliers = suppList;
    $scope.editMode = false;
    $scope.purchaseOrders = [];
    $scope.pIdEnc = PharmacyIdEnc;
    $scope.purchaseId = 0;
    $scope.selectedVal = 0;
    $scope.purchaseHeader.TotalDiscount = 0;
    $scope.purchaseHeader.NetAmount = 0;
    $scope.purchaseHeader.TotalVatAmount = 0;
    $scope.purchaseHeader.GrnDate = new Date();
    $scope.InvNoSelected = false;
    $scope.SupplierId = 0;

    if ($routeParams.id && $routeParams.id > 0) {
        $scope.editMode = true;
    }

    $scope.productMaster = [];
    $scope.inserted = {};
    $scope.purchaseHeader.DiscountPercent = 0;
    $scope.dataLoading = true;
    $scope.authorized = false;
    $scope.validatingCredentials = false;
    $scope.purchaseHeader.SavedUser = { PlainPwd: '' };
    $("body").addClass("aside-collapsed");

    if ($routeParams.id && $routeParams.id > 0) {
        PurchaseDataService.getPurchaseInfo($routeParams.id)
                                .then(function (purchase) {
                                    $scope.purchaseHeader = purchase;
                                    $scope.purchaseOrders = purchase.PurchaseReturnItems;
                                },
                                      function () { alert('error while loading purchase return info') }
                               ).finally(function () {
                                   $scope.dataLoading = false;
                               })
    }
    else {
        $scope.dataLoading = false;
    }

    $scope.$watch('purchaseHeader.SupplierId', function (newValue, oldValue, scope) {
        if (newValue > 0) {
            var selectedInvNo = $filter('filter')($scope.suppliers, { Id: parseInt(newValue, 10), }, true)[0];
            var SupId = selectedInvNo.Id;
            $scope.SupplierId = SupId;
            PurchaseDataService.getSupplierInfo(SupId)
                                    .then(function (purchase) {
                                        $scope.invoiceDetails = purchase;
                                    },
                                          function () { alert('error while loading Supplier info') }
                                   ).finally(function () {
                                       $scope.dataLoading = false;
                                   })
        }
    });

    $scope.$watch('purchaseHeader.SupplierInvNo', function (newValue, oldValue, scope) {
        if (newValue > 0) {
            var selectedInvNo = $filter('filter')($scope.invoiceDetails, { Id: parseInt(newValue, 10), }, true)[0];
            //$scope.purchaseHeader.SupplierInvDate = selectedInvNo.SupplierInvDate;
            if ($scope.SupplierId < 10)
            {
                InvNo = '00' + $scope.SupplierId + selectedInvNo.Name;
            }
            else if ($scope.SupplierId > 100) {
                InvNo = $scope.SupplierId + selectedInvNo.Name;
            }
            else {
                InvNo = '0' + $scope.SupplierId + selectedInvNo.Name;
            }
            PurchaseDataService.getPurchasedInfo(InvNo)
                                    .then(function (purchase) {
                                        $scope.dataLoading = false;
                                    },
                                          function () { alert('error while loading Invoice info') }
                                   ).finally(function () {
                                       $scope.dataLoading = false;
                                   })
            $scope.purchaseHeader.SupplierInvNo = selectedInvNo.Name;
        }
    });

    $scope.savePurchase = function () {
        var valid = $scope.validateOrders();
        if ($scope.authorized) {
            $scope.purchaseHeader.PharmacyIdEnc = $scope.pIdEnc;
            $scope.purchaseHeader.PurchaseReturnItems = $scope.purchaseOrders;
            //console.log(JSON.stringify($scope.purchaseHeader));
            PurchaseDataService.savePurchase($scope.purchaseHeader)
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
                 function () { alert('error while saving purchase return'); $scope.authorized = false; }
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
                PurchaseDataService.authorizeUser($scope.purchaseHeader.SavedUser)
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
                     function () { alert('error while deleting purchase return') }
                   );
            });
    };

    $scope.savePurchaseItem = function (data, id, rowform, idx) {
        var selected = [];
        var idx = -1;

        selected = $filter('filter')($scope.purchaseOrders, { Id: id }, true)[0];
        idx = $scope.purchaseOrders.indexOf(selected);
        if (data.Qty > data.Stock) {
            $scope.removeProduct(order);
        }
        else {
            $scope.purchaseOrders[idx].ProductId = data.ProductId;
            $scope.purchaseOrders[idx].AssortedCostPrice = data.AssortedCostPrice;
            $scope.purchaseOrders[idx].AssortedMRPPrice = data.AssortedMRPPrice;
            $scope.purchaseOrders[idx].AssortedQty = data.AssortedQty;

            $scope.purchaseOrders[idx].VATAmount = data.VATAmount;
            $scope.purchaseOrders[idx].TotalCostPrice = data.TotalCostPrice;
            $scope.purchaseOrders[idx].TotalMRP = data.TotalMRP;
            $scope.purchaseOrders[idx].AbatedMRP = data.AbatedMRP;
            $scope.purchaseOrders[idx].TotalVatAmount = data.TotalVatAmount;
            $scope.purchaseOrders[idx].savedLocal = true;
            $scope.updateCalcAmount();
        }
    }

    $scope.checkNewProductRow = function (data, Id, rowform, index) {
      
        $scope.savePurchaseItem(rowform.$data, Id, rowform, index);
        if ($scope.purchaseOrders.length - 1 == index)
            $scope.addNewProduct();
        else {
            document.getElementById('ProductName' + (index + 1)).focus();
        }
    }

    $scope.checkProductName = function (data, rowform) {
        if (data === "" || typeof (data) === 'undefined' || data == null) {
            return "Please enter product name";
        }
    }

    $scope.updateCalcAmount = function (data) {
        var amt = 0;
        for (var i = 0; i < $scope.purchaseOrders.length; i++) {
            if (isFinite($scope.purchaseOrders[i].TotalCostPrice)) {
                amt = amt + parseFloat($scope.purchaseOrders[i].TotalCostPrice);
            }
        }
        $scope.purchaseHeader.NetAmount = amt;
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
            BatchNo: '', Qty: 1, ProductName: '', ProductId: 0, ManufacturerId: 0, Manufacturer: '',
            ExpDate: '', Packing: 1, AssortedQty: 0, VAT: 5.5, DiscountPercentage: $scope.purchaseHeader.DiscountPercent, CostPrice: 0, MRP: 0,
            DiscountAmount: 0, TaxMode: 'COST', TaxType: 'EXCL'
        };

        $scope.purchaseOrders.push($scope.inserted);
    };
    $scope.addNewProduct();

    $scope.focusProductName = function (rowform) {
        rowform.$activate("ProductName");
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
    
    $scope.productList = function (q) {
        var def = PurchaseDataService.getProductList(q);
        $scope.productMaster = def.resolve;
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
        $rowform.$data.PurDetId = $item.Id;
        var selected = [];
        var idx = -1;
        selected = $filter('filter')($scope.purchaseOrders, { Id: order.Id }, true)[0];
        idx = $scope.purchaseOrders.indexOf(selected);
        $scope.purchaseOrders[idx].ProductId = $item.ProductId;
        $scope.purchaseOrders[idx].BatchNo = $item.batchNo;
        $scope.purchaseOrders[idx].Qty = $item.Qty
        $scope.purchaseOrders[idx].ExpDate = $item.expDate;
        $scope.purchaseOrders[idx].MRP = $item.mrp;
        $scope.purchaseOrders[idx].CostPrice = $item.costPrice;
        $scope.purchaseOrders[idx].ManufacturerId = $item.manfId;
        $scope.purchaseOrders[idx].Manufacturer = $item.manf;
        $scope.purchaseOrders[idx].Stock = $item.stock;
        $scope.purchaseOrders[idx].PurStk = $item.purstk;
        $scope.purchaseOrders[idx].PurDetId = $item.purDetId;
        $scope.purchaseOrders[idx].VAT = $item.vat;
        $scope.purchaseOrders[idx].Packing = $item.Pack;
        
        var drugElement = $filter('filter')($rowform.$editables, { name: 'ProductName' }, true)[0];
        drugElement.scope.$data = $item.label;

        var ProductIdEditable = $filter('filter')($rowform.$editables, { name: 'ProductId' }, true)[0];
        ProductIdEditable.scope.$data = $item.ProductId;

        var StockElement = $filter('filter')($rowform.$editables, { name: 'Stock' }, true)[0];
        StockElement.scope.$data = $item.stock;

        var MRPEditable = $filter('filter')($rowform.$editables, { name: 'MRP' }, true)[0];
        MRPEditable.scope.$data = $item.mrp;

        var VATEditable = $filter('filter')($rowform.$editables, { name: 'VAT' }, true)[0];
        VATEditable.scope.$data = $item.vat;

        var CostEditable = $filter('filter')($rowform.$editables, { name: 'CostPrice' }, true)[0];
        CostEditable.scope.$data = $item.costPrice;

        var ManufEditable = $filter('filter')($rowform.$editables, { name: 'ManufacturerId' }, true)[0];
        ManufEditable.scope.$data = $item.manfId;

        var qtyElement = $filter('filter')($rowform.$editables, { name: 'Qty' }, true)[0].inputEl[0].focus();
        qtyElement.scope.$data = $item.Qty;
    };

    $scope.showProductName = function (model) {
        return model.ProductName;
    };

    $scope.getStats = function (q) {
        return $scope.states;
    };

    $scope.taxModes = [{ text: "COST", value: "COST" }, { text: "MRP", value: "MRP" }];
    $scope.taxTypes = [{ text: "Inclusive", value: "INCL" }, { text: "Exclusive", value: "EXCL" }];
    $scope.YesNoType = [{ text: "Yes", value: "1" }, { text: "No", value: "0" }];

    $scope.showSelectedTaxMode = function (order) {
        var selected = [];
        selected = $filter('filter')($scope.taxModes, { value: order.TaxMode });
        return selected.length ? selected[0].text : 'COST';
    };
    $scope.showSelectedTaxType = function (order) {
        var selected = [];
        selected = $filter('filter')($scope.taxTypes, { value: order.TaxType });
        return selected.length ? selected[0].text : 'INCL';
    };

    $scope.calculateAbatedMRP = function (order) {
        var totalMrp = isFinite(order.TotalMRP) ? order.TotalMRP : 0;
        var vat = isFinite(order.VAT) ? order.VAT : 0;;
        var amount = totalMrp - (totalMrp - (totalMrp / ((vat / 100) + 1)));
        order.AbatedMRP = isFinite(amount) ? round(amount, 2) : 0;
        return order.AbatedMRP;
    }
    $scope.calculateNetMRP = function (order) {
        var totalMrp = isFinite(order.TotalMRP) ? order.TotalMRP : 0;
        var totalVat = isFinite(order.TotalVatAmount) ? order.TotalVatAmount : 0;
        var totalDisc = isFinite(order.TotalDiscountAmount) ? order.TotalDiscountAmount : 0;
        var amount = totalMrp - totalVat - totalDisc;
        order.NetMRP = isFinite(amount) ? round(amount, 2) : 0;
        return order.NetMRP;
    }

    $scope.calculateFreeQtyVATAmount = function (order) {

        var amount = 0;
        if (order.TaxMode === 'COST') {
            var assortedCostPrice = isFinite(order.AssortedCostPrice) ? order.AssortedCostPrice : 0;
            amount = ((parseFloat(order.Packing)) * assortedCostPrice) * (parseFloat(order.VAT) / 100);
        }
        else if (order.TaxMode === 'MRP') {
            var assortedMrpPrice = isFinite(order.AssortedMRPPrice) ? order.AssortedMRPPrice : 0;
            amount = ((parseFloat(order.Packing)) * assortedMrpPrice) * (parseFloat(order.VAT) / 100);
        }

        order.FreeQtyVATAmount = isFinite(amount) ? round(amount, 2) : 0;
        return order.FreeQtyVATAmount;
    }
    $scope.calculateVatOnDiscountAmount = function (order) {
        var totalVat = isFinite(order.TotalVatAmount) ? order.TotalVatAmount : 0;
        var amount = totalVat * (parseFloat(order.DiscountPercentage) / 100);
        order.VatOnDiscountAmount = isFinite(amount) ? round(amount, 2) : 0;
        return order.VatOnDiscountAmount;
    }
    $scope.calculateAssortedQty = function (order) {
        var amount = (order.Qty * order.Packing);
        order.AssortedQty = isFinite(amount) ? round(amount, 2) : 0;
        return order.AssortedQty;
    }

    $scope.calculateDiscountAmount = function (order) {
        var discPerc = isFinite(order.DiscountPercentage) ? order.DiscountPercentage : 0;
        var amount = 0;
        if (order.TaxMode === 'COST') {
            amount = (parseFloat(order.TotalCostPrice)) * (discPerc / 100);
        }
        else if (order.TaxMode === 'MRP') {
            amount = (parseFloat(order.TotalMRP)) * (discPerc / 100);
        }
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
    $scope.calculateAssortedCostPrice = function (order) {

        var amount = parseFloat(order.CostPrice) / (order.Packing);
        order.AssortedCostPrice = isFinite(amount) ? round(amount, 2) : 0;
        return order.AssortedCostPrice;
    }

    $scope.calculateAssortedMRPPrice = function (order) {

        var amount = parseFloat(order.MRP) / (order.Packing);
        order.AssortedMRPPrice = isFinite(amount) ? round(amount, 2) : 0;
        return order.AssortedMRPPrice;
    }
    $scope.calculateVATAmount = function (order) {
        //(Total Cost - (TotalCost/(Vat%(common)/100)+1)) 
        var vat = isFinite(order.VAT) ? order.VAT : 0;
        var amount = 0;
        if (order.TaxMode === 'COST' && order.TaxType === 'INCL') {
            amount = order.TotalCostPrice - (order.TotalCostPrice / ((vat / 100) + 1));
        }
        else if (order.TaxMode === 'COST' && order.TaxType === 'EXCL') {
            amount = order.TotalCostPrice * (vat / 100);
        }
        else if (order.TaxMode === 'MRP' && order.TaxType === 'INCL') {
            amount = order.TotalMRP - (order.TotalMRP / ((vat / 100) + 1));
        }
        else if (order.TaxMode === 'MRP' && order.TaxType === 'EXCL') {
            amount = order.TotalMRP * (vat / 100);
        }
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
        description: 'Save PurchaseReturn',
        callback: function (e) {
            e.preventDefault();
            $scope.savePurchase();
        }
    })
    .add({
        combo: 'f4',
        description: 'Clear PurchaseReturn',
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

PurchaseListController.$inject = ['$scope', '$filter', '$route', 'PurchaseDataService', 'hotkeys', '$location'];

function PurchaseListController($scope, $filter, $route, PurchaseDataService, hotkeys, $location) {

    $scope.purchases = [];

    $scope.cdate = new Date();

    PurchaseDataService.getPurchaseList()
        .then(function (purchaseList) { $scope.purchases = purchaseList },
              function () { alert('error while fetching purchaseList from server') }
         );
    $scope.delete = function (id) {
        $('#confirm-purchase-delete').modal({ backdrop: false, keyboard: false })
            .one('click', '#delete', function () {
                PurchaseDataService.deletePurchase(id)
                            .then(function (data) {
                                if (data.status === true) {
                                    $route.reload();
                                }
                            },
                              function () { alert('error while deleting purchase return') }
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
        description: 'AddNew PurchaseReturn',
        callback: function (e) {
            e.preventDefault();
            $location.path('/add');
        }
    });
}