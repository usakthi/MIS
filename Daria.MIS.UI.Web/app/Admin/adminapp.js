(function () {
    'use strict';

    config.$inject = ['$routeProvider', '$locationProvider', 'ivhTreeviewOptionsProvider'];

    angular.module('adminApp', [
        'ngRoute', 'adminServices', 'ivh.treeview', 'ui.bootstrap', 'xeditable', 'ui.grid', 'ui.grid.pagination'])
    
    .config(['$httpProvider', function ($httpProvider) {
        $httpProvider.defaults.headers.common["X-Requested-With"] = 'XMLHttpRequest';
        //http://thecodebarbarian.com/2015/01/24/angularjs-interceptors
        $httpProvider.interceptors.push(function ($location) {
            return {
                request: function(request) {                   
                    return request;
                },
                // This is the responseError interceptor
                responseError: function(rejection) {                    
                    if (rejection.status === 403 && rejection.data && rejection.data.Redirect) {
                        // Return a new promise                       
                        $location.path(rejection.data.Redirect);
                    }
                    return rejection;
                }
            };
        });

    }])
    .config(config);

    function config($routeProvider, $locationProvider,ivhTreeviewOptionsProvider) {
        $routeProvider
            .when('/', {
                templateUrl: '/app/admin/unit/views/listunit.html',
                controller: 'UnitMasterListController'
            })
             .when('/unit', {
                 templateUrl: '/app/admin/unit/views/listunit.html',
                 controller: 'UnitMasterListController'
             })
            .when('/unit/add', {
                templateUrl: '/app/admin/unit/views/addunit.html',
                controller: 'UnitMasterAddController'
            })
            .when('/unit/edit/:id', {
                templateUrl: '/app/admin/unit/views/editunit.html',
                controller: 'UnitMasterEditController'
            })
            .when('/category', {
                templateUrl: '/app/admin/category/views/listcategory.html',
                controller: 'CategoryListController'
            })
             .when('/category', {
                 templateUrl: '/app/admin/category/views/listcategory.html',
                 controller: 'CategoryListController'
             })
            .when('/category/add', {
                templateUrl: '/app/admin/category/views/addcategory.html',
                controller: 'CategoryAddController'
            })
            .when('/category/edit/:id', {
                templateUrl: '/app/admin/category/views/editcategory.html',
                controller: 'CategoryEditController'
            })
             .when('/content', {
                 templateUrl: '/app/admin/content/views/listcontent.html',
                 controller: 'ContentListController'
             })
             .when('/content', {
                 templateUrl: '/app/admin/content/views/listcontent.html',
                 controller: 'ContentListController'
             })
            .when('/content/add', {
                templateUrl: '/app/admin/content/views/addcontent.html',
                controller: 'ContentAddController'
            })
            .when('/content/edit/:id', {
                templateUrl: '/app/admin/content/views/editcontent.html',
                controller: 'ContentEditController'
            })
             .when('/department', {
                 templateUrl: '/app/admin/department/views/listdepartment.html',
                 controller: 'DepartmentListController'
             })
             .when('/department', {
                 templateUrl: '/app/admin/department/views/listdepartment.html',
                 controller: 'DepartmentListController'
             })
            .when('/department/add', {
                templateUrl: '/app/admin/department/views/adddepartment.html',
                controller: 'DepartmentAddController'
            })
            .when('/department/edit/:id', {
                templateUrl: '/app/admin/department/views/editdepartment.html',
                controller: 'DepartmentEditController'
            })
             .when('/drugtype', {
                 templateUrl: '/app/admin/drugtype/views/listdrugtype.html',
                 controller: 'DrugtypeListController'
             })
             .when('/drugtype', {
                 templateUrl: '/app/admin/drugtype/views/listdrugtype.html',
                 controller: 'DrugtypeListController'
             })
            .when('/drugtype/add', {
                templateUrl: '/app/admin/drugtype/views/adddrugtype.html',
                controller: 'DrugtypeAddController'
            })
            .when('/drugtype/edit/:id', {
                templateUrl: '/app/admin/drugtype/views/editdrugtype.html',
                controller: 'DrugtypeEditController'
            })
            .when('/manf', {
                templateUrl: '/app/admin/manf/views/listmanufacturer.html',
                controller: 'ManufacturerListController'
            })
             .when('/manf', {
                 templateUrl: '/app/admin/manf/views/listmanufacturer.html',
                 controller: 'ManufacturerListController'
             })
            .when('/manf/add', {
                templateUrl: '/app/admin/manf/views/addmanufacturer.html',
                controller: 'ManufacturerAddController'
            })
            .when('/manf/edit/:id', {
                templateUrl: '/app/admin/manf/views/editmanufacturer.html',
                controller: 'ManufacturerEditController'
            })
             .when('/rack', {
                 templateUrl: '/app/admin/rack/views/listrack.html',
                 controller: 'RackListController'
             })
             .when('/rack', {
                 templateUrl: '/app/admin/rack/views/listrack.html',
                 controller: 'RackListController'
             })
            .when('/rack/add', {
                templateUrl: '/app/admin/rack/views/addrack.html',
                controller: 'RackAddController'
            })
            .when('/rack/edit/:id', {
                templateUrl: '/app/admin/rack/views/editrack.html',
                controller: 'RackEditController'
            })
            .when('/tax', {
                templateUrl: '/app/admin/tax/views/listtax.html',
                controller: 'TaxListController'
            })
             .when('/tax', {
                 templateUrl: '/app/admin/tax/views/listtax.html',
                 controller: 'TaxListController'
             })
            .when('/tax/add', {
                templateUrl: '/app/admin/tax/views/addtax.html',
                controller: 'TaxAddController'
            })
            .when('/tax/edit/:id', {
                templateUrl: '/app/admin/tax/views/edittax.html',
                controller: 'TaxEditController'
            })
            .when('/bank', {
                templateUrl: '/app/admin/bank/views/listbank.html',
                controller: 'BankListController'
            })

            .when('/bank/add', {
                templateUrl: '/app/admin/bank/views/addbank.html',
                controller: 'BankAddController'
            })
            .when('/bank/edit/:id', {
                templateUrl: '/app/admin/bank/views/editbank.html',
                controller: 'BankEditController'
            })
            .when('/creditauth', {
                templateUrl: '/app/admin/creditauth/views/listcreditauth.html',
                controller: 'CreditAuthListController'
            })
            .when('/creditauth', {
                templateUrl: '/app/admin/creditauth/views/listcreditauth.html',
                controller: 'CreditAuthListController'
            })
           .when('/creditauth/add', {
               templateUrl: '/app/admin/creditauth/views/addcreditauth.html',
               controller: 'CreditAuthAddController'
           })
           .when('/creditauth/edit/:id', {
               templateUrl: '/app/admin/creditauth/views/editcreditauth.html',
               controller: 'CreditAuthEditController'
           })
            .when('/druggeneric', {
                templateUrl: '/app/admin/druggeneric/views/listdruggeneric.html',
                controller: 'DrugGenericMasterListController'
            })
            .when('/druggeneric', {
                templateUrl: '/app/admin/druggeneric/views/listdruggeneric.html',
                controller: 'DrugGenericMasterListController'
            })
           .when('/druggeneric/add', {
               templateUrl: '/app/admin/druggeneric/views/adddruggeneric.html',
               controller: 'DrugGenericMasterAddController'
           })
           .when('/druggeneric/edit/:id', {
               templateUrl: '/app/admin/druggeneric/views/editdruggeneric.html',
               controller: 'DrugGenericMasterEditController'
           })
         .when('/product', {
             templateUrl: '/app/admin/product/views/listproduct.html',
             controller: 'ProductListController'
         })
            .when('/product', {
                templateUrl: '/app/admin/product/views/listproduct.html',
                controller: 'ProductListController'
            })
           .when('/product/add', {
               templateUrl: '/app/admin/product/views/addproduct.html',
               controller: 'ProductAddController'
           })
           .when('/product/edit/:id', {
               templateUrl: '/app/admin/product/views/editproduct.html',
               controller: 'ProductEditController'
           })
          .when('/purchaserequest', {
              templateUrl: '/app/admin/purchaserequest/views/listpurchaserequest.html',
              controller: 'PurchaseRequestDetailsListController'
          })
           .when('/purchaserequest/add', {
               templateUrl: '/app/admin/purchaserequest/views/addpurchaserequest.html',
               controller: 'PurchaseRequestDetailsAddController'
           })
           .when('/purchaserequest/edit/:id', {
               templateUrl: '/app/admin/purchaserequest/views/editpurchaserequest.html',
               controller: 'PurchaseRequestDetailsEditController'
           })
            .when('/supplier', {
                templateUrl: '/app/admin/supplier/views/listsupplier.html',
                controller: 'SupplierListController'
            })

            .when('/supplier/add', {
                templateUrl: '/app/admin/supplier/views/addsupplier.html',
                controller: 'SupplierAddController'
            })
            .when('/supplier/edit/:id', {
                templateUrl: '/app/admin/supplier/views/editsupplier.html',
                controller: 'SupplierEditController'
            })

        .when('/consultant', {
            templateUrl: '/app/admin/consultant/views/listconsultant.html',
            controller: 'ConsultantListController'
        })

            .when('/consultant/add', {
                templateUrl: '/app/admin/consultant/views/addconsultant.html',
                controller: 'ConsultantAddController'
            })
            .when('/consultant/edit/:id', {
                templateUrl: '/app/admin/consultant/views/editconsultant.html',
                controller: 'ConsultantEditController'
            })

        .when('/role', {
            templateUrl: '/app/admin/role/views/listrole.html',
            controller: 'RoleListController'
        })

           .when('/role/add', {
               templateUrl: '/app/admin/role/views/editrole.html',
               controller: 'RoleEditController'
           })
           .when('/role/edit/:id', {
               templateUrl: '/app/admin/role/views/editrole.html',
               controller: 'RoleEditController'
           })

           .when('/patient', {
               templateUrl: '/app/admin/patient/views/listpatient.html',
               controller: 'PatientListController'
           })
           .when('/patient/add', {
               templateUrl: '/app/admin/patient/views/addpatient.html',
               controller: 'PatientAddController'
           })
           .when('/patient/edit/:id', {
               templateUrl: '/app/admin/patient/views/editpatient.html',
               controller: 'PatientEditController'
           });

        //.when('/user', {
        //    templateUrl: '/app/admin/user/views/listuser.html',
        //    controller: 'UserListController'
        //})
        //   .when('/user/add', {
        //       templateUrl: '/app/admin/user/views/adduser.html',
        //       controller: 'UserAddController'
        //   })
        //   .when('/user/edit/:id', {
        //       templateUrl: '/app/admin/user/views/edituser.html',
        //       controller: 'UserEditController'
        //   })
        //    .when('/error/noAccess', {
        //        templateUrl: '/app/common/views/noAccess.html'
        //    });

        //$locationProvider.html5Mode(true);
        ivhTreeviewOptionsProvider.set(
        {
            defaultSelectedState: false,
            validate: true,
            twistieCollapsedTpl: '<span class="glyphicon glyphicon-chevron-right"></span>',
            twistieExpandedTpl: '<span class="glyphicon glyphicon-chevron-down"></span>',
            twistieLeafTpl: '&#9679;'
        });
    }

})();