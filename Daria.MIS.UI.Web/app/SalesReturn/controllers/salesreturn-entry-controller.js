IndentBillEntryController.$inject = ['$scope', '$filter', '$route', '$routeParams', 'IndentBillDataService', 'DepartmentList', 'PatientList', 'ManufacturerList', 'UnitList', 'IndentList', 'PharmacyIdEnc', '$location', 'hotkeys'];

function IndentBillEntryController($scope, $filter, $route, $routeParams, IndentBillDataService, deptList, patientList, mfgList, unitList, indentList, PharmacyIdEnc, $location, hotkeys) {
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
    $scope.billcount = 0;
    if ($routeParams.id && $routeParams.id > 0) {
        $scope.editMode = true;
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
                                    $scope.purchaseOrders = purchase.SalesRetItems;
                                },
                                      function () { alert('error while loading sales Return info') }
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
    $scope.$watch('purchaseHeader.IPList', function (newValue, oldValue, scope) {
        
        if (newValue > 0) {
            var selectedIP = $filter('filter')($scope.patients, { Id: parseInt(newValue, 10), }, true)[0];
            var IPNo = selectedIP.Name;
            IndentBillDataService.getIndentInfo(IPNo)
                                    .then(function (purchase) {
                                        
                                    },
                                          function () { alert('error while loading Indent info') }
                                   ).finally(function () {
                                       $scope.dataLoading = false;
                                   })
        }
        
    });

    //$scope.$watch('purchaseHeader.BillNo', function (newValue, oldValue, scope) {
    //    if (newValue > 0) {
    //        var BillNo = $scope.purchaseHeader.BillNo;
    //        IndentBillDataService.getIndentInfo(BillNo)
    //                                .then(function (bill) {
                                        
    //                                },
    //                                      function () { alert('error while loading bill info') }
    //                               ).finally(function () {
    //                                   $scope.dataLoading = false;
    //                               })
    //    }

    //});

    $scope.purchaseHeader.DType = 'S';

    $scope.hidePatientDetails = function () {
        $scope.purchaseHeader.IPNo = false;
        $scope.purchaseHeader.PatientName = false;
        $scope.purchaseHeader.Age = false;
        $scope.purchaseHeader.PayMode = false;
        $scope.purchaseHeader.Ward = false;
            $scope.purchaseHeader.IPList = false;
            $scope.purchaseHeader.DType = 'S';
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

    $scope.sshow = function () {
        var BillNo = $scope.purchaseHeader.BillNo;
        IndentBillDataService.getIndentInfo(BillNo)
                                .then(function (bill) {
                                    $scope.purchaseHeader.PatientName = bill.Customer;
                                    $scope.purchaseHeader.BillNumber = bill.BillNo;
                                    $scope.purchaseHeader.BillDt = bill.BillDate;
                                },
                                      function () { alert('error while loading bill info') }
                               ).finally(function () {
                                   $scope.dataLoading = false;
                               })
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

    //$scope.$watch('purchaseHeader.BillNo', function (newValue, oldValue, scope) {
    //    //if (newValue != oldValue) {
    //    //    var selectedIP = $filter('filter')($scope.BillNo, { Id: 4151 }, true)[0];
    //    //    //$scope.purchaseHeader.BillNo = selectedIP.Name;
    //    //    $scope.purchaseHeader.PatientName = selectedIP.PatientName;
    //    //    //$scope.purchaseHeader.Age = selectedIP.PatientName;
    //    //}
    //    //else
    //    //{
    //    //    var selectedIP = $filter('filter')($scope.BillNo, { Id: 4151 }, true)[0];
    //    //    $scope.purchaseHeader.PatientName = selectedIP.PatientName;
    //    //    $scope.purchaseHeader.Age = selectedIP.BillNo;
    //    //}
    //    var selectedIP = $filter('filter')($scope.BillNo, { Id: 1 }, true)[0];
    //    $scope.purchaseHeader.PatientName = selectedIP.Id;
    //});

    $scope.savePurchase = function () {
        if ($scope.billcount == 0) {
            var valid = $scope.validateOrders();
            if ($scope.authorized) {
                $scope.purchaseHeader.PharmacyIdEnc = $scope.pIdEnc;
                $scope.purchaseHeader.SalesRetItems = $scope.purchaseOrders;

                IndentBillDataService.savePurchase($scope.purchaseHeader)
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
                     function () { alert('error while saving Return'); $scope.authorized = false; }
                );
                $scope.billcount = $scope.billcount + 1;
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
    //            IndentBillDataService.authorizeUser($scope.purchaseHeader.SavedUser)
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
        $scope.purchaseOrders[idx].ProductId = data.ProductId;
        $scope.purchaseOrders[idx].manfId = data.ManufacturerId;
        $scope.purchaseOrders[idx].batchNo = data.BatchNo;
        $scope.purchaseOrders[idx].Qty = data.Qty;
        $scope.purchaseOrders[idx].stock = data.Stock;
        $scope.purchaseOrders[idx].expDate = data.ExpDate;
        $scope.purchaseOrders[idx].purDetId = data.PurDetId
        
        $scope.purchaseOrders[idx].MRP = data.MRP;
        $scope.purchaseOrders[idx].VAT = data.VAT;
        $scope.purchaseOrders[idx].TotalMRP = data.TotalMRP;
        $scope.purchaseOrders[idx].VATAmount = data.VATAmount;

        $scope.purchaseOrders[idx].savedLocal = true;
        $scope.updateCalcAmount();
    }

    $scope.checkNewProductRow = function (data, Id, rowform, index) {
        
        $scope.savePurchaseItem(rowform.$data, Id, rowform, index);
        if ($scope.purchaseOrders.length - 1 == index)
            $scope.addNewProduct();
        else {
            document.getElementById('ProductName' + (index + 1)).focus();
        }
    }

    $scope.updateCalcAmount = function (data) {
        var mrp1 = 0;
        for (var i = 0; i < $scope.purchaseOrders.length; i++) {
            if (isFinite($scope.purchaseOrders[i].TotalMRP)) {
                mrp1 = mrp1 + parseFloat($scope.purchaseOrders[i].TotalMRP);
            }
        }
        $scope.purchaseHeader.NetAmount = mrp1;
        $scope.purchaseHeader.TotalAmount = mrp1;
    }

    $scope.checkProductName = function (data, rowform) {
        if (data === "" || typeof (data) === 'undefined' || data == null) {
            return "Please enter product name";
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
            BatchNo: '', Qty: 1, ProductName: '', ProductId: 0, ManufacturerId: 0, ManufacturerName: '',
            ExpiryDate: '', VAT: 5.5, MRP: 0,
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
        $scope.purchaseOrders[idx].ManufacturerId = $item.manfId;
        
        $scope.purchaseOrders[idx].BatchNo = $item.batchNo;
        $scope.purchaseOrders[idx].Qty = $item.Qty
        $scope.purchaseOrders[idx].ExpDate = $item.expDate;
        $scope.purchaseOrders[idx].MRP = $item.mrp;
               
        $scope.purchaseOrders[idx].Manufacturer = $item.manf;
        $scope.purchaseOrders[idx].Stock = $item.stock;
        $scope.purchaseOrders[idx].GRNNo = $item.grnNo;
        $scope.purchaseOrders[idx].PurDetId = $item.purDetId;
        $scope.purchaseOrders[idx].VAT = $item.vat;
        $scope.purchaseOrders[idx].BillCode = $item.billcode;

        var drugElement = $filter('filter')($rowform.$editables, { name: 'ProductName' }, true)[0];
        drugElement.scope.$data = $item.label;

        var ProductIdEditable = $filter('filter')($rowform.$editables, { name: 'ProductId' }, true)[0];
        ProductIdEditable.scope.$data = $item.id;

        var MRPEditable = $filter('filter')($rowform.$editables, { name: 'MRP' }, true)[0];
        MRPEditable.scope.$data = $item.mrp;

        var VATEditable = $filter('filter')($rowform.$editables, { name: 'VAT' }, true)[0];
        VATEditable.scope.$data = $item.vat;

        var QtyEditable = $filter('filter')($rowform.$editables, { name: 'Qty' }, true)[0].inputEl[0].focus();
        QtyEditable.scope.$data = 1;

        var manfIdEditable = $filter('filter')($rowform.$editables, { name: 'ManufacturerId' }, true)[0];
        manfIdEditable.scope.$data = $item.manfId;

        var ExpiryElement = $filter('filter')($rowform.$editables, { name: 'ExpDate' }, true)[0];
        ExpiryElement.scope.$data = $item.expDate;
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
    $scope.calculateTotalMRP = function (order) {
        var qty = parseInt(order.Qty);
        
        var amount = (qty) * (isFinite(order.MRP) ? order.MRP : 0)
        order.TotalMRP = isFinite(amount) ? round(amount, 2) : 0;
        return order.TotalMRP;
    }
    $scope.calculateVATAmount = function (order) {
        
        var vat = isFinite(order.VAT) ? order.VAT : 0;
        var amount = 0;
        amount = order.TotalMRP * (vat / 100);
        
        order.VATAmount = isFinite(amount) ? round(amount, 2) : 0;
        return order.VATAmount;
    }

    hotkeys.bindTo($scope)
    .add({
        combo: 'f3',
        description: 'Save SalesReturn',
        callback: function (e) {
            e.preventDefault();
            $scope.savePurchase();
        }
    })
    .add({
        combo: 'f4',
        description: 'Clear SalesReturn',
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

IndentBillListController.$inject = ['$scope', '$filter', '$route', 'IndentBillDataService', 'hotkeys', '$location'];

function IndentBillListController($scope, $filter, $route, IndentBillDataService, hotkeys, $location) {

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

    $scope.print = function (id) {
        $('#confirm-purchase-print').modal({ backdrop: false, keyboard: false })
            .one('click', '#print', function () {
                IndentBillDataService.printBillReturnReceipt(id)
                            .then(function (data) {
                                if (data.status === true) {
                                    $route.reload();
                                }
                            },
                              function () { alert('error while Print Receipt') }
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
        description: 'Help',
        callback: function (e) {
            e.preventDefault();
            $location.path('/add');
        }
    });
}

IndentBillPrintController.$inject = ['$scope', '$filter', '$timeout', '$route', '$routeParams', 'IndentBillDataService', '$location']

function IndentBillPrintController($scope, $filter, $timeout, $route, $routeParams, IndentBillDataService, $location) {
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

        IndentBillDataService.getPurchaseInfo($routeParams.id)
                                .then(function (purchase) {
                                    $scope.purchaseHeader = purchase;
                                    $scope.purchaseOrders = purchase.SalesRetItems;

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
