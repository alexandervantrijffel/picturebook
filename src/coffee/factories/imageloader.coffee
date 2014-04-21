angular.module('ngApp').service 'ImageLoader', ($http,rootUrl) ->
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
            if @index == -1 || !@images || @images.length < @index
                return $http.get "#{rootUrl}/api/pics", {}
                    .success (result) =>
                        # console.log 'result from load pics:',result
                        _.each result.images, (i) =>
                            @load i
                    .error (data,status,headers,config) ->
                        return console.log "#{status} failed to retrieve first images"
            else
                return $http.post "#{rootUrl}/api/pics/next", fromId: @images[@index]._id
                    .success (result) =>
                        # console.log 'result from next pics:',result
                        console.log "retrieved #{result.images.length} pictures (total #{@images.length} images)."
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
        @updateCurrentImage @images[@index]
    @displayPrevious = =>
        if @index > 0
            @index--
        @updateCurrentImage @images[@index]
    @onTick = =>
        @displayNext()
        @timer = setTimeout @onTick, @interval
    @load = (imgsrc) =>
        img1 = new Image()
        img1.onload = =>
            #console.log "img loaded with width #{img1.width} img height #{img1.height}"
            @images.push img1
            if @images.length == 1 then @displayNext()
        img1[p]=imgsrc[p] for p of imgsrc 
    this