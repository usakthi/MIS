

ManufacturerListController.$inject = ['$scope', '$filter', '$route', 'MasterData', '$location'];

function ManufacturerListController($scope, $filter, $route, MasterData, $location) {
    $scope.manufs = [];

    MasterData.getAllManufacturers()
        .then(function (manufs) { $scope.manufs = manufs },
              function () { alert('error while fetching Manufacturer from server') }
         );

    $scope.manuf = { Name: '', Desc: '', isActive: true };

    $scope.add = function () {
        MasterData.addManufacturer($scope.manuf)
       .then(function (data) {
           if (data.status === true) {
               $location.path('/manf');
           }
       },
             function () { alert('error while adding DrugType') }
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

        selected = $filter('filter')($scope.manufs, { Id: order.Id }, true)[0];
        idx = $scope.manufs.indexOf(selected);
        if (idx > -1) {
            $scope.manufs.splice(idx, 1);
        }

    };
    $scope.showCategory = function (model) {
        return model.Name;
    };
    $scope.manuf = {};
    $scope.saveItem = function (data, id, rowform, idx) {
        var selected = [];
        var idx = -1;
        selected = $filter('filter')($scope.manufs, { Id: id }, true)[0];
        idx = $scope.manufs.indexOf(selected);

        $scope.manufs[idx].Id = data.Id;
        $scope.manufs[idx].Name = data.Name;
        $scope.manufs[idx].Desc = data.Desc;
        if (data.isActive = true) {
            $scope.manufs[idx].isActive = true;
            $scope.manuf.isActive = true;
        }
        else {
            $scope.manufs[idx].isActive = false;
            $scope.manuf.isActive = false;
        }

        $scope.manuf.Id = data.Id;
        $scope.manuf.Name = data.Name;
        $scope.manuf.Desc = data.Desc;

        MasterData.editManufacturer($scope.manuf)
                .then(function (data) {
                    if (data.status === true) {
                        $location.path('/manf');
                    }
                },
                     function () { alert('error while editing Category') }
                );
    }

}


ManufacturerAddController.$inject = ['$scope', 'MasterData', '$location'];

function ManufacturerAddController($scope, MasterData, $location) {

    $scope.manuf = { Name: '', Desc: '', isActive: true };

    $scope.add = function () {
        MasterData.addManufacturer($scope.manuf)
       .then(function (data) {
           if (data.status === true) {
               $location.path('/manf/manuf');
           }
       },
             function () { alert('error while adding Manufacturer') }
        );
    };
}

ManufacturerEditController.$inject = ['$scope', '$routeParams', '$location', 'MasterData'];

function ManufacturerEditController($scope, $routeParams, $location, MasterData) {
    $scope.manuf = {};
    MasterData.getManufacturer($routeParams.id)
                             .then(function (manuf) { $scope.manuf = manuf },
                                   function () { alert('error while updating Manufacturer') }
                            );
    $scope.edit = function () {
        MasterData.editManufacturer($scope.manuf)
       .then(function (data) {
           if (data.status === true) {
               $location.path('/manf/manuf');
           }
       },
             function () { alert('error while editing Manufacturer') }
       );
    };
}
