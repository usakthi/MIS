BillEntryController.$inject = ['$scope', '$filter', '$route', '$routeParams', 'BillDataService', 'SupplierList', 'RackList', 'ManufacturerList', 'UnitList', 'PharmacyIdEnc', '$location'];

function BillEntryController($scope, $filter, $route, $routeParams, BillDataService, suppList, rackList, mfgList, unitList, PharmacyIdEnc, $location) {
    $scope.purchaseHeader = {};
    $scope.suppliers = suppList;
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
    $scope.purchaseHeaderTotalVat = 0;
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
                                    $scope.purchaseOrders = purchase.BillReturnItems;
                                },
                                      function () { alert('error while loading purchase info') }
                               ).finally(function () {
                                   $scope.dataLoading = false;
                               })
    }
    else {
        $scope.dataLoading = false;
    }

    $scope.$watch('purchaseHeader.SalesMode', function (newValue, oldValue, scope) {
        if (newValue === 'Credit') {
            $scope.purchaseHeader.PaidAmount = '';
            $scope.purchaseHeader.Balance = $scope.purchaseHeader.NetAmount;
        }
        else {
            $scope.purchaseHeader.PaidAmount = $scope.purchaseHeader.NetAmount;
            $scope.purchaseHeader.Balance = 0;
        }
    });

    $scope.savePurchase = function () {
        var valid = $scope.validateOrders();
        if ($scope.authorized) {
            $scope.purchaseHeader.PharmacyIdEnc = $scope.pIdEnc;
            $scope.purchaseHeader.BillReturnItems = $scope.purchaseOrders;
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
                 function () { alert('error while updating Bill'); $scope.authorized = false; }
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
        $scope.purchaseOrders[idx].PurDetId = data.PurDetId;
        
        $scope.purchaseOrders[idx].ManufacturerId = data.ManfId;
        $scope.purchaseOrders[idx].Qty = data.Qty;
        $scope.purchaseOrders[idx].Stock = data.Stock;
        $scope.purchaseOrders[idx].CostPrice = data.CostPrice;
        $scope.purchaseOrders[idx].MRP = data.MRP;
        $scope.purchaseOrders[idx].VAT = data.VAT;
        $scope.purchaseOrders[idx].VATAmount = data.VATAmount;
        
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
        var vamt = 0;
        for (var i = 0; i < $scope.purchaseOrders.length; i++) {
            if (isFinite($scope.purchaseOrders[i].TotalMRP)) {
                amt = amt + parseFloat($scope.purchaseOrders[i].TotalMRP);
                vamt = vamt + parseFloat($scope.purchaseOrders[i].VATAmount);
            }
        }
        
        $scope.purchaseHeader.NetAmount = amt;
        $scope.purchaseHeader.TotalVAT = vamt;
        if ($scope.purchaseHeader.SalesMode === 'Credit') {
            $scope.purchaseHeader.PaidAmount = '';
            $scope.purchaseHeader.Balance = amt;
        }
        else {
            $scope.purchaseHeader.PaidAmount = amt;
            $scope.purchaseHeader.Balance = 0;
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
            DiscApplicable: '0', DiscountAmount: 0
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
        $scope.purchaseOrders[idx].BatchNo = $item.batchNo;
        $scope.purchaseOrders[idx].Qty = $item.Qty
        $scope.purchaseOrders[idx].ExpDate = $item.expDate;
        $scope.purchaseOrders[idx].MRP = $item.mrp;
        $scope.purchaseOrders[idx].CostPrice = $item.costPrice;
        $scope.purchaseOrders[idx].ManfId = $item.manfId;
        $scope.purchaseOrders[idx].Manufacturer = $item.manf;
        $scope.purchaseOrders[idx].Stock = $item.stock;
        $scope.purchaseOrders[idx].GRNNo = $item.grnNo;
        $scope.purchaseOrders[idx].PurDetId = $item.purDetId;
        $scope.purchaseOrders[idx].VAT = $item.vat;
        var drugElement = $filter('filter')($rowform.$editables, { name: 'ProductName' }, true)[0];
        drugElement.scope.$data = $item.label;

        var StockElement = $filter('filter')($rowform.$editables, { name: 'Stock' }, true)[0];
        StockElement.scope.$data = $item.stock;

        var MRPEditable = $filter('filter')($rowform.$editables, { name: 'MRP' }, true)[0];
        MRPEditable.scope.$data = $item.mrp;

        var CostEditable = $filter('filter')($rowform.$editables, { name: 'CostPrice' }, true)[0];
        CostEditable.scope.$data = $item.costPrice;

        var ManufEditable = $filter('filter')($rowform.$editables, { name: 'ManfId' }, true)[0];
        ManufEditable.scope.$data = $item.manfId;

        var QtyEditable = $filter('filter')($rowform.$editables, { name: 'Qty' }, true)[0].inputEl[0].focus();
        QtyEditable.scope.$data = $item.Qty;

        var ExpiryElement = $filter('filter')($rowform.$editables, { name: 'checkExpDate' }, true)[0];
        ExpiryElement.scope.$data = $item.expDate;
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
    $scope.showSelectedDiscApplicable = function (order) {
        var selected = [];
        selected = $filter('filter')($scope.YesNoType, { value: order.DiscApplicable });
        return selected.length ? selected[0].text : 'No';
    };
    $scope.showSelectedVATOnDiscount = function (order) {
        var selected = [];
        selected = $filter('filter')($scope.YesNoType, { value: order.VATOnDiscount });
        return selected.length ? selected[0].text : 'No';
    };
    $scope.showSelectedVATOnFreeQty = function (order) {
        var selected = [];
        selected = $filter('filter')($scope.YesNoType, { value: order.VATOnFreeQty });
        return selected.length ? selected[0].text : 'No';
    };
    $scope.showSelectedDiscOnFreeQty = function (order) {
        var selected = [];
        selected = $filter('filter')($scope.YesNoType, { value: order.DiscOnFreeQty });
        return selected.length ? selected[0].text : 'No';
    };


    $scope.calculateAbatedMRP = function (order) {
        var totalMrp = isFinite(order.TotalMRP) ? order.TotalMRP : 0;  //F21-(F21-(F21/((F13/100)+1)))
        var vat = isFinite(order.VAT) ? order.VAT : 0;;
        var amount = totalMrp - (totalMrp - (totalMrp / ((vat / 100) + 1)));
        order.AbatedMRP = isFinite(amount) ? round(amount, 2) : 0;
        return order.AbatedMRP;
    }
    $scope.calculateNetMRP = function (order) {
        var totalMrp = isFinite(order.TotalMRP) ? order.TotalMRP : 0;
        var totalVat1 = isFinite(order.TotalVatAmount) ? order.TotalVatAmount : 0;
        var totalDisc = isFinite(order.TotalDiscountAmount) ? order.TotalDiscountAmount : 0;
        var amount = totalMrp - totalVat1 - totalDisc;
        order.NetMRP = isFinite(amount) ? round(amount, 2) : 0;
        return order.NetMRP;
    }

    $scope.calculateFreeQtyVATAmount = function (order) {

        var amount = 0;
        if (order.TaxMode === 'COST') {
            var assortedCostPrice = isFinite(order.AssortedCostPrice) ? order.AssortedCostPrice : 0;
            amount = ((order.FreeQty * parseFloat(order.Packing)) * assortedCostPrice) * (parseFloat(order.VAT) / 100);
        }
        else if (order.TaxMode === 'MRP') {
            var assortedMrpPrice = isFinite(order.AssortedMRPPrice) ? order.AssortedMRPPrice : 0;
            amount = ((order.FreeQty * parseFloat(order.Packing)) * assortedMrpPrice) * (parseFloat(order.VAT) / 100);
        }

        order.FreeQtyVATAmount = isFinite(amount) ? round(amount, 2) : 0;
        return order.FreeQtyVATAmount;
    }
    $scope.calculateVatOnDiscountAmount = function (order) {
        var totalVat1 = isFinite(order.TotalVatAmount) ? order.TotalVatAmount : 0;
        var amount = totalVat1 * (parseFloat(order.DiscountPercentage) / 100);
        order.VatOnDiscountAmount = isFinite(amount) ? round(amount, 2) : 0;
        return order.VatOnDiscountAmount;
    }
    $scope.calculateAssortedQty = function (order) {
        var amount = (order.Qty + order.FreeQty) * order.Packing;
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
    $scope.calculateDiscOnFreeQtyAmount = function (order) {
        var discPerc = isFinite(order.DiscountPercentage) ? order.DiscountPercentage : 0;
        var amount = 0;
        if (order.DiscOnFreeQty && order.DiscOnFreeQty === '1') {
            if (order.TaxMode === 'COST') {
                amount = (order.FreeQty * order.CostPrice) * (discPerc / 100);
            }
            else {
                amount = (order.FreeQty * order.MRP) * (discPerc / 100);
            }
        }
        order.DiscOnFreeQtyAmount = isFinite(amount) ? round(amount, 2) : 0;
        return order.DiscOnFreeQtyAmount;
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
        var vat = isFinite(order.VAT) ? order.VAT : 0;
        var amount = 0;
        amount = order.TotalMRP * (vat / 100);
        order.VATAmount = isFinite(amount) ? round(amount, 2) : 0;
        return order.VATAmount;
    }

    $scope.calculateTotalCostPrice = function (order) {
        var qty = parseInt(order.Qty);
        var amount = parseFloat(order.CostPrice) * (qty);
        order.TotalCostPrice = isFinite(amount) ? round(amount, 2) : 0;
        return order.TotalCostPrice;
    }
    $scope.calculateNetCostPrice = function (order) {
        var amount = parseFloat(order.TotalCostPrice) - (isFinite(order.TotalDiscountAmount) ? order.TotalDiscountAmount : 0);
        order.NetCostPrice = isFinite(amount) ? round(amount, 2) : 0;
        return order.NetCostPrice;
    }
    $scope.calculateTotalMRP = function (order) {
        var qty = parseInt(order.Qty);
        //var stock = parseInt(order.Stock);
        //if (qty > stock) {
        //    qty = parseInt(order.Stock);
        //    order.Qty = parseInt(order.Stock);
        //    return order.Qty
        //} else {
        //    qty = parseInt(order.Qty);
        //}
        var amount = 0;
        var amount = (qty) * (isFinite(order.MRP) ? order.MRP : 0)
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

    $(document).keydown(function (e) {
        var nodeName = e.target.nodeName.toLowerCase();

        if (e.which === 8) {
            if ((nodeName === 'input' && e.target.type === 'number' || e.target.type === 'text') ||
                nodeName === 'textarea') {
            } else {
                e.preventDefault();
            }
        }
    });
}

BillListController.$inject = ['$scope', '$filter', '$route', 'BillDataService', 'PharmacyIdEnc', 'uiGridConstants'];

function BillListController($scope, $filter, $route, BillDataService, PharmacyIdEnc, uiGridConstants) {
    $scope.purchases = [];
    $scope.purchaseHeader = {};

    $scope.pIdEnc = PharmacyIdEnc;

    var paginationOptions = {
        pageNumber: 1,
        pageSize: 10,
        sort: null
    };

    $scope.filterOptions = {
        filterText: "",
        useExternalFilter: true
    };

    $scope.gridOptions = {
        paginationPageSizes: [10, 25, 50, 75],
        paginationPageSize: 10,
        useExternalPagination: true,
        useExternalSorting: true,

        filterOptions: $scope.filterOptions,
        columnDefs: [
          {
              field: 'Id', displayName: '', enableSorting: false, useExternalSorting: false, enableColumnMenu: false,
              cellTemplate: '<div class="form-control"> <a href="#/edit/{{row.entity[col.field]}}" class="btn btn-labeled btn-purple btn-xs"> <span class="btn-label"><i class="fa fa-edit"></i></span></a> <a href="bill#/print/{{row.entity[col.field]}}" class="btn btn-labeled btn-pink btn-xs"> <span class="btn-label"><i class="fa fa-print"></i></span></a> <a ng-click="grid.appScope.delete(COL_FIELD)" class="btn btn-labeled btn-danger btn-xs hidden"><span class="btn-label"><i class="fa fa-times"></i></span><span class="hidden-xs">Delete</span> </a></div>'
          },
          {
              name: 'BillNo', field: 'BillNo', enableSorting: false, useExternalSorting: false
          },
          {
              name: 'BillDate', field: 'BillDate', cellFilter: 'jsonDate', enableFiltering: false, filter: {
                  noTerm: true
              }
          },
          {
              name: 'Customer', field: 'Customer', enableSorting: false
          },
          { name: 'NetAmount', field: 'NetAmount' },
          { name: 'PayMode', field: 'PayMode' }
        ],
        onRegisterApi: function (gridApi) {
            $scope.gridApi = gridApi;

            $scope.gridApi.core.on.sortChanged($scope, function (grid, sortColumns) {
                if (sortColumns.length == 0) {
                    paginationOptions.sort = null;
                } else {
                    paginationOptions.sort = sortColumns[0].field + '_' + sortColumns[0].sort.direction;
                }
                $scope.search();
            });


            gridApi.pagination.on.paginationChanged($scope, function (newPage, pageSize) {
                paginationOptions.pageNumber = newPage;
                paginationOptions.pageSize = pageSize;
                $scope.search();
            });
        }
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

    $scope.search = function () {

        var params = {
            BillNo: $scope.purchaseHeader.BillNo,
            BillDate: $scope.purchaseHeader.BillDate,
            Customer: $scope.purchaseHeader.Customer,
            IPId: $scope.purchaseHeader.IPId,
            PageNo: paginationOptions.pageNumber,
            PageSize: paginationOptions.pageSize,
            OrderBy: paginationOptions.sort,
            EditedTo: $scope.purchaseHeader.EditedTo,
            EditedFrom: $scope.purchaseHeader.EditedFrom
        };

        BillDataService.SearchPurchases(params)
           .then(function (purchaseList) {
               $scope.gridOptions.data = purchaseList.data;
               $scope.gridOptions.totalItems = purchaseList.total;
           },
             function () { alert('error while fetching purchases from server') }
        );
    }

    $scope.search();

    //$scope.purchases = [];

    //$scope.cdate = new Date();

    //BillDataService.getPurchaseList()
    //    .then(function (purchaseList) { $scope.purchases = purchaseList },
    //          function () { alert('error while fetching purchaseList from server') }
    //     );
    //$scope.delete = function (id) {
    //    $('#confirm-purchase-delete').modal({ backdrop: false, keyboard: false })
    //        .one('click', '#delete', function () {
    //            BillDataService.deletePurchase(id)
    //                        .then(function (data) {
    //                            if (data.status === true) {
    //                                $route.reload();
    //                            }
    //                        },
    //                          function () { alert('error while deleting purchase') }
    //                        );
    //        });//end of one
    //};
    // cellTemplate: '<div class="form-control"> <a href="#/print/{{row.entity[col.field]}}" class="btn btn-labeled btn-pink btn-xs"> <span class="btn-label"><i class="fa fa-print"></i></span></a> </div>'
}
