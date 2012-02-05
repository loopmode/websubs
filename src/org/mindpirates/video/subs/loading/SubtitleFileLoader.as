package org.mindpirates.video.subs.loading
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import nl.inlet42.data.subtitles.SubtitleParser;
	import org.mindpirates.video.subs.SubtitleFormats;
	import org.mindpirates.video.subs.lines.SubtitlesLines;
	
	/** 
	 * Dispatched when the subtitle file has been loaded.
	 * @eventType flash.events.Event
	 */
	[Event(name="complete", type="flash.events.Event")]
	
	
	/**
	 * Represents a subtitle file based on a node of the XML file loaded by <code>SubtitleListLoader</code>.<br>
	 * Offers named access to the node attrbutes and its value. Furtheron, it can load the actual subtitle file.
	 * @see org.mindpirates.video.subtitleplayer.loading.SubtitlesListLoader
	 */ 
	public class SubtitleFileLoader extends EventDispatcher
	{
		/**
		 * The xml from the subtitleList XML file.
		 */
		public var xml:XML;
		 
		private var loader:URLLoader;
		private var _data:Object;
		private var _isLoaded:Boolean;
		private var _subtitles:SubtitlesLines;
		 
		/** 
		 * Proxy class for a node of the subtitleList XML file.
		 * @param node [xml] A node from the XML listing of available subtitle files.
		 */
		public function SubtitleFileLoader(node:XML)
		{
			xml = node;
		}
		
		/**
		 * The format of the subtitle file
		 */
		public function get format():String
		{
			return String(xml.@format);
		}
		
		/**
		 * Shortcode for language of the subtitle file.
		 */
		public function get lang():String
		{
			return String(xml.@lang);
		}
		
		/**
		 * Title of the subtitle file, usually the name of the language.
		 */
		public function get title():String
		{
			return String(xml.@title);
		}
		
		/**
		 * Description for the subtitle file.
		 */
		public function get description():String
		{
			return String(xml.@description);
		}
		
		/**
		 * URL to an SWF file that contains a font needed to displayed the subtitles.<br>
		 * Relevant for languages that use a character set other than the basic Latin set, like Chinese or Japanese.
		 */
		public function get fontFile():String
		{
			return String(xml.@fontFile);
		}
		
		/**
		 * Name of the font required to displayed the subtitles. A font with this name must be available in the file specified in <code>fontFile</code>
		 * @see #fontFile fontFile
		 */
		public function get fontName():String
		{
			return String(xml.@fontName);
		}
		 
		/**
		 * The default font size at which the subtitles should be displayed.
		 */
		public function get fontSize():int
		{
			return int(xml.@fontSize);
		}
		
		/**
		 * The URL to the subtitle file, specified by the value of the <code>xml</code>
		 * @see #xml xml
		 */
		public function get fileURL():String
		{
			return xml.valueOf();
		}
		
		/**
		 * Loads the subtitle file specified by the value of <code>xml</code>
		 * @see #xml xml
		 */
		public function load():void
		{
			_isLoaded = false;
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, handleLoadComplete);
			loader.load( new URLRequest( fileURL) );
		}
		
		protected function handleLoadComplete(event:Event):void
		{
			_data = event.target.data;
			loader.removeEventListener(Event.COMPLETE, handleLoadComplete);	
			_isLoaded = true;
			
			
			switch (format) {
				case SubtitleFormats.SRT:
					var lines:Array = SubtitleParser.parseSRT( String(_data) );
					trace('parsed '+lines.length+' subtitle lines');
					_subtitles = new SubtitlesLines(lines, fileURL);	
			}
			
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		public function get subtitles():SubtitlesLines
		{
			return _subtitles;
		}
		
		/**
		 * A boolean value indicating whether or not the subtitle file has been loaded.
		 */
		public function get isLoaded():Boolean
		{
			return _isLoaded;
		}
		 
	}
}