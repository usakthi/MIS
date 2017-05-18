    DrugGenericMasterListController.$inject = ['$scope', '$route', 'MasterData'];

    function DrugGenericMasterListController($scope, $route, MasterData) {
        $scope.druggenerics = [];
        
        MasterData.getAllDrugGenerics()
            .then(function (druggenerics) { $scope.druggenerics = druggenerics },
                  function () { alert('error while fetching druggeneric from server') }
             );
        $scope.delete = function (id) {
            $('#confirm-druggeneric-delete').modal({ backdrop: false, keyboard: false })
                .one('click', '#delete', function () {
                    MasterData.deleteDrugGeneric(id)
                                .then(function (data) {
                                    if (data.status === true) {
                                        $route.reload();
                                    }
                                },
                                  function () { alert('error while deleting druggeneric') }
                                );
                });//end of one
        };
       
    }

    
    DrugGenericMasterAddController.$inject = ['$scope', 'MasterData', '$location'];

    function DrugGenericMasterAddController($scope, MasterData, $location) {
        $scope.druggeneric = { Name: '', Desc: '', isActive: true };
        $scope.add = function () {
            MasterData.addDrugGeneric($scope.druggeneric)
           .then(function (data) {
               if (data.status === true) {
                   $location.path('/druggeneric');
               }
           },
                 function () { alert('error while adding druggeneric') }
            );
        };
    }

    DrugGenericMasterEditController.$inject = ['$scope', '$routeParams', '$location', 'MasterData'];

    function DrugGenericMasterEditController($scope, $routeParams, $location, MasterData) {
        $scope.druggeneric = {};
        MasterData.getDrugGeneric($routeParams.id)
                                 .then(function (druggeneric) { $scope.druggeneric = druggeneric },
                                       function () { alert('error while updating druggeneric') }
                                );
        $scope.edit = function () {
            MasterData.editDrugGeneric($scope.druggeneric)
           .then(function (data) {
               if (data.status === true) {
                   $location.path('/druggeneric');
               }
            },
                 function () { alert('error while editing druggeneric') }
           );
        };
    }  
