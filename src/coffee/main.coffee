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
				, 'http://upload.wikimedia.org/wikipedia/commons/3/37/Killerwhales_jumping.jpg']
		@photos = []
		@imageContainer = $("#fullscreen")
		@image = $("#fullscreen img")
		_.each @photosUrls, (e) =>
			@load e
		setTimeout @toggle,2000

	load: (src) =>
		img1 = new Image()
		img1.onload = =>
			console.log 'img1 loaded',img1
			console.log "img width #{img1.width} img height #{img1.height}"
			@photos.push img1
		img1.src = src

	toggle: =>
		console.log 'index',@currentIndex
		photo = @photos[@currentIndex]
		if @photos.length-1 > @currentIndex then @currentIndex++ else @currentIndex = 0

		console.log 'toggling', photo
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
			if (photo.width < )
			if (photo.width > photo.height)
				console.log 'landscape'
				@image.css 'width', photo.width
				@image.css 'height', photo.height
			else
				console.log 'portrait'
				@image.css 'width', photo.width
				@image.css 'height', photo.height
				# @imageContainer.css 'background-size','20%'	
			@image.attr 'src', photo.src
			@imageContainer.css 'background-image', ''
			@image.show()
		else
			@image.attr 'src', ''
			@image.hide()
			@imageContainer.css 'background-image', "url(#{photo.src})"
		setTimeout @toggle,3000

$("#clickme").click ->
	goFullscreen 'fullscreen'

$ ->
	toggler = new ImageToggler()