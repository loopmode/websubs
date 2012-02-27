/*global window,jQuery,swfobject*/
/*jslint white: true*/
(function($) {
	"use strict";
	
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

		isiPad = window.navigator.userAgent.match(/iPad/i) !== null,
		o = null,
		id = null,
		src = null,
		width = null,
		height = null,
		div = null,
		
		/**
		 * properties of the options object that will be used as params for the swf object. 
		 */
		allowedParams = 'play,loop,menu,quality,scale,salign,wmode,bgcolor,base,swliveconnect,flashvars,devicefont,allowscriptaccess,seamlesstabbing,allowfullscreen,allownetworking',
		
		/**
		 * properties of the options object that will be used as attributes for the swf object. 
		 */
		allowedAttribs = 'id,name,class,align',
		
		/**
		 * properties of the options object that are used for internal purpose and should not be passed as flashvars 
		 */
		internalOptions = 'swfpath,swfname,swfupdater,swfminversion,classname',
		
		/**
		 * Methods defined in the swf and made available via ExternalInterface.addCallback()
		 */
		swfmethods = 'play,pause,stop,isReady,isPlaying,isPaused,seekTo,subtitles,list',
		
		/**
		 * Takes the options object and returns a new object that contains only those properties that are not listed as allowed params or attributes.
		 * @param {} Options object
		 * @returns {} flashvars object
		 */
		flashvars = function(obj) {
			var r = {}, prop, p;
			for (prop in obj) {
				if (obj.hasOwnProperty(prop)) {
					p = prop.toLowerCase();
					if (!internalOptions.match(p) && !allowedParams.match(p) && !allowedAttribs.match(p)) {
						r[prop] = obj[prop];
					}
				}
			}
			return r; 
		},
		
		/**
		 * Takes the options object and returns a new object that contains only those properties that are listed as allowed swf params.
		 * @param {} Options object
		 * @returns {} flashvars object
		 */
		params = function(obj) {
			var r = {}, prop;
			for (prop in obj) {
				if (obj.hasOwnProperty(prop)) {
					if (allowedParams.match(prop.toLowerCase())) {
						r[prop] = obj[prop];
					}
				}
			}
			return r;
		},
		
		/**
		 * Takes the options object and returns a new object that contains only those properties that are listed as allowed swf attributes.
		 * @param {} Options object
		 * @returns {} flashvars object
		 */
		attribs = function(obj) {
			var r = {}, prop;
			for (prop in obj) {
				if (obj.hasOwnProperty(prop)) {
					if (allowedAttribs.match(prop.toLowerCase())) {
						r[prop] = obj[prop];
					}
				}
			}
			return r;
		},
		methods = {
			//-----------------------------------------------------------
			// init
			//-----------------------------------------------------------
			init: function(options) {
				o = $.extend({}, defaults, options);
				src = $(this).attr('src');		 
				id = $(this).attr('id') || 'websubs_'+($.fn.websubs.idc++);
				$(this).removeAttr('id');
				width = $(this).width();
				height = $(this).height();
				if (!o.video_id && src) { o.video_id = src.split('video/')[1].split('?')[0]; }
				if (src.indexOf('autoplay') !== -1) { o.autoplay = src.split('autoplay=')[1].split('&');}
				div = $('<div class="' + o.className + '">');
				$(this).before(div);
				$(this).remove(); 
				div.append($('<div id="'+id+'">'));
				swfobject.embedSWF(o.swfpath + o.swfname, id, width, height, o.swfminversion, o.swfpath + o.swfupdater,	flashvars(o), params(o), attribs(o), o.callback);
			}
		};
		
	$.fn.websubs = function(method) {
		var result;
	    if (isiPad) {
			result = null;
	    } else if ( methods[method] ) { 
			result = methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
	    } else if ( typeof method === 'object' || ! method ) {
			result = methods.init.apply( this, arguments );
	    } else if (swfmethods.indexOf(method) !== -1) {
			result = arguments.length > 1 ? this[0][method](Array.prototype.slice.call( arguments, 1 )) : this[0][method]();
	    } else {
			$.error( 'Method ' +  method + ' does not exist on jQuery.websubs' );
	    }    
		
	};
	$.fn.websubs.idc = 0;
}(jQuery));