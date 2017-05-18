RoleListController.$inject = ['$scope', '$route', 'MasterData'];

function RoleListController($scope, $route, MasterData) {
    $scope.roles = [];

    MasterData.getAllRoles()
        .then(function (roles) { $scope.roles = roles },
              function () { alert('error while fetching roles from server') }
         );
    $scope.delete = function (id) {
        $('#confirm-role-delete').modal({ backdrop: false, keyboard: false })
            .one('click', '#delete', function () {
                MasterData.deleteRole(id)
                            .then(function (data) {
                                if (data.status === true) {
                                    $route.reload();
                                }
                            },
                              function () { alert('error while deleting role') }
                            );
            });//end of one
    };

}

RoleEditController.$inject = ['$scope', '$routeParams', '$location', 'MasterData'];

function RoleEditController($scope, $routeParams, $location, MasterData) {

    $scope.RoleViewModel = {};
    $scope.RoleViewModel.TreeData = [];
    MasterData.getRole($routeParams.id)
                             .then(function (data) {
                                 $scope.RoleViewModel.Role = data.Role;
                                 $scope.RoleViewModel.TreeData = data.TreeData;
                             },
                                   function () { alert('error while updating role') }
                            );

    $scope.edit = function () {

        MasterData.saveRole($scope.RoleViewModel)
       .then(function (data) {
           if (data.status === true) {
               $location.path('/role');
           }
       },
             function () { alert('error while editing role') }
       );
    };
}

