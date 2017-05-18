
ConsultantListController.$inject = ['$scope', '$filter', '$route', 'MasterData', '$location'];

function ConsultantListController($scope, $filter, $route, MasterData, $location) {
    $scope.cons = [];

    MasterData.getAllConsultants()
        .then(function (cons) { $scope.cons = cons },
              function () { alert('error while fetching consultant from server') }
         );
    //$scope.delete = function (id) {
    //    $('#confirm-con-delete').modal({ backdrop: false, keyboard: false })
    //        .one('click', '#delete', function () {
    //            MasterData.deleteConsultant(id)
    //                        .then(function (data) {
    //                            if (data.status === true) {
    //                                $route.reload();
    //                            }
    //                        },
    //                          function () { alert('error while deleting consultant') }
    //                        );
    //        });//end of one
    //};
    $scope.con = { Name: '', Desc: '', isActive: true };

    $scope.add = function () {
        MasterData.addConsultant($scope.con)
       .then(function (data) {
           if (data.status === true) {
               $location.path('/consultant');
           }
       },
             function () { alert('error while adding consultant') }
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

        selected = $filter('filter')($scope.cons, { Id: order.Id }, true)[0];
        idx = $scope.cons.indexOf(selected);
        if (idx > -1) {
            $scope.cons.splice(idx, 1);
        }

    };
    $scope.showCategory = function (model) {
        return model.Name;
    };
    $scope.cons = {};
    $scope.saveItem = function (data, id, rowform, idx) {
        var selected = [];
        var idx = -1;
        selected = $filter('filter')($scope.cons, { Id: id }, true)[0];
        idx = $scope.cons.indexOf(selected);

        $scope.cons[idx].Id = data.Id;
        $scope.cons[idx].Name = data.Name;
        $scope.cons[idx].Desc = data.Desc;
        if (data.isActive = true) {
            $scope.cons[idx].isActive = true;
            $scope.con.isActive = true;
        }
        else {
            $scope.cons[idx].isActive = false;
            $scope.con.isActive = false;
        }

        $scope.con.Id = data.Id;
        $scope.con.Name = data.Name;
        $scope.con.Desc = data.Desc;

        MasterData.editConsultant($scope.con)
                .then(function (data) {
                    if (data.status === true) {
                        $location.path('/consultant');
                    }
                },
                     function () { alert('error while editing Category') }
                );
    }

}


ConsultantAddController.$inject = ['$scope', 'MasterData', '$location'];

function ConsultantAddController($scope, MasterData, $location) {

    $scope.con = { Name: '', Desc: '', isActive: true };

    $scope.add = function () {
        MasterData.addConsultant($scope.con)
       .then(function (data) {
           if (data.status === true) {
               $location.path('/consultant');
           }
       },
             function () { alert('error while adding consultant') }
        );
    };
}

ConsultantEditController.$inject = ['$scope', '$routeParams', '$location', 'MasterData'];

function ConsultantEditController($scope, $routeParams, $location, MasterData) {
    $scope.con = {};
    MasterData.getConsultant($routeParams.id)
                             .then(function (con) { $scope.con = con },
                                   function () { alert('error while updating consultant') }
                            );
    $scope.edit = function () {
        MasterData.editConsultant($scope.con)
       .then(function (data) {
           if (data.status === true) {
               $location.path('/consultant');
           }
       },
             function () { alert('error while editing consultant') }
       );
    };
}
