/*global window,jQuery,swfobject*/
(function($) {
	
	var defaults = {
			swfpath: './media/swf/',
			swfname: 'VimeoSubtitlePlayer.swf',
			swfupdater: 'expressInstall.swf',
			swfminversion: "10.0.0", 
			className: 'vimeosubs',
			video_id: null,
			autoplay: false,
		 	allowFullScreen: true,	 
			allowScriptAccess: 'always', 
			wmode: 'window',
			bgcolor: '0x000000'
		},

		self = this,
		id = null,
		src = null,
		width = null,
		height = null,
		div = null,
		iframe = null,
		
		allowedParams = 'play,loop,menu,quality,scale,salign,wmode,bgcolor,base,swliveconnect,flashvars,devicefont,allowscriptaccess,seamlesstabbing,allowfullscreen,allownetworking',
		allowedAttribs = 'id,name,class,align',
		flashvars = function(obj) {
			var result = {};
			for (var prop in obj) {
				if (!allowedParams.match(prop.toLowerCase()) && !allowedAttribs.match(prop.toLowerCase())) {
					result[prop] = obj[prop];
				}
			}
			return result; 
		},
		params = function(obj) {
			var result = {};
			for (var prop in obj) {
				if (allowedParams.match(prop.toLowerCase())) {
					result[prop] = obj[prop];
				}
			}
			return result;
		},
		attribs = function(obj) {
			var result = {};
			for (var prop in obj) {
				if (allowedAttribs.match(prop.toLowerCase())) {
					result[prop] = obj[prop];
				}
			}
			return result;
		},
		methods = {
			//-----------------------------------------------------------
			// init
			//-----------------------------------------------------------
			init: function(options) {
				o = $.extend({}, defaults, options);
				src = $(this).attr('src');		 
				id = $(this).attr('id');
				$(this).removeAttr('id');
				width = $(this).width();
				height = $(this).height();
				if (!o.video_id && src) { o.video_id = src.split('video/')[1].split('?')[0]; }
				if (src.indexOf('autoplay') != -1) { o.autoplay = src.split('autoplay=')[1].split('&');}
				div = $('<div class="' + o.className + '">');
				$(this).before(div);
				$(this).remove(); 
				div.append($('<div id="'+id+'">'));
				swfobject.embedSWF(o.swfpath + o.swfname, id, width, height, o.swfminversion, o.swfpath + o.swfupdater,	flashvars(o), params(o), attribs(o), o.callback);
			},
			play: function() {
				return this[0].play();
			},
			pause: function() {
				return this[0].pause();
			},
			stop: function() {
				return this[0].stop();
			},
			isPlaying: function() {
				return this[0].isPlaying();
			},
			seekTo: function(value) {
			console.log(value)
				return this[0].seekTo(value);
			}
		};
		   
	$.fn.vimeosubs = function(method, options) {
		  
	    if ( methods[method] ) { 
	      return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
	    } else if ( typeof method === 'object' || ! method ) {
	      return methods.init.apply( this, arguments );
	    } else {
	      $.error( 'Method ' +  method + ' does not exist on jQuery.vimeosubs' );
	    }    
		
	};
	
}(jQuery));