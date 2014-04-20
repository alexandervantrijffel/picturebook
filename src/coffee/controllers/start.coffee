angular.module('ngApp').controller 'StartController', ($scope, ImageLoader, $modal) ->
    console.log 'hello start controller'
    $scope.keys = ''
    $scope.currentImage = { src: ''}
    $scope.currentImageSrc = ""
    $scope.imageLoader = ImageLoader.create (newImg) ->
        console.log 'currentImageSrc:',newImg.src
        $scope.currentImage = newImg
        $scope.currentImageSrc = newImg.src
        $scope.$apply()
    
    $scope.hasFullScreen = ->
        i = document.getElementById('fullscreen')
        i.requestFullscreen || i.webkitRequestFullscreen || i.mozRequestFullScreen || i.msRequestFullscreen
    
    if !$scope.hasFullScreen() then $("#clickme").hide()

    $("body").keyup (e) ->
        if e.keyCode == 37
            $scope.keys += 'LEFT '
            $scope.imageLoader.displayPrevious()
        else if e.keyCode == 39
            $scope.keys += 'RIGHT '
            $scope.imageLoader.displayNext()
        $scope.$apply()
    
    $scope.currentInterval = 3
    $scope.$watch 'currentInterval', (newVal,oldVal) ->
        newInterval = 5000
        switch newVal
            when 1 then newInterval = 40000
            when 2 then newInterval = 15000
            when 3 then newInterval = 10000
            when 4 then newInterval = 4000
            when 5 then newInterval = 1500
        $scope.imageLoader.updateInterval newInterval
    $scope.translateInterval = (val) ->
        switch val
            when '1' then "Very slow"
            when '2' then "Slow"
            when '3' then "Normal"
            when '4' then "Fast"
            when '5' then "Very fast"
    $scope.showAddImage = ->
        loginModal = $modal.open
            templateUrl: 'AddImage.html'
            controller: 'AddImageController'
            backdrop: false
            keyboard: true
        loginModal.result.then ->
                console.log 'succ'
                loginModal = undefined
            , ->
                console.log 'cancelled'
                loginModal = undefined
    
    $scope.goFullScreen = ->
        i = document.getElementById('fullscreen')
        if i.requestFullscreen
            console.log '1 go fullscreen'
            i.requestFullscreen()
        else if i.webkitRequestFullscreen
            console.log 'webkit go fullscreen'
            i.webkitRequestFullscreen()
        else if i.mozRequestFullScreen
            console.log 'moz go fullscreen'
            i.mozRequestFullScreen()
        else if i.msRequestFullscreen
            console.log 'ms go fullscreen'
            i.msRequestFullscreen()
    