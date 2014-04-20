angular.module('ngApp').controller 'ApplicationController', ($scope, USER_ROLES, $modal, AUTH_EVENTS) ->
    $scope.currentUser = null
    $scope.userRoles = USER_ROLES
    $scope.isAuthorized = false
     
    $scope.showLogin = ->
        loginModal = $modal.open
            templateUrl: 'loginModal.html'
            controller: 'LoginController'
            backdrop: false
            keyboard: true
        loginModal.result.then ->
                console.log 'succ'
                loginModal = undefined
            , ->
                console.log 'cancelled'
                loginModal = undefined
        
    $scope.$on AUTH_EVENTS.loginSuccess, (event, user) ->
        $scope.currentUser = user
