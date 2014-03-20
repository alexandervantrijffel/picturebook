var ImageToggler, goFullscreen,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

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
    this.photosUrls = ['http://pbs.twimg.com/media/BHHSn9jCIAEc9a9.jpg', 'http://pbs.twimg.com/media/BPnnHJeCcAAbaxm.jpg', 'http://upload.wikimedia.org/wikipedia/commons/3/37/Killerwhales_jumping.jpg'];
    this.photos = [];
    this.imageContainer = $("#fullscreen");
    this.image = $("#fullscreen img");
    _.each(this.photosUrls, (function(_this) {
      return function(e) {
        return _this.load(e);
      };
    })(this));
    setTimeout(this.toggle, 2000);
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
    var imageRatio, photo, ratioDiff, screenRatio;
    console.log('index', this.currentIndex);
    photo = this.photos[this.currentIndex];
    if (this.photos.length - 1 > this.currentIndex) {
      this.currentIndex++;
    } else {
      this.currentIndex = 0;
    }
    console.log('toggling', photo);
    screenRatio = $(document).width() / $(document).height();
    imageRatio = photo.width / photo.height;
    ratioDiff = (screenRatio / imageRatio).toFixed(2);
    $("#screenRatio").text("Screen ratio: " + (screenRatio.toFixed(2)));
    $("#imageRatio").text("Image ratio: " + (imageRatio.toFixed(2)));
    $("#ratioDiff").text("Ratio diff: " + ratioDiff);
    if (ratioDiff > 1.5) {
      if (photo.width > photo.height) {
        console.log('landscape');
        this.image.css('width', photo.width);
        this.image.css('height', photo.height);
      } else {
        console.log('portrait');
        this.image.css('width', photo.width);
        this.image.css('height', photo.height);
      }
      this.image.attr('src', photo.src);
      this.imageContainer.css('background-image', '');
      this.image.show();
    } else {
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
  return toggler = new ImageToggler();
});
