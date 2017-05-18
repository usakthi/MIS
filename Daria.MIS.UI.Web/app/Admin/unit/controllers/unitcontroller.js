
UnitMasterListController.$inject = ['$scope', '$filter', '$route', 'MasterData', '$location'];

function UnitMasterListController($scope, $filter, $route, MasterData, $location) {
    $scope.units = [];

    MasterData.getAllDrugUnits()
        .then(function (units) { $scope.units = units },
              function () { alert('error while fetching units from server') }
         );
    //$scope.delete = function (id) {
    //    $('#confirm-unit-delete').modal({ backdrop: false, keyboard: false })
    //        .one('click', '#delete', function () {
    //            MasterData.deleteDrugUnit(id)
    //                        .then(function (data) {
    //                            if (data.status === true) {
    //                                $route.reload();
    //                            }
    //                        },
    //                          function () { alert('error while deleting unit') }
    //                        );
    //        });//end of one
    //};
    $scope.unit = { Name: '', Desc: '', isActive: true };

    $scope.add = function () {
        MasterData.addDrugUnit($scope.unit)
       .then(function (data) {
           if (data.status === true) {
               $location.path('/unit');
           }
       },
             function () { alert('error while adding unit') }
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

        selected = $filter('filter')($scope.units, { Id: order.Id }, true)[0];
        idx = $scope.units.indexOf(selected);
        if (idx > -1) {
            $scope.units.splice(idx, 1);
        }

    };
    $scope.showCategory = function (model) {
        return model.Name;
    };
    $scope.unit = {};
    $scope.saveItem = function (data, id, rowform, idx) {
        var selected = [];
        var idx = -1;
        selected = $filter('filter')($scope.units, { Id: id }, true)[0];
        idx = $scope.units.indexOf(selected);

        $scope.units[idx].Id = data.Id;
        $scope.units[idx].Name = data.Name;
        $scope.units[idx].Desc = data.Desc;
        if (data.isActive = true) {
            $scope.units[idx].isActive = true;
            $scope.unit.isActive = true;
        }
        else {
            $scope.units[idx].isActive = false;
            $scope.unit.isActive = false;
        }

        $scope.unit.Id = data.Id;
        $scope.unit.Name = data.Name;
        $scope.unit.Desc = data.Desc;

        MasterData.editDrugUnit($scope.unit)
                .then(function (data) {
                    if (data.status === true) {
                        $location.path('/unit');
                    }
                },
                     function () { alert('error while editing Category') }
                );
    }
}


UnitMasterAddController.$inject = ['$scope', 'MasterData', '$location'];

function UnitMasterAddController($scope, MasterData, $location) {

    $scope.unit = { Name: '', Desc: '', isActive: true };

    $scope.add = function () {
        MasterData.addDrugUnit($scope.unit)
       .then(function (data) {
           if (data.status === true) {
               $location.path('/unit');
           }
       },
             function () { alert('error while adding unit') }
        );
    };
}

UnitMasterEditController.$inject = ['$scope', '$routeParams', '$location', 'MasterData'];

function UnitMasterEditController($scope, $routeParams, $location, MasterData) {
    $scope.unit = {};
    MasterData.getDrugUnit($routeParams.id)
                             .then(function (unit) { $scope.unit = unit },
                                   function () { alert('error while updating unit') }
                            );
    $scope.edit = function () {
        MasterData.editDrugUnit($scope.unit)
       .then(function (data) {
           if (data.status === true) {
               $location.path('/unit');
           }
       },
             function () { alert('error while editing unit') }
       );
    };
};