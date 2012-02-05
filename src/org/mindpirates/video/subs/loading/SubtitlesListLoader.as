package org.mindpirates.video.subs.loading
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.mindpirates.video.events.SubtitleListEvent;

	/**
	 * Dispatched subtitlelist has been loaded.
	 * @eventType org.mindpirates.video.events.SubtitleListEvent
	 */
	[Event(name="loadComplete", type="org.mindpirates.video.events.SubtitleListEvent")]
	
	/**
	 * The SubtitlesListLoader class loads the XML file with a listing of available subtitlefiles.<br>
	 * Each of these files is represented by a <code>SubtitleFileLoader</code> instance and listed in the <code>files</code> Vector.
	 * @see #files
	 * @see org.mindpirates.video.subtitleplayer.loading.SubtitleFileLoader
	 */
	public class SubtitlesListLoader extends URLLoader
	{
		/**
		 * Holds the raw loaded data
		 */
		private var _data:Object;
		
		/**
		 * Holds the loaded XML
		 */
		private var _xml:XML;
		
		/**
		 * An Array (Vector) containing SubtitleFileLoader instances for each of the subtitle files specified in the subtitleList XML.
		 */
		public var files:Vector.<SubtitleFileLoader>;
		
		public function SubtitlesListLoader(request:URLRequest=null)
		{
			super(request);
		}
		
		override public function load(request:URLRequest):void
		{
			addEventListener(Event.COMPLETE, handleComplete);
			super.load(request);
		}
		
		protected function handleComplete(event:Event):void
		{
			_data = event.target.data;
			_xml = new XML( event.target.data ); 
			files =  new Vector.<SubtitleFileLoader>();
			for (var i:int = 0; i<_xml.subtitle.length(); i++){
				files.push(new SubtitleFileLoader(_xml.subtitle[i]));
			}
			removeEventListener(Event.COMPLETE, handleComplete);
			dispatchEvent( new SubtitleListEvent( SubtitleListEvent.LOAD_COMPLETE ) );
		}
		 
	}
}