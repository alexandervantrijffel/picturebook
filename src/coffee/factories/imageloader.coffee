angular.module('ngApp').service 'ImageLoader', ($http) ->
    @interval = 5000
    @updateInterval = (interval) =>
        if interval <= 600
            console.error 'The interval must be at least 600 (ms)'
            return
        console.log 'new interval ',interval
        @interval = interval
        @resetTimeout()
    @create = (updateCurrentImage) =>
        @images = []
        @index = -1
        @updateCurrentImage = updateCurrentImage
        @resetTimeout()
        @displayNext()
        this
    @resetTimeout = =>
        if @timer && @timer > 0
            clearTimeout @timer
        @timer = setTimeout @onTick, @interval
    @add = (img) =>
        if (!angular.isArray img) then img = [img]
        @images.concat img
    @hasMoreImages = =>
        @index + 1 < @images.length
    @displayNext = =>
        if !@hasMoreImages()
            console.log 'retrieving images, timer', @timer
            if @index == -1 || !@images || @images.length < @index
                return $http.get 'http://localhost:3001/api/pics', {}
                    .success (result) =>
                        console.log 'result from load pics:',result
                        _.each result.images, (i) =>
                            @load i
                    .error (data,status,headers,config) ->
                        return console.log "#{status} failed to retrieve first images"
            else
                return $http.post 'http://localhost:3001/api/pics/next', fromId: @images[@index].id
                    .success (result) =>
                        console.log 'result from next pics:',result
                        _.each result.images, (i) =>
                            @load i
                    .error (data,status,headers,config) ->
                        return console.log "#{status} Failed to retrieve images."
            # @images.push 
            #     src: 'http://upload.wikimedia.org/wikipedia/commons/a/af/Bonsai_IMG_6426.jpg'
            #     id: 1
            # @images.push 
            #     src: 'http://stackoverflow.com/users/769384/tkoomzaaskz'
            #     id: 2
        if @images.length == 0 then return
        if @index + 1 < @images.length
            @index++
        else
            @index = 0;
        console.log "displaying index #{@index}"
        @updateCurrentImage @images[@index]
    @displayPrevious = =>
        if @index > 0
            @index--
        console.log "displaying index #{@index}"
        @updateCurrentImage @images[@index]
    @onTick = =>
        @displayNext()
        @timer = setTimeout @onTick, @interval
    @load = (imgsrc) =>
        console.log 'loading image',imgsrc
        img1 = new Image()
        img1.onload = =>
            console.log "img loaded with width #{img1.width} img height #{img1.height}"
            @images.push img1
            if @images.length == 1 then @displayNext()
        img1.src = imgsrc.src
        img1._id = imgsrc._id
        img1.postedAt = imgsrc.postedAt
    this