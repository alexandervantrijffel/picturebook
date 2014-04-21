angular.module('ngApp').service 'Session', ->
    @create = (sessionId, userId, userRole) ->
        @id = sessionId
        @userId = userId
        @userRole = userRole
        this
    @destroy = ->
        @id = null
        @userId = null
        @userRole = null
        this
    this