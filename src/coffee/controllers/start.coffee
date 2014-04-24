angular.module('ngApp').controller 'StartController', ($scope, ImageLoader, $modal) ->
    $scope.imageContainer = $("#fullscreen")
    $scope.image = $("#fullscreen img")
    $scope.keys = ''
    $scope.currentImage = { src: ''}
    this.imageLoader = ImageLoader.create (photo) ->
        $scope.currentImage = photo
        windowSize = 
            x:$(document).width()
            y:$(document).height()
        screenRatio = windowSize.x / windowSize.y
        imageRatio = photo.width / photo.height
        ratioDiff = (screenRatio / imageRatio).toFixed(2)
        $scope.imageDetails.title = if photo.title.length then photo.title else ""
        $scope.imageDetails.screenRatio = "Screen ratio: #{screenRatio.toFixed(2)}"
        $scope.imageDetails.imageRatio = "Image ratio: #{imageRatio.toFixed(2)}"
        $scope.imageDetails.ratioDiff = "Ratio diff: #{ratioDiff}"
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
            $scope.imageDetails.resizeDiff = "Resize diff: #{resizeDiff.toFixed(2)}"
            $scope.image.attr 'src', photo.src
            $scope.imageContainer.css 'background-image', ''
            $scope.image.show()
        else
            $scope.imageDetails.resizeDiff = ""
            $scope.image.attr 'src', ''
            $scope.image.hide()
            $scope.imageContainer.css 'background-image', "url(#{photo.src})"
        $scope.image.attr 'alt',photo.title
        $scope.$apply()
    
    $scope.hasFullScreen = ->
        i = document.getElementById('fullscreen')
        i.requestFullscreen || i.webkitRequestFullscreen || i.mozRequestFullScreen || i.msRequestFullscreen
    
    if !$scope.hasFullScreen() then $(".js-enter-fullscreen").hide()

    $("body").keyup (e) =>
        if e.keyCode == 37
            $scope.keys += 'LEFT '
            this.imageLoader.displayPrevious()
        else if e.keyCode == 39
            $scope.keys += 'RIGHT '
            this.imageLoader.displayNext()
        $scope.$apply()
    
    $scope.currentInterval = 3
    $scope.$watch 'currentInterval', (newVal,oldVal) =>
        newInterval = 5000
        switch newVal
            when 1 then newInterval = 40000
            when 2 then newInterval = 20000
            when 3 then newInterval = 10000
            when 4 then newInterval = 4000
            when 5 then newInterval = 1500
        this.imageLoader.updateInterval newInterval
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

    this.elementToFullScreen = (i) =>
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
    $scope.goFullScreen = =>
        this.elementToFullScreen document.getElementById('fullscreen')

    $scope.imageDetails =
        title: 'Loading..'
        screenRatio: ''
        imageRatio: ''
        resizeDiff: ''
        ratioDiff: ''

    $scope.showRatios = false
    $scope.toggleShowDetails = ->
        $scope.showRatios = !$scope.showRatios

    this.showControlBar = (e) =>
        $(window).unbind "mousemove", this.showControlBar
        $(window).unbind "touchstart",this.showControlBar
        $(".js-controlbar").fadeIn()
        this.fadeControlBar()

    $scope.isInFullScreen = false
    
    this.fullScreenChangeHandler = =>
        $scope.isInFullScreen = undefined != (document.fullScreenElement||document.webkitCurrentFullScreenElement||document.mozFullScreenElement)

    document.addEventListener "fullscreenchange", this.fullScreenChangeHandler, false
    document.addEventListener "webkitfullscreenchange", this.fullScreenChangeHandler, false
    document.addEventListener "mozfullscreenchange", this.fullScreenChangeHandler, false

    this.fadeControlBar = =>
        if @timer && @timer > 0
            clearTimeout @timer
        @timer = setTimeout => 
                $(".js-controlbar").fadeOut 1000
                $(window).mousemove this.showControlBar
                $(window).bind "touchstart",this.showControlBar
            , if this.isInFullScreen then 2000 else 12000          
            
    @fadeControlBar()

    
