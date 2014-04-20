angular.module('ngApp').service 'ImageLoader', ($http) ->
    this.interval = 5000
    this.updateInterval = (interval) =>
        if interval <= 600
            console.error 'The interval must be at least 600 (ms)'
            return
        console.log 'new interval ',interval
        this.interval = interval
        this.resetTimeout()
    this.create = (updateCurrentImage) =>
        this.images = []
        this.index = -1
        this.updateCurrentImage = updateCurrentImage
        this.resetTimeout()
        this
    this.resetTimeout = =>
        if this.timer && this.timer > 0
            clearTimeout this.timer
        this.timer = setTimeout this.onTick, this.interval
    this.add = (img) =>
        if (!angular.isArray img) then img = [img]
        this.images.concat img
    this.hasMoreImages = =>
        this.index + 1 < this.images.length
    this.displayNext = =>
        if !this.hasMoreImages()
            console.log 'retrieving images, timer', this.timer
            if this.index == -1 || !this.images || this.images.length < this.index
                $http.post 'http://localhost:3001/api/pics', {}
                    .success (result) =>
                        @load result.images
                    .error (data,status,headers,config) ->
                        console.log "#{status} failed to retrieve first images"
            else
                $http.post '/api/images/next', id: this.images[this.index].id
                    .success (result) ->
                        @load result.images
                    .error (data,status,headers,config) ->
                        console.log "#{status} Failed to retrieve images."
            # this.images.push 
            #     src: 'http://upload.wikimedia.org/wikipedia/commons/a/af/Bonsai_IMG_6426.jpg'
            #     id: 1
            # this.images.push 
            #     src: 'http://2'
            #     id: 2
            # this.images.push 
            #     src: 'http://3'
            #     id: 3
            # this.images.push 
            #     src: 'http://4'
            #     id: 4
            # this.images.push 
            #     src: 'http://5'
            #     id: 5

        # if this.index + 1 < this.images.length
        #     this.index++
        # else
        #     this.index = 0;
        # console.log "displaying index #{this.index}"
        # this.updateCurrentImage this.images[this.index]
    this.displayPrevious = =>
        if this.index > 0
            this.index--
        console.log "displaying index #{this.index}"
        this.updateCurrentImage this.images[this.index]
    this.onTick = =>
        this.displayNext()
        this.timer = setTimeout this.onTick, this.interval
    this.load = (imgsrc) =>
        img1 = new Image()
        img1.onload = =>
            console.log 'img1 loaded',imgl
            console.log "img width #{img1.width} img height #{img1.height}"
            @images.push img1.src
        img1.src = imgsrc.src
    this