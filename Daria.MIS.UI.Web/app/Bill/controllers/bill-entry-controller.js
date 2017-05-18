BillEntryController.$inject = ['$scope', '$filter', '$route', '$routeParams', 'BillDataService', 'ConsultantList', 'CustomerList', 'PatientList', 'ManufacturerList', 'IndentList', 'PharmacyIdEnc', '$location', '$q', 'hotkeys'];

function BillEntryController($scope, $filter, $route, $routeParams, BillDataService, consultantList, customerList, patientList, mfgList, indentList, PharmacyIdEnc, $location, $q, hotkeys) {
    $scope.purchaseHeader = {};
    $scope.consultants = consultantList;
    $scope.customers = customerList;
    $scope.editMode = false;
    $scope.patients = patientList;
    $scope.manufacturers = mfgList;
    $scope.indents = indentList;
    $scope.taxes = [{ value: 5.5, text: '5.5' }, { value: 14.5, text: '14.5' }];
    $scope.purchaseOrders = [];
    $scope.pIdEnc = PharmacyIdEnc;
    $scope.purchaseId = 0;
    $scope.selectedVal = 0;
    $scope.purchaseHeader.Discount = 0;
    $scope.purchaseHeader.TotalAmount = 0;
    $scope.purchaseHeader.NetAmount = 0;
    $scope.purchaseHeader.PaidAmount = 0;
    $scope.purchaseHeader.Balance = 0;
    $scope.purchaseHeader.VatAmount = 0;
    $scope.purchaseHeader.GrnDate = new Date();
    $scope.purchaseHeader.SupplierInvDate = new Date();
    $scope.billcount = 0;
    //$scope.totalBillAmountEntered = true;
    
    if ($routeParams.id && $routeParams.id > 0) {
        $scope.editMode = true;
    }
    $scope.productMaster = [];
    $scope.manfMaster = [];
    $scope.consultantMaster = [];
    $scope.customerMaster = [];
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
                                    $scope.purchaseOrders = purchase.BillItems;
                                },
                                      function () { alert('error while loading bill info') }
                               ).finally(function () {
                                   $scope.dataLoading = false;
                               })
    }
    else {
        $scope.dataLoading = false;
    }

    $scope.purchaseHeader.DType = 'W';
    $scope.purchaseHeader.SalesMode = 'Cash';
    $scope.purchaseHeader.CustomerName = '';
    
    $scope.hideIPPatientDetails = function () {
        $scope.purchaseHeader.IPNo = false;
        $scope.purchaseHeader.IPNo = '';
        $scope.purchaseHeader.PatientName = '';//false;
        $scope.purchaseHeader.Age = ''; //false;
        $scope.purchaseHeader.PayMode = 'Credit';//false;
        $scope.purchaseHeader.SalesMode = 'Credit';
        $scope.purchaseHeader.Ward = '';//false;
        $scope.purchaseHeader.PatientId = false;
        $scope.purchaseHeader.DType = 'C';
        $('#credit').prop("checked", true);
        $('#cash').prop("checked", false);
        $('#card').prop("checked", false);
        $('#cheque').prop("checked", false);
        $scope.purchaseHeader.PaidAmount = '';
        $scope.purchaseHeader.Balance = 0;
    }

    $scope.hidePatientDetails = function () {
        $scope.purchaseHeader.IPNo = false;
        $scope.purchaseHeader.IPNo = '';
        $scope.purchaseHeader.PatientName = '';//false;
        $scope.purchaseHeader.Age = '';//false;
        //$scope.purchaseHeader.PayMode = false;
        $scope.purchaseHeader.PayMode = 'Cash';
        $scope.purchaseHeader.Ward = '';//false;
        $scope.purchaseHeader.PatientId = false;
        $scope.purchaseHeader.DType = 'W';
        $('#credit').prop("checked", false);
        $('#cash').prop("checked", true);
        $('#card').prop("checked", false);
        $('#cheque').prop("checked", false);
        $scope.purchaseHeader.PaidAmount = $scope.purchaseHeader.NetAmount;
        $scope.purchaseHeader.Balance = 0;
    }

    $scope.ShowPatientDetails = function () {
        $scope.purchaseHeader.IPNo = true;
        $scope.purchaseHeader.PatientName = ''//true;
        $scope.purchaseHeader.Age = '';//true;
        $scope.purchaseHeader.PayMode = '';//true;
        $scope.purchaseHeader.SalesMode = 'Credit';
        $scope.purchaseHeader.Ward = '';//true;
        $scope.purchaseHeader.PatientId = true;
        $scope.purchaseHeader.DType = 'P';
        $('#cash').prop("checked", false);
        $('#credit').prop("checked", true);
        $('#card').prop("checked", false);
        $('#cheque').prop("checked", false);
        $scope.purchaseHeader.PaidAmount = '';
        $scope.purchaseHeader.Balance = $scope.purchaseHeader.NetAmount;
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

    $scope.$watch('purchaseHeader.PatientId', function (newValue, oldValue, scope) {
        if (newValue != oldValue) {
            var selectedIP = $filter('filter')($scope.patients, { Id: parseInt(newValue, 10) }, true)[0];
            //$scope.purchaseHeader.IPNo = selectedIP.Name;
            $scope.purchaseHeader.IPNo = selectedIP.IPNo;
            $scope.purchaseHeader.PatientName = selectedIP.PatientName;
            $scope.purchaseHeader.Age = selectedIP.Age;
            $scope.purchaseHeader.PayMode = selectedIP.PayMode;
            $scope.purchaseHeader.Ward = selectedIP.Ward;
            $scope.purchaseHeader.Customer = selectedIP.PatientName;
            $scope.purchaseHeader.ConsultantName = selectedIP.Consultant;
            $scope.purchaseHeader.DType = 'P';
            $scope.purchaseHeader.SalesMode = 'Credit';
            if (newValue === 'Credit') {
                $scope.purchaseHeader.PaidAmount = '';
                $scope.purchaseHeader.Balance = $scope.purchaseHeader.NetAmount;
            }
            else {
                $scope.purchaseHeader.PaidAmount = $scope.purchaseHeader.NetAmount;
                $scope.purchaseHeader.Balance = 0;
            }
        }
    });

    $scope.$watch('purchaseHeader.ConsultantName', function (newValue, oldValue, scope) {
        if (newValue != oldValue) {
            var selected = $filter('filter')($scope.consultants, { Id: parseInt(newValue, 10) }, true)[0];
            //$scope.purchaseHeader.ConsultantName = selected.Name;
            //$scope.totalBillAmountEntered = true;
        }
    });

    $scope.$watch('purchaseHeader.Customer', function (newValue, oldValue, scope) {
        if (newValue != oldValue) {
            $scope.purchaseHeader.CustomerName = newValue;
            //$scope.totalBillAmountEntered = true;
        }
    });

    $scope.getbalance = function () {
        var paidamount = $scope.purchaseHeader.PaidAmount;
        var totalamount = $scope.purchaseHeader.TotalAmount;
        var discount = $scope.purchaseHeader.Discount;
        var balance = totalamount - (paidamount + discount);
        $scope.purchaseHeader.Balance = round(balance,2);
    }

    $scope.calculatediscount = function () {
        var discper = $scope.purchaseHeader.DiscountPercent;
        var netamount = $scope.purchaseHeader.NetAmount;
        var totalamount = $scope.purchaseHeader.TotalAmount;

        var discount = round(totalamount * (discper / 100), 2);
        if (discount < totalamount) {
            $scope.purchaseHeader.Discount = discount;
            $scope.updateCalcAmount();
            $scope.purchaseHeader.DiscountPercent = discper;
        }
        else {
            $scope.purchaseHeader.Discount = 0;
            $scope.purchaseHeader.DiscountPercent = 0;
        }
    }

    $scope.calculatediscountpercent = function () {
        var discount = $scope.purchaseHeader.Discount;
        var totalamount = $scope.purchaseHeader.TotalAmount;
        var netamount = $scope.purchaseHeader.NetAmount;
        if (discount < totalamount) {
            $scope.purchaseHeader.DiscountPercent = round((discount * 100) / totalamount, 2);
            $scope.updateCalcAmount();
        }
        else {
            $scope.purchaseHeader.Discount = 0;
            $scope.purchaseHeader.DiscountPercent = 0;
        }
    }

    //var app = angular.module("billApp", []);

    //app.directive('enterAsTab', function () {
    //    alert('123');
    //    return function (scope, element, attrs) {
    //        element.bind("keydown keypress", function (event) {
    //            if (event.which === 13) {
    //                alert('123');
    //                event.preventDefault();
    //                var elementToFocus = element.next('tr').find('span')[7];
    //                if (angular.isDefined(elementToFocus))
    //                    elementToFocus.focus();
    //            }
    //        });
    //    };
    //});

    $scope.savePurchase = function () {
        if ($scope.billcount == 0) {
            var valid = $scope.validateOrders();
            var customer = $scope.purchaseHeader.CustomerName;
            if (customer == '') {
                alert('enter customer name');
            }
            else {
                if ($scope.authorized) {
                    $scope.purchaseHeader.PharmacyIdEnc = $scope.pIdEnc;
                    $scope.purchaseHeader.BillItems = $scope.purchaseOrders;
                    //console.log(JSON.stringify($scope.purchaseHeader));
                    BillDataService.savePurchase($scope.purchaseHeader)
                    .then(function (data) {
                        if (data.status === true) {
                            $scope.authorized = false;
                            if (data.mode == "add") {
                                $scope.purchaseHeader.Id = data.id;
                                alert('Data Saved Successfully');
                            }
                            $location.path('print/' + data.id);
                        }
                    },
                         function () { alert('error while saving Bill'); $scope.authorized = false; }
                    );
                }
                else {
                    $scope.showLoginForm();
                }
                $scope.billcount = $scope.billcount + 1;
            }
        }
    }

    //$scope.showLoginForm = function () {
    //    $('#show-purchase-login').modal({ backdrop: false, keyboard: false })
    //        .one('click', '#authorize', function () {
    //            $scope.validatingCredentials = true;
    //            BillDataService.authorizeUser($scope.purchaseHeader.SavedUser)
    //                        .then(function (data) {
    //                            $scope.validatingCredentials = false;
    //                            if (data.LoginStatus === 5) {
    //                                $scope.purchaseHeader.SavedUser.UserId = data.UserId;
    //                                $scope.authorized = true;

    //                                $('#show-purchase-login').modal('hide');
    //                                $scope.savePurchase();
    //                            }
    //                            if (data.LoginStatus === 2) {
    //                                alert('invalid password');
    //                            }
    //                        },
    //                          function () { alert('error while deleting purchase') }
    //                        );
    //        });//end of one
    //};

    $scope.showLoginForm = function () {
        $('#show-purchase-login').modal({ backdrop: false, keyboard: false })
            .one('click', '#oksave', function () {
                $scope.saveauthorized = true;
                $scope.purchaseHeader.SavedUser.UserId = 7;
                $scope.authorized = true;
                $('#show-purchase-login').modal('hide');
                $scope.savePurchase();
            });

        $('#show-purchase-login').modal({ backdrop: false, keyboard: false })
           .one('click', '#nosave', function () {
               $scope.saveauthorized = false;
               $scope.authorized = false;
               $('#show-purchase-login').modal('hide');
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

            $scope.purchaseOrders[idx].ManufacturerId = data.ManfId;
            $scope.purchaseOrders[idx].batchNo = data.BatchNo;
            $scope.purchaseOrders[idx].Qty = data.Qty;
            $scope.purchaseOrders[idx].Stock = data.Stock;
            $scope.purchaseOrders[idx].CostPrice = data.CostPrice;
            $scope.purchaseOrders[idx].MRP = data.MRP;
            $scope.purchaseOrders[idx].VAT = data.VAT;

            $scope.purchaseOrders[idx].VATAmount = data.VATAmount;
            $scope.purchaseOrders[idx].DiscPercent = data.DiscPercent;
            $scope.purchaseOrders[idx].Discount = data.Discount;
            $scope.purchaseOrders[idx].TotalCostPrice = data.TotalCostPrice;
            $scope.purchaseOrders[idx].TotalMRP = data.TotalMRP;
            $scope.purchaseOrders[idx].savedLocal = true;
            $scope.updateCalcAmount();
        }
        $scope.purchaseHeader.Discount = 0;
        $scope.purchaseHeader.DiscountPercent = 0;
    }

    $scope.checkNewProductRow = function (data, Id, rowform, index) {
        //$scope.savePurchaseItem(rowform.$data, Id, rowform, index);
        //$scope.addNewProduct();
        
        $scope.savePurchaseItem(rowform.$data, Id, rowform, index);
        if ($scope.purchaseOrders.length - 1 == index)
            $scope.addNewProduct();
        else {
            document.getElementById('ProductName' + (index + 1)).focus();
        }
    }

    //$scope.calculateexistingRow = function (data, Id, rowform, index) {
    //    $scope.savePurchaseItem(rowform.$data, Id, rowform, index);
    //}

    $scope.checkMinimumFields = function (rowform) {
        if (rowform.$data.ProductId && rowform.$data.BatchNo && angular.isNumber(rowform.$data.MRP) && rowform.$data.MRP > 0) {
            return true;
        }
        return false;
    }

    $scope.checkProductName = function (data, rowform) {
        if (data === "" || typeof (data) === 'undefined' || data == null) {
            return "Please enter product name";
        }
    }

    //$scope.checkQty = function (data, rowform) {
    //    if (data === "" || typeof (data) === 'undefined' || data == null) {
    //        return "Please enter qty";
    //    }
    //}

    $scope.updateCalcAmount = function (data) {
        var amt = 0;
        var vat = 0;
        var discount = $scope.purchaseHeader.Discount;
        for (var i = 0; i < $scope.purchaseOrders.length; i++) {
            if (isFinite($scope.purchaseOrders[i].TotalMRP)) {
                amt = amt + parseFloat($scope.purchaseOrders[i].TotalMRP);
            }
        }
        for (var i = 0; i < $scope.purchaseOrders.length; i++) {
            if (isFinite($scope.purchaseOrders[i].VATAmount)) {
                vat = vat + parseFloat($scope.purchaseOrders[i].VATAmount);
            }
        }
        //$scope.purchaseHeader.DType = 'C';
        //if ($scope.purchaseHeader.SalesMode === 'Credit') {
        if ($scope.purchaseHeader.DType === 'P') {
            $scope.purchaseHeader.NetAmount = round(amt - discount,2);
            $scope.purchaseHeader.PaidAmount = '';
            $scope.purchaseHeader.Balance = round(amt - discount,2);
            $scope.purchaseHeader.TotalAmount = round(amt, 2);
            $scope.purchaseHeader.VatAmount = round(vat, 2);
        }
        else {
            $scope.purchaseHeader.NetAmount = round(amt - discount,2);
            $scope.purchaseHeader.PaidAmount = round(amt - discount,2);
            $scope.purchaseHeader.Balance = 0;
            $scope.purchaseHeader.TotalAmount = round(amt, 2);
            $scope.purchaseHeader.VatAmount = round(vat, 2);
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

    $scope.setDiscPercentToAll = function (data, tableform) {
        for (var i = 0; i < tableform.$editables.length; i++) {
            if (tableform.$editables[i].name === 'user.status') {
                tableform.$editables[i].scope.$data = data;

            }
        }
    };
    $scope.$watch('purchaseHeader.DiscountPercent', function (newValue, oldValue, scope) {
         // $scope.totalBillAmountEntered = true;
    });
    $scope.$watch('purchaseHeader.Discount', function (newValue, oldValue, scope) {
         //$scope.totalBillAmountEntered = true;
    });

    $scope.addNewProduct = function () {
        $scope.inserted = {
            isNew: true, Id: getUniqueId(),savedLocal:false,
            BatchNo: '', Qty: 1, ProductName: '', ProductId: 0, ManufacturerId: 0, ManufacturerName: '',
            ExpiryDate: '', VAT: 5.5, DiscountPercentage: $scope.purchaseHeader.DiscountPercent, MRP: 0,
            DiscApplicable: '0', VATOnDiscount: '0',
            DiscountAmount: 0
        };
        $scope.purchaseOrders.push($scope.inserted);
    };
    $scope.addNewProduct();

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
    $scope.showSelectedRack = function (order) {
        var selected = [];
        selected = $filter('filter')($scope.racks, { Id: order.RackId });
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

        var MRPEditable = $filter('filter')($rowform.$editables, { name: 'MRP' }, true)[0];
        MRPEditable.scope.$data = $item.mrp;

        var CostEditable = $filter('filter')($rowform.$editables, { name: 'CostPrice' }, true)[0];
        CostEditable.scope.$data = $item.costPrice;

        var ManufEditable = $filter('filter')($rowform.$editables, { name: 'ManfId' }, true)[0];
        ManufEditable.scope.$data = $item.manfId;

        var StockElement = $filter('filter')($rowform.$editables, { name: 'Stock' }, true)[0];
        StockElement.scope.$data = $item.stock;

        var VATEditable = $filter('filter')($rowform.$editables, { name: 'VAT' }, true)[0];
        VATEditable.scope.$data = $item.vat;

        var QtyEditable = $filter('filter')($rowform.$editables, { name: 'Qty' }, true)[0].inputEl[0].focus();
        QtyEditable.scope.$data = $item.Qty;

        //var ExpiryElement = $filter('filter')($rowform.$editables, { name: 'ExpiryDate' }, true)[0];
        //ExpiryElement.scope.$data = $item.expDate;

        //var unitEditable = $filter('filter')($rowform.$editables, { name: 'UnitId' }, true)[0];
        //unitEditable.scope.$data = $item.unitId;
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
        var totalVat = isFinite(order.TotalVatAmount) ? order.TotalVatAmount : 0;
        var amount = totalVat * (parseFloat(order.DiscountPercentage) / 100);
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
        //(Total Cost - (TotalCost/(Vat%(common)/100)+1)) 
        var vat = isFinite(order.VAT) ? order.VAT : 0;
        var amount = 0;
        //if (order.TaxMode === 'COST' && order.TaxType === 'INCL') {
        //    amount = order.TotalCostPrice - (order.TotalCostPrice / ((vat / 100) + 1));
        //}
        //else if (order.TaxMode === 'COST' && order.TaxType === 'EXCL') {
        amount = order.TotalMRP * (vat / 100);
        //}
        //else if (order.TaxMode === 'MRP' && order.TaxType === 'INCL') {
        //    amount = order.TotalMRP - (order.TotalMRP / ((vat / 100) + 1));
        //}
        //else if (order.TaxMode === 'MRP' && order.TaxType === 'EXCL') {
        //    amount = order.TotalMRP * (vat / 100);
        //}
        order.VATAmount = isFinite(amount) ? round(amount, 2) : 0;
        return order.VATAmount;
    }

    $scope.calculateTotalCostPrice = function (order) {
        var qty = parseInt(order.Qty);
        //var stock = parseInt(order.Stock) + 1;
        //if (qty < stock) {
        //    qty = parseInt(order.Qty);
        //} else {
        //    qty = parseInt(order.Stock);
        //    order.Qty = parseInt(order.Stock);
        //    return order.Qty
        //}
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
        var stock = parseInt(order.Stock);

        if (qty > stock) {
            qty = parseInt(order.Stock);
            alert("Please check the Available Stock");
            order.Qty = qty;
            return order.Qty
        } else {
            qty = parseInt(order.Qty);
        }
        var amount = (qty) * (isFinite(order.MRP) ? order.MRP : 0)
        order.TotalMRP = isFinite(amount) ? round(amount, 2) : 0;
        return order.TotalMRP;
    }

    $scope.consList = function (q) {
       
            var def = BillDataService.getConsultantList(q);
            $scope.consultantMaster = def.resolve;
            var deferred = $q.defer();
            def.promise.then(function (data) {
                if (data.findIndex(function (o) { return o.label === q; }) == -1)
                    data.splice(0, 0, { 'label': 'Add "' + q + '"', 'isNew': true, 'q': q });
                deferred.resolve(data);
            }, deferred.reject);
            return deferred.promise;
       
    };
    
    $scope.onConsultantSelect = function ($item, $model, $label) {
        if (!$item.isNew) {
            // -- 
        }
        else {
            $scope.addNewConsultant($item.q)
        }
    };

    $scope.addNewConsultant = function (q) {
        $scope.newConsultant = { Name: '', Desc: '', isActive: true };

        $scope.newConsultant.Name = q ? q : "";
        
        $('#show-add-consultant').modal({ backdrop: false, keyboard: false })
           .one('click', '#addNewConsultant', function () {
               $scope.newConsultant_addingConsultant = true;
               BillDataService.addConsultant($scope.newConsultant)
               .then(function (data) {
                   $scope.newConsultant_addingConsultant = false;
                   $('#show-add-consultant').modal('hide');
                   window.location.reload();
               },
                   function () { alert('error while adding consultant') }
               );
           });//end of one
    }

    $scope.customerList = function (q) {
        if ($scope.purchaseHeader.DType === 'C') {
            var def = BillDataService.getCustomerList(q);
            $scope.customerMaster = def.resolve;
            var deferred = $q.defer();
            def.promise.then(function (data) {
                if (data.findIndex(function (o) { return o.label === q; }) == -1)
                    data.splice(0, 0, { 'label': 'Add "' + q + '"', 'isNew': true, 'q': q });
                deferred.resolve(data);
            }, deferred.reject);
            return deferred.promise;
        }
    };

    $scope.onCustomerSelect = function ($item, $model, $label) {
        if (!$item.isNew) {
            $scope.purchaseHeader.CustomerId = $item.id;
        }
        else {
            $scope.addNewCustomer($item.q)
        }
    };

    $scope.addNewCustomer = function (q) {
        $scope.newCustomer = {};
        $scope.newCustomer.Name = q ? q : "";

        $('#show-add-customer').modal({ backdrop: false, keyboard: false })
           .one('click', '#addNewCustomer', function () {
               $scope.newCustomer_addingCustomer = true;
               BillDataService.addCustomer($scope.newCustomer)
               .then(function (data) {
                   $scope.newCustomer_addingCustomer = false;
                   $('#show-add-customer').modal('hide');
                   window.location.reload();
               },
                   function () { alert('error while adding customer') }
               );
           });//end of one
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
        description: 'Save Sales',
        callback: function (e) {
            e.preventDefault();
            $scope.savePurchase();
        }
    })
    .add({
        combo: 'f4',
        description: 'Clear Sales',
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

BillListController.$inject = ['$scope', '$filter', '$route', 'BillDataService', 'PharmacyIdEnc', 'uiGridConstants', 'hotkeys', '$location'];

function BillListController($scope, $filter, $route, BillDataService, PharmacyIdEnc, uiGridConstants, hotkeys, $location) {
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
              cellTemplate: '<div class="form-control"> <a href="#/edit/{{row.entity[col.field]}}" class="btn btn-labeled btn-purple btn-xs"> <span class="btn-label"><i class="fa fa-edit"></i></span></a> <a href="#/print/{{row.entity[col.field]}}" class="btn btn-labeled btn-pink btn-xs"> <span class="btn-label"><i class="fa fa-print"></i></span></a> <a ng-click="grid.appScope.delete(COL_FIELD)" class="btn btn-labeled btn-danger btn-xs hidden"><span class="btn-label"><i class="fa fa-times"></i></span><span class="hidden-xs">Delete</span> </a></div>'
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
          { name: 'PaidAmount', field: 'PaidAmount' },
          { name: 'Balance', field: 'Balance' },
          { name: 'SalesMode', field: 'SalesMode' },
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
            description: 'Help',
            callback: function (e) {
                e.preventDefault();
                $location.path('/add');
            }
        });
}

BillPrintController.$inject = ['$scope', '$filter', '$timeout', '$route', '$routeParams', 'BillDataService', '$location']

function BillPrintController($scope, $filter, $timeout, $route, $routeParams, BillDataService, $location)
{
    $scope.dataLoading = true;

    $scope.purchaseHeader = {};
    $scope.purchaseOrders = [];
    $scope.convertedPdf = false;

    $scope.convertToPdf = function () {
        var doc = new jsPDF('p', 'pt', 'letter');

        doc.addHTML($("#printContent"), function () {
            var obj = doc.output('datauristring');
            document.getElementById('pdfWraper').innerHTML = '<embed style="width:100%;height:500px;" name="plugin" id="plugin" src="' + obj + '" type="application/pdf" internalinstanceid="164" title="Bill Receipt">';
        });
        $scope.convertedPdf = true;
    };

    $scope.closeForm = function () {
        $location.path("");
    };

    $scope.printForm = function () {
        window.print();
    }

    $("body").addClass("aside-collapsed");
    if ($routeParams.id && $routeParams.id > 0) {

        BillDataService.getPurchaseInfo($routeParams.id)
                                .then(function (purchase) {
                                    $scope.purchaseHeader = purchase;
                                    $scope.purchaseOrders = purchase.BillItems;

                                    $timeout($scope.printForm, 0);
                                },
                                      function () { alert('error while loading bill info') }
                               ).finally(function () {
                                   $scope.dataLoading = false;
                               })
    }
    else {
        $scope.dataLoading = false;
    }

}


//function BillListController($scope, $filter, $route, BillDataService, hotkeys, $location) {
//    $scope.purchases = [];

//    $scope.cdate = new Date();

//    BillDataService.getPurchaseList()
//        .then(function (purchaseList) { $scope.purchases = purchaseList },
//              function () { alert('error while fetching purchaseList from server') }
//         );

//    $scope.delete = function (id) {
//        $('#confirm-purchase-delete').modal({ backdrop: false, keyboard: false })
//            .one('click', '#delete', function () {
//                BillDataService.deletePurchase(id)
//                            .then(function (data) {
//                                if (data.status === true) {
//                                    $route.reload();
//                                }
//                            },
//                              function () { alert('error while deleting purchase') }
//                            );
//            });//end of one
//    };

//    $scope.print = function (id) {
//        $('#confirm-purchase-print').modal({ backdrop: false, keyboard: false })
//            .one('click', '#print', function () {
//                BillDataService.printBillReceipt(id)
//                            .then(function (data) {
//                                if (data.status === true) {
//                                    $route.reload();
//                                }
//                            },
//                              function () { alert('error while Print Receipt') }
//                            );
//            });//end of one
//    };

//    hotkeys.bindTo($scope)
//    .add({
//        combo: 'f1',
//        description: 'Help',
//        callback: function (e) {
//            e.preventDefault();
//            $('#help-window').modal({ backdrop: false, keyboard: false });
//        }
//    })
//    .add({
//        combo: 'f2',
//        description: 'Help',
//        callback: function (e) {
//            e.preventDefault();
//            $location.path('/add');
//        }
//    });
//}