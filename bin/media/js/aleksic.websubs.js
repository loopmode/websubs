/*global window, jQuery, aleksic, Froogaloop, $f */
var aleksic;
(function($) {
	
	'use strict';
	
	var id_counter,
		
		warn,
		log,
		utils,
		
		Websubs,
		SubtitleFile,
		SubtitleLine,
		pluginName,
		pluginMethods;
		 
	id_counter = 0;
	
	log = function() {
		try { window.console.log.apply(window.console, arguments); }
		catch (err) {
			
		}
	};
	warn = function() {
		try { window.console.warn.apply(window.console, arguments); }
		catch (err) {
			
		}
	};
	
	utils = {
		/**
		 * Takes an srt-formatted timecode string and converts it to seconds
		 * @param a string in the format hh:mm:ss,ms
		 * @returns Decimal number of seconds
		 */
		srtTimeToSeconds: function(tc) {
			//00:05:54,880
			var qp = tc.split(':'),
			cp = qp[qp.length-1].split(','),
			hh = Number(qp[0]),
			mm = Number(qp[1]),
			ss = Number(cp[0]),
			ms = Number(cp[1]),
			result = ss	+ mm*60	+ hh*3600 + Number('0.'+ms);
			return result;
		}
	};
	//===========================================================================================
	// 
	// WEBSUBS
	//
	//===========================================================================================
	
	Websubs = function(el, o) {
		this.element = $(el);
		this.options = $.extend(true, {}, Websubs.defaults, o);
		this.init();
	};
	
	Websubs.defaults = {
		froogaloop_url: 'http://a.vimeocdn.com/js/froogaloop2.min.js'
	};
	
	Websubs.prototype = {
		
		//-----------------------------------------------------------------------------------
		// 
		// INSTANCE VARIABLES
		// 
		// ----------------------------------------------------------------------------------
		
		/**
		 * Options object. Inherits from Websubs.defaults and options passed to the constructor.
		 */
		options: null,
		
		/**
		 * The IFRAME element with froogaloop.
		 */
		element: null,
		
		/**
		 * The wrapper element that gets created around the iframe.
		 */
		wrapper: null,
		
		/**
		 * The div element which will display the subtitle text
		 */
		textfield: null,
		
		/**
		 * The SELECT element for changing the subtitle file
		 */
		select: null,
		
		
		
		/**
		 * The loaded XML list of subtitles.
		 * Type: {DOMDocument}
		 */
		list: null,
		
		/**
		 * An array containing an object for each subtitle line of the loaded file.
		 * @see #loadList
		 */
		lines: null,
		
		/**
		 * An object 
		 * @see #loadList
		 */
		currentLine: null,
		
		/**
		 * Subtitle ID of the currentlyloaded file.
		 */
		currentID: null,
		
		/**
		 * Our Froogaloop reference to call vimeo API functions on the iframe
		 */
		froogaloop: null,
		
		//-----------------------------------------------------------------------------------
		// 
		// INSTANCE METHODS
		// 
		// ----------------------------------------------------------------------------------
		
		init: function() {
			if (this.verifyElements()) {
				this.createTextfield();
				this.loadList(this.options.subtitles_list);
				this.loadFroogaloop();
			}
		},
		
		createTextfield: function() {
			if (this.wrapper) {
				return;
			}
			
			var el = this.element,
				wrapper = $('<div class="websubs-wrapper">'),
				textfield = $('<div class="websubs-textfield subtitles">');
			
			wrapper.css({
				position: 'relative',
				width: el.width(),
				height: el.height()
			});
			
			
			el.before(wrapper);
			wrapper.append(el);
			wrapper.append(textfield);
			
			this.wrapper = wrapper;
			this.textfield = textfield;
			
			textfield.css('opacity',0).html('<b>preload</b><i>preload</i><b><i>preload</i></b>');
		},
		
		/**
		 * Ensures that the element is an iframe and has required parameters and attributes.
		 * The iframe element must have a unique id and and the the api and player_id parameters in the src value.
		 * This function checks for each of these conditions and foxes occuring problems.
		 */
		verifyElements: function() {
			
			var	time = new Date().getTime(),
				select = $(this.options.select),
				el = this.element,
				id = el.attr('id') || 'websubs_' + id_counter + '_' + time,
				src = el.attr('src');

			if (!el.is('iframe')) {
				$.error('Illegal operation: target is not an iframe!');
				return false;
			}
			
			
			if (select.length) {
				select.bind('change', $.proxy(this.handleListChange, this));
				this.select = select;
			}
			 
			 
			if (!el.attr('id')) {
				el.attr('id', id);
				id_counter = id_counter + 1;
			}
			
			if (!src.match(/api=1/)) {
				src += (src.match(/\?/) ? '&' : '?') + 'api=1';
			}

			if (!src.match(/player_id=/)) {
				src += (src.match(/\?/) ? '&' : '?') + 'player_id=' + id;
			}
			
			if (src !== el.attr('src')) {
				el.attr('src', src);
			}
			
			return true;
		},
		
		//-----------------------------------------------------------------------------------
		// XML LIST
		// ----------------------------------------------------------------------------------
		
		/**
		 * Loads an XML list of available subtitle files. Invokes <code>loadListDone()</code> on success.
		 * @example: 
		 * <?xml version="1.0" standalone="yes" ?>
		 * <subtitles default_id="ger">
		 *  <subtitle format="srt" id="eng" title="English">./media/subtitles/problema_english.srt</subtitle>  
		 *  <subtitle format="srt" id="ger" title="German">./media/subtitles/problema_german.srt</subtitle>
		 *  <subtitle format="srt" id="esp" title="Spanish">./media/subtitles/problema_spanish.srt</subtitle> 
		 *  <subtitle format="srt" id="arb" title="Arabic" fontName="Adobe Arabic" fontFile="./media/swf/font-arabic.swf" fontSize="30">./media/subtitles/problema_arabic.srt</subtitle>
		 *  <subtitle format="srt" id="chn" title="Chinese" fontName="Bitstream Cyberbit" fontFile="./media/swf/font-chinese.swf" fontSize="22">./media/subtitles/problema_chinese.srt</subtitle>
		 *  <subtitle format="srt" id="jap" title="Japanese" fontName="Meiryo UI" fontFile="./media/swf/font-japanese.swf" fontSize="22">./media/subtitles/problema_japanese.srt</subtitle>
		 * </subtitles>
				 * 
		 * @see #loadListDone
		 * @see #loadListFailed
		 */
		loadList: function(/**String*/url) {
			if (!url) {
				return;
			}
			$.ajax({
				type: 'GET',
				url: url,
				dataType: 'xml'
			})
			.done($.proxy(this.loadListDone, this))
			.fail($.proxy(this.loadListFailed, this));
		},
		
		/**
		 * Handles successful loading of an XML list file.
		 * If a select element was specified in the options and the list contains data, option elements are created and attached to the select element. 
		 */
		loadListDone: function(/**String*/xml) {
			this.list = $(xml); 
			
			var self = this,
				list = this.list,
				select = this.select,
				default_id;
				
			if (list.length && select.length) {
				
				select.empty();
				default_id = list.find('subtitles').attr('default_id');
				
				$(list).find('subtitle').each(function(i) {
					var option = $('<option>')
						.text( $(this).attr('title') ) 
						.data({
							url: $(this).text(),
							id: $(this).attr('id')
						});
					select.append(option);
					if (default_id && option.data('id') === default_id) {
						select.val(option.text());
						self.loadSubtitles(option.data('url'), option.data('id'));
					}
				});
				
				
			}
		},
		
		loadListFailed: function(xhr, res) {
			warn('Failed to load list', xhr);
		},
		
		//-----------------------------------------------------------------------------------
		// SRT LOADING
		// ----------------------------------------------------------------------------------
		
		loadSubtitles: function(url, id) {
			$.ajax({
				type: 'GET',
				url: url,
				dataType: 'text'
			})
			.done($.proxy(this.loadSubtitlesDone, this))
			.fail($.proxy(this.loadSubtitlesFailed, this));
			
			if (this.currentID) {
				this.wrapper.removeClass(this.currentID);
			}
			this.currentID = id;
			this.wrapper.addClass(id);
		},
		loadSubtitlesDone: function(data) {
			this.setSubtitles( this.parseSrt(data), this.currentID );
		},
		loadSubtitlesFailed: function(xhr, res) {
			warn('Failed loading subtitle file', xhr, res);
		},
		
		setSubtitles: function(/**Array*/lines) {
			if (lines.length === 0) {
				lines = null;
			}
			
			this.lines = lines;
			this.update();
		},
		
		//-----------------------------------------------------------------------------------
		// SRT PARSING
		// ----------------------------------------------------------------------------------
		
		/**
		 * Parses SRT data and returns an array of subtitle lines. 
		 * Each subtitle line is represented by an object: {id, start, end, text}
		 * TODO: amend the function as it is from the old version
		 * @param {String} The contents of a .srt file 
		 */
		parseSrt: function(string) { 
			var result = [],
				lines = string.split('\n'),
				errors = [],
				s,
				sid;
			
			$(lines).each(function(i,l) {
				
				var getLineIsEmpty = function(line) { 
					if (!line) {
						return true;
					}
					if (line) {
						if (line.length === 0) {return true;} 
						if (line === '\\s') {return true;}
						if (line === '\\r') {return true;}
						if (line === '\\n') {return true;}
						if (line === '\\r\\n') {return true;}
						if (line.toString().trim().length === 0) {return true;}
					} 
				},
				
				// detect if its an empty line
				isEmpty = getLineIsEmpty(l),
			 
				// detect if its the first line
				isFirst = !isEmpty && !isNaN(l) && ( (i===0) || getLineIsEmpty(lines[i-1]) ) ,
							
				// detect if its the last line			  
				isLast = isEmpty && ( i>=lines.length-1 || !isNaN(lines[i+1]) ) ;
				
				//--------------------------------------------------------------
				// id line
				//--------------------------------------------------------------
				if ( isFirst ) {
					s = {id: parseInt(l,10), text:''};
					sid = i; 
					//console.log('first line: '+l)
				}
				
				//--------------------------------------------------------------
				// timecode line
				//--------------------------------------------------------------
			 
				if (i === sid+1) {
					if (l.indexOf(' --> ') !== -1) {
						s.start = l.split(' --> ')[0];
						s.end = l.split(' --> ')[1];					
					}
					else {
						errors.push( "Illegal timecode line at "+i+": "+l );
					}
					//console.log('tc line: '+l)
				} 

				//--------------------------------------------------------------
				// text lines
				//--------------------------------------------------------------
				if (i >= sid+2 && !isLast) {
					s.text += l.replace(/\r\n/g, '\n');
					if (!getLineIsEmpty(lines[i+1])) {
						s.text += '\n';
					}
					//console.log('text line: '+l)
				}
				
				//--------------------------------------------------------------
				// last line
				//--------------------------------------------------------------
				if ( isLast ) { 
					result.push(s);
					//console.log('last line: '+l)
				}
				
			}); 
			if (errors.length > 0) {
				window.alert('errors happened parsing the srt file!');
			}  
			
			return result;
		},
		
		//-----------------------------------------------------------------------------------
		// Froogaloop
		// ----------------------------------------------------------------------------------
		
		loadFroogaloop: function() {
			var url;
			if (window.Froogaloop) {
				this.loadFroogaloopDone.call(this);
			} else {
				url = this.options.froogaloop_url;
				$.getScript(url, $.proxy(this.loadFroogaloopDone, this));
			}
			 
		},
		
		loadFroogaloopDone: function() {
			this.froogaloop = $f( this.element.attr('id') );
			this.froogaloop.addEvent('ready', $.proxy(this.handlePlayerReady, this));
		},
		
		
		
		
		//-----------------------------------------------------------------------------------
		// EVENT HANDLING
		// ----------------------------------------------------------------------------------
		handlePlayerReady: function(player_id) {
			this.froogaloop.addEvent('playProgress', $.proxy(this.update, this));  
			this.froogaloop.addEvent('seek', $.proxy(this.update, this));  
		},
	 
		handleListChange: function(e) {
			var file = $(e.target).closest('select').find('option:selected'),
				url = file.data('url'),
				id = file.data('id');
			this.loadSubtitles(url, id);
		},
		 
		update: function() {
			if (!this.lines) {
				return;
			}
			this.froogaloop.api('getCurrentTime', $.proxy(function(value) {
				var line = this.getLineByTime(value);
				if (line) {
					this.displayText(line.text);
					this.currentLine = line;
				}
				else if (this.currentLine) {
					this.displayText('');
					this.currentLine = null;
				}
					
			}, this));
		},
		getLineByTime: function(time) {

			var lines = this.lines,
				i = 0,
				t = lines.length,
				line;
			
			while(i < t) {
				line = lines[i]; 
				if (line) {
					if (utils.srtTimeToSeconds( line.start ) <= time  && utils.srtTimeToSeconds( line.end ) >= time) {
						i = t;
						return line;
					}
				}
				i = i + 1;
			}
		},
	 
		/*
		 * ----------------------------------------------------- 
		 * 
		 * 
		 * ----------------------------------------------------- 
		 */
		
		displayText: function(value) {
			this.textfield.html(value).css('opacity',1);
		},
		
		destroy: function() {
			this.options = 
			this.element = 
			this.select = 
			this.list = 
			this.lines = 
			this.frooga =
			null;
		}
		  
	};
	Websubs.prototype.constructor = Websubs;
	if (!window.aleksic) {
		window.aleksic = {};
	}
	aleksic.Websubs = Websubs;
	 
	
	/*
	 * ----------------------------------------------------------------
	 * 
	 * jQuery plugin
	 * 
	 * ----------------------------------------------------------------
	 */	
	
	
	pluginName = 'websubs';
	
	pluginMethods =
    {
        init : function(/*Object*/ options)
        {
            return this.each(function()
            {
				var instance = new aleksic.Websubs(this, options);
				$(this).data(pluginName, instance);
            });
        },

        destroy : function()
        {
            return this.each(function()
            {
                $(this).data(pluginName).destroy();
                $(this).data(pluginName, null);
            });
        }

    };

	$.fn[pluginName] = function(method) {
		if ( pluginMethods[method] ) { 
			return pluginMethods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
	    } else if ( typeof method === 'object' || !method ) {
			return pluginMethods.init.apply( this, arguments );
	    } else {
			$.error( 'Method ' +  method + ' does not exist on ' + pluginName );
	    }
	};
	
		
	/**
	 * fixing DOMNodeRemoved event for MSIE.
	 * Use $(el).remove() to ensure it works!
	 */  
	(function(){ 
		var remove = $.fn.remove;		  
		$.fn.remove = function(){ 
			// -------------------------------------------- //
			// If this is IE, then manually trigger the DOM
			// node removed event on the given element.
			if ($.browser.msie){
				$( this ).each(function(){
					$( this ).trigger({
						type: "DOMNodeRemoved"
					});
				});
			}
			// -------------------------------------------- //
			remove.apply( this, arguments );
		};
	}());
	
	/**
	 * Destroy instances of Websubs when their elements are removed.
	 */
	$('body').bind('DOMNodeRemoved', function(e) {
		if ($(e.target).data(pluginName)) {
			$(e.target)[pluginName]('destroy');
		}
	});
	 

}(jQuery));