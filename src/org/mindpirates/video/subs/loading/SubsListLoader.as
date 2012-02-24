package org.mindpirates.video.subs.loading
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.mindpirates.video.events.SubtitleListLoaderEvent;

	/**
	 * Dispatched subtitlelist has been loaded.
	 * @eventType org.mindpirates.video.events.SubtitleListEvent
	 */
	[Event(name="loadComplete", type="org.mindpirates.video.events.SubtitleListLoaderEvent")]
	
	/**
	 * The SubtitlesListLoader class loads the XML file with a listing of available subtitlefiles.<br>
	 * Each of these files is represented by a <code>SubtitleFileLoader</code> instance and listed in the <code>files</code> Vector.
	 * @see #files
	 * @see org.mindpirates.video.subtitleplayer.loading.SubtitleFileLoader
	 */
	public class SubsListLoader extends URLLoader
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
		 * Holds the value of <code>files</code>
		 * @see #files files
		 */
		private var _files:Vector.<SubtitleFileLoader>;
		
		public function SubsListLoader(request:URLRequest=null)
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
			_files =  new Vector.<SubtitleFileLoader>();
			for (var i:int = 0; i<_xml.subtitle.length(); i++){
				_files.push(new SubtitleFileLoader(_xml.subtitle[i]));
			}
			removeEventListener(Event.COMPLETE, handleComplete);
			dispatchEvent( new SubtitleListLoaderEvent( SubtitleListLoaderEvent.LOAD_COMPLETE ) );
		}
		
		/**
		 * An Array (Vector.&lt;SubtitleFileLoader&gt;) containing SubtitleFileLoader instances for each of the subtitle files specified in the subtitleList XML.
		 */
		public function get files():Vector.<SubtitleFileLoader>
		{
			return _files;
		}
		
		/**
		 * The ID of the default subtitle file. Must be defined in the root node of the XML file as an attribute named "default_id".
		 */
		public function get defaultFileID():String
		{
			return _xml.@default_id;
		}
		
		/**
		 * The subtitle file that corresponds to <code>defaultFileID</code>.
		 * @see #defaultFileID 
		 */
		public function get defaultFile():SubtitleFileLoader
		{
			return getFileByID( defaultFileID );
		}
		
		/**
		 * Returns a subtitle file based on its ID.
		 * @return The subtitle file that matches the ID. If no result is found, <code>null</code> is returned.
		 */
		public function getFileByID(id:String):SubtitleFileLoader
		{
			trace(this, 'getFilebyID('+id+')');
			for each (var file:SubtitleFileLoader in files) { 
				if (file.id == id) {
					return file;
				}
			}
			return null;
		}
		
		/**
		 * Returns a subtitle file based on its url.
		 * @return The subtitle file that matches the url. If no result is found, <code>null</code> is returned.
		 */
		public function getFileByUrl(url:String):SubtitleFileLoader
		{
			for each (var file:SubtitleFileLoader in files) {
				if (file.fileURL == url) {
					return file;
				}
			}
			return null;
		}
	}
}