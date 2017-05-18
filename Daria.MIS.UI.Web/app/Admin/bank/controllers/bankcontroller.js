BankListController.$inject = ['$scope', '$filter', '$route', 'MasterData', '$location'];

function BankListController($scope, $filter, $route, MasterData, $location) {
        $scope.bans = [];

        MasterData.getAllBanks()
            .then(function (bans) { $scope.bans = bans },
                  function () { alert('error while fetching bank from server') }
             );
        //$scope.delete = function (id) {
        //    $('#confirm-ban-delete').modal({ backdrop: false, keyboard: false })
        //        .one('click', '#delete', function () {
        //            MasterData.deleteBank(id)
        //                        .then(function (data) {
        //                            if (data.status === true) {
        //                                $route.reload();
        //                            }
        //                        },
        //                          function () { alert('error while deleting bank') }
        //                        );
        //        });//end of one
        //};

        $scope.ban = { Name: '', Desc: '', isActive: true };

        $scope.add = function () {
            MasterData.addBank($scope.ban)
           .then(function (data) {
               if (data.status === true) {
                   $location.path('/bank');
               }
           },
                 function () { alert('error while adding bank') }
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

            selected = $filter('filter')($scope.bans, { Id: order.Id }, true)[0];
            idx = $scope.bans.indexOf(selected);
            if (idx > -1) {
                $scope.bans.splice(idx, 1);
            }

        };
        $scope.showCategory = function (model) {
            return model.Name;
        };
        $scope.bans = {};
        $scope.saveItem = function (data, id, rowform, idx) {
            var selected = [];
            var idx = -1;
            selected = $filter('filter')($scope.bans, { Id: id }, true)[0];
            idx = $scope.bans.indexOf(selected);

            $scope.bans[idx].Id = data.Id;
            $scope.bans[idx].Name = data.Name;
            $scope.bans[idx].Desc = data.Desc;
            if (data.isActive = true) {
                $scope.bans[idx].isActive = true;
                $scope.ban.isActive = true;
            }
            else {
                $scope.bans[idx].isActive = false;
                $scope.ban.isActive = false;
            }

            $scope.ban.Id = data.Id;
            $scope.ban.Name = data.Name;
            $scope.ban.Desc = data.Desc;

            MasterData.editBank($scope.ban)
                    .then(function (data) {
                        if (data.status === true) {
                            $location.path('/bank');
                        }
                    },
                         function () { alert('error while editing Category') }
                    );
        }


    }

    
    BankAddController.$inject = ['$scope', 'MasterData', '$location'];

    function BankAddController($scope, MasterData, $location) {

        $scope.ban = { Name: '', Desc: '', isActive: true };

        $scope.add = function () {
            MasterData.addBank($scope.ban)
           .then(function (data) {
               if (data.status === true) {
                   $location.path('/bank');
               }
           },
                 function () { alert('error while adding bank') }
            );
        };

           
    }

    BankEditController.$inject = ['$scope', '$routeParams', '$location', 'MasterData'];

    function BankEditController($scope, $routeParams, $location, MasterData) {
        $scope.ban = {};
        
        MasterData.getBank($routeParams.id)
                                 .then(function (ban) { $scope.ban = ban },
                                       function () { alert('error while updating bank') }
                                );
       
        $scope.edit = function () {
            MasterData.editBank($scope.ban)
           .then(function (data) {
               if (data.status === true) {
                   $location.path('/bank');
               }
            },
                 function () { alert('error while editing bank') }
           );
        };
    }  

