
DrugtypeListController.$inject = ['$scope', '$filter', '$route', 'MasterData', '$location'];

function DrugtypeListController($scope, $filter, $route, MasterData, $location) {
    $scope.types = [];

    MasterData.getAllDrugTypes()
        .then(function (types) { $scope.types = types },
              function () { alert('error while fetching DrugType from server') }
         );

    $scope.type = { Name: '', Desc: '', isActive: true };

    $scope.add = function () {
        MasterData.addDrugType($scope.type)
       .then(function (data) {
           if (data.status === true) {
               $location.path('/drugtype');
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

        selected = $filter('filter')($scope.types, { Id: order.Id }, true)[0];
        idx = $scope.types.indexOf(selected);
        if (idx > -1) {
            $scope.types.splice(idx, 1);
        }

    };
    $scope.showCategory = function (model) {
        return model.Name;
    };
    $scope.type = {};
    $scope.saveItem = function (data, id, rowform, idx) {
        var selected = [];
        var idx = -1;
        selected = $filter('filter')($scope.types, { Id: id }, true)[0];
        idx = $scope.types.indexOf(selected);

        $scope.types[idx].Id = data.Id;
        $scope.types[idx].Name = data.Name;
        $scope.types[idx].Desc = data.Desc;
        if (data.isActive = true) {
            $scope.types[idx].isActive = true;
            $scope.type.isActive = true;
        }
        else {
            $scope.types[idx].isActive = false;
            $scope.type.isActive = false;
        }

        $scope.type.Id = data.Id;
        $scope.type.Name = data.Name;
        $scope.type.Desc = data.Desc;

        MasterData.editDrugType($scope.type)
                .then(function (data) {
                    if (data.status === true) {
                        $location.path('/drugtype');
                    }
                },
                     function () { alert('error while editing Category') }
                );
    }

}


DrugtypeAddController.$inject = ['$scope', 'MasterData', '$location'];

function DrugtypeAddController($scope, MasterData, $location) {

    $scope.type = { Name: '', Desc: '', isActive: true };

    $scope.add = function () {
        MasterData.addDrugType($scope.type)
       .then(function (data) {
           if (data.status === true) {
               $location.path('/drugtype');
           }
       },
             function () { alert('error while adding DrugType') }
        );
    };
}

DrugtypeEditController.$inject = ['$scope', '$routeParams', '$location', 'MasterData'];

function DrugtypeEditController($scope, $routeParams, $location, MasterData) {
    $scope.type = {};
    MasterData.getDrugType($routeParams.id)
                             .then(function (type) { $scope.type = type },
                                   function () { alert('error while updating DrugType') }
                            );
    $scope.edit = function () {
        MasterData.editDrugType($scope.type)
       .then(function (data) {
           if (data.status === true) {
               $location.path('/drugtype');
           }
       },
             function () { alert('error while editing DrugType') }
       );
    };
}


