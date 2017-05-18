

DepartmentListController.$inject = ['$scope', '$filter', '$route', 'MasterData', '$location'];
function DepartmentListController($scope, $filter, $route, MasterData, $location) {
    $scope.depts = [];

    MasterData.getAllDepartments()
        .then(function (depts) { $scope.depts = depts },
              function () { alert('error while fetching department from server') }
         );
    //$scope.delete = function (id) {
    //    $('#confirm-dept-delete').modal({ backdrop: false, keyboard: false })
    //        .one('click', '#delete', function () {
    //            MasterData.deleteDepartment(id)
    //                        .then(function (data) {
    //                            if (data.status === true) {
    //                                $route.reload();
    //                            }
    //                        },
    //                          function () { alert('error while deleting department') }
    //                        );
    //        });//end of one
    //};
    $scope.dept = { Name: '', Desc: '', isActive: true };

    $scope.add = function () {
        MasterData.addDepartment($scope.dept)
       .then(function (data) {
           if (data.status === true) {
               $location.path('/department');
           }
       },
             function () { alert('error while adding department') }
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

        selected = $filter('filter')($scope.depts, { Id: order.Id }, true)[0];
        idx = $scope.depts.indexOf(selected);
        if (idx > -1) {
            $scope.depts.splice(idx, 1);
        }

    };
    $scope.showCategory = function (model) {
        return model.Name;
    };
    $scope.depts = {};
    $scope.saveItem = function (data, id, rowform, idx) {
        var selected = [];
        var idx = -1;
        selected = $filter('filter')($scope.depts, { Id: id }, true)[0];
        idx = $scope.depts.indexOf(selected);

        $scope.depts[idx].Id = data.Id;
        $scope.depts[idx].Name = data.Name;
        $scope.depts[idx].Desc = data.Desc;
        if (data.isActive = true) {
            $scope.depts[idx].isActive = true;
            $scope.dept.isActive = true;
        }
        else {
            $scope.depts[idx].isActive = false;
            $scope.dept.isActive = false;
        }

        $scope.dept.Id = data.Id;
        $scope.dept.Name = data.Name;
        $scope.dept.Desc = data.Desc;

        MasterData.editDepartment($scope.dept)
                .then(function (data) {
                    if (data.status === true) {
                        $location.path('/department');
                    }
                },
                     function () { alert('error while editing Category') }
                );
    }

}


DepartmentAddController.$inject = ['$scope', 'MasterData', '$location'];

function DepartmentAddController($scope, MasterData, $location) {

    $scope.dept = { Name: '', Desc: '', isActive: true };

    $scope.add = function () {
        MasterData.addDepartment($scope.dept)
       .then(function (data) {
           if (data.status === true) {
               $location.path('/department');
           }
       },
             function () { alert('error while adding department') }
        );
    };
}

DepartmentEditController.$inject = ['$scope', '$routeParams', '$location', 'MasterData'];

function DepartmentEditController($scope, $routeParams, $location, MasterData) {
    $scope.dept = {};
    MasterData.getDepartment($routeParams.id)
                             .then(function (dept) { $scope.dept = dept },
                                   function () { alert('error while updating department') }
                            );
    $scope.edit = function () {
        MasterData.editDepartment($scope.dept)
       .then(function (data) {
           if (data.status === true) {
               $location.path('/department');
           }
       },
             function () { alert('error while editing department') }
       );
    };
}
