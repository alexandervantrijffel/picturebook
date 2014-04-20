angular.module('ngApp').controller 'LoginController', ($scope, $rootScope, AUTH_EVENTS, AuthService, $modalInstance) ->
    $scope.credentials = 
        username: ''
        password: ''
    $scope.ok = ->
        $modalInstance.dismiss() 
    $scope.login = (credentials) ->
        AuthService.login(credentials)
        console.log 'credentials', credentials
        $rootScope.$broadcast AUTH_EVENTS.loginSuccess, 
            name: "Alex (#{credentials.username})"            
            #.then ->
            #    $rootScope.$broadcast AUTH_EVENTS.loginSuccess
            #, ->
            #    $rootScope.$broadcast AUTHEVENTS.loginFailed
        $modalInstance.close()