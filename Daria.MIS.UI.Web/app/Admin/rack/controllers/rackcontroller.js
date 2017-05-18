

RackListController.$inject = ['$scope', '$filter', '$route', 'MasterData', '$location'];

function RackListController($scope, $filter, $route, MasterData, $location) {
    $scope.racks = [];

    MasterData.getAllRacks()
        .then(function (racks) { $scope.racks = racks },
              function () { alert('error while fetching racks from server') }
         );
    //$scope.delete = function (id) {
    //    $('#confirm-rack-delete').modal({ backdrop: false, keyboard: false })
    //        .one('click', '#delete', function () {
    //            MasterData.deleteRack(id)
    //                        .then(function (data) {
    //                            if (data.status === true) {
    //                                $route.reload();
    //                            }
    //                        },
    //                          function () { alert('error while deleting racks') }
    //                        );
    //        });//end of one
    //};
    $scope.rack = { Name: '', Desc: '', isActive: true };

    $scope.add = function () {
        MasterData.addRack($scope.rack)
       .then(function (data) {
           if (data.status === true) {
               $location.path('/rack');
           }
       },
             function () { alert('error while adding rack') }
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

        selected = $filter('filter')($scope.racks, { Id: order.Id }, true)[0];
        idx = $scope.racks.indexOf(selected);
        if (idx > -1) {
            $scope.racks.splice(idx, 1);
        }

    };
    $scope.showCategory = function (model) {
        return model.Name;
    };
    $scope.rack = {};
    $scope.saveItem = function (data, id, rowform, idx) {
        var selected = [];
        var idx = -1;
        selected = $filter('filter')($scope.racks, { Id: id }, true)[0];
        idx = $scope.racks.indexOf(selected);

        $scope.racks[idx].Id = data.Id;
        $scope.racks[idx].Name = data.Name;
        $scope.racks[idx].Desc = data.Desc;
        if (data.isActive = true) {
            $scope.racks[idx].isActive = true;
            $scope.rack.isActive = true;
        }
        else {
            $scope.racks[idx].isActive = false;
            $scope.rack.isActive = false;
        }

        $scope.rack.Id = data.Id;
        $scope.rack.Name = data.Name;
        $scope.rack.Desc = data.Desc;

        MasterData.editRack($scope.rack)
                .then(function (data) {
                    if (data.status === true) {
                        $location.path('/rack');
                    }
                },
                     function () { alert('error while editing Category') }
                );
    }
}


RackAddController.$inject = ['$scope', 'MasterData', '$location'];

function RackAddController($scope, MasterData, $location) {

    $scope.rack = { Name: '', Desc: '', isActive: true };

    $scope.add = function () {
        MasterData.addRack($scope.rack)
       .then(function (data) {
           if (data.status === true) {
               $location.path('/rack');
           }
       },
             function () { alert('error while adding rack') }
        );
    };
}

RackEditController.$inject = ['$scope', '$routeParams', '$location', 'MasterData'];

function RackEditController($scope, $routeParams, $location, MasterData) {
    $scope.dept = {};
    MasterData.getRack($routeParams.id)
                             .then(function (rack) { $scope.rack = rack },
                                   function () { alert('error while updating rack') }
                            );
    $scope.edit = function () {
        MasterData.editRack($scope.rack)
       .then(function (data) {
           if (data.status === true) {
               $location.path('/rack');
           }
       },
             function () { alert('error while editing rack') }
       );
    };
}
