angular.module('ngApp').factory 'AuthService', ($http, Session) ->
    login: (credentials) ->
        return Session.create 'sessionId', 'alex', 'admin'
        $http
            .post '/login', credentials
            .then (res) ->
                Session.create res.id, res.userid, res.role
    isAuthenticated: ->
        !!Session.userId
    isAuthorized: (authorizedRoles) ->
        if (!angular.isArray authorizedRoles) then authorizedRoles = [authorizedRoles]
        this.isAuthenticated() && authorizedRoles.indexOf Session.userRole != -1

        