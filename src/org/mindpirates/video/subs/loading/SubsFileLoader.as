package org.mindpirates.video.subs.loading
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.mindpirates.video.subs.SubtitleFormats;
	import org.mindpirates.video.subs.SubtitleParser;
	import org.mindpirates.video.subs.SubtitlesFileData;
	
	import ru.etcs.utils.FontLoader;
	
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
	public class SubsFileLoader extends EventDispatcher
	{
		/**
		 * The xml from the subtitleList XML file.
		 */
		public var xml:XML;
		  
		private var _data:Object;
		private var _isLoaded:Boolean;
		private var _subtitles:SubtitlesFileData;
		 
		/** 
		 * Proxy class for a node of the subtitleList XML file.
		 * @param node [xml] A node from the XML listing of available subtitle files.
		 */
		public function SubsFileLoader(node:XML)
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
		 * Identifier of the subtitle file.
		 */
		public function get id():String
		{
			return String(xml.@id);
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
		 * Returns the data of a subtitles file. 
		 * @return SubtitlesFileData
		 * @see org.mindpirates.video.subs.SubtitlesFileData
		 */
		public function get subtitles():SubtitlesFileData
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
		
		/**
		 * Loads the subtitle file specified by the value of <code>xml</code>
		 * @see #xml xml
		 */
		public function load():void
		{
			trace(this, 'load()', fileURL);
			_isLoaded = false;
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, handleLoadComplete);
			loader.load( new URLRequest( fileURL) );
		}
		
		protected function handleLoadComplete(event:Event):void
		{
			trace(this, 'loaded:', fileURL);
			var loader:URLLoader = event.target as URLLoader;
			loader.removeEventListener(Event.COMPLETE, handleLoadComplete);	
			_data = loader.data;
			_isLoaded = true;
			
			
			switch (format) {
				case SubtitleFormats.SRT:
					var lines:Array = SubtitleParser.parseSRT( String(_data) );
					trace('parsed '+lines.length+' subtitle lines');
					_subtitles = new SubtitlesFileData(lines, fileURL);	
			}
			trace('fontFile', fontFile);
			if(fontFile) {
				loadFont();			
			}
			else {
				dispatchEvent( new Event( Event.COMPLETE ) );					
			}
		}
		
		private function loadFont():void
		{ 
			var loader:FontLoader = new FontLoader();
			loader.addEventListener(Event.COMPLETE, handleFontLoaded); 
			loader.load(new URLRequest(fontFile));
		}
		
		protected function handleFontLoaded(event:Event):void
		{
			var loader:FontLoader = event.target as FontLoader;
			loader.removeEventListener(Event.COMPLETE, handleFontLoaded);
			dispatchEvent( new Event( Event.COMPLETE ) );	
		}		
		 
	}
}