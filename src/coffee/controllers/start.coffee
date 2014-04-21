angular.module('ngApp').controller 'StartController', ($scope, ImageLoader, $modal) ->
    console.log 'hello start controller'
    $scope.imageContainer = $("#fullscreen")
    $scope.image = $("#fullscreen img")
    $scope.keys = ''
    $scope.currentImage = { src: ''}
    $scope.imageLoader = ImageLoader.create (photo) ->
        $scope.currentImage = photo
        windowSize = 
            x:$(document).width()
            y:$(document).height()
        screenRatio = windowSize.x / windowSize.y
        imageRatio = photo.width / photo.height
        ratioDiff = (screenRatio / imageRatio).toFixed(2)
        $("#screenRatio").text("Screen ratio: #{screenRatio.toFixed(2)}")
        $("#imageRatio").text("Image ratio: #{imageRatio.toFixed(2)}")
        $("#ratioDiff").text("Ratio diff: #{ratioDiff}")
        if ratioDiff > 1.5
            resizeDiff=0
            if (photo.width > photo.height)
                resizeDiff = windowSize.x / photo.width
                console.log "landscape x #{photo.width} y #{photo.height}"
                $scope.image.css 'width', windowSize.x
                $scope.image.css 'height', resizeDiff * photo.height
            else
                console.log "portrait x #{photo.width} y #{photo.height}"
                resizeDiff = windowSize.y / photo.height
                $scope.image.css 'height', windowSize.y
                $scope.image.css 'width', resizeDiff * photo.width
            $("#resizeDiff").text("Resize diff: #{resizeDiff.toFixed(2)}")
            $scope.image.attr 'src', photo.src
            $scope.imageContainer.css 'background-image', ''
            $scope.image.show()
        else
            $("#resizeDiff").text("")
            $scope.image.attr 'src', ''
            $scope.image.hide()
            $scope.imageContainer.css 'background-image', "url(#{photo.src})"
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
    
    $scope.currentInterval = 4
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
    