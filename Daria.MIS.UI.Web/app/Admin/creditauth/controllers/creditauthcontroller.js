    CreditAuthListController.$inject = ['$scope', '$route', 'MasterData'];

    function CreditAuthListController($scope, $route, MasterData) {
        $scope.creditauths = [];

        MasterData.getAllCreditAuths()
            .then(function (creditauths) { $scope.creditauths = creditauths },
                  function () { alert('error while fetching creditauth from server') }
             );
        $scope.delete = function (id) {
            $('#confirm-creditauth-delete').modal({ backdrop: false, keyboard: false })
                .one('click', '#delete', function () {
                    MasterData.deleteCreditAuth(id)
                                .then(function (data) {
                                    if (data.status === true) {
                                        $route.reload();
                                    }
                                },
                                  function () { alert('error while deleting creditauth') }
                                );
                });//end of one
        };
        $scope.creditauth = { Name: '', Desc: '', isActive: true };

        $scope.add = function () {
            MasterData.addCreditAuth($scope.creditauth)
           .then(function (data) {
               if (data.status === true) {
                   $location.path('/creditauth');
               }
           },
                 function () { alert('error while adding creditauth') }
            );
        };
    }

    
    CreditAuthAddController.$inject = ['$scope', 'MasterData', '$location'];

    function CreditAuthAddController($scope, MasterData, $location) {

        $scope.creditauth = { Name: '', Desc: '', isActive: true };

        $scope.add = function () {
            MasterData.addCreditAuth($scope.creditauth)
           .then(function (data) {
               if (data.status === true) {
                   $location.path('/creditauth');
               }
           },
                 function () { alert('error while adding creditauth') }
            );
        };
    }

    CreditAuthEditController.$inject = ['$scope', '$routeParams', '$location', 'MasterData'];

    function CreditAuthEditController($scope, $routeParams, $location, MasterData) {
        $scope.creditauth = {};
        MasterData.getCreditAuth($routeParams.id)
                                 .then(function (creditauth) { $scope.creditauth = creditauth },
                                       function () { alert('error while updating creditauth') }
                                );
        $scope.edit = function () {
            MasterData.editCreditAuth($scope.creditauth)
           .then(function (data) {
               if (data.status === true) {
                   $location.path('/creditauth');
               }
            },
                 function () { alert('error while editing creditauth') }
           );
        };
    }  
