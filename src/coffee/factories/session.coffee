angular.module('ngApp').service 'Session', ->
    this.create = (sessionId, userId, userRole) ->
        this.id = sessionId
        this.userId = userId
        this.userRole = userRole
        this
    this.destroy = ->
        this.id = null
        this.userId = null
        this.userRole = null
        this
    this