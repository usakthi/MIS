
TaxListController.$inject = ['$scope', '$filter', '$route', 'MasterData', '$location'];

function TaxListController($scope, $filter, $route, MasterData, $location) {
    $scope.taxs = [];

    MasterData.getAllTaxs()
        .then(function (taxs) { $scope.taxs = taxs },
              function () { alert('error while fetching tax from server') }
         );
    //$scope.delete = function (id) {
    //    $('#confirm-tax-delete').modal({ backdrop: false, keyboard: false })
    //        .one('click', '#delete', function () {
    //            MasterData.deleteTax(id)
    //                        .then(function (data) {
    //                            if (data.status === true) {
    //                                $route.reload();
    //                            }
    //                        },
    //                          function () { alert('error while deleting tax') }
    //                        );
    //        });//end of one
    //};
    $scope.tax = { Name: '', Desc: '', isActive: true };

    $scope.add = function () {
        MasterData.addTax($scope.tax)
       .then(function (data) {
           if (data.status === true) {
               $location.path('/tax');
           }
       },
             function () { alert('error while adding tax') }
        );
    };
    $scope.repeaterRefreshed = function () {
        // ---------
    }

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

        selected = $filter('filter')($scope.taxs, { Id: order.Id }, true)[0];
        idx = $scope.taxs.indexOf(selected);
        if (idx > -1) {
            $scope.taxs.splice(idx, 1);
        }

    };
    $scope.showCategory = function (model) {
        return model.Name;
    };
    $scope.taxs = {};
    $scope.saveItem = function (data, id, rowform, idx) {
        var selected = [];
        var idx = -1;
        selected = $filter('filter')($scope.taxs, { Id: id }, true)[0];
        idx = $scope.taxs.indexOf(selected);

        $scope.taxs[idx].Id = data.Id;
        $scope.taxs[idx].Name = data.Name;
        $scope.taxs[idx].Desc = data.Desc;
        if (data.isActive = true) {
            $scope.taxs[idx].isActive = true;
            $scope.tax.isActive = true;
        }
        else {
            $scope.taxs[idx].isActive = false;
            $scope.tax.isActive = false;
        }

        $scope.tax.Id = data.Id;
        $scope.tax.Name = data.Name;
        $scope.tax.Desc = data.Desc;

        MasterData.editTax($scope.tax)
                .then(function (data) {
                    if (data.status === true) {
                        $location.path('/tax');
                    }
                },
                     function () { alert('error while editing Category') }
                );
    }

}




TaxAddController.$inject = ['$scope', 'MasterData', '$location'];

function TaxAddController($scope, MasterData, $location) {

    $scope.tax = { Name: '', Desc: '', isActive: true };

    $scope.add = function () {
        MasterData.addTax($scope.tax)
       .then(function (data) {
           if (data.status === true) {
               $location.path('/tax');
           }
       },
             function () { alert('error while adding tax') }
        );
    };
}

TaxEditController.$inject = ['$scope', '$routeParams', '$location', 'MasterData'];

function TaxEditController($scope, $routeParams, $location, MasterData) {
    $scope.tax = {};
    MasterData.getTax($routeParams.id)
                             .then(function (tax) { $scope.tax = tax },
                                   function () { alert('error while updating tax') }
                            );
    $scope.edit = function () {
        MasterData.editTax($scope.tax)
       .then(function (data) {
           if (data.status === true) {
               $location.path('/tax');
           }
       },
             function () { alert('error while editing tax') }
       );
    };
}

