
PatientListController.$inject = ['$scope', '$route', 'MasterData'];

function PatientListController($scope, $route, MasterData) {
    $scope.customers = [];
    
    MasterData.getAllCustomers()
            .then(function (customers) { $scope.customers = customers },
                  function () { alert('error while fetching Customer from server') }
             );
    $scope.delete = function (id) {
        $('#confirm-patient-delete').modal({ backdrop: false, keyboard: false })
            .one('click', '#delete', function () {
                MasterData.deleteCustomer(id)
                            .then(function (data) {
                                if (data.status === true) {
                                    $route.reload();
                                }
                            },
                              function () { alert('error while deleting Customer') }
                            );
            });//end of one
    };
}

PatientAddController.$inject = ['$scope', 'MasterData', '$location'];
function PatientAddController($scope, MasterData, $location) {

    $scope.customer = {};

    $scope.add = function () {
        MasterData.addCustomer($scope.customer)
       .then(function (data) {
           if (data.status === true) {
               $location.path('/patient');
           }
       },
             function () { alert('error while adding customer') }
        );
    };
}

PatientEditController.$inject = ['$scope', '$routeParams', '$location', 'MasterData'];

function PatientEditController($scope, $routeParams, $location, MasterData) {
    $scope.customer = {};
    
    MasterData.getCustomer($routeParams.id)
                                 .then(function (customer) { $scope.customer = customer },
                                       function () { alert('error while updating customer') }
                                );
    $scope.edit = function () {
        MasterData.editCustomer($scope.customer)
       .then(function (data) {
           if (data.status === true) {
               $location.path('/patient');
           }
       },
             function () { alert('error while editing customer') }
       );
    };
}

