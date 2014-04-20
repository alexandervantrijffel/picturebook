angular.module('ngApp', ['ngRoute','ui.bootstrap','vr.directives.slider'])
    .config ($routeProvider, $locationProvider, USER_ROLES,$httpProvider) ->
        $routeProvider
            .when '/', {templateUrl: 'start.html', controller: 'StartController'}
            .when '/about', {templateUrl: 'about.html', controller: 'AboutController', params: USER_ROLES.admin}
            .otherwise {redirectTo:'/'}
        $locationProvider
            .html5Mode(false)
            .hashPrefix("!")
        delete $httpProvider.defaults.headers.common['X-Requested-With']
    .value 'rootUrl', ''
    .run ($rootScope, AUTH_EVENTS, AuthService) ->
        #$rootScope.$on '$locationChangeStart', (event, next, current) ->
        $rootScope.$on '$routeChangeStart', (event, next, current) ->
            if next.authorizedRoles
                if !AuthService.isAuthorized next.authorizedRoles
                    alert "You are not allowed to access this page because you are not a member of #{next.authorizedRoles}"
                    console.log 'authorizedRoles', next.authorizedRoles
                    event.preventDefault() #doesnt work for routeChange, only for locationChange
                    if AuthService.isAuthenticated
                        $rootScope.$broadcast AUTH_EVENTS.notAuthorized
                    else
                        $rootScope.$broadcast AUTH_EVENTS.notAuthenticated                

if (typeof console == "undefined")
    window.console = 
        log: () ->
            

