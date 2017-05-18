CategoryListController.$inject = ['$scope', '$filter', '$route', 'MasterData', '$location'];

function CategoryListController($scope, $filter, $route, MasterData, $location) {
    $scope.cats = [];

    MasterData.getAllDrugCategories()
        .then(function (cats) { $scope.cats = cats },
              function () { alert('error while fetching Category from server') }
         );


    $scope.cat = { Name: '', Desc: '', isActive: true };
    $scope.add = function () {
        MasterData.addDrugCategory($scope.cat)
       .then(function (data) {
           if (data.status === true) {
               $location.path('/category');
           }
       },
             function () { alert('error while adding Category') }
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

        selected = $filter('filter')($scope.cats, { Id: order.Id }, true)[0];
        idx = $scope.cats.indexOf(selected);
        if (idx > -1) {
            $scope.cats.splice(idx, 1);
        }

    };
    $scope.showCategory = function (model) {
        return model.Name;
    };
    $scope.cat = {};
    $scope.saveItem = function (data, id, rowform, idx) {
        var selected = [];
        var idx = -1;
        selected = $filter('filter')($scope.cats, { Id: id }, true)[0];
        idx = $scope.cats.indexOf(selected);

        $scope.cats[idx].Id = data.Id;
        $scope.cats[idx].Name = data.Name;
        $scope.cats[idx].Desc = data.Desc;
        if (data.isActive = true) {
            $scope.cats[idx].isActive = true;
            $scope.cat.isActive = true;
        }
        else {
            $scope.cats[idx].isActive = false;
            $scope.cat.isActive = false;
        }

        $scope.cat.Id = data.Id;
        $scope.cat.Name = data.Name;
        $scope.cat.Desc = data.Desc;

        MasterData.editDrugCategory($scope.cat)
                .then(function (data) {
                    if (data.status === true) {
                        $location.path('/category');
                    }
                },
                     function () { alert('error while editing Category') }
                );
    }
}


CategoryAddController.$inject = ['$scope', 'MasterData', '$location'];

function CategoryAddController($scope, MasterData, $location) {

    $scope.cat = { Name: '', Desc: '', isActive: true };
  
    $scope.add = function () {
        MasterData.addDrugCategory($scope.cat)
       .then(function (data) {
           if (data.status === true) {
               $location.path('/category');
           }
       },
             function () { alert('error while adding Category') }
        );
    };
}

CategoryEditController.$inject = ['$scope', '$routeParams', '$location', 'MasterData'];

function CategoryEditController($scope, $routeParams, $location, MasterData) {
    $scope.cat = {};
    MasterData.getDrugCategory($routeParams.id)
                             .then(function (cat) { $scope.cat = cat },
                                   function () { alert('error while updating Category') }
                            );
    $scope.edit = function () {
        MasterData.editDrugCategory($scope.cat)
       .then(function (data) {
           if (data.status === true) {
               $location.path('/category');
           }
       },
             function () { alert('error while editing Category') }
       );
    };
}