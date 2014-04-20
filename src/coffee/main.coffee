window.console ?=
    log:->
hasFullscreen = (id) ->
	i = document.getElementById(id)
	i.requestFullscreen || i.webkitRequestFullscreen || i.mozRequestFullScreen || i.msRequestFullscreen
goFullscreen = (id) ->
	i = document.getElementById(id)
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

ImageToggler = class ImageToggler
	constructor: ->
		@currentIndex = 0
		@photosUrls = ['http://pbs.twimg.com/media/BHHSn9jCIAEc9a9.jpg'
				, 'http://pbs.twimg.com/media/BPnnHJeCcAAbaxm.jpg'
				, 'http://upload.wikimedia.org/wikipedia/commons/3/37/Killerwhales_jumping.jpg'
				, 'http://pbs.twimg.com/media/BjLy5SbIgAAYJYt.jpg'
				, 'http://pbs.twimg.com/media/Bi-W93-IEAA5q4L.jpg']
		@photos = []
		@imageContainer = $("#fullscreen")
		@image = $("#fullscreen img")
		_.each @photosUrls, (e) =>
			@load e
		setTimeout @toggle,1000

	load: (src) =>
		img1 = new Image()
		img1.onload = =>
			console.log 'img1 loaded',img1
			console.log "img width #{img1.width} img height #{img1.height}"
			@photos.push img1
		img1.src = src

	toggle: =>
		photo = @photos[@currentIndex]
		console.log 'toggling', photo
		if @photos.length-1 > @currentIndex then @currentIndex++ else @currentIndex = 0
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
				@image.css 'width', windowSize.x
				@image.css 'height', resizeDiff * photo.height
			else
				console.log "portrait x #{photo.width} y #{photo.height}"
				resizeDiff = windowSize.y / photo.height
				@image.css 'height', windowSize.y
				@image.css 'width', resizeDiff * photo.width
			$("#resizeDiff").text("Resize diff: #{resizeDiff.toFixed(2)}")
			@image.attr 'src', photo.src
			@imageContainer.css 'background-image', ''
			@image.show()
		else
			$("#resizeDiff").text("")
			@image.attr 'src', ''
			@image.hide()
			@imageContainer.css 'background-image', "url(#{photo.src})"
		setTimeout @toggle,3000

$("#clickme").click ->
	goFullscreen 'fullscreen'

$ ->
	if !hasFullscreen 'fullscreen' then $("#clickme").hide()
	toggler = new ImageToggler()



blockMove = (event) ->
  # Tell Safari not to move the window.
  event.preventDefault()
