angular.module('ngApp').directive "focusMe", ($timeout, $parse) ->
    #scope: true,   // optionally create a child scope
    link: (scope, element, attrs) ->
        model = $parse(attrs.focusMe)
        scope.$watch model, (value) ->
            if value is true then $timeout ->
                element[0].focus()
                
        # to address @blesh's comment, set attribute value to 'false'
        # on blur event:
        element.bind "blur", ->
            scope.$apply model.assign(scope, false)
