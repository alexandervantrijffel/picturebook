var ImageToggler, blockMove, goFullscreen, hasFullscreen,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

hasFullscreen = function(id) {
  var i;
  i = document.getElementById(id);
  return i.requestFullscreen || i.webkitRequestFullscreen || i.mozRequestFullScreen || i.msRequestFullscreen;
};

goFullscreen = function(id) {
  var i;
  i = document.getElementById(id);
  if (i.requestFullscreen) {
    console.log('1 go fullscreen');
    return i.requestFullscreen();
  } else if (i.webkitRequestFullscreen) {
    console.log('webkit go fullscreen');
    return i.webkitRequestFullscreen();
  } else if (i.mozRequestFullScreen) {
    console.log('moz go fullscreen');
    return i.mozRequestFullScreen();
  } else if (i.msRequestFullscreen) {
    console.log('ms go fullscreen');
    return i.msRequestFullscreen();
  }
};

ImageToggler = ImageToggler = (function() {
  function ImageToggler() {
    this.toggle = __bind(this.toggle, this);
    this.load = __bind(this.load, this);
    this.currentIndex = 0;
    this.photosUrls = ['http://pbs.twimg.com/media/BHHSn9jCIAEc9a9.jpg', 'http://pbs.twimg.com/media/BPnnHJeCcAAbaxm.jpg', 'http://upload.wikimedia.org/wikipedia/commons/3/37/Killerwhales_jumping.jpg', 'http://pbs.twimg.com/media/BjLy5SbIgAAYJYt.jpg', 'http://pbs.twimg.com/media/Bi-W93-IEAA5q4L.jpg'];
    this.photos = [];
    this.imageContainer = $("#fullscreen");
    this.image = $("#fullscreen img");
    _.each(this.photosUrls, (function(_this) {
      return function(e) {
        return _this.load(e);
      };
    })(this));
    setTimeout(this.toggle, 1000);
  }

  ImageToggler.prototype.load = function(src) {
    var img1;
    img1 = new Image();
    img1.onload = (function(_this) {
      return function() {
        console.log('img1 loaded', img1);
        console.log("img width " + img1.width + " img height " + img1.height);
        return _this.photos.push(img1);
      };
    })(this);
    return img1.src = src;
  };

  ImageToggler.prototype.toggle = function() {
    var imageRatio, photo, ratioDiff, resizeDiff, screenRatio, windowSize;
    photo = this.photos[this.currentIndex];
    console.log('toggling', photo);
    if (this.photos.length - 1 > this.currentIndex) {
      this.currentIndex++;
    } else {
      this.currentIndex = 0;
    }
    windowSize = {
      x: $(document).width(),
      y: $(document).height()
    };
    screenRatio = windowSize.x / windowSize.y;
    imageRatio = photo.width / photo.height;
    ratioDiff = (screenRatio / imageRatio).toFixed(2);
    $("#screenRatio").text("Screen ratio: " + (screenRatio.toFixed(2)));
    $("#imageRatio").text("Image ratio: " + (imageRatio.toFixed(2)));
    $("#ratioDiff").text("Ratio diff: " + ratioDiff);
    if (ratioDiff > 1.5) {
      resizeDiff = 0;
      if (photo.width > photo.height) {
        resizeDiff = windowSize.x / photo.width;
        console.log("landscape x " + photo.width + " y " + photo.height);
        this.image.css('width', windowSize.x);
        this.image.css('height', resizeDiff * photo.height);
      } else {
        console.log("portrait x " + photo.width + " y " + photo.height);
        resizeDiff = windowSize.y / photo.height;
        this.image.css('height', windowSize.y);
        this.image.css('width', resizeDiff * photo.width);
      }
      $("#resizeDiff").text("Resize diff: " + (resizeDiff.toFixed(2)));
      this.image.attr('src', photo.src);
      this.imageContainer.css('background-image', '');
      this.image.show();
    } else {
      $("#resizeDiff").text("");
      this.image.attr('src', '');
      this.image.hide();
      this.imageContainer.css('background-image', "url(" + photo.src + ")");
    }
    return setTimeout(this.toggle, 3000);
  };

  return ImageToggler;

})();

$("#clickme").click(function() {
  return goFullscreen('fullscreen');
});

$(function() {
  var toggler;
  if (!hasFullscreen('fullscreen')) {
    $("#clickme").hide();
  }
  return toggler = new ImageToggler();
});

blockMove = function(event) {
  return event.preventDefault();
};
