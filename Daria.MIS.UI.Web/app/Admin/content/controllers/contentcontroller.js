ContentListController.$inject = ['$scope', '$filter', '$route', 'MasterData', '$location'];

function ContentListController($scope, $filter, $route, MasterData, $location) {
    $scope.conts = [];

    MasterData.getAllDrugContents()
        .then(function (conts) { $scope.conts = conts },
              function () { alert('error while fetching Content from server') }
         );
    //$scope.delete = function (id) {
    //    $('#confirm-cont-delete').modal({ backdrop: false, keyboard: false })
    //        .one('click', '#delete', function () {
    //            MasterData.deleteDrugContent(id)
    //                        .then(function (data) {
    //                            if (data.status === true) {
    //                                $route.reload();
    //                            }
    //                        },
    //                          function () { alert('error while deleting Content') }
    //                        );
    //        });//end of one
    //};
    $scope.cont = { Name: '', Desc: '', isActive: true };

    $scope.add = function () {
        MasterData.addDrugContent($scope.cont)
       .then(function (data) {
           if (data.status === true) {
               $location.path('/content');
           }
       },
             function () { alert('error while adding Content') }
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

        selected = $filter('filter')($scope.conts, { Id: order.Id }, true)[0];
        idx = $scope.conts.indexOf(selected);
        if (idx > -1) {
            $scope.conts.splice(idx, 1);
        }

    };
    $scope.showCategory = function (model) {
        return model.Name;
    };
    $scope.cat = {};
    $scope.saveItem = function (data, id, rowform, idx) {
        var selected = [];
        var idx = -1;
        selected = $filter('filter')($scope.conts, { Id: id }, true)[0];
        idx = $scope.conts.indexOf(selected);

        $scope.conts[idx].Id = data.Id;
        $scope.conts[idx].Name = data.Name;
        $scope.conts[idx].Desc = data.Desc;
        if (data.isActive = true) {
            $scope.conts[idx].isActive = true;
            $scope.cont.isActive = true;
        }
        else {
            $scope.conts[idx].isActive = false;
            $scope.cont.isActive = false;
        }

        $scope.cont.Id = data.Id;
        $scope.cont.Name = data.Name;
        $scope.cont.Desc = data.Desc;

        MasterData.editDrugContent($scope.cont)
                .then(function (data) {
                    if (data.status === true) {
                        $location.path('/content');
                    }
                },
                     function () { alert('error while editing Category') }
                );
    }
}


ContentAddController.$inject = ['$scope', 'MasterData', '$location'];

function ContentAddController($scope, MasterData, $location) {

    $scope.cont = { Name: '', Desc: '', isActive: true };

    $scope.add = function () {
        MasterData.addDrugContent($scope.cont)
       .then(function (data) {
           if (data.status === true) {
               $location.path('/content');
           }
       },
             function () { alert('error while adding Content') }
        );
    };
}

ContentEditController.$inject = ['$scope', '$routeParams', '$location', 'MasterData'];

function ContentEditController($scope, $routeParams, $location, MasterData) {
    $scope.cont = {};
    MasterData.getDrugContent($routeParams.id)
                             .then(function (cont) { $scope.cont = cont },
                                   function () { alert('error while updating Content') }
                            );
    $scope.edit = function () {
        MasterData.editDrugContent($scope.cont)
       .then(function (data) {
           if (data.status === true) {
               $location.path('/content');
           }
       },
             function () { alert('error while editing Content') }
       );
    };
}