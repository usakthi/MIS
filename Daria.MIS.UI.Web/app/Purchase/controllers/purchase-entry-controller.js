
PurchaseEntryController.$inject = ['$scope', '$filter', '$route', '$routeParams', 'PurchaseDataService', 'SupplierList', 'RackList', 'ManufacturerList', 'UnitList', 'PharmacyIdEnc', '$location', '$q', 'hotkeys'];

function PurchaseEntryController($scope, $filter, $route, $routeParams, PurchaseDataService, suppList, rackList, mfgList, unitList, PharmacyIdEnc, $location, $q, hotkeys) {
    $scope.suppliers = suppList;
    $scope.editMode = false;
    $scope.racks = rackList;
    $scope.manufacturers = mfgList;
    $scope.units = unitList;
    $scope.taxes = [{ value: 5.5, text: '5.5' }, { value: 14.5, text: '14.5' }, { value: 5, text: '5' }, { value: 0, text: '0' }];
    $scope.pIdEnc = PharmacyIdEnc;
    $scope.purchaseId = 0;
    $scope.selectedVal = 0;
    $scope.autoSave = false;
    $scope.viewMode = false;
    $scope.initPurchase = function () {
        $scope.purchaseHeader = {};
        $scope.purchaseHeader.CreditPeriod = 0;
        $scope.purchaseHeader.NetAmount = 0;
        $scope.purchaseHeader.GrnDate = new Date();
        $scope.purchaseHeader.SupplierInvDate = new Date();
        $scope.purchaseOrders = [];
        $scope.totalBillAmountEntered = false;
    }
    $scope.initPurchase();

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
    $scope.supplierMaster = [];
    $scope.invoicenoMaster = [];
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
                                    $scope.purchaseOrders = purchase.PurchaseItems;
                                    var saveStatus = purchase.SaveStatus.trim();
                                    if (saveStatus == "Draft" || saveStatus == "Holding")
                                        $scope.autoSave = true;
                                    else if (saveStatus == "Completed")
                                        $scope.viewMode = true;
                                },
                                      function () { alert('error while loading purchase info') }
                               ).finally(function () {
                                   $scope.dataLoading = false;
                               })
    }
    else {
        //$scope.purchaseHeader.PharmacyIdEnc = $scope.pIdEnc;
        //$scope.purchaseHeader.PurchaseItems = [];
        //$scope.purchaseHeader.SaveStatus = "Draft";

        //PurchaseDataService.savePurchase($scope.purchaseHeader)
        //.then(function (data) {
        //    if (data.status === true) {
        //        if (data.mode == "add") {
        //            $scope.purchaseHeader.Id = data.id;
        //        }
        //        $location.path('edit/' + data.id);
        //    }
        //},
        //    function () { $scope.autoSave = false; }
        //);
        $scope.dataLoading = false;
    }
    debugger;
    //var currentRow = 0;
    //var currentCell = 0;

    //function ChangeCurrentCell() {
    //    var tableRow = document.getElementsByTagName("tr")[currentRow];
    //    var tableCell = tableRow.childNodes[currentCell];
    //    tableCell.focus();
    //    tableCell.style.color = "Green";
    //}
    //ChangeCurrentCell();

    //debugger;
    //$(document).keydown(function (e) {
    //    if (e.keyCode == 37) {
    //        currentCell--;
    //        ChangeCurrentCell();
    //        return false;
    //    }
    //    if (e.keyCode == 38) {
    //        currentRow--;
    //        ChangeCurrentCell();
    //        return false;
    //    }
    //    if (e.keyCode == 39) {
    //        currentCell++;
    //        ChangeCurrentCell();
    //        return false;
    //    }
    //    if (e.keyCode == 40) {
    //        currentRow++;
    //        ChangeCurrentCell();
    //        return false;
    //    }
    //});

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

    //$scope.$watchCollection('purchaseHeader', function (newValue, oldValue, scope) {
    //    if (newValue != oldValue && $scope.autoSave) {
    //        $scope.purchaseHeader.PharmacyIdEnc = $scope.pIdEnc;
    //        $scope.purchaseHeader.SaveStatus = "Draft";

    //        PurchaseDataService.savePurchase($scope.purchaseHeader)
    //        .then(function (data) {
    //            console.log("---------Purchase Header---------");
    //            console.log(data);
    //            console.log("---------------------------------");
    //        },
    //             function () { }
    //        );
    //    }
    //});

    //$scope.$watchCollection('purchaseOrders', function (newValue, oldValue, scope) {
    //    if (newValue != oldValue && $scope.autoSave) {
    //        $scope.purchaseHeader.PharmacyIdEnc = $scope.pIdEnc;
    //        $scope.purchaseHeader.PurchaseItems = $scope.purchaseOrders;
    //        $scope.purchaseHeader.SaveStatus = "Draft";

    //        PurchaseDataService.savePurchase($scope.purchaseHeader)
    //        .then(function (data) {
    //            console.log("---------Purchase Orders---------");
    //            console.log(data);
    //            console.log("---------------------------------");
    //        },
    //             function () { }
    //        );
    //    }
    //});

    $scope.holdPurchase = function () {
        $scope.purchaseHeader.PharmacyIdEnc = $scope.pIdEnc;
        $scope.purchaseHeader.PurchaseItems = $scope.purchaseOrders;
        $scope.purchaseHeader.SaveStatus = "Holding";

        PurchaseDataService.savePurchase($scope.purchaseHeader)
        .then(function (data) {
            if (data.status === true) {
                $location.path('');
            }
        },
             function () { alert('error while saving purchase'); }
        );
    }

    $scope.savePurchase = function () {
        if (parseFloat($scope.purchaseHeader.DiffAmount) > 2 || parseFloat($scope.purchaseHeader.DiffAmount) < -2) {
            alert("Please check bill Amount is not Matched...");
        }
        else {
            var valid = $scope.validateOrders();
            if ($scope.authorized) {
                $scope.purchaseHeader.PharmacyIdEnc = $scope.pIdEnc;
                $scope.purchaseHeader.PurchaseItems = $scope.purchaseOrders;
                $scope.purchaseHeader.SaveStatus = "Completed";

                PurchaseDataService.savePurchase($scope.purchaseHeader)
                .then(function (data) {
                    if (data.status === true) {
                        if (data.mode == "add") {
                            $scope.purchaseHeader.Id = data.id;
                            alert('Data Saved Successfully');
                        }
                        $scope.authorized = false;
                        $location.path('print/' + data.id);
                    }
                },
                     function () { alert('error while saving purchase'); $scope.authorized = false; }
                );
            }
            else {
                $scope.showLoginForm();
            }
        }
    }

    //$scope.showLoginForm = function () {
    //    $('#show-purchase-login').modal({ backdrop: false, keyboard: false })
    //        .one('click', '#authorize', function () {
    //            $scope.validatingCredentials = true;
    //            PurchaseDataService.authorizeUser($scope.purchaseHeader.SavedUser)
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
                //$scope.purchaseHeader.SavedUser.UserId = data.UserId;
                $scope.authorized = true;
                $('#show-purchase-login').modal('hide');
                $scope.savePurchase();
            });
    };

    $scope.savePurchaseItem = function (data, id, rowform, idx) {
        var selected = [];
        var idx = -1;

        selected = $filter('filter')($scope.purchaseOrders, { Id: id }, true)[0];
        idx = $scope.purchaseOrders.indexOf(selected);
        if (data.CostPrice > data.MRP) {
            $scope.removeProduct(order);
        }
        else {
            $scope.purchaseOrders[idx].ProductId = data.ProductId;
            $scope.purchaseOrders[idx].ManufacturerId = data.ManufacturerId;
            $scope.purchaseOrders[idx].ManufacturerName = data.ManufacturerName;
            $scope.purchaseOrders[idx].AssortedCostPrice = data.AssortedCostPrice;
            $scope.purchaseOrders[idx].AssortedMRPPrice = data.AssortedMRPPrice;
            $scope.purchaseOrders[idx].AssortedQty = data.AssortedQty;

            $scope.purchaseOrders[idx].DiscountAmount = data.DiscountAmount;
            $scope.purchaseOrders[idx].FreeQtyVATAmount = data.FreeQtyVATAmount;
            $scope.purchaseOrders[idx].sAbatedMRP = data.sAbatedMRP;
            $scope.purchaseOrders[idx].AbatedMRP = data.AbatedMRP;
            $scope.purchaseOrders[idx].VAT = data.VAT;
            
            $scope.purchaseOrders[idx].VATAmount = data.VATAmount;
            $scope.purchaseOrders[idx].TotalCostPrice = data.TotalCostPrice;
            $scope.purchaseOrders[idx].NetCostPrice = data.NetCostPrice;
            $scope.purchaseOrders[idx].TotalMRP = data.TotalMRP;
            $scope.purchaseOrders[idx].NetMRP = data.NetMRP;
            $scope.purchaseOrders[idx].VatOnDiscountAmount = data.VatOnDiscountAmount;
            $scope.purchaseOrders[idx].DiscOnFreeQtyAmount = data.DiscOnFreeQtyAmount;
            $scope.purchaseOrders[idx].TotalDiscountAmount = data.TotalDiscountAmount;
            $scope.purchaseOrders[idx].NetVATAmount = data.NetVATAmount;
            $scope.purchaseOrders[idx].TotalVatAmount = data.TotalVatAmount;
            if (data.Id > 1) {
                $scope.purchaseOrders[idx].PurDetId = data.Id;
            } else {
                $scope.purchaseOrders[idx].PurDetId = 0;
            }
            $scope.purchaseOrders[idx].BatchNo = data.BatchNo;
            $scope.purchaseOrders[idx].ExpiryDate = data.ExpiryDate;
            $scope.purchaseOrders[idx].Packing = data.Packing;
            $scope.purchaseOrders[idx].Qty = data.Qty;
            $scope.purchaseOrders[idx].FreeQty = data.FreeQty;
            $scope.purchaseOrders[idx].CostPrice = data.CostPrice;
            $scope.purchaseOrders[idx].MRP = data.MRP;
            $scope.purchaseOrders[idx].DiscountPercentage = data.DiscountPercentage;

            $scope.purchaseOrders[idx].DiscApplicable = data.DiscApplicable;
            $scope.purchaseOrders[idx].TaxMode = data.TaxMode;
            $scope.purchaseOrders[idx].TaxType = data.TaxType;
            $scope.purchaseOrders[idx].VATOnFreeQty = data.VATOnFreeQty;
            $scope.purchaseOrders[idx].DiscOnFreeQty = data.DiscOnFreeQty;
            $scope.purchaseOrders[idx].VATOnDiscount = data.VATOnDiscount;
            
            $scope.purchaseOrders[idx].savedLocal = true;
            $scope.updateCalcAmount();
        }
    }

    $scope.checkNewProductRow = function (data, Id, rowform, index) {
        //if (rowform.$data.isNew && $scope.checkMinimumFields(rowform)) {
        $scope.savePurchaseItem(rowform.$data, Id, rowform, index);
        if($scope.purchaseOrders.length - 1 == index)
            $scope.addNewProduct();
        else {
            document.getElementById('ProductName' + (index + 1)).focus();
        }
       //     if ($scope.inserted.Id === rowform.$data.Id) {
       //     }
       // }
    }

    $scope.calculateexistingRow = function (data, Id, rowform, index) {
        $scope.savePurchaseItem(rowform.$data, Id, rowform, index);
    }

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

    $scope.updateCalcAmount = function (data) {
        var amt = 0;
        var totdis = 0;
        var totvat = 0;
        for (var i = 0; i < $scope.purchaseOrders.length; i++) {
            //CHANGE IN LOGIC
            if (isFinite($scope.purchaseOrders[i].NetCostPrice)) {
                amt = amt + parseFloat($scope.purchaseOrders[i].NetCostPrice) + parseFloat($scope.purchaseOrders[i].NetVATAmount);
                totvat = totvat + parseFloat($scope.purchaseOrders[i].NetVATAmount);
                totdis = totdis + parseFloat($scope.purchaseOrders[i].TotalDiscountAmount);
            }
        }

        $scope.purchaseHeader.NetAmount = round(amt,2);
        var diffAmt = parseFloat($scope.purchaseHeader.TotalAmount) - amt;
        $scope.purchaseHeader.DiffAmount = (isNaN(diffAmt)) ? 0 : round(diffAmt, 2);
        $scope.purchaseHeader.RoundOff = $scope.purchaseHeader.DiffAmount;
        $scope.purchaseHeader.TotalVatAmount = round(totvat,2);
        $scope.purchaseHeader.TotalDiscount = round(totdis,2);
    }

    $scope.$watch('purchaseHeader.TotalAmount', function (newValue, oldValue, scope) {
        if (isFinite(newValue) && newValue > 0) {
            $scope.updateCalcAmount();
        }
        $scope.totalBillAmountEntered = true;
    });

    $scope.checkUnit = function (data, rowform) {
        if (data === 0 || data === "" || typeof (data) === 'undefined' || data == null) {
            return "Please select unit";
        }
    }

    $scope.checkManufacturer = function (data, rowform) {
        if (data === 0 || data === "" || typeof (data) === 'undefined' || data == null) {
            // return "Please select manufacturer";
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
    $scope.addNewProduct = function (index) {
        $scope.inserted = {
            isNew: true, Id: getUniqueId(),savedLocal:false,
            BatchNo: '', Qty: 1, FreeQty: 0, ProductName: '', ProductId: 0, ManufacturerId: 0, ManufacturerName: '',
            ExpiryDate: '', Packing: 1, AssortedQty: 0, VAT: 5.5, DiscountPercentage: $scope.purchaseHeader.DiscountPercent, MRP: 0,
            DiscApplicable: 'No', VATOnDiscount: 'No',
            VATOnFreeQty: 'No', DiscOnFreeQty: 'No', AssortedCostPrice: 0, AssortedMRPPrice: 0,
            FreeQtyVATAmount: 0, DiscountAmount: 0, RackId: 1, UnitId: 1, TaxMode: 'MRP', TaxType: 'INCL'
        };

        if (index || index === 0)
            $scope.purchaseOrders.splice(index, 0, $scope.inserted);
        else
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
    $scope.showSelectedUnit = function (order) {
        var selected = [];
        selected = $filter('filter')($scope.units, { Id: order.UnitId });
        return selected.length ? selected[0].Name : '';
    };

    $scope.productList = function (q) {
        var def = PurchaseDataService.getProductList(q);
        $scope.productMaster = def.resolve;
        var deferred = $q.defer();
        def.promise.then(function (data) {
            if (data.findIndex(function (o) { return o.label === q; }) == -1)
                data.splice(0, 0, { 'label': 'Add "' + q + '"', 'isNew': true, 'q': q });
            deferred.resolve(data);
        }, deferred.reject);
        return deferred.promise;
    };

    $scope.getPurchaseItems = function (q) {
        var def = PurchaseDataService.getPurchaseItems(q);
        var deferred = $q.defer();
        def.then(function (data) {
            deferred.resolve(data);
        }, deferred.reject);
        return deferred.promise;
    };

    $scope.manfList = function (q) {
        var def = PurchaseDataService.getManufacturerList(q);
        $scope.manfMaster = def.resolve;
        var deferred = $q.defer();
        def.promise.then(function (data) {
            if (data.findIndex(function (o) { return o.label === q; }) == -1)
                data.splice(0, 0, { 'label': 'Add "' + q + '"', 'isNew': true, 'q': q });
            deferred.resolve(data);
        }, deferred.reject);
        return deferred.promise;
    };

    $scope.supplList = function (q) {
        var def = PurchaseDataService.getSupplierList(q);
        $scope.supplierMaster = def.resolve;
        var deferred = $q.defer();
        def.promise.then(function (data) {
            if (data.findIndex(function (o) { return o.label === q; }) == -1)
                data.splice(0, 0, { 'label': 'Add "' + q + '"', 'isNew': true, 'q': q });
            deferred.resolve(data);
        }, deferred.reject);
        return deferred.promise;
    };

    $scope.invoicenoList = function (q) {
        var def = PurchaseDataService.getInvoiceList(q);
        $scope.invoicenoMaster = def.resolve;
        var deferred = $q.defer();
        def.promise.then(function (data) {
            if (data.findIndex(function (o) { return o.label === q; }) == -1)
            deferred.resolve(data);
        }, deferred.reject);
        return deferred.promise;
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


    $scope.onProductSelect = function ($item, $model, $label, $rowform, order, $index) {
        if (!$item.isNew) {
        $rowform.$data.ProductId = $item.id;
        var selected = [];
        var idx = -1;
        selected = $filter('filter')($scope.purchaseOrders, { Id: order.Id }, true)[0];
        idx = $scope.purchaseOrders.indexOf(selected);
        $scope.purchaseOrders[idx].UnitId = $item.unitId;

        var unitEditable = $filter('filter')($rowform.$editables, { name: 'UnitId' }, true)[0];
        unitEditable.scope.$data = $item.unitId;

        $scope.getPurchaseItems($item.id).then(function (data) {
            var $itemsDiv = $("<div class='products-list' tabindex='-1'></div>");
            var pos = $("#ProductName" + $index).position();
            $itemsDiv.css({ top: (pos.top + 22) + "px", left: pos.left + "px" });
            $itemsDiv.append("<div class='products-list-header'><span>Product Name</span><span>Batch No</span><span>Manufacturer</span><span>Packing</span><span>Qty</span><span>Cost Price</span><span>MRP</span></div>")
            var dataTmp = data.slice(0, 5);
            for (var i in dataTmp) {
                $itemsDiv.append("<div class='products-list-item' data-index='" + i + "'><span>" + data[i].ProductName + "</span><span>" + data[i].BatchNo + "</span><span>" + data[i].ManufacturerName + "</span><span>" + data[i].Packing + "</span><span>" + data[i].Qty + "</span><span>" + data[i].CostPrice + "</span><span>" + data[i].MRP + "</span></div>")
            }
            
            $itemsDiv.find('.products-list-item')
                .on('mouseover', function () {
                    $itemsDiv.find('.products-list-item.active').removeClass('active');
                    $(this).addClass('active');
                })
                .on('click', function () {
                    $("#ProductsItemList" + $index).html("");
                    $("#ProductName" + $index).focus();
                    var item = data[$(this).data('index')];
                    $scope.prefillPurchaseItems(idx, item, $rowform, $index);
                });
            $itemsDiv.on('keydown', function (e) {

                if (e.which === 40 && !$itemsDiv.find('.products-list-item.active').is(':last-of-type')) {
                    e.preventDefault();
                    var $next = $itemsDiv.find('.products-list-item.active').next('.products-list-item');
                    $itemsDiv.find('.products-list-item.active').removeClass('active');
                    $next.addClass('active');
                }
                else if (e.which === 38 && !$itemsDiv.find('.products-list-item.active').is(':first-of-type')) {
                    e.preventDefault();
                    var $prev = $itemsDiv.find('.products-list-item.active').prev('.products-list-item');
                    if ($prev.length > 0) {
                        $itemsDiv.find('.products-list-item.active').removeClass('active');
                        $prev.addClass('active');
                    }
                }
                else if (e.which === 27) {
                    $("#ProductsItemList" + $index).html("");
                    $("#ProductName" + $index).focus();
                }
                else if (e.which === 13) {
                    $("#ProductsItemList" + $index).html("");
                    $("#ProductName" + $index).focus();
                    var item = data[$itemsDiv.find('.products-list-item.active').data('index')];
                    $scope.prefillPurchaseItems(idx, item, $rowform, $index);
                }
            });
            $itemsDiv.find('.products-list-item:first-of-type').addClass('active');
            if (data.length > 0) {
                $("#ProductsItemList" + $index).html("").append($itemsDiv);
                $("#ProductsItemList" + $index).find('.products-list').focus();
            }
        });

        var batchElement = $filter('filter')($rowform.$editables, { name: 'BatchNo' }, true)[0].inputEl[0].focus();
    }
    else {
        $scope.addNewDrug($item.q);
    }

    };
    $scope.prefillPurchaseItems = function (idx, $item, $rowform, $index) {

        $('#tr' + $index).find('[name="BatchNo"]').val($item.BatchNo);
        $rowform.$data.BatchNo = $item.BatchNo;
        //$('#tr' + $index).find('[name="Qty"]').val($item.Qty);
        //$rowform.$data.Qty = $item.Qty;
        //$('#tr' + $index).find('[name="Packing"]').val($item.Packing);
        //$rowform.$data.Packing = $item.Packing;
        //$('#tr' + $index).find('[name="FreeQty"]').val($item.FreeQty);
        //$rowform.$data.FreeQty = $item.FreeQty;
        //$('#tr' + $index).find('[name="ExpiryDate"]').val($item.ExpiryDate);
        //$rowform.$data.ExpiryDate = $item.ExpiryDate;
        $('#tr' + $index).find('[name="MRP"]').val($item.MRP);
        $rowform.$data.MRP = $item.MRP;
        $('#tr' + $index).find('[name="CostPrice"]').val($item.CostPrice);
        $rowform.$data.CostPrice = $item.CostPrice;
        var selected = [];
        selected = $filter('filter')($scope.taxes, { value: $item.VAT });
        $('#tr' + $index).find('[name="VAT"]').val($scope.taxes.indexOf(selected[0]));
        $rowform.$data.VAT = $item.VAT;
        selected = $filter('filter')($scope.taxModes, { value: $item.TaxMode });
        $('#tr' + $index).find('[name="TaxMode"]').val($scope.taxModes.indexOf(selected[0]));
        $rowform.$data.TaxMode = $item.TaxMode;
        selected = $filter('filter')($scope.taxTypes, { value: $item.TaxType });
        $('#tr' + $index).find('[name="TaxType"]').val($scope.taxTypes.indexOf(selected[0]));
        $rowform.$data.TaxType = $item.TaxType;
        //selected = $filter('filter')($scope.disType, { value: $item.DiscApplicable });
        //$('#tr' + $index).find('[name="DiscApplicable"]').val($scope.disType.indexOf(selected[0]));
        //$rowform.$data.DiscApplicable = $item.DiscApplicable;
        //selected = $filter('filter')($scope.YesNoType, { value: $item.VATOnFreeQty });
        //$('#tr' + $index).find('[name="VATOnFreeQty"]').val($scope.YesNoType.indexOf(selected[0]));
        //$rowform.$data.VATOnFreeQty = $item.VATOnFreeQty;
        //selected = $filter('filter')($scope.YesNoType, { value: $item.VATOnDiscount });
        //$('#tr' + $index).find('[name="VATOnDiscount"]').val($scope.YesNoType.indexOf(selected[0]));
        //$rowform.$data.VATOnDiscount = $item.VATOnDiscount;
        $('#tr' + $index).find('[name="ManufacturerId"]').val($item.ManufacturerId);
        $rowform.$data.ManufacturerId = $item.ManufacturerId;
        $('#tr' + $index).find('[name="ManufacturerName"]').val($item.ManufacturerName);
        $rowform.$data.ManufacturerName = $item.ManufacturerName;
    };
    $scope.onManfSelect = function ($item, $model, $label, $rowform, order) {
        if (!$item.isNew) {
            $rowform.$data.ManufacturerId = $item.id;
            var selected = [];
            var idx = -1;
            selected = $filter('filter')($scope.purchaseOrders, { Id: order.Id }, true)[0];
            idx = $scope.purchaseOrders.indexOf(selected);
            $scope.purchaseOrders[idx].ManufacturerId = $item.id;
        }
        else {
            $scope.addNewMfg($item.q)
        }
    };

    $scope.onSupplierSelect = function ($item, $model, $label) {
        if (!$item.isNew) {
            $scope.purchaseHeader.SupplierId = $item.id;
            PurchaseDataService.getSupplierInfo($item.id)
                                    .then(function (purchase) {
                                        $scope.invoiceDetails = purchase;
                                    },
                                          function () { alert('error while loading Supplier info') }
                                   ).finally(function () {
                                       $scope.dataLoading = false;
                                   })
        }
        else {
            $scope.addNewSuplr($item.q)
        }
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

    $scope.taxModes = [{ text: "MRP", value: "MRP" }, {text: "COST", value: "COST" }];
    $scope.taxTypes = [{ text: "Incl", value: "INCL" }, { text: "Excl", value: "EXCL" }];
    $scope.YesNoType = [{ text: "Yes", value: "Yes" }, { text: "No", value: "No" }];
    $scope.disType = [{ text: "COST", value: "COST" }, { text: "MRP", value: "MRP" }, { text: "No", value: "No" }];

    $scope.showSelectedTaxMode = function (order) {
        var selected = [];
        selected = $filter('filter')($scope.taxModes, { value: order.TaxMode });
        return selected.length ? selected[0].text : 'MRP';
    };
    $scope.showSelectedTaxType = function (order) {
        var selected = [];
        selected = $filter('filter')($scope.taxTypes, { value: order.TaxType });
        return selected.length ? selected[0].text : 'INCL';
    };
    $scope.showSelectedDiscApplicable = function (order) {
        var selected = [];
        selected = $filter('filter')($scope.disType, { value: order.DiscApplicable });
        return selected.length ? selected[0].text : 'COST';
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

    $scope.calculateSingleAbatedMRP = function (order) {
        var totalMrp = isFinite(order.TotalMRP) ? order.TotalMRP : 0;  
        var vat = isFinite(order.VAT) ? order.VAT : 0;;
        var qty = isFinite(order.AssortedQty) ? order.AssortedQty : 0;;
        var amount = (totalMrp - (totalMrp - (totalMrp / ((vat / 100) + 1)))) / qty;
        order.sAbatedMRP = isFinite(amount) ? round(amount, 2) : 0;
        return order.sAbatedMRP;
    }
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
        if (order.VATOnFreeQty === 'Yes') {
            if (order.TaxMode === 'COST') {
                var assortedCostPrice = isFinite(order.AssortedCostPrice) ? order.AssortedCostPrice : 0;
                amount = ((order.FreeQty * parseFloat(order.Packing)) * assortedCostPrice) * (parseFloat(order.VAT) / 100);
            }
            else if (order.TaxMode === 'MRP') {
                var assortedMrpPrice = isFinite(order.AssortedMRPPrice) ? order.AssortedMRPPrice : 0;
                amount = ((order.FreeQty * parseFloat(order.Packing)) * assortedMrpPrice) * (parseFloat(order.VAT) / 100);
            }

            order.FreeQtyVATAmount = isFinite(amount) ? round(amount, 2) : 0;
        }
        else {
            order.FreeQtyVATAmount = 0;
        }
        return order.FreeQtyVATAmount;
    }
    $scope.calculateVatOnDiscountAmount = function (order) {
        var totalVat = isFinite(order.TotalVatAmount) ? order.TotalVatAmount : 0;
        var amount = 0;
        if (order.VATOnDiscount && order.VATOnDiscount === 'Yes') {
            amount = totalVat * (parseFloat(order.DiscountPercentage) / 100);
            order.VatOnDiscountAmount = isFinite(amount) ? round(amount, 2) : 0;
        }
        else {
            order.VatOnDiscountAmount = 0;
        }
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
        //if (order.TaxMode === 'COST') {
        //    amount = (parseFloat(order.TotalCostPrice)) * (discPerc / 100);
        //}
        //else if (order.TaxMode === 'MRP') {
        //    amount = (parseFloat(order.TotalMRP)) * (discPerc / 100);
        //}
        if (order.DiscApplicable === 'COST') {
            amount = (parseFloat(order.TotalCostPrice)) * (discPerc / 100);
        }
        else if (order.DiscApplicable === 'MRP') {
            amount = (parseFloat(order.TotalMRP)) * (discPerc / 100);
        }
        else {
            var amount = 0;
        }
        order.DiscountAmount = isFinite(amount) ? round(amount, 2) : 0;
        return order.DiscountAmount;
    }
    $scope.calculateDiscOnFreeQtyAmount = function (order) {
        var discPerc = isFinite(order.DiscountPercentage) ? order.DiscountPercentage : 0;
        var amount = 0;
        if (order.DiscOnFreeQty && order.DiscOnFreeQty === 'Yes') {
            //if (order.TaxMode === 'COST') {
            //    amount = (order.FreeQty * order.CostPrice) * (discPerc / 100);
            //}
            //else {
            //    amount = (order.FreeQty * order.MRP) * (discPerc / 100);
            //}
            if (order.DiscApplicable === 'COST') {
                amount = (order.FreeQty * order.CostPrice) * (discPerc / 100);
            }
            else if (order.DiscApplicable === 'MRP') {
                amount = (order.FreeQty * order.MRP) * (discPerc / 100);
            }
            else {
                var amount = 0;
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
        var amount = (order.Qty + order.FreeQty) * (isFinite(order.MRP) ? order.MRP : 0)
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

    $scope.addNewDrug = function (q) {

        $scope.q = {};
        $scope.newDrug = { Name: '', TypeId: 1, isActive: true };

        $scope.newDrug.Name = q ? q : "";

        $scope.newDrug_Type = [];
        PurchaseDataService.getAllDrugTypes()
            .then(function (Type) { $scope.newDrug_Type = Type },
                                      function () { alert('error while fetching type from server') }
                           );
        $scope.newDrug_category = [];
        PurchaseDataService.getAllDrugCategories()
            .then(function (category) { $scope.newDrug_category = category },
                                      function () { alert('error while fetching category from server') }
                                      );
        $scope.newDrug_Content = [];
        PurchaseDataService.getAllDrugContents()
            .then(function (Content) { $scope.newDrug_Content = Content },
                                      function () { alert('error while fetching content from server') }
                                      );
        $scope.newDrug_Generic = [];
        PurchaseDataService.getAllDrugGenerics()
            .then(function (Generic) { $scope.newDrug_Generic = Generic },
                                      function () { alert('error while fetching generic from server') }
                                      );

        $scope.newDrug_Man = [];
        PurchaseDataService.getAllManufacturers()
            .then(function (Man) { $scope.newDrug_Man = Man },
                                         function () { alert('error while fetching manufacturer from server') }
                                         );
        $scope.newDrug_unit = [];
        PurchaseDataService.getAllDrugUnits()
            .then(function (unit) { $scope.newDrug_unit = unit },
            function () { alert('error while fetching units from server') }
            );
        $scope.newDrug_rack = [];
        PurchaseDataService.getAllRacks()
            .then(function (rack) { $scope.newDrug_rack = rack },
            function () { alert('error while fetching racks from server') }
            );
        $scope.newDrug_tax = [];
        PurchaseDataService.getAllTaxs()
            .then(function (tax) { $scope.newDrug_tax = tax },
            function () { alert('error while fetching taxs from server') }
            );
        $('#show-add-drug').modal({ backdrop: false, keyboard: false })
            .one('click', '#addDrug', function () {
                $scope.newDrug_addingDrug = true
                PurchaseDataService.addProduct($scope.newDrug)
                .then(function (data) {
                    $scope.newDrug_addingDrug = false;
                    $('#show-add-drug').modal('hide');
                },
                    function () { alert('error while adding product') }
                );
            });//end of one
    }

    $scope.addNewMfg = function (q) {
        $scope.newMfg = { Name: '', Desc: '', isActive: true };

        $scope.newMfg.Name = q ? q : "";

        $('#show-add-mfg').modal({ backdrop: false, keyboard: false })
           .one('click', '#addMfg', function () {
               $scope.newMfg_addingMfg = true
               PurchaseDataService.addManufacturer($scope.newMfg)
               .then(function (data) {
                   $scope.newMfg_addingMfg = false;
                   $('#show-add-mfg').modal('hide');
               },
                   function () { alert('error while adding manufacturer') }
               );
           });//end of one
    }

    $scope.addNewSuplr = function (q) {
        $scope.newSuplr = { Name: '', TypeId: 1, isActive: true };

        $scope.newSuplr.Name = q ? q : "";

        $('#show-add-suplr').modal({ backdrop: false, keyboard: false })
           .one('click', '#addSuplr', function () {
               $scope.newSuplr_addingSuplr = true
               PurchaseDataService.addSupplier($scope.newSuplr)
               .then(function (data) {
                   $scope.newSuplr_addingSuplr = false;
                   $('#show-add-suplr').modal('hide');
                   window.location.reload();
               },
                   function () { alert('error while adding supplier') }
               );
           });//end of one
    }

    $scope.addNewRack = function (q) {
        $scope.newRack = { Name: '', Desc: '', isActive: true };

        $scope.newRack.Name = q ? q : "";

        $('#show-add-rack').modal({ backdrop: false, keyboard: false })
           .one('click', '#addRack', function () {
               $scope.newRack_addingRack = true
               PurchaseDataService.addRack($scope.newRack)
               .then(function (data) {
                   $scope.newRack_addingRack = false;
                   $('#show-add-rack').modal('hide');
                   window.location.reload();
               },
                   function () { alert('error while adding supplier') }
               );
           });//end of one
    }

    hotkeys.bindTo($scope)
    .add({
        combo: 'f3',
        description: 'Save Purchase',
        callback: function (e) {
            e.preventDefault();
            $scope.savePurchase();
        }
    })
    .add({
        combo: 'f4',
        description: 'Clear Purchase',
        callback: function (e) {
            e.preventDefault();
            $scope.initPurchase();
        }
    })
    .add({
        combo: 'f6',
        description: 'Print PDF',
        callback: function (e) {
            e.preventDefault();
            $location.path('/print/' + $routeParams.id);
        }
    })
    .add({
        combo: 'f7',
        description: 'Hold Purchase and Open new entry',
        callback: function (e) {
            e.preventDefault();
            $scope.holdPurchase('/add');
        }
    })
    .add({
        combo: 'f9',
        description: 'Close',
        callback: function (e) {
            e.preventDefault();
            $location.path('/');
        }
    })
    .add({
        combo: 'f10',
        description: 'Add new row',
        callback: function (e) {
            e.preventDefault();
            if ($scope.totalBillAmountEntered) {
                if ($scope.purchaseOrders.length > 0) {
                    if ($scope.newRow) {
                        $scope.newRow.row = 0;
                        $scope.newRow.position = 0;
                    }
                    else
                        $scope.newRow = { row: 0, position: 0 };
                    $('#new-row-popup').find('#entry-row').val("0");
                    $scope.$apply();
                    $('#new-row-popup').modal({ backdrop: false, keyboard: false }).one('click', '#insert-row', function () {
                        $scope.addNewProduct(Number($scope.newRow.row) + Number($scope.newRow.position));
                        $scope.$apply();
                        $('#new-row-popup').modal('hide');
                    });
                }
                else {
                    $scope.addNewProduct();
                }
            }
        }
    });
}

PurchasePrintController.$inject = ['$scope', '$filter', '$timeout', '$route', '$routeParams', 'PurchaseDataService', 'SupplierList', '$location']

function PurchasePrintController($scope, $filter, $timeout, $route, $routeParams, PurchaseDataService, supList, $location) {
    $scope.dataLoading = true;
    $scope.purchaseHeader = {};
    $scope.taxes = [{ value: 5.5, text: '5.5' }, { value: 14.5, text: '14.5' }, { value: 0, text: '0' }];
    $scope.purchaseOrders = [];
    $scope.convertedPdf = false;
    $scope.suppliers = supList;

    $scope.dateToLocalDateString = function (dt) {
        var date = new Date(dt);
        return date.toLocaleDateString();
    }

    var limitStep = 5;
    $scope.limit = limitStep;

    $scope.getSupplierName = function (supId) {
        return $scope.suppliers.find(function (supplier) {
            return supplier.Id == supId;
        }).Name;
    };

    $scope.showSelectedVAT = function (order) {

        var selected = [];
        selected = $filter('filter')($scope.taxes, { Tax: order.VAT });

        return selected.length ? selected[0].value : $scope.taxes[0].value;
    };

    $scope.calculateGrandTotal = function (key) {
        return $scope.purchaseOrders.reduce(function (a, b) { return Math.round(a + b[key],2) }, 0);
    };

    $scope.convertToPdf = function () {
        var doc = new jsPDF('p', 'pt', 'letter');

        doc.addHTML($("#printContent"), function () {
            var obj = doc.output('datauristring');
            document.getElementById('pdfWraper').innerHTML = '<embed style="width:100%;height:500px;" name="plugin" id="plugin" src="' + obj + '" type="application/pdf" internalinstanceid="164" title="GRN Receipt">';
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
        PurchaseDataService.getPurchaseInfo($routeParams.id)
            .then(function (purchase) {
                $scope.purchaseHeader = purchase;
                $scope.purchaseOrders = purchase.PurchaseItems;
                
                //var n = purchase.PurchaseItems.length / 10;
                //var rn = Math.ceil(n);
                //var k = 0;
                //for(var i = 1; i<=rn; i++)
                //{
                //    document.write('<U><center>PIONEER PHARMA</center></U>');
                //    document.write('Supplier Inv Date: &nbsp;');
                //    document.write($scope.purchaseHeader.SupplierInvDate);
                //    document.write('&nbsp;');
                //    document.write('Supplier Tin No: &nbsp;');
                //    document.write($scope.purchaseHeader.TinNo);
                //    document.write('&nbsp;');
                //    document.write('Supplier ID: &nbsp;');
                //    document.write($scope.purchaseHeader.SupplierId);
                //    document.write('<br />');
                //    document.write('<br />');
                    
                //    document.write('<table><thead><tr><th style="column-width:0px">S#</th><th style="column-width:0px">DrugName</th><th style="column-width:60px">BatchNo</th><th style="column-width:60px">MFG</th><th style="column-width:20px">Pak</th><th style="column-width:20px">Qty</th><th style="column-width:20px">Free</th><th style="column-width:30px">Exp</th><th style="column-width:40px">Cost</th><th style="column-width:40px">MRP</th><th style="column-width:30px">Vat%</th><th style="column-width:30px">Vat</th><th style="column-width:30px">Disc</th><th style="column-width:60px">NetCost</th><th style="column-width:60px">NetMRP</th></tr></thead></table>');
                //    document.write('<hr>');
                //    var c = 1;
                    
                //    for (var j = k ; j <= purchase.PurchaseItems.length; j++) {
                //            debugger;
                //            if (c < 11) {
                //                document.write(j + 1);
                //                document.write('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                //                document.write($scope.purchaseOrders[j].ProductName);
                //                document.write('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                //                document.write($scope.purchaseOrders[j].BatchNo);
                //                document.write('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                //                document.write($scope.purchaseOrders[j].ManufacturerName);
                //                document.write('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                //                document.write($scope.purchaseOrders[j].Packing);
                //                document.write('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                //                document.write($scope.purchaseOrders[j].Qty);
                //                document.write('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                //                document.write($scope.purchaseOrders[j].FreeQty);
                //                document.write('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                //                document.write($scope.purchaseOrders[j].ExpiryDate);
                //                document.write('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                //                document.write($scope.purchaseOrders[j].CostPrice);
                //                document.write('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                //                document.write($scope.purchaseOrders[j].MRP);
                //                document.write('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                //                document.write($scope.purchaseOrders[j].VAT);
                //                document.write('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                //                document.write($scope.purchaseOrders[j].VATAmount);
                //                document.write('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                //                document.write($scope.purchaseOrders[j].TotalDiscountAmount);
                //                document.write('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                //                document.write($scope.purchaseOrders[j].TotalCostPrice);
                //                document.write('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                //                document.write($scope.purchaseOrders[j].TotalMRP);
                //                document.write('<br />');
                //                c++;
                //                k = k + 1;
                //            }
                //        }
                //    document.write('Footer');
                //    document.write('<br />');
                //}

                $timeout($scope.printForm, 0);
            },
            function () { alert('error while loading purchase info') })
            .finally(function () {
                $scope.dataLoading = false;
            })
    }
    else {
        $scope.dataLoading = false;
    }
}

PurchaseListController.$inject = ['$scope', '$filter', '$route', 'PurchaseDataService', 'SupplierList', 'ManufacturerList', 'UnitList', 'PharmacyIdEnc', 'uiGridConstants', 'hotkeys', '$location'];

function PurchaseListController($scope, $filter, $route, PurchaseDataService, suppList, mfgList, unitList, PharmacyIdEnc, uiGridConstants, hotkeys, $location) {

    $scope.purchaseHeader = {};
    $scope.suppliers = suppList;
    $scope.manufacturers = mfgList;
    $scope.units = unitList;
    $scope.pIdEnc = PharmacyIdEnc;

    $scope.purchases = [];

    $scope.cdate = new Date();

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
              field: 'Id', displayName: '', enableSorting: false, useExternalSorting: false,  enableColumnMenu:false,
              cellTemplate: '<div class="form-control" style="width:60px"> <a href="#/edit/{{row.entity[col.field]}}" class="btn btn-labeled btn-purple btn-xs hidden"> <span class="btn-label"><i class="fa fa-edit"></i></span></a> <a href="#/print/{{row.entity[col.field]}}" class="btn btn-labeled btn-pink btn-xs"> <span class="btn-label"><i class="fa fa-print"></i></span></a> <a ng-click="grid.appScope.delete(COL_FIELD)" class="btn btn-labeled btn-danger btn-xs hidden"><span class="btn-label"><i class="fa fa-times"></i></span><span class="hidden-xs">Delete</span> </a></div>'
          },
          {
              name: 'Grn No', field: 'GrnNo', enableSorting: false, useExternalSorting: false
          },
          {
              name: 'Grn Date', field: 'GrnDate', cellFilter: 'jsonDate', enableFiltering: false, filter: {
                  noTerm: true
              }
          },
          {
              name: 'Invoice No', field: 'SupplierInvNo', enableSorting: false
          },

          { name: 'Supplier', field: 'Supplier.Name' }
        ],
        onRegisterApi: function (gridApi) {
            $scope.gridApi = gridApi;

            $scope.gridApi.core.on.sortChanged($scope, function (grid, sortColumns) {
                if (sortColumns.length == 0) {
                    paginationOptions.sort = null;
                } else {                    
                    paginationOptions.sort = sortColumns[0].field+'_'+sortColumns[0].sort.direction;
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

    $scope.draftGridOptions = {
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
              name: 'Grn No', field: 'GrnNo', enableSorting: false, useExternalSorting: false
          },
          {
              name: 'Grn Date', field: 'GrnDate', cellFilter: 'jsonDate', enableFiltering: false, filter: {
                  noTerm: true
              }
          },
          {
              name: 'Invoice No', field: 'SupplierInvNo', enableSorting: false
          },

          { name: 'Supplier', field: 'Supplier.Name' }
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

    $scope.holdingGridOptions = {
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
              name: 'Grn No', field: 'GrnNo', enableSorting: false, useExternalSorting: false
          },
          {
              name: 'Grn Date', field: 'GrnDate', cellFilter: 'jsonDate', enableFiltering: false, filter: {
                  noTerm: true
              }
          },
          {
              name: 'Invoice No', field: 'SupplierInvNo', enableSorting: false
          },

          { name: 'Supplier', field: 'Supplier.Name' }
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

    $scope.delete = function (id) {        
        $('#confirm-purchase-delete').modal({ backdrop: false, keyboard: false })
            .on('click', '#delete', function () {
                PurchaseDataService.deletePurchase(id)
                            .then(function (data) {
                                if (data.status === true) {
                                    $route.reload();
                                }
                            },
                              function () { alert('error while deleting purchase') }
                            );
            });//end of one
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
            GrnNo: $scope.purchaseHeader.GrnNo,
            GrnDate: $scope.purchaseHeader.GrnDate,
            SupplierInvNo: $scope.purchaseHeader.SupplierInvNo,
            SupplierId: $scope.purchaseHeader.SupplierId,            
            PageNo: paginationOptions.pageNumber,
            PageSize: paginationOptions.pageSize,
            OrderBy: paginationOptions.sort,
            AddedTo: $scope.purchaseHeader.AddedTo,
            AddedFrom: $scope.purchaseHeader.AddedFrom
        };

        PurchaseDataService.SearchPurchases(params)
           .then(function (purchaseList) {
               $scope.gridOptions.data = purchaseList.data;

               $scope.gridOptions.totalItems = purchaseList.total;

               $scope.draftGridOptions.data = purchaseList.data.filter(function (item) { return !!item.SaveStatus && item.SaveStatus.trim() == "Draft"; });

               $scope.draftGridOptions.totalItems = $scope.draftGridOptions.data.length;

               $scope.holdingGridOptions.data = purchaseList.data.filter(function (item) { return !!item.SaveStatus && item.SaveStatus.trim() == "Holding"; });

               $scope.holdingGridOptions.totalItems = $scope.holdingGridOptions.data.length;

               $timeout(function () { $scope.selectedOption = "Completed"; }, 0);
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
        description: 'AddNew Purchase',
        callback: function (e) {
            e.preventDefault();
            $location.path('/add');
        }
    })
    .add({
        combo: 'f5',
        description: 'Search Purchases',
        callback: function (e) {
            e.preventDefault();
            $scope.search();
        }
    })
    .add({
        combo: 'f8',
        description: 'Show held bills list',
        callback: function (e) {
            e.preventDefault();
            $scope.selectedOption = 'Holding';
        }
    });
}

OpenStockController.$inject = ['$scope', '$filter', '$route', '$routeParams', 'PurchaseDataService', 'SupplierList', 'RackList', 'ManufacturerList', 'UnitList', 'PharmacyIdEnc'];

function OpenStockController($scope, $filter, $route, $routeParams, PurchaseDataService, suppList, rackList, mfgList, unitList, PharmacyIdEnc) {
    $scope.message = "";
    $scope.FileInvalidMessage = "";
    $scope.SelectedFileForUpload = null;
    $scope.FileDescription = "";

    $scope.IsFileValid = false;
    $scope.IsFormValid = false;

    //Form Validation
    $scope.$watch("formOpenStock.$valid", function (isValid) {
        $scope.IsFormValid = isValid;
    });


    // THIS IS REQUIRED AS File Control is not supported 2 way binding features of Angular
    // ------------------------------------------------------------------------------------
    //File Validation
    $scope.CheckFileValid = function (file) {
        var isValid = false;
        if ($scope.SelectedFileForUpload != null) {
            debugger;
            if ((file.type == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' || file.type == 'application/vnd.ms-excel')) {
                $scope.FileInvalidMessage = "";
                isValid = true;
            }
            else {
                $scope.FileInvalidMessage = "Selected file is Invalid. (only file type xls, xlsx allowed)";
            }
        }
        else {
            $scope.FileInvalidMessage = "Image required!";
        }
        $scope.IsFileValid = isValid;
    };

    //File Select event 
    $scope.selectFileforUpload = function (file) {
        $scope.SelectedFileForUpload = file[0];
    }
    //----------------------------------------------------------------------------------------

    //Save File
    $scope.SaveFile = function () {
        $scope.IsFormSubmitted = true;
        $scope.Message = "";
        $scope.CheckFileValid($scope.SelectedFileForUpload);
        if ($scope.IsFormValid && $scope.IsFileValid) {
            PurchaseDataService.uploadOpenStocksFile($scope.SelectedFileForUpload, $scope.FileDescription).then(function (stocks) {
                debugger;
                //ClearForm();
                PopulateOpenStocks(stocks);
                debugger;
            }, function (e) {
                alert(e);
            });
        }
        else {
            $scope.Message = "All the fields are required.";
        }
    };
    //Clear form 
    function ClearForm() {
        $scope.FileDescription = "";
        //as 2 way binding not support for File input Type so we have to clear in this way
        //you can select based on your requirement
        angular.forEach(angular.element("input[type='file']"), function (inputElem) {
            angular.element(inputElem).val(null);
        });

        $scope.formOpenStock.$setPristine();
        $scope.IsFormSubmitted = false;
    }

    function PopulateOpenStocks(result) {
        if (result.status === true) {
            $scope.purchaseOrders = result.stocks;
        }
    }

}
